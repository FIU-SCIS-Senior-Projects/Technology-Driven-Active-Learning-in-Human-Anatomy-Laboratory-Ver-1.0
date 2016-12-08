//
//  FinalQuizGradeViewController.swift
//  Anatomy Lab
//
//  Created by Darian Mendez on 10/14/16.
//

import UIKit
import SwiftyJSON

class FinalQuizGradeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //Vars
    var arraysofAnswers: [String]?
    var finalGrade:Double?
    var takeQuizQuestions:JSON?
    var quizTitle: String = ""
    //Outlets
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reTake: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
//MARK: SetUp Views
extension FinalQuizGradeViewController {
    func setupView () {
        if let grade = finalGrade {
            let text = "Grade: \(String(format: "%.2f", grade))"
            gradeLabel.text = text
        }
    }
    func numberofAnswer () ->Int {
        if let data = arraysofAnswers {
            return data.count
        }
        return 0
    }
}
//MARK: Buttons Actions
extension FinalQuizGradeViewController {
    @IBAction func finishPressed(sender: UIButton) {
        let validView = QuizzesDetailViewController()
        if quizTitle == validView.getQuizTittle() {
            self.performSegueWithIdentifier("unwindToCustomize", sender: self)
        }
        else {
            self.performSegueWithIdentifier("unwindtoMenu", sender: self)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwindToCustomize" {
            let validView = segue.destinationViewController as! QuizzesDetailViewController
            validView.labSelected.removeAll()
            validView.stationsSelected.removeAll()
            validView.arrayofTerms.removeAll()
            validView.arrayofLabels.removeAll()
            validView.arrayOfQuizImages.removeAll()
            validView.arrayofAlreadyAskedQuestions.removeAll()
            validView.labsSelectedLabel.text = validView.emptyLabSelectedArrayMessage
            
        }
    }

}
//MARK: - UITableViewDataSource
extension FinalQuizGradeViewController {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberofAnswer()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("saveAnswerCell", forIndexPath: indexPath)
        if let data = arraysofAnswers {
            cell.textLabel?.text = data[indexPath.row]
        }
        return cell
    }
    
}
//MARK: - UITableViewDelegate
extension FinalQuizGradeViewController {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
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


