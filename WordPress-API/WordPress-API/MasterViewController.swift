//
//  MasterViewController.swift
//  WordPress-API
//
//  Created by Pierre Marty on 11/02/2015.
//  Copyright (c) 2015 Pierre Marty. All rights reserved.
//

//
//  This controller is in charge of the list of categories
//

import UIKit

class MasterViewController: UITableViewController {
    
    let webService = WordPressWebServices()
    var categories = [Dictionary<String, AnyObject>]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let split = self.splitViewController {
//            let controllers = split.viewControllers
//        }
        self.updateCategoryList()
    }
    
    func updateCategoryList() {
        webService.categories({ (categories, error) -> Void in
            if categories != nil {
                self.categories = []
                for category in categories {
                    if let catPostCount = category["post_count"] as? Int where catPostCount > 0 {
                        self.categories.append(category)
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), { // access to UI in the main thread
                    self.tableView.reloadData()
                })
            }
        })
    }

    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPosts" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let category = categories[indexPath.row]
                let postListViewController = segue.destinationViewController as! PostListViewController
                postListViewController.category = category
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 
        let category = categories[indexPath.row]
        cell.textLabel!.text = category["name"] as? String
        return cell
    }
    

}

