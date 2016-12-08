//
//  GeneralSplitViewController.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 9/19/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import UIKit

final class GeneralSplitViewController: UISplitViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupViews()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        isLoggedIn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: Public API
extension GeneralSplitViewController {
    
    func configure(withViewModel viewModel: GeneralSplitViewModel){
        
        tabBarItem.title = viewModel.title
        tabBarItem.image = viewModel.image
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch viewModel.appSection {
        case .Labs:
            let labsVCNavigationController = storyboard.instantiateViewControllerWithIdentifier("LabsDetailNavigationViewController")
            viewControllers.append(labsVCNavigationController)
            break
        case .Quizzes:
            let quizzesVC = storyboard.instantiateViewControllerWithIdentifier("QuizzesDetailNavigationViewController")
            viewControllers.append(quizzesVC)
            break
        case .Terminology:
            let termsVC = storyboard.instantiateViewControllerWithIdentifier("TerminologyDetailNavigationViewController")
            viewControllers.append(termsVC)
            break
        }
    }
    
}

//MARK: Private API
private extension GeneralSplitViewController {
    
    func isLoggedIn() {
        
        if !GIDSignIn.sharedInstance().hasAuthInKeychain() {
            Utilities.manager.loginViewController({ [weak self] viewController in
                self?.presentViewController(viewController, animated: true, completion: nil)
            })
        }

    }
    
    func setupViews() {
        preferredDisplayMode = UISplitViewControllerDisplayMode.PrimaryHidden
    }
    
}