//
//  LabsDetailViewController.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 9/16/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import UIKit
import FontAwesome_swift

class LabsDetailViewController: UIViewController {
    
    @IBOutlet weak var reviewGuidanceImage: UIImageView!
    @IBOutlet weak var stepOnceGuidanceImage: UIImageView!
    @IBOutlet weak var stepTwoGuidanceImage: UIImageView!
    @IBOutlet weak var stepThreeGuidanceImage: UIImageView!
    @IBOutlet weak var loggedImageView: UIImageView!
    
    @IBOutlet weak var stepOneGuidanceLabel: UILabel!
    @IBOutlet weak var stepTwoGuidanceLabel: UILabel!
    @IBOutlet weak var stepThreeGuidanceLabel: UILabel!
    
    @IBOutlet weak var reviewGuidanceLabel: UILabel!
    @IBOutlet weak var loggedInAsLabel: UILabel!
    
    var googleSignInDelegate: GoogleSignInDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = User.currentUser() {
            updateUsername()
        }else{
            showLoginView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: IBActions
extension LabsDetailViewController {
    
}

//MARK: Private API
private extension LabsDetailViewController {
    
    func updateUsername() {
        guard let user = User.currentUser() else {
            return
        }
        loggedInAsLabel.text = String.localizedStringWithFormat("Logged in as: %@", user.fullname())
    }
    
    func showLoginView() {
        Utilities.manager.loginViewController({ [weak self] viewController in
            self?.presentViewController(viewController, animated: true, completion: nil)
        })
    }
    
    func setupViews() {
        
        if let parentVC = parentViewController?.parentViewController as? GeneralSplitViewController {
            let menuButton = UIBarButtonItem(title: String.localizedStringWithFormat("Labs"),
                                             style: .Done,
                                             target: parentVC.displayModeButtonItem().target,
                                             action: parentVC.displayModeButtonItem().action)
            
            navigationItem.leftBarButtonItem = menuButton
            
            if let menuNavViewController = parentVC.childViewControllers[0] as? UINavigationController,
                let menuViewController = menuNavViewController.childViewControllers.first as? GeneralMenuViewController {
                
                let labsTabViewModel = LabsTabMenuViewModel(fromViewController: menuViewController)
                
                configureMenu(inMenuViewController: menuViewController, withViewModel: labsTabViewModel)
            }
            
        }
                
        navigationItem.title = String.localizedStringWithFormat("Laboratory detailed information")
        
        stepOneGuidanceLabel.numberOfLines = 2
        stepOneGuidanceLabel.textAlignment = .Left
        stepOneGuidanceLabel.text = String.localizedStringWithFormat("1. Tap on the \"Labs\" button on the top left corner to display the Labs list, then select the Lab you want to access.")
        stepOneGuidanceLabel.font = UIFont.systemFontOfSize(16, weight: UIFontWeightSemibold)
        
        stepTwoGuidanceLabel.numberOfLines = 2
        stepTwoGuidanceLabel.textAlignment = .Left
        stepTwoGuidanceLabel.text = String.localizedStringWithFormat("2. After tapping on the selected Lab, a list of stations will be displayed. Select the station you want to access.")
        stepTwoGuidanceLabel.font = UIFont.systemFontOfSize(16, weight: UIFontWeightSemibold)
        
        stepThreeGuidanceLabel.numberOfLines = 2
        stepThreeGuidanceLabel.textAlignment = .Left
        stepThreeGuidanceLabel.text = String.localizedStringWithFormat("3. After tapping on the selected station, its information will be displayed in this view.")
        stepThreeGuidanceLabel.font = UIFont.systemFontOfSize(16, weight: UIFontWeightSemibold)
        
        reviewGuidanceLabel.numberOfLines = 2
        reviewGuidanceLabel.textAlignment = .Right
        reviewGuidanceLabel.text = String.localizedStringWithFormat("You can review a station by tapping the \"Review\" button at the top right corner of the screen.")
        reviewGuidanceLabel.font = UIFont.systemFontOfSize(16, weight: UIFontWeightSemibold)
        
        loggedInAsLabel.numberOfLines = 1
        loggedInAsLabel.textAlignment = .Left
        loggedInAsLabel.font = UIFont.systemFontOfSize(16, weight: UIFontWeightSemibold)
        
        let leftChevron = UIImage.fontAwesomeIconWithName(FontAwesome.ChevronCircleLeft,
                                                          textColor: UIColor.blackColor(),
                                                          size: CGSizeMake(60, 60))
        stepOnceGuidanceImage.contentMode = .Center
        stepOnceGuidanceImage.image = leftChevron
        stepTwoGuidanceImage.contentMode = .Center
        stepTwoGuidanceImage.image = leftChevron
        stepThreeGuidanceImage.contentMode = .Center
        stepThreeGuidanceImage.image = leftChevron
        
        reviewGuidanceImage.contentMode = .Center
        reviewGuidanceImage.image = UIImage.fontAwesomeIconWithName(FontAwesome.ChevronCircleUp,
                                                                    textColor: UIColor.blackColor(),
                                                                    size: CGSizeMake(60, 60))
        
        loggedImageView.contentMode = .Center
        loggedImageView.image = UIImage.fontAwesomeIconWithName(FontAwesome.User,
                                                                textColor: UIColor.blackColor(),
                                                                size: CGSizeMake(60, 60))
    }
    
    func configureMenu(inMenuViewController menuViewController: GeneralMenuViewController, withViewModel viewModel: LabsTabMenuViewModel) {
        menuViewController.configure(withViewModel: viewModel)
    }
    
}
