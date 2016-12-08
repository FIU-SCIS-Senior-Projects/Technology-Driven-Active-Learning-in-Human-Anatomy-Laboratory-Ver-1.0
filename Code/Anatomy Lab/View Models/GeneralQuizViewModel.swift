//
//  GeneralQuizViewModel.swift
//  Anatomy Lab
//
//  Created by Darian Mendez on 10/13/16.
//

import UIKit
import SwiftyJSON

final class GeneralQuizViewModel: NSObject {
    
    
    private let imagesKey="images"
    private let labelsKey="labels"
    private let labelKey="label"
    private let termKey="term"
    private let imagename="imagename"
    private let metadataKey = "metadata"
    private var quizData: JSON?
    private var fixpositionforthelabels: Int = 0
    
    
    
    
    required init?(forQuiz quiz: JSON){
        quizData = quiz
        print ("quizData\(quizData)")
        super.init()
    }
    //Function to get the Image Name to print in the Displayed Question. Send the JSON like:
    //data[quizzes][0][questions][0]
    func getImage (positionOfTheImage: Int)->String {
        if let imagename = quizData![imagesKey][positionOfTheImage][metadataKey][0][imagename].string{
            return imagename
        }
        return "Error Loading the image"
    }
    //Function to get a JSON array with all the labels of a selected image. Send the JSON like:
    //data[quizzes][0][questions][0][images][positionRequiered]
    func getLabelsofSelectedImage () -> [JSON] {
        return quizData![labelsKey].array!
    }
    func countImages ()-> Int {
        return quizData![imagesKey].count
    }
    func getLabel (positionoftheImage positionofTheImage: Int,positionofLabel:Int)-> String {
        return quizData![imagesKey][positionofTheImage][labelsKey][positionofLabel][labelKey].string!
    }
    func getTerm (positionoftheImage positionofTheImage: Int,positionofLabel:Int)-> String {
        return quizData![imagesKey][positionofTheImage][labelsKey][positionofLabel][termKey].string!
    }
    func countLabels (positionofTheImage: Int)->Int{
        return quizData![imagesKey][positionofTheImage][labelsKey].count
    }
    //Mark: Get the data functions
    func getImagesNames ()-> [String]{
        let end = countImages()
        var arrayofQuiz:[String]=[]
        for i in 0..<end {
            arrayofQuiz.insert(getImage(i), atIndex: i)
        }
        return arrayofQuiz
    }
    //The following function will populate the 2D arrays for the Labels and the Terms. The first loop will repeat according with the total of image that the station have under the quiz json. The nested loop will get all the labels and respective terms. The temporary arrays are just created to save the data while looping. Position i is for the image position, and position j is for the label and term position.
    func populateArray ( isAlabel isalabel: Bool) -> [[String]]{
        var arraytoreturn:[[String]] = []
        let amountofimages = countImages()
        for i in 0..<amountofimages {
            let countOfLabels = countLabels(i)
            var temp: [String] = []
            for j in 0..<countOfLabels {
                if isalabel == true {
                    temp.insert(getLabel(positionoftheImage: i, positionofLabel: j), atIndex: j)
                }
                else {
                    temp.insert(getTerm(positionoftheImage: i, positionofLabel: j), atIndex: j)
                }
            }
            arraytoreturn.insert(temp, atIndex: i)
        }
        return arraytoreturn
    }
    
    
    
}
