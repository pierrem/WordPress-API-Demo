//
//  WordPressWebServices.swift
//  WordPress-API
//
//  Created by Pierre Marty on 11/02/2015.
//  Copyright (c) 2015 Pierre Marty. All rights reserved.
//

// WordPress REST API documentation:  https://developer.wordpress.com/docs/api/


import Foundation


class WordPressWebServices {
    
    private var baseURL:String? = nil;
    
    convenience init(url: String) {
        self.init()
        self.baseURL = url
    }
    
    // Returns an array of posts (a dictionary with ID, name, slug and post_count keys) tagged with a given category identifier
    func categories (completionHandler:(Array<Dictionary<String, AnyObject>>!, NSError!) -> Void) {
        var requestURL = baseURL! + "/categories?fields=ID,name,slug,post_count"
        let url = NSURL(string: requestURL)!
        let urlSession = NSURLSession.sharedSession()
        
        let dataTask = urlSession.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                completionHandler(nil, error);
            }
            var jsonError: NSError?
            var jsonResult:AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError)
            var categories:Array<Dictionary<String, AnyObject>> = []
            
            // Attention, version Swift 1.2 is required to compile next line !
            if let resultDictionary = jsonResult as? Dictionary<String, AnyObject>, returnedCategories = resultDictionary["categories"] as? [Dictionary<String, AnyObject>]{
                for category in returnedCategories {
                    if let catID = category["ID"] as? Int,
                        catName = category["name"] as? String,
                        catSlug = category["slug"] as? String,
                        catPostCount = category["post_count"] as? Int
                    {
                        categories.append(category)
                    }
                }
            }
            completionHandler(categories, jsonError);
        })
        
        dataTask.resume()
    }
    
    // Returns an array of posts (a dictionary with ID and title keys) tagged with a given category identifier
    func postsInCategory (categoryIdentifier:String, completionHandler:(Array<Dictionary<String, AnyObject>>!, NSError!) -> Void) {
        var requestURL = baseURL! + "/posts/?category=\(categoryIdentifier)&fields=ID,title"
        let url = NSURL(string: requestURL)!
        let urlSession = NSURLSession.sharedSession()
        
        let dataTask = urlSession.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                completionHandler(nil, error);
            }
            var jsonError: NSError?
            var jsonResult:AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError)
            var articles:Array<Dictionary<String, AnyObject>> = []
            
            if let resultDictionary = jsonResult as? Dictionary<String, AnyObject>, posts = resultDictionary["posts"] as? [Dictionary<String, AnyObject>]{
                for post in posts {
                    if let postID = post["ID"] as? Int, postTitle = post["title"] as? String  {
                        articles.append(post)
                    }
                }
            }
            completionHandler(articles, jsonError);
        })
        
        dataTask.resume()
    }
    
}

