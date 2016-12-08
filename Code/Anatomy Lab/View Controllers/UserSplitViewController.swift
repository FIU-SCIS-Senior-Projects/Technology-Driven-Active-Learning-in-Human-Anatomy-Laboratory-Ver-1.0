//
//  UserSplitViewController.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 11/4/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import UIKit

class UserSplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configure(withViewModel viewModel: UserSplitViewModel){
        
        tabBarItem.title = viewModel.title
        tabBarItem.image = viewModel.image
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let usersVC = storyboard.instantiateViewControllerWithIdentifier("UserDetailNavigationViewController")
        viewControllers.append(usersVC)
    }

}
