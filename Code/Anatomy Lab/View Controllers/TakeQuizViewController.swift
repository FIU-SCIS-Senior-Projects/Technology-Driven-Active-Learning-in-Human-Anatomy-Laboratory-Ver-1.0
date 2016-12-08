//
//  TakeQuizViewController.swift
//  Anatomy Lab
//
//  Created by Darian Mendez on 10/10/16.
//

import UIKit
import SwiftyJSON

class TakeQuizViewController: UIViewController {
    
    @IBOutlet weak var takeQuizDescription: UILabel!
    @IBOutlet weak var takeQuizTittle: UILabel!
    var takeQuizQuestions: JSON?
    var takeQuizMetadata: JSON?
    var arrayOfQuizImages: [String] = []
    var arrayofLabels: [[String]] = []
    var arrayofTerms:  [[String]] = []
    var arrayofAlreadyAskedQuestions: [[Int]] = []
    var quizGrade:Double = 000.00
    var saveAnswersArray:[String]=[]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
//MARK: Set Up the Labels.
extension TakeQuizViewController {
    func setupView (){
        
        if let validMetadaInfo = TakeQuiz(withJSON: takeQuizMetadata!){
            takeQuizTittle.text = validMetadaInfo.title
            takeQuizDescription.text = validMetadaInfo.quizdescription
        }
        populateArrays()
        
    }
    func populateAlreadyAnswerDocument () {
        for i in 0..<arrayOfQuizImages.count {
            arrayofAlreadyAskedQuestions.insert([], atIndex: i)
        }
    }
    func populateArrays () {
        if let validView = GeneralQuizViewModel (forQuiz: takeQuizQuestions!) {
            arrayOfQuizImages = validView.getImagesNames()
            arrayofTerms = validView.populateArray(isAlabel: false)
            arrayofLabels = validView.populateArray(isAlabel: true)
            populateAlreadyAnswerDocument()
        }
    }
}
//MARK: Button Action Functions
extension TakeQuizViewController {
    @IBAction func multipleChoicePressed(sender: UIButton) {
        
        callMultipleViewQuiz(arrayOfImages: arrayOfQuizImages, arrayOfLabels: arrayofLabels, arrayOfTerm: arrayofTerms, isRandom: false)
    }
    @IBAction func fillInBlankPressed(sender: UIButton) {
        
        callFillinBlankViewQuiz(arrayOfImages: arrayOfQuizImages, arrayOfLabels: arrayofLabels, arrayOfTerm: arrayofTerms, isRandom: false)
    }
    @IBAction func randomPressed(sender: UIButton) {
        
        let randomNumber = Int(arc4random_uniform(2))
        switch randomNumber {
        case 0:
            callMultipleViewQuiz(arrayOfImages: arrayOfQuizImages, arrayOfLabels: arrayofLabels, arrayOfTerm: arrayofTerms, isRandom: true)
            break
        case 1:
            callFillinBlankViewQuiz(arrayOfImages: arrayOfQuizImages, arrayOfLabels: arrayofLabels, arrayOfTerm: arrayofTerms, isRandom: true)
            break
        default:
            print ("error creating the random number")
        }
        
    }
    @IBAction func unwindtoMenu (segue: UIStoryboardSegue){}
}
//MARK: QUIZ VIEW CALLERS
//The following contains two functions, one to call the multiple choice view. The other one to call the fill in the blank view
extension TakeQuizViewController {
    func callMultipleViewQuiz (arrayOfImages arrayofimages: [String], arrayOfLabels arrayoflabels:[[String]], arrayOfTerm arrayofterms:[[String]], isRandom random:Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let menuNavigationController = storyboard.instantiateViewControllerWithIdentifier("multipleChoiceNavigator") as? UINavigationController else {
            return
        }
        if let menuViewController = menuNavigationController.childViewControllers.first as? MultipleChoiceViewController {
            menuViewController.arrayofLabels = arrayoflabels
            menuViewController.arrayofTerms = arrayofterms
            menuViewController.arrayOfQuizImages = arrayofimages
            menuViewController.quizTitle = takeQuizTittle.text
            menuViewController.isRandom = random
            menuViewController.questionsAskedAlready = arrayofAlreadyAskedQuestions
            
        }
        self.presentViewController(menuNavigationController, animated: true, completion: nil)
        
    }
    func callFillinBlankViewQuiz (arrayOfImages arrayofimages: [String], arrayOfLabels arrayoflabels:[[String]], arrayOfTerm arrayofterms:[[String]], isRandom random:Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let menuNavigationController = storyboard.instantiateViewControllerWithIdentifier("fillInTheBlankNavigator") as? UINavigationController else {
            return
        }
        if let menuViewController = menuNavigationController.childViewControllers.first as? FillinTheBlankViewController {
            menuViewController.arrayofLabels = arrayoflabels
            menuViewController.arrayofTerms = arrayofterms
            menuViewController.arrayOfQuizImages = arrayofimages
            menuViewController.quizTitle = takeQuizTittle.text
            menuViewController.isRandom = random
            menuViewController.questionsAskedAlready = arrayofAlreadyAskedQuestions
        }
        self.presentViewController(menuNavigationController, animated: true, completion: nil)
    }
    
    
}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */


