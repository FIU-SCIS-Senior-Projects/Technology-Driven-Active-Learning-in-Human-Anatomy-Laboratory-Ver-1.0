//
//  MultipleChoiceViewController.swift
//  Anatomy Lab
//
//  Created by Darian Mendez on 10/13/16.
//
//Important Description:
//There are 3 main arrays in this class. The Firs array contains the names of the images. The second array is a 2D array that have the labels, and the last one is a
//2D array that contain the term of the definitions. The 2D arrays match in positions, for example [0,1] is label A, and in the term array position [0,1] is the term for label A. Now, the images position match the first position of the 2D arrays. In that way. Image 1 that is store in the array at position 0, have is labels in the 2D array at position 0.

import UIKit
import SwiftyJSON
import PopupDialog

class MultipleChoiceViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //Data Var
    var quizTitle: String?
    var labelquizQuestions = "What is the name of label "
    var termquizQuestions = "What label is the term "
    var quizAnswer: String?
    var arrayOfQuizImages: [String] = []
    var arrayofLabels: [[String]] = []
    var arrayofTerms:  [[String]] = []
    //This variable is use to traverse the array of questions. Always have to be init to zero. Only change it when the question have to change.
    var traverse2DArray: Int = 0
    //This variable is use to traverse the image array. It is also to determine the first field in the 2D arrays.
    var traverseImageArray: Int = 0
    //The following var is use to set the fix amount of possible answers in the multiple choice. This variable is set by the product owner. By default 4
    var numberofRows: Int = 4
    //The following variable is use to save the text of the row selected by the user with the correct answer when the user press the CheckButton. Is important to don't set it with an initial value. In that way if the user press the Check Button without selecting a row, the program will not do anything. Important: The check Button func should have an if to check is the optional is nil
    var answerSelected: String?
    var lengthOfQuiz:Int?
    var quizGrade:Double = 000.00
    //The following array is use to store the answers that the user have given. The use of this array is to control if the user already andwered a question, and to print the list of rigth and wrong questions at the end of the Quiz
    var saveAnswersArray:[String]=[]
    var traverseSaveAnswwerArray:Int = 0
    var alreadyAnswer: Bool = false
    var isRandom: Bool = false
    let wrongAnswerMessage: String = "Incorrect answer, please choose again"
    let correctAnswerMessage: String = "Correct"
    var questionsAskedAlready: [[Int]] = []
    var arrayOfPossibleAnswers: [String] = []
    //The variable is to determine what type of question the user wants. 
    //Make true is the user wants to be ask a term, and select the corresponding label. False if the user want to be ask a label, and choose the corresponding term.
    //By default make it false
    var isTermQuestion = false
    //The following variable is use to alternate between the isTerm or isLabel.
    var isTypeOfQuestionRandom = false
    var minutesLeftForTheQuiz = 60
    var secondsLeftForTheQuiz = 00
    var timer = NSTimer ()
    //Outlets var
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var quizTittle: UILabel!
    @IBOutlet weak var quizImage: UIImageView!
    @IBOutlet weak var checkAnswerButton: UIButton!
    @IBOutlet weak var quizQuestion: UILabel!
    @IBOutlet weak var questionWrongMessage: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    

    
    @IBOutlet weak var timeRemainedLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
        setupView ()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func nextQuestionAction(sender: UIButton) {
        questionWrongMessage.hidden = true
        if let length = lengthOfQuiz {
            if calculateNumberofQuestionsAskedAlready() < length {
                alreadyAnswer = false
                if isRandom == true {
                    callNextView()
                }
                else {
                    setupView()
                }
            }
            else {
                endQuiz()
            }
        }
    }
    
    @IBAction func checkAnswerPressed(sender: UIButton) {
        
        if answerSelected != nil {
            if checkAnswer() == true {
                questionWrongMessage.hidden = false
                questionWrongMessage.text = correctAnswerMessage
                nextButton.hidden = false
                if alreadyAnswer == false {
                    saveAnswer(answerStatus: "Correct")
                    calculateGrade()
                    tableView.canCancelContentTouches = false
                    alreadyAnswer = true
                }
            }
            else {
                questionWrongMessage.hidden = false
                questionWrongMessage.text = wrongAnswerMessage
                if alreadyAnswer == false {
                    saveAnswer(answerStatus: "Incorrect")
                    alreadyAnswer = true
                }
                
            }
        }
        else {
            questionWrongMessage.hidden = false
            questionWrongMessage.text = "Needs to select an answer first"
        }
    }
    @IBAction func zoomAction(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let menuNavigationController = storyboard.instantiateViewControllerWithIdentifier("imageZoomNavigator") as? UINavigationController else {
            return
        }
        if let menuViewController = menuNavigationController.childViewControllers.first as? ZoomImageViewController {
            menuViewController.newImage = quizImage.image
            menuViewController.isComingFromTerm = false
        }
        self.presentViewController(menuNavigationController, animated: true, completion: nil)
    }
    @IBAction func unwindToQuiz (segue: UIStoryboardSegue) {}
}
//MARK: SET UP the View
extension MultipleChoiceViewController {
    func setupView () {
        questionWrongMessage.hidden = true
        nextButton.hidden = true
        tableView.canCancelContentTouches = false
        quizController ()
    }
}
//MARK: QUIZ CONTROLer
//The following func is in charge of controlling the flow of the quiz.
extension MultipleChoiceViewController {
    func quizController () {
        setTextView()
        selectImageRandom()
        setQuestionAndSaveAnswer()
        setImageView()
        lengthOfQuiz = calculateNumberofQuestions()
        arrayOfPossibleAnswers = fillBlankArray()
        createRandomPossibleAnswerArray()
        tableView.reloadData()
    }
}

