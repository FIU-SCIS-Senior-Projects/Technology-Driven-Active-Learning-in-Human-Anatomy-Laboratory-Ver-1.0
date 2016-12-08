//
//  QuizzesDetailViewController.swift
//  Anatomy Lab
//
//  Created by Darian Mendez on 10/20/16.
//

import UIKit
import PopupDialog

class QuizzesDetailViewController: UIViewController {
    
    @IBOutlet weak var selectLabsDescription: UILabel!
    @IBOutlet weak var timeDescriptionLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var displayTimeLabel: UILabel!
    @IBOutlet weak var typeOfQuestionLabel: UILabel!
    @IBOutlet weak var typeOfQuestionSegment: UISegmentedControl!
    
    @IBOutlet weak var labsSelectedLabel: UILabel!
    var labSelected: [Int] = []
    var stationsSelected: [[Int]] = []
    var arrayOfQuizImages: [String] = []
    var arrayofLabels: [[String]] = []
    var arrayofTerms:  [[String]] = []
    var arrayofAlreadyAskedQuestions: [[Int]] = []
    var labCounter: Int = 0
    var stationCounter: Int = 0
    var timeForTheQuiz: Float = 60
    let quizTitle = "Customize Quiz"
    let labDescriptionText = "To start a quiz select a lab first. Click on the button on the right."
    let timeDescriptionText = "Select the time in minutes for the quiz ( Default is 60 min)."
    let typeOfQuestionDescriptionLabelText = "Please choose what type of question you wish. \n A question about a label, to answer with a term, or a term to identify its label. \n You can also choose random to alternate them."
    let labsSelectedTextForLabel = "Lab Selected: "
    let stationsSelectedTextForLabel = "Station Selected"
    let emptyLabSelectedArrayMessage = "No labs selected yet"
    //The variable is to determine what type of question the user wants.
    //Make true is the user wants to be ask a term, and select the corresponding label. False if the user want to be ask a label, and choose the corresponding term.
    //By default make it false
    var isTermQuestion = false
    var isTypeRandom = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK: IBActions
extension QuizzesDetailViewController {
    
    @IBAction func updateTimeValueAction(sender: UISlider) {
        timeForTheQuiz = timeSlider.value
        displayTimeLabel.text = String (Int(timeForTheQuiz))
        
    }
    @IBAction func typeOfQuestionAction(sender: UISegmentedControl) {
        if typeOfQuestionSegment.selectedSegmentIndex == 0 {
            isTermQuestion = false
        }
        else if typeOfQuestionSegment.selectedSegmentIndex == 1 {
            isTermQuestion = true
        }
        else {
            isTypeRandom = true
            let random = Int(arc4random_uniform(2))
            if random == 0 {
                isTermQuestion = false
            }
            else {
                isTermQuestion = true
            }
        }
    }

    @IBAction func selectLabsAndStationsAction(sender: UIButton) {
        labSelected.removeAll()
        stationsSelected.removeAll()
        labsSelectedLabel.text = emptyLabSelectedArrayMessage
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuViewController = storyboard.instantiateViewControllerWithIdentifier("selectLabsForCustomizaQuiz") as! SelectLabsForCustomeQuizViewController
        self.presentViewController(menuViewController, animated: true, completion: nil)
        
        
        
    }
    @IBAction func unwindtoCustomizeQuiz (segue: UIStoryboardSegue){
        if labSelected.count > 0 {
            printLabAndStationSelectedInfo ()
        }
    }
    @IBAction func multipleChoiceAction(sender: UIButton) {
        if labSelected.count > 0 {
            populateArrays()
            callMultipleViewQuiz(arrayOfImages: arrayOfQuizImages, arrayOfLabels: arrayofLabels, arrayOfTerm: arrayofTerms, isRandom: false)
        }
        else {
            printSelectALabFirstMessage()
        }
    }
    @IBAction func fillInTheBlankAction(sender: UIButton) {
        if labSelected.count > 0 {
            populateArrays()
            callFillinBlankViewQuiz(arrayOfImages: arrayOfQuizImages, arrayOfLabels: arrayofLabels, arrayOfTerm: arrayofTerms, isRandom: false)
        }
        else {
            printSelectALabFirstMessage()
        }
    }
    @IBAction func makeItRandomAction(sender: UIButton) {
        if labSelected.count > 0 {
            populateArrays()
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
        else {
            printSelectALabFirstMessage()
        }
    }
}

//Mark: Call Quiz Views
extension QuizzesDetailViewController {
    func callMultipleViewQuiz (arrayOfImages arrayofimages: [String], arrayOfLabels arrayoflabels:[[String]], arrayOfTerm arrayofterms:[[String]], isRandom random:Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let menuNavigationController = storyboard.instantiateViewControllerWithIdentifier("multipleChoiceNavigator") as? UINavigationController else {
            return
        }
        if let menuViewController = menuNavigationController.childViewControllers.first as? MultipleChoiceViewController {
            menuViewController.arrayofLabels = arrayoflabels
            menuViewController.arrayofTerms = arrayofterms
            menuViewController.arrayOfQuizImages = arrayofimages
            menuViewController.quizTitle = quizTitle
            menuViewController.isRandom = random
            menuViewController.questionsAskedAlready = arrayofAlreadyAskedQuestions
            menuViewController.isTermQuestion = isTermQuestion
            menuViewController.isTypeOfQuestionRandom = isTypeRandom
            menuViewController.minutesLeftForTheQuiz = Int (timeForTheQuiz)
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
            menuViewController.quizTitle = quizTitle
            menuViewController.isRandom = random
            menuViewController.questionsAskedAlready = arrayofAlreadyAskedQuestions
            menuViewController.isTermQuestion = isTermQuestion
            menuViewController.isTypeOfQuestionRandom = isTypeRandom
            menuViewController.minutesLeftForTheQuiz = Int (timeForTheQuiz)
        }
        self.presentViewController(menuNavigationController, animated: true, completion: nil)
    }
}

//MARK: Private API
extension QuizzesDetailViewController {
    
