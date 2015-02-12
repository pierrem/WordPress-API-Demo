//
//  DetailViewController.swift
//  WordPress-API
//
//  Created by Pierre Marty on 11/02/2015.
//  Copyright (c) 2015 Pierre Marty. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    
    let webService = WordPressWebServices()
    var postContent:Dictionary<String, AnyObject> = [:]
    
    var detailItem: AnyObject? {
        didSet {
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item. We test titleLabel as configureView can be called before titleLabel is ok
        if let titleLabel = self.titleLabel as UILabel?, postDesc = self.detailItem as? Dictionary<String, AnyObject> {
            titleLabel.text = postDesc["title"] as? String
            self.updatePost()
        }
    }
    
    func updatePost() {
        if let postDesc = self.detailItem as? Dictionary<String, AnyObject>, identifier = postDesc["ID"] as? Int{
            webService.postByIdentifier(identifier, completionHandler: { (postContent, error) -> Void in
                if postContent != nil {
                    self.postContent = postContent
                    dispatch_async(dispatch_get_main_queue(), { // access to UI in the main thread
                        self.updateWebView()
                    })
                }
            })
        }
    }
    
    func updateWebView() {
        if let contentString = postContent["content"] as? String {
            webView.loadHTMLString(contentString, baseURL: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
    
}



