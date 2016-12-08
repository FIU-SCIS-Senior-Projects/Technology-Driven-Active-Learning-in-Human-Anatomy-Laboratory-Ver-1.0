//
//  GeneralStationViewController.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 9/22/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import UIKit
import SwiftyJSON

class GeneralStationViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var terminologyTableView: UITableView!
    @IBOutlet weak var termImageView: UIImageView!
    @IBOutlet weak var zoomButton: UIButton!
    
    var searchControllerDelegate: SearchControllerDelegate?
    var generalStationViewModel: GeneralStationViewModel?
    var jsonvideoselected: Int = 0
    
    var searchController: UISearchController?
    var searchText: String?
    
    var terminologyTableViewDelegateDatasource: LabTerminologyDelegateDatasource?
    
    //videoCounter will have the value for how many videos are in the station.
    var videoCounter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTerminologyTableView()
        setupViews()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setupSearchController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK: IBActions
extension GeneralStationViewController {

    @IBAction func unwindToTerm (segue: UIStoryboardSegue) {}

    @IBAction func takeQuizPressed(sender: UIButton) {
        self.performSegueWithIdentifier("takeQuizWindow", sender: self)
    }
    @IBAction func videoPressed(sender: UIButton) {
        
        //Check with view to send, the POPUP (if there is more than one video, or if there is 1 video only
        //Show the video window.
        if videoCounter > 1 {
            self.performSegueWithIdentifier("videoPopupLink", sender: self)
        } else {
            jsonvideoselected = 0
            self.performSegueWithIdentifier("videoWindow", sender: self)
        }
        
    }
    @IBAction func zoomAction(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let menuNavigationController = storyboard.instantiateViewControllerWithIdentifier("imageZoomNavigator") as? UINavigationController else {
            return
        }
        if let menuViewController = menuNavigationController.childViewControllers.first as? ZoomImageViewController {
            menuViewController.newImage = termImageView.image
            menuViewController.isComingFromTerm = true
        }
        self.presentViewController(menuNavigationController, animated: true, completion: nil)
    }
    
}

//MARK: Private API
private extension GeneralStationViewController {
    
    func setupTerminologyTableView() {
        
        terminologyTableViewDelegateDatasource = LabTerminologyDelegateDatasource()
        terminologyTableViewDelegateDatasource?.cellSelectionHandler = { [weak self] term in
            
            self?.termImageView.image = UIImage(named: term.first?.1["image"].stringValue ?? "")
            self?.zoomButton.hidden = false
        }
        
        terminologyTableView.scrollEnabled = true
        terminologyTableView.delegate = terminologyTableViewDelegateDatasource
        terminologyTableView.dataSource = terminologyTableViewDelegateDatasource
    }
    
    func setupSearchController() {
        
        searchControllerDelegate = SearchControllerDelegate()
        
        searchControllerDelegate?.searchControllerTextHandler = { [weak self] searchText in
            self?.filterTermsForSearchText(searchText)
        }
        
        searchControllerDelegate?.searchBarCancelButtonTapped = { [weak self] in
            self?.terminologyTableView.reloadData()
        }
        
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchBar.autocapitalizationType = .None
        searchController?.searchBar.autocorrectionType = .No
        searchController?.searchBar.keyboardType = .NamePhonePad
        searchController?.searchBar.delegate = searchControllerDelegate
        
        searchController?.searchResultsUpdater = searchControllerDelegate
        searchController?.dimsBackgroundDuringPresentation = false
        terminologyTableView.tableHeaderView = searchController?.searchBar
    }

    func setupViews() {
        zoomButton.hidden = true
        if let validViewModel = generalStationViewModel {
            configure(withViewModel: validViewModel)
            countVideos(withViewModel: validViewModel)
        }
        
        if let parentVC = parentViewController?.parentViewController as? GeneralSplitViewController {
            let menuButton = UIBarButtonItem(title: String.localizedStringWithFormat("Labs"),
                                             style: .Done,
                                             target: parentVC.displayModeButtonItem().target,
                                             action: parentVC.displayModeButtonItem().action)
            
            navigationItem.leftBarButtonItem = menuButton
        }
        
        let reviewMenuButton = UIBarButtonItem(title: NSLocalizedString("Review", comment: ""),
                                               style: .Plain,
                                               target: self,
                                               action: #selector(GeneralStationViewController.displayReviewPrompt))
        
        navigationItem.rightBarButtonItem = reviewMenuButton
    }
    
    func markStationWith(status: StationReview) {
        
        guard let currentUser = User.currentUser() else {
            return
        }
        
        currentUser.markStationWith(status)
        
    }
    
    func configure(withViewModel viewModel: GeneralStationViewModel){
        
        navigationItem.title = viewModel.title()
        titleLabel.text = viewModel.title()
        terminologyTableViewDelegateDatasource?.terms = viewModel.terms()
        terminologyTableView.reloadData()
        
    }
    //A function use to count how many videos the station have.
    func countVideos(withViewModel viewModel: GeneralStationViewModel) {
        videoCounter = viewModel.videoData().count
    }
    
}

//MARK: Filtering function
private extension GeneralStationViewController {
    
