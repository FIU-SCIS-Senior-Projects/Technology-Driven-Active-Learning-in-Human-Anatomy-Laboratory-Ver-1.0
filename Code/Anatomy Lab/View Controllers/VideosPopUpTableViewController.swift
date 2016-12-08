//
//  VideosPopUpTableViewController.swift
//  Anatomy Lab
//
//  Created by Darian Mendez on 9/30/16.
//

import UIKit
import SwiftyJSON

class VideosPopUpTableViewController: UITableViewController {

    typealias VideoSelectedHandler = (Int) -> Void
    var videoSelectedHandler: VideoSelectedHandler?
        
    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    var videoStationInfo: JSON?
    var videoCount: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView ()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

 private extension VideosPopUpTableViewController {
    
    @IBAction func dismiss(sender: UIBarButtonItem) {
       dismissViewControllerAnimated(true, completion:nil)
    }
    
    func setupView (){
       closeButton.title = String.localizedStringWithFormat("Close")
    }

    
}

//MARK: -Auxiliars 
extension VideosPopUpTableViewController {
    func count () -> Int {
        if let count = videoCount {
            return count
        }else {
            print ("Error")
            return -1
        }
    }
}
//MARK: - UITableViewDataSource
extension VideosPopUpTableViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return count()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("videoCell", forIndexPath: indexPath)
        if let data = videoStationInfo?[indexPath.row] {
            let videos: Videos = Videos (withJSON: data)!
            cell.textLabel?.text = videos.title
        
        }
            return cell
    }
    
}

//MARK: - UITableViewDelegate
extension VideosPopUpTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        videoSelectedHandler?(indexPath.row)
        
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
    
}