//MARK: Controllers of the Quiz
extension MultipleChoiceViewController {
    
    func selectImageRandom (){
        let tempTraverseImageArray = generateRandomNumber(randomRange: UInt32(arrayOfQuizImages.count))
        if questionsAskedAlready[tempTraverseImageArray].count < arrayofLabels[tempTraverseImageArray].count {
            traverseImageArray = tempTraverseImageArray
        }
        else {
            selectImageRandom()
        }
        
    }

    func setTextView () {
        quizTittle.text = quizTitle
        printRemainedTime()
    }
    // The func is use to check if the random number create has been use before to ask a question.
    //Return true is the number has been used, therefore meaning that the quesiton was asked already.
    func checkIfQuestionWasAskedAlready (tempRandomNumber number: Int)->Bool {
        var check: Bool = false
        let end = questionsAskedAlready[traverseImageArray].count
        if end > 0 {
            for i in 0..<end {
                if number == questionsAskedAlready[traverseImageArray][i] {
                    check = true
                }
            }
            
        }
        return check
    }
    func makeTypeOfQuestionRandom () {
        let random = Int(arc4random_uniform(2))
        if random == 0 {
            isTermQuestion = false
        }
        else {
            isTermQuestion = true
        }
    }
    func setQuestionAndSaveAnswer () {
        let tempTraverse2DArray = generateRandomNumber(randomRange: UInt32(arrayofTerms[traverseImageArray].count))
        var questionText: String = " "
        if isTypeOfQuestionRandom == true {
            makeTypeOfQuestionRandom()
        }
        if isTermQuestion == true {
            questionText = termquizQuestions
            isTermQuestion = false
        }
        else {
            questionText = labelquizQuestions
            isTermQuestion = true
        }
        var tempArray = typeOfQuestion()
        if isTermQuestion == true {
            isTermQuestion = false
        }
        else {
            isTermQuestion = true
        }
        if checkIfQuestionWasAskedAlready(tempRandomNumber: tempTraverse2DArray) == true {
            setQuestionAndSaveAnswer()
        }
        else {
            let question = "\(questionText) \(tempArray[traverseImageArray][tempTraverse2DArray])"
            quizQuestion.text = question
            tempArray = typeOfQuestion()
            quizAnswer = tempArray[traverseImageArray][tempTraverse2DArray]
            questionsAskedAlready[traverseImageArray].append(tempTraverse2DArray)
        
        }
    }

