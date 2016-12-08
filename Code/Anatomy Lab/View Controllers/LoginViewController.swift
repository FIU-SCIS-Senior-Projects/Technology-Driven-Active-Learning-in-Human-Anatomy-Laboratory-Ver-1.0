//
//  LoginViewController.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 10/1/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import UIKit
import PopupDialog

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var partOfLabel: UILabel!
    @IBOutlet weak var developedByLabel: UILabel!
    @IBOutlet weak var vipLogoImageView: UIImageView!
    @IBOutlet weak var fiuLogoImageView: UIImageView!
    
    var googleSignInDelegate: GoogleSignInDelegate?
    
    private var googleUser: GIDGoogleUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupGoogleSignInDelegate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: Private API
private extension LoginViewController {
    
    func setupViews() {
        
        partOfLabel.text = NSLocalizedString("Part of:", comment: "")
        partOfLabel.font = UIFont(name: "Futura-Medium", size: 28)
        
        developedByLabel.text = NSLocalizedString("Developed by:", comment: "")
        developedByLabel.font = UIFont(name: "Futura-Medium", size: 28)
        
        vipLogoImageView.backgroundColor = UIColor.clearColor()
        vipLogoImageView.contentMode = .ScaleAspectFit
        vipLogoImageView.image = UIImage(named: "vip-logo")
        
        fiuLogoImageView.backgroundColor = UIColor.clearColor()
        fiuLogoImageView.contentMode = .ScaleAspectFit
        fiuLogoImageView.image = UIImage(named: "fiu-eng-comp-logo-horizontal")
        
    }
    
    func showPopup(withTitle title: String? = nil, message: String, buttons: [PopupDialogButton]){
        let popup = PopupDialog(title: title,
                                message: message,
                                transitionStyle: .BounceDown,
                                buttonAlignment: .Horizontal)
        popup.addButtons(buttons)
        presentViewController(popup, animated: true, completion: nil)
    }
    
    func promptForPantherIdAndCreateUser() {
        
        let alert = UIAlertController(title: NSLocalizedString("Please enter your Panther ID", comment: ""),
                                      message: nil,
                                      preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler({ (textfield) in
            textfield.placeholder = NSLocalizedString("Your Panther ID", comment: "")
            textfield.keyboardType = .NumberPad
            textfield.autocapitalizationType = .None
            textfield.autocorrectionType = .No
            textfield.delegate = self
        })
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: .Cancel,
                                         handler: nil)
        alert.addAction(cancelAction)
        
        let okHandler: (UIAlertAction) -> Void = { [weak self] _ in
            let pantherIdTextField = alert.textFields![0] as UITextField
            self?.createUser(forGoogleUser: self?.googleUser, withPantherId: pantherIdTextField.text!)
        }
        
        let okAction = UIAlertAction(title: NSLocalizedString("Save", comment: ""),
                                     style: .Default,
                                     handler: okHandler)
        
        alert.addAction(okAction)
        
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func createUser(forGoogleUser user: GIDGoogleUser?, withPantherId id: String) {
        
        guard let validGoogleUser = user else {
            return
        }
        
        User.createUser(forUser: validGoogleUser, withPantherId: id) { [weak self] in
            let standardDefaults = NSUserDefaults.standardUserDefaults()
            standardDefaults.setValue(user?.profile.email, forKey: "currentUserEmail")
            standardDefaults.synchronize()
            self?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}

//MARK: IBActions
extension LoginViewController {
    
    @IBAction func login(sender: UIButton) {
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            GIDSignIn.sharedInstance().signInSilently()
        }else{
            GIDSignIn.sharedInstance().signIn()
        }
    }
    
}

//MARK: Google Sign In Delegate
private extension LoginViewController {
    
    func setupGoogleSignInDelegate() {
        
        googleSignInDelegate = GoogleSignInDelegate()
        
        googleSignInDelegate?.authenticationSignInCompletionHandler = { [weak self] user, error in
            if error != nil {
                self?.showPopup(withTitle: String.localizedStringWithFormat("Access denied"),
                                message: error?.localizedDescription ?? "An unexpected error occurred.",
                                buttons: [CancelButton(title: String.localizedStringWithFormat("Cancel"), action: nil),
                                    DefaultButton(title: String.localizedStringWithFormat("Retry"), action: {
                                        GIDSignIn.sharedInstance().disconnect()
                                    })])
                return
            }
            self?.googleUser = user
            if let _ = User.findUserWithPrimaryKey(email: (user?.profile.email)!) {
                let standardDefaults = NSUserDefaults.standardUserDefaults()
                standardDefaults.setValue(user?.profile.email, forKey: "currentUserEmail")
                standardDefaults.synchronize()
                self?.dismissViewControllerAnimated(true, completion: nil)
            }else{
                self?.promptForPantherIdAndCreateUser()
            }
        }
        
        googleSignInDelegate?.authenticationPresentUICompletionHandler = { [weak self] viewController in
            self?.presentViewController(viewController, animated: true, completion: nil)
        }
        
        googleSignInDelegate?.authenticationDismissUICompletionHandler = { [weak self] in
            self?.dismissViewControllerAnimated(true, completion: nil)
        }
        
        GIDSignIn.sharedInstance().uiDelegate = googleSignInDelegate
        GIDSignIn.sharedInstance().delegate = googleSignInDelegate
    }
    
}

//MARK: UITextField delegate

extension LoginViewController: UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let aSet = NSCharacterSet(charactersInString:"0123456789").invertedSet
        let compSepByCharInSet = string.componentsSeparatedByCharactersInSet(aSet)
        let numberFiltered = compSepByCharInSet.joinWithSeparator("")
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        
        return string == numberFiltered && newLength <= 7
        
    }
    
}
