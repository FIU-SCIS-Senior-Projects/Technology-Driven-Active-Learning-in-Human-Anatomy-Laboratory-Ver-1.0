//
//  MainTabViewController.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 9/16/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {
    
    private var tabBarControllerDelegate: MainTabControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupDelegate()
        setupViewControllers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: Private API
extension MainTabViewController {
    
    func setupDelegate() {
        tabBarControllerDelegate = MainTabControllerDelegate()
        delegate = tabBarControllerDelegate
    }
    
    func setupViewControllers() {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let labsVC = mainStoryboard.instantiateViewControllerWithIdentifier("MainSplitViewController") as? GeneralSplitViewController,
            let quizzesVC = mainStoryboard.instantiateViewControllerWithIdentifier("MainSplitViewController") as? GeneralSplitViewController,
            let terminologyVC = mainStoryboard.instantiateViewControllerWithIdentifier("MainSplitViewController") as? GeneralSplitViewController,
            let usersVC = mainStoryboard.instantiateViewControllerWithIdentifier("UserSplitViewController") as? UserSplitViewController else {
                return
        }
        
        let labsViewModel = GeneralSplitViewModel(forSection: .Labs)
        labsVC.configure(withViewModel: labsViewModel)
        
        let quizzesViewModel = GeneralSplitViewModel(forSection: .Quizzes)
        quizzesVC.configure(withViewModel: quizzesViewModel)
        
        let terminologyViewModel = GeneralSplitViewModel(forSection: .Terminology)
        terminologyVC.configure(withViewModel: terminologyViewModel)
        
        let usersViewModel = UserSplitViewModel()
        usersVC.configure(withViewModel: usersViewModel)
        
        setViewControllers([labsVC, quizzesVC, terminologyVC, usersVC], animated: false)
    }
    
}