    func showPopup(withTitle title: String? = nil, message: String, buttons: [PopupDialogButton]){
        let popup = PopupDialog(title: title,
                                message: message,
                                transitionStyle: .BounceDown,
                                buttonAlignment: .Horizontal)
        popup.addButtons(buttons)
        presentViewController(popup, animated: true, completion: nil)
    }
    
    func setupViews() {
        
        labSelected.removeAll()
        stationsSelected.removeAll()
        setTextFieldsFunc()
        
    }
    func printLabAndStationSelectedInfo () {
        var tempFinalString = ""
        var labTempString = " "
        var stationTempString = " "
        for i in 0..<labSelected.count {
            labTempString = "Lab: \(String (labSelected[i]+1))"
            for j in 0..<stationsSelected[i].count {
                if stationTempString != " " {
                    stationTempString = stationTempString + ","
                }
                stationTempString = "\(stationTempString) \(String (stationsSelected[i][j]+1))"
            }
            tempFinalString = tempFinalString + "\(labTempString)||Stations:\(stationTempString)\n"
            labTempString = ""
            stationTempString = " "
        }
        labsSelectedLabel.text = tempFinalString
    }
    func printSelectALabFirstMessage () {
        showPopup(message: String.localizedStringWithFormat("You need to select the labs first"),
                  buttons: [CancelButton(title: String.localizedStringWithFormat("Ok"), action: nil),
            ])
    }
    func getQuizTittle ()-> String {
        return quizTitle
    }
    func setTextFieldsFunc () {
        timeDescriptionLabel.text = timeDescriptionText
        typeOfQuestionLabel.text = typeOfQuestionDescriptionLabelText
        selectLabsDescription.text = labDescriptionText
        displayTimeLabel.text = String(Int (timeForTheQuiz))
        labsSelectedLabel.text = emptyLabSelectedArrayMessage
    }
    func populateAlreadyAnswerDocument () {
        for i in 0..<arrayOfQuizImages.count {
            arrayofAlreadyAskedQuestions.insert([], atIndex: i)
        }
    }
    func populateArrays () {
        for i in 0..<labSelected.count {
            for j in 0..<stationsSelected[i].count {
                if let validData = Utilities.manager.loadData(forLab: labSelected[i], station: stationsSelected[i][j]) {
                    if let validView = GeneralStationViewModel.init(forStation: validData) {
                        let quizQuestionData = validView.takeQuizquestionsData(validView.takeQuizData())
                        print (quizQuestionData)
                        if let validView = GeneralQuizViewModel (forQuiz: quizQuestionData) {
                            let temparrayOfQuizImages = validView.getImagesNames()
                            let temparrayofTerms = validView.populateArray(isAlabel: false)
                            let temparrayofLabels = validView.populateArray(isAlabel: true)
                            arrayOfQuizImages = arrayOfQuizImages+temparrayOfQuizImages
                            arrayofTerms = arrayofTerms + temparrayofTerms
                            arrayofLabels = arrayofLabels + temparrayofLabels
                        }
                    }
                }
            }
        }
        populateAlreadyAnswerDocument()
    }
}