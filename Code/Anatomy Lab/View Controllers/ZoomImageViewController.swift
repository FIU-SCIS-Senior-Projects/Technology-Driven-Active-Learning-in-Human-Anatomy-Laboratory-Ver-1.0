//
//  ZoomImageViewController.swift
//  Anatomy Lab
//
//  Created by Darian Mendez on 11/10/16.
//

import UIKit

class ZoomImageViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    var newImage: UIImage?
    //The following variable is determine to know if the image to make a zoom in is coming from the term view or a quiz view.
    var isComingFromTerm = true
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//Mark Action buttons
extension ZoomImageViewController {
    @IBAction func cancelAction(sender: UIBarButtonItem) {
        if isComingFromTerm == true {
          self.performSegueWithIdentifier("unwindToTerm", sender: self)
        }
        else {
           self.performSegueWithIdentifier("unwindToQuiz", sender: self)
        }
    }
}
//Mark SetUP Views
extension ZoomImageViewController {
    func setUpView () {
        
        self.scrollView.maximumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        if newImage != nil {
           imageView.image = newImage 
        }
        
    }
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
