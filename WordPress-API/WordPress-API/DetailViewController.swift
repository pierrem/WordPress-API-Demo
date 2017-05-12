//
//  DetailViewController.swift
//  WordPress-API
//
//  Created by Pierre Marty on 11/02/2015.
//  Copyright (c) 2015 Pierre Marty. All rights reserved.
//


import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var postContent:Dictionary<String, AnyObject>? = [:]
    
    var detailItem: Any? {
        didSet {
            self.updatePost()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add the displayModeButtonItem in the navigation bar of the detail view controller (visible on iPad in portrait mode)
        self.navigationController!.topViewController!.navigationItem.leftBarButtonItem = splitViewController!.displayModeButtonItem
    }

    
    func updatePost() {
        if let postDesc = self.detailItem as? Dictionary<String, AnyObject>, let identifier = postDesc["ID"] as? Int {
            WordPressWebServices.sharedInstance.postByIdentifier(identifier, completionHandler: { (postContent, error) -> Void in
                if postContent != nil {
                    self.postContent = postContent
                    DispatchQueue.main.async(execute: { // access to UI in the main thread
                        self.updateWebView()
                    })
                }
            })
        }
    }
    
    func updateWebView() {
        if let contentString = self.postContent!["content"] as? String {
            webView.loadHTMLString(contentString, baseURL: nil)
        }
        if let titleString = self.postContent!["title"] as? String {
            self.navigationItem.title = String(htmlEncodedString: titleString);
        }
        
    }
    
}



