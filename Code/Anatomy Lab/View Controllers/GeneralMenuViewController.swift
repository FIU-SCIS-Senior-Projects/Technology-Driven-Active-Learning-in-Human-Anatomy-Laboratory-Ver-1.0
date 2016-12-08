//
//  GeneralMenuViewController.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 9/19/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import UIKit

class GeneralMenuViewController: UITableViewController {
    
    var cellSelectionHandler: CellSelectionHandler?
    var cellDeselectionHandler: CellDeselectionHandler?
    
    var menuItems = [MainMenuItem]()
    private var mainMenuItemsManager: MenuItemsManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupDataSource()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configure(withViewModel viewModel: GeneralTabMenuViewModel) {
        self.cellSelectionHandler = viewModel.cellSelectionHandler
        self.cellDeselectionHandler = viewModel.cellDeselectionHandler
    }

}

// MARK: Private API
private extension GeneralMenuViewController {
    
    func setupViews(){
        navigationItem.title = NSLocalizedString("Labs", comment: "")
        tableView.scrollEnabled = false
        
        guard let parentVC = parentViewController?.parentViewController as? GeneralSplitViewController else {
            return
        }
        
        let closeButton = UIBarButtonItem(title: NSLocalizedString("Close", comment: ""),
                                          style: .Done,
                                          target: parentVC.displayModeButtonItem().target,
                                          action: parentVC.displayModeButtonItem().action)
        
        navigationItem.rightBarButtonItem = closeButton
        
    }
    
    func setupDataSource(){
        mainMenuItemsManager = MenuItemsManager(forType: .Labs)
        mainMenuItemsManager?.itemsHandler = { [weak self] items, error in
            
            guard error == nil else {
                print("error: \(error)")
                print("error loading labs")
                return
            }
            
            guard let _items = items else{
                print("invalid labs information")
                return
            }
            
            self?.menuItems = _items as! [MainMenuItem]
        }
        mainMenuItemsManager?.allItems()
    }
    
}

//MARK: - UITableViewDataSource
extension GeneralMenuViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("labCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = menuItems[indexPath.row].title
        cell.detailTextLabel?.text = menuItems[indexPath.row].subtitle
        
        return cell
    }
    
}

//MARK: - UITableViewDelegate
extension GeneralMenuViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        cellSelectionHandler?(tableView, indexPath)
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        cellDeselectionHandler?(tableView, indexPath)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40.0
    }
    
}