    func setImageView () {
        self.quizImage.image = UIImage(named: arrayOfQuizImages[traverseImageArray])
    }
    func saveRowSelected (IndexPath rowselected: String){
        answerSelected = rowselected
    }
    func checkAnswer () -> Bool{
        if let answerselected = answerSelected {
            if answerselected == quizAnswer {
                return true
            }
            
        }
        return false
    }
    //A function that will send the array of labels or the array of terms, depending what the user wants to be ask about.
    func typeOfQuestion () ->[[String]] {
        if isTermQuestion == true {
            return arrayofLabels
        }
        return arrayofTerms
    }
    func fillBlankArray ()-> [String] {
        var array: [String] = []
        for i in 0..<numberofRows {
            array.insert(" ", atIndex: i)
        }
        return array
    }
    //Create the array for the table view.
    //First step is to save the answer in a random position
    //Then populate the rest of the positions with other random possible answers
    func createRandomPossibleAnswerArray () {
        let randomNumber = generateRandomNumber(randomRange: UInt32 (numberofRows))
        var tempTraverseImageArray = 0
        if let quizAnswer = quizAnswer {
            arrayOfPossibleAnswers.removeAtIndex(randomNumber)
            arrayOfPossibleAnswers.insert(quizAnswer, atIndex: randomNumber)
            let tempArray = typeOfQuestion()
            for i in 0..<numberofRows {
                tempTraverseImageArray = traverseImageArray
                if arrayOfPossibleAnswers[i] == " "{
                    if tempArray[tempTraverseImageArray].count < numberofRows {
                        tempTraverseImageArray  = generateRandomNumber(randomRange: UInt32(arrayOfQuizImages.count))
                        while (tempTraverseImageArray == traverseImageArray) {
                           tempTraverseImageArray  = generateRandomNumber(randomRange: UInt32(arrayOfQuizImages.count))
                        }
                    }
                    var tempRandomNumber = generateRandomNumber(randomRange: UInt32(tempArray[tempTraverseImageArray].count))
                    while arrayOfPossibleAnswers.contains(tempArray[tempTraverseImageArray][tempRandomNumber]) {
                        tempRandomNumber = generateRandomNumber(randomRange: UInt32(tempArray[tempTraverseImageArray].count))
                    }
                    arrayOfPossibleAnswers.removeAtIndex(i)
                    arrayOfPossibleAnswers.insert(tempArray[tempTraverseImageArray][tempRandomNumber], atIndex: i)
                }
                print (arrayOfPossibleAnswers.description)
            }
        }
        
    }
    func calculateNumberofQuestionsAskedAlready ()-> Int {
        var totalnumberofQuestions = 0
        for i in 0..<questionsAskedAlready.count {
            totalnumberofQuestions = totalnumberofQuestions + questionsAskedAlready[i].count
        }
        print ("Total Number of Questions Asked Already\(totalnumberofQuestions)")
        return totalnumberofQuestions
    }
    func calculateNumberofQuestions ()-> Int {
        var totalnumberofQuestions = 0
        for i in 0..<arrayofLabels.count {
            totalnumberofQuestions = totalnumberofQuestions + arrayofLabels[i].count
        }
        return totalnumberofQuestions
    }
    func calculateGrade () {
        if let length = lengthOfQuiz {
            let add:Double = 100/Double(length)
            quizGrade = quizGrade + add
        }
    }
    func saveAnswer (answerStatus answer:String) {
        if let select = answerSelected {
            saveAnswersArray.insert("\(answer)--> \(select)", atIndex: traverseSaveAnswwerArray)
            traverseSaveAnswwerArray = traverseSaveAnswwerArray + 1
        }
    }
    func endQuiz () {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let menuNavigationController = storyboard.instantiateViewControllerWithIdentifier("printGradeNavigatorControl") as? UINavigationController else {
            return
        }
        if let menuViewController = menuNavigationController.childViewControllers.first as? FinalQuizGradeViewController {
            menuViewController.finalGrade = quizGrade
            menuViewController.arraysofAnswers = saveAnswersArray
            menuViewController.quizTitle = quizTitle!
        }
        self.presentViewController(menuNavigationController, animated: true, completion: nil)
    }
    func generateRandomNumber (randomRange range: UInt32)-> Int {
        return Int(arc4random_uniform(range))
    }
    func callNextView () {
        let randomNumber = generateRandomNumber(randomRange: 2)
        if randomNumber == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let menuNavigationController = storyboard.instantiateViewControllerWithIdentifier("fillInTheBlankNavigator") as? UINavigationController else {
                return
            }
            if let menuViewController = menuNavigationController.childViewControllers.first as? FillinTheBlankViewController {
                menuViewController.arrayofLabels = arrayofLabels
                menuViewController.arrayofTerms = arrayofTerms
                menuViewController.arrayOfQuizImages = arrayOfQuizImages
                menuViewController.quizTitle = quizTitle
                menuViewController.isRandom = true
                menuViewController.quizGrade = quizGrade
                menuViewController.traverse2DArray = traverse2DArray
                menuViewController.traverseImageArray = traverseImageArray
                menuViewController.traverseSaveAnswwerArray = traverseSaveAnswwerArray
                menuViewController.saveAnswersArray = saveAnswersArray
                menuViewController.questionsAskedAlready = questionsAskedAlready
                menuViewController.timer = timer
                menuViewController.minutesLeftForTheQuiz = minutesLeftForTheQuiz
                menuViewController.secondsLeftForTheQuiz = secondsLeftForTheQuiz
                menuViewController.isTermQuestion = isTermQuestion
                menuViewController.isTypeOfQuestionRandom = isTypeOfQuestionRandom
                
            }
            self.presentViewController(menuNavigationController, animated: true, completion: nil)
        }
        else if randomNumber == 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let menuNavigationController = storyboard.instantiateViewControllerWithIdentifier("multipleChoiceNavigator") as? UINavigationController else {
                return
            }
            if let menuViewController = menuNavigationController.childViewControllers.first as? MultipleChoiceViewController {
                menuViewController.arrayofLabels = arrayofLabels
                menuViewController.arrayofTerms = arrayofTerms
                menuViewController.arrayOfQuizImages = arrayOfQuizImages
                menuViewController.quizTitle = quizTitle
                menuViewController.isRandom = true
                menuViewController.quizGrade = quizGrade
                menuViewController.traverse2DArray = traverse2DArray
                menuViewController.traverseImageArray = traverseImageArray
                menuViewController.traverseSaveAnswwerArray = traverseSaveAnswwerArray
                menuViewController.saveAnswersArray = saveAnswersArray
                menuViewController.questionsAskedAlready = questionsAskedAlready
                menuViewController.timer = timer
                menuViewController.minutesLeftForTheQuiz = minutesLeftForTheQuiz
                menuViewController.secondsLeftForTheQuiz = secondsLeftForTheQuiz
                menuViewController.isTermQuestion = isTermQuestion
                menuViewController.isTypeOfQuestionRandom = isTypeOfQuestionRandom
            }
            self.presentViewController(menuNavigationController, animated: true, completion: nil)
        }
    }
    
}
//MARK: - UITableViewDataSource
extension MultipleChoiceViewController {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberofRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("multiplechoiceCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = arrayOfPossibleAnswers[indexPath.row]
        return cell
    }
    
}
//MARK: - UITableViewDelegate
extension MultipleChoiceViewController {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text {
            questionWrongMessage.hidden = true
            saveRowSelected(IndexPath: cell)
        }
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
//MARK: Cancel PopUp Dialog
extension MultipleChoiceViewController {
    @IBAction func CancelQuizAction(sender: UIBarButtonItem) {
        showPopup(message: String.localizedStringWithFormat("Do you want to quit the quiz"),
                  buttons: [CancelButton(title: String.localizedStringWithFormat("No"), action: nil),
                    DefaultButton(title: String.localizedStringWithFormat("Yes"), action: { self.unwindFunc()
                    })])
    }
    func showPopup(withTitle title: String? = nil, message: String, buttons: [PopupDialogButton]){
        let popup = PopupDialog(title: title,
                                message: message,
                                transitionStyle: .BounceDown,
                                buttonAlignment: .Horizontal)
        popup.addButtons(buttons)
        presentViewController(popup, animated: true, completion: nil)
    }
    func unwindFunc () {
        let validView = QuizzesDetailViewController()
        if quizTitle == validView.getQuizTittle() {
           self.performSegueWithIdentifier("unwindToCustomize", sender: self)
        }
        else {
            self.performSegueWithIdentifier("unwindToMenu", sender: self)
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
//MARK: TIME CONTROLERS 
extension MultipleChoiceViewController {
    func startTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(01.0, target: self, selector: #selector(MultipleChoiceViewController.countDown), userInfo: nil, repeats: true)
        
    }
    func printRemainedTime () {
        if minutesLeftForTheQuiz < 10 {
            if secondsLeftForTheQuiz < 10 {
                timeRemainedLabel.text = "Time Remaining: 0\(minutesLeftForTheQuiz): 0\(secondsLeftForTheQuiz)"
            }
            else {
                timeRemainedLabel.text = "Time Remaining: 0\(minutesLeftForTheQuiz): \(secondsLeftForTheQuiz)"
            }

        }
        else {
            if secondsLeftForTheQuiz < 10 {
                timeRemainedLabel.text = "Time Remaining: \(minutesLeftForTheQuiz): 0\(secondsLeftForTheQuiz)"
            }
            else {
                timeRemainedLabel.text = "Time Remaining: \(minutesLeftForTheQuiz): \(secondsLeftForTheQuiz)"
            }

        }
        
    }
    func countDown () {
        
        if secondsLeftForTheQuiz > 0 {
            secondsLeftForTheQuiz = secondsLeftForTheQuiz - 1
            printRemainedTime()
        }
        else {
            if minutesLeftForTheQuiz > 0 {
                minutesLeftForTheQuiz = minutesLeftForTheQuiz - 1
                secondsLeftForTheQuiz = 60
                printRemainedTime()
                
            }
            else {
                printTimeEndMessage()
            }
           
        }
    }
    
    func printTimeEndMessage () {
        showPopup(message: String.localizedStringWithFormat("Time is up, press continue to finish the quiz. Good Luck next time"),
                  buttons: [DefaultButton(title: String.localizedStringWithFormat("Continue"), action: { self.endQuiz()
                    })])
    }
    
}