    func filterTermsForSearchText(searchText: String? = "", scope: String = "All") {
        
        guard let validViewModel = generalStationViewModel else {
            return
        }
        terminologyTableViewDelegateDatasource?.terms = validViewModel.terms(searchText)
        terminologyTableView.reloadData()
    }
    
}

//MARK: Public API
extension GeneralStationViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "videoWindow" {
            
            let videoStationViewController = segue.destinationViewController as! VideoStationViewController
            if let data = generalStationViewModel?.videoData() {
                videoStationViewController.videoInfo = data [jsonvideoselected]
            }
            
        }
        else if segue.identifier == "videoPopupLink" {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let menuNavigationController = storyboard.instantiateViewControllerWithIdentifier("videoPopUpNavigator") as? UINavigationController else {
                return
            }
            if let menuViewController = menuNavigationController.childViewControllers.first as? VideosPopUpTableViewController {
                if let data = generalStationViewModel?.videoData() {
                    menuViewController.videoStationInfo = data
                    menuViewController.videoCount = videoCounter
                }
                menuViewController.videoSelectedHandler = { [weak self] index in
                    print("handler")
                    self?.jsonvideoselected = index
                    self?.performSegueWithIdentifier("videoWindow", sender: nil)
                    menuNavigationController.dismissViewControllerAnimated(true, completion: nil)
                }
            }
            menuNavigationController.modalPresentationStyle = UIModalPresentationStyle.Popover
            menuNavigationController.preferredContentSize = CGSizeMake(400, 280)
            presentViewController(menuNavigationController, animated: true, completion: nil)
            
            let popoverPresentationController = menuNavigationController.popoverPresentationController
            popoverPresentationController?.sourceView = videoButton
            popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.Down
            popoverPresentationController?.delegate = self
            
        }
            
        else if segue.identifier == "takeQuizWindow" {
            let takeQuizViewController = segue.destinationViewController as! TakeQuizViewController
            if let data = generalStationViewModel?.takeQuizData() {
                if let metadata = generalStationViewModel?.takeQuizMetadata(data) {
                    takeQuizViewController.takeQuizMetadata = metadata
                    if let questions = generalStationViewModel?.takeQuizquestionsData(data){
                        takeQuizViewController.takeQuizQuestions = questions
                        
                    }
                }
            }
        }
    }
    
    func displayReviewPrompt() {
        
        let reviewAlert = UIAlertController(title: NSLocalizedString("Station review", comment: ""),
                                            message: NSLocalizedString("You can mark this station to keep track of your progress", comment: ""),
                                            preferredStyle: .Alert)
        
        let completedAction = UIAlertAction(title: NSLocalizedString("Completed", comment: ""),
                                            style: .Default,
                                            handler: { [weak self] _ in
                                                self?.markStationWith(.Completed)
                                            })
        
        
        let pendingAction = UIAlertAction(title: NSLocalizedString("Pending", comment: ""),
                                          style: .Default,
                                          handler: { [weak self] _ in
                                                self?.markStationWith(.Pending)
                                            })
        
        let favoriteAction = UIAlertAction(title: NSLocalizedString("Favorite", comment: ""),
                                           style: .Default,
                                           handler: { [weak self] _ in
                                                self?.markStationWith(.Favorite)
                                            })
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: .Cancel,
                                         handler: nil)
        
        reviewAlert.addAction(completedAction)
        reviewAlert.addAction(pendingAction)
        reviewAlert.addAction(favoriteAction)
        reviewAlert.addAction(cancelAction)
        
        presentViewController(reviewAlert, animated: true, completion: nil)
        
    }
    
}

//MARK: UIPopoverPresentationControllerDelegate
extension GeneralStationViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
        
}
