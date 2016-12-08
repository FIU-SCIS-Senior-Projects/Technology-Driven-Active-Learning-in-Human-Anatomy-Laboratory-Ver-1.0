//
//  UserProgressInformationViewController.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 11/26/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import UIKit

class UserProgressInformationViewController: UIViewController {

    @IBOutlet weak var completedInfoTile: CounterInfoTileView!
    @IBOutlet weak var favoriteInfoTile: CounterInfoTileView!
    @IBOutlet weak var pendingInfoTile: CounterInfoTileView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadUserInformation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: Private API
extension UserProgressInformationViewController {
    
    func setupViews() {
        
        navigationItem.title = NSLocalizedString("Progress information", comment: "")
        
    }
    
    func loadUserInformation() {
        
        guard let currentUser = User.currentUser() else {
            print("could not load user info")
            return
        }
        
        completedInfoTile.configure(withViewModel: currentUser.infoForStationWith(.Completed))
        favoriteInfoTile.configure(withViewModel: currentUser.infoForStationWith(.Favorite))
        pendingInfoTile.configure(withViewModel: currentUser.infoForStationWith(.Pending))
    }
    
}