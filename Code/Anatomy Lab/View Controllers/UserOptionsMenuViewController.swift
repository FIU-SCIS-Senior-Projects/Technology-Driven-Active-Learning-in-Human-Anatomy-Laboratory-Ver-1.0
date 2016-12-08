//
//  UserOptionsMenuViewController.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 11/4/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import UIKit
import Foundation
import PopupDialog

class UserOptionsMenuViewController: UITableViewController {
    
    private var options: [String] = [String]()
    var profileView: ProfileView?
    var userOptionsMenuDelegateDatasource: UserOptionsMenuDelegateDatasource?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupProfileView()
        setupDelegateDatasource()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

//MARK: Setup Views
private extension UserOptionsMenuViewController {
    
    func setupViews() {
        
        navigationItem.title = NSLocalizedString("Options", comment: "")
        tableView.scrollEnabled = false
        
        profileView = ProfileView(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(tableView.frame), height: 200))
        
        tableView.tableHeaderView = profileView
    }
    
    func setupDelegateDatasource() {
        userOptionsMenuDelegateDatasource = UserOptionsMenuDelegateDatasource()
        
        userOptionsMenuDelegateDatasource?.cellSelectionHandler = { [weak self] menuOption in
            
            let userStoryboard = UIStoryboard(name: "UserProfileStoryboard", bundle: nil)
            var detailViewController = UIViewController()
            
            switch menuOption {
            case .StudentInformation:
                break
            case .CourseInformation:
                break
            case .ProgressInformation:
                detailViewController = userStoryboard.instantiateViewControllerWithIdentifier("userProgressInformationNavStoryboard")
                break
            case .GradingStatistics:
                break
            case .AppInformation:
                break
            case .SignOut:
                self?.showLogoutPrompt()
                return
            }
            
            guard let mainTabBarViewController = UIApplication.sharedApplication().keyWindow?.rootViewController as? MainTabViewController,
                let splitViewController = mainTabBarViewController.viewControllers?[mainTabBarViewController.selectedIndex] as? UserSplitViewController else {
                    return
            }
            
            splitViewController.viewControllers.removeLast()
            splitViewController.viewControllers.append(detailViewController)
            
        }
        
        tableView.delegate = userOptionsMenuDelegateDatasource
        tableView.dataSource = userOptionsMenuDelegateDatasource
    }
    
    func setupProfileView() {
        
        let profileViewManager = ProfileViewManager()
        profileViewManager.completionHandler = { [weak self] profileViewModel, error in
            self?.profileView?.configure(withViewModel: profileViewModel)
        }
        profileViewManager.defaultProfile()
        
    }
    
    func showPopup(withTitle title: String? = nil, message: String, buttons: [PopupDialogButton]){
        let popup = PopupDialog(title: title,
                                message: message,
                                transitionStyle: .BounceDown,
                                buttonAlignment: .Horizontal)
        popup.addButtons(buttons)
        presentViewController(popup, animated: true, completion: nil)
    }
    
    func showLogoutPrompt() {
        
        let oKbutton = DefaultButton(title: NSLocalizedString("Yes!", comment: ""),
                                     action: { [weak self] in
                                        self?.logout()
        })
        
        let cancelButton = CancelButton(title: NSLocalizedString("Cancel", comment: ""), action: nil)
        
        showPopup(message: NSLocalizedString("Do you wish to sign out of the application?", comment: ""),
                  buttons: [cancelButton, oKbutton])
    }
    
    func logout() {
        Utilities.manager.logout({
            GIDSignIn.sharedInstance().disconnect()
            if let mainTabVC = Utilities.manager.mainTabViewController() {
                mainTabVC.setupViewControllers()
                mainTabVC.selectedIndex = 0
            }
        })
    }
    
}
