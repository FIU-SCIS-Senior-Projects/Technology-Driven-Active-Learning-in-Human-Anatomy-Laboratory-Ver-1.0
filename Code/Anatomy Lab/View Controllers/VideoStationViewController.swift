//
//  VideoStationViewController.swift
//  Anatomy Lab
//
//  Created by Darian Mendez on 9/30/16.
//

import UIKit
import SwiftyJSON

class VideoStationViewController: UIViewController {

    
    //@IBOutlet var videoView: UIWebView!
   

    var videoInfo: JSON?
    var videoSelected: Int?
  
    @IBOutlet weak var webVideo: UIWebView!
    
    @IBOutlet weak var videoTitle: UILabel!
    
    @IBOutlet weak var videoDescription: UILabel!
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
      
        setupView ()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension VideoStationViewController {
 
    func setupView (){

        if let data = Videos(withJSON: videoInfo!){
          videoTitle.text = data.title
          videoDescription.text = data.videodescription
          let url = data.url
          setVideoWebView (url)
        }
        else {
            print ("Error, nil object")
             }
    }
    //The following func is use to set the youtube frame in the webView
    func setVideoWebView (videourl: String){
        webVideo.allowsInlineMediaPlayback = true
        self.webVideo.loadHTMLString("<iframe width=\"\(webVideo.frame.width)\" height=\"\(webVideo.frame.height)\" src=\"\(videourl)\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
    }
    
  }
