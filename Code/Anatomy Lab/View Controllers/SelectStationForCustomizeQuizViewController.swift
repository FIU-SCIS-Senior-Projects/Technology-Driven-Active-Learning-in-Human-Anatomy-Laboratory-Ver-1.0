//
//  SelectStationForCustomizeQuizViewController.swift
//  Anatomy Lab
//
//  Created by Darian Mendez on 10/30/16.
//

import UIKit
import SwiftyJSON
import PopupDialog

class SelectStationForCustomizeQuizViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var labSelected: [Int] = []
    var labCounter: Int = 0
    var arrayOfStationSelected: [[Int]] = []
    var countOfStationSelected: Int = 0
    var data: JSON?
    let selectSatationDescriptionText = "Please select as many stations as you wish. \n You can select more than one station."
    @IBOutlet weak var stationTableView: UITableView!
    @IBOutlet weak var selectStationDescriptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView ()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
//Mark: StepUpView
extension SelectStationForCustomizeQuizViewController {
   func setupView () {
        stationTableView.delegate = self
        stationTableView.dataSource = self
        countOfStationSelected = 0
        labCounter = 0
        selectStationDescriptionLabel.text = selectSatationDescriptionText
        populateBlankStationArray()
    
    }
    func populateBlankStationArray () {
        for i in 0..<labSelected.count {
            arrayOfStationSelected.insert([], atIndex: i)
        }
    }
 
}
//MARK: UIButton Actions
extension SelectStationForCustomizeQuizViewController {
    @IBAction func cancelAction(sender: UIButton) {
        showPopup(message: String.localizedStringWithFormat("Do you want to cancel the selection (No stations will be modified, and the quiz will have all the stations"),
                  buttons: [CancelButton(title: String.localizedStringWithFormat("No"), action: nil),
                    DefaultButton(title: String.localizedStringWithFormat("Yes"), action: { self.sendAllStations()
                    })])

    }
    @IBAction func saveAction(sender: UIButton) {
        if countOfStationSelected == 0 {
            showPopup(message: String.localizedStringWithFormat("You need to select a station first"),
                      buttons: [CancelButton(title: String.localizedStringWithFormat("OK"), action: nil)])
        }
        else {
            showPopup(message: String.localizedStringWithFormat("Do you want to save the stations selected?"),
                      buttons: [CancelButton(title: String.localizedStringWithFormat("No"), action: nil),
                        DefaultButton(title: String.localizedStringWithFormat("Yes"), action: {self.performSegueWithIdentifier("goBackToCustomize", sender: self)
                        })])
        }
       
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goBackToCustomize" {
            if arrayOfStationSelected.count > 0 {
                let destinationVC = segue.destinationViewController as! QuizzesDetailViewController
                destinationVC.labSelected = labSelected
                destinationVC.stationsSelected = arrayOfStationSelected
            }
        }
    }
    func sendAllStations () {
        for i in 0..<labSelected.count {
            if let labData = Utilities.manager.loadData(forLab: labSelected[i]) {
                if let countStations = Utilities.manager.loadStations(fromData: labData)?.count {
                    var temp: [Int] = []
                    for j in 0..<countStations {
                        temp.insert(j, atIndex: j)
                    }
                    arrayOfStationSelected.insert(temp, atIndex: i)
                }
            }
        }
        self.performSegueWithIdentifier("goBackToCustomize", sender: self)
    }
    func showPopup(withTitle title: String? = nil, message: String, buttons: [PopupDialogButton]){
        let popup = PopupDialog(title: title,
                                message: message,
                                transitionStyle: .BounceDown,
                                buttonAlignment: .Horizontal)
        popup.addButtons(buttons)
        presentViewController(popup, animated: true, completion: nil)
    }

    

    
    
}
//MARK: - UITableViewDataSource
extension SelectStationForCustomizeQuizViewController {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        if let validLab = Utilities.manager.loadData(forLab: labSelected[labCounter]) {
            if let validStations = Utilities.manager.loadStations(fromData: validLab) {
                returnValue = validStations.count
            }
        }
        return returnValue
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("satitionCustomCell", forIndexPath: indexPath)
        
        if let validStationData = Utilities.manager.loadData(forLab: labCounter, station: indexPath.row) {
            if let validGeneralStationViewModel = GeneralStationViewModel.init(forStation: validStationData) {
                 cell.textLabel?.text = validGeneralStationViewModel.title()            }
        }
        return cell
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var returnValue = ""
        if let appData = Utilities.manager.loadData(forLab: labSelected[section]) {
            let metaData = Utilities.manager.loadMetadata(fromData: appData)
            if let labTitle = Lab (withJSON: metaData!)?.title {
                returnValue = labTitle
            }
        }
     return returnValue
    }
}
//MARK: Delegates for the selections and deselection of labs
extension SelectStationForCustomizeQuizViewController {
    func saveStationSelected (RowSelected row: Int, SectionSelected section: Int) {
         arrayOfStationSelected[section].append(row)
        countOfStationSelected = countOfStationSelected + 1
    }
    func deleteSelectedStation (RowDeselected row: Int, SectionSelected section: Int) {
        var itemFound = false
        var index = 0
        while itemFound == false {
            if arrayOfStationSelected[section][index] == row {
                arrayOfStationSelected[section].removeAtIndex(index)
                itemFound = true
            }
            else {
                index = index + 1
            }
        }
          countOfStationSelected = countOfStationSelected - 1
    }
}

//MARK: - UITableViewDelegate
extension SelectStationForCustomizeQuizViewController {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return labSelected.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        saveStationSelected(RowSelected: indexPath.row, SectionSelected: indexPath.section)
        
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        deleteSelectedStation(RowDeselected: indexPath.row, SectionSelected: indexPath.section)
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
