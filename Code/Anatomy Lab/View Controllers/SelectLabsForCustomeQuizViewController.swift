//
//  SelectLabsForCustomeQuizViewController.swift
//  Anatomy Lab
//
//  Created by Darian Mendez on 10/30/16.
//

import UIKit
import SwiftyJSON
import PopupDialog

class SelectLabsForCustomeQuizViewController: UIViewController ,UITableViewDataSource , UITableViewDelegate {

    var menuItems = [MainMenuItem] ()
    private var mainMenuItemsManager: MenuItemsManager?
    private var selectedLab: Int?
    var arrayOfSelectedLabs: [Int] = []
    var arrayOfSelectedStations: [[Int]] = []
    var countOfLabsSelected: Int = 0
    let labDescriptionText = "Please select the labs that you wish to be test on. \n You can select more than one lab"
    
    @IBOutlet weak var labDescriptionLabel: UILabel!
    @IBOutlet weak var labsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupDataSource()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
//MARK: SetUp Views
extension SelectLabsForCustomeQuizViewController {
    func setupView () {
        labsTableView.dataSource = self
        labsTableView.delegate = self
        countOfLabsSelected = 0
        arrayOfSelectedLabs.removeAll()
        labDescriptionLabel.text = labDescriptionText
        
    }
    func setupDataSource() {
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
//MARK: Cancel PopUp Dialog
extension SelectLabsForCustomeQuizViewController {
    
    func showPopup(withTitle title: String? = nil, message: String, buttons: [PopupDialogButton]){
        let popup = PopupDialog(title: title,
                                message: message,
                                transitionStyle: .BounceDown,
                                buttonAlignment: .Horizontal)
        popup.addButtons(buttons)
        presentViewController(popup, animated: true, completion: nil)
    }
}

    //MARK: UIButton Actions
extension SelectLabsForCustomeQuizViewController {
    @IBAction func cancelAction(sender: UIButton) {
        showPopup(message: String.localizedStringWithFormat("Do you want to cancel the selection (No labs will be selected"),
                  buttons: [CancelButton(title: String.localizedStringWithFormat("No"), action: nil),
                    DefaultButton(title: String.localizedStringWithFormat("Yes"), action: { self.performSegueWithIdentifier("goBackToCustomize", sender: self)
                    })])
        
    }
    @IBAction func saveAction(sender: UIButton) {
        if arrayOfSelectedLabs.count == 0 {
            showPopup(message: String.localizedStringWithFormat("Please select a lab first"),
                      buttons: [CancelButton(title: String.localizedStringWithFormat("OK"), action: nil)])
        }
        else {
            showPopup(message: String.localizedStringWithFormat("Do you want to customize the stations for each labs ( If No, then all the stations will be tested"),
                      buttons: [CancelButton(title: String.localizedStringWithFormat("No"), action: {self.performSegueWithIdentifier("goBackToCustomize", sender: self)}),
                        DefaultButton(title: String.localizedStringWithFormat("Yes"), action: { self.callCustomizeStationView()
                        })])
        }
        
    }
    func callCustomizeStationView () {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let menuViewController = storyboard.instantiateViewControllerWithIdentifier("selectStationForCustomizeQuiz") as! SelectStationForCustomizeQuizViewController
        menuViewController.labSelected = arrayOfSelectedLabs
        self.presentViewController(menuViewController, animated: true, completion: nil)
        
    }
    func populateStationArray () {
       
        for i in 0..<arrayOfSelectedLabs.count {
            if let labData = Utilities.manager.loadData(forLab: arrayOfSelectedLabs[i]) {
                if let countStations = Utilities.manager.loadStations(fromData: labData)?.count {
                    print ("countStations \(countStations)")
                    var temp: [Int] = []
                    for j in 0..<countStations {
                        temp.insert(j, atIndex: j)
                    }
                    arrayOfSelectedStations.insert(temp, atIndex: i)
                }
            }
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goBackToCustomize" {
            if arrayOfSelectedLabs.count > 0 {
                let destinationVC = segue.destinationViewController as! QuizzesDetailViewController
                destinationVC.labSelected = arrayOfSelectedLabs
                populateStationArray ()
                print ("Station Array \(arrayOfSelectedStations.description)")
                destinationVC.stationsSelected = arrayOfSelectedStations
            }
        }
    }

    
}
//MARK: - UITableViewDataSource
extension SelectLabsForCustomeQuizViewController {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("selectCustomLabCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = menuItems[indexPath.row].title
        return cell
    }
    
}
//MARK: Delegates for the selections and deselection of labs
extension SelectLabsForCustomeQuizViewController {
    func saveLabSelected (RowSelected row: Int) {
         arrayOfSelectedLabs.insert(row, atIndex: countOfLabsSelected)
        countOfLabsSelected = countOfLabsSelected+1
    }
    func deleteSelectedLab (RowDeselected row: Int) {
        var itemFound = false
        var index = 0
        while itemFound == false {
            if arrayOfSelectedLabs [index] == row {
                arrayOfSelectedLabs.removeAtIndex(index)
                countOfLabsSelected = countOfLabsSelected - 1
                itemFound = true
            }
            else {
                index = index + 1
            }
        }
       
    }
}

//MARK: - UITableViewDelegate
extension SelectLabsForCustomeQuizViewController {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        saveLabSelected(RowSelected: indexPath.row)
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        deleteSelectedLab(RowDeselected: indexPath.row)
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}



