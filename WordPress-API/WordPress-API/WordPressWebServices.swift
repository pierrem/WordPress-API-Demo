//
//  WordPressWebServices.swift
//  WordPress-API
//
//  Created by Pierre Marty on 11/02/2015.
//  Copyright (c) 2015 Pierre Marty. All rights reserved.
//

// WordPress REST API documentation:  https://developer.wordpress.com/docs/api/


import Foundation
import UIKit

class WordPressWebServices {
    
    private var baseURL:String? = "https://public-api.wordpress.com/rest/v1.1/sites/developer.wordpress.com";   // your site url here !
    //    private var baseURL:String? = "https://public-api.wordpress.com/rest/v1.1/sites/www.alpeslog.com";
    
    convenience init(url: String) {
        self.init()
        self.baseURL = url
    }
    
    // Returns an array of categories (a dictionary with ID, name, slug and post_count keys)
    func categories (completionHandler:(Array<Dictionary<String, AnyObject>>!, NSError!) -> Void) {
        let requestURL = baseURL! + "/categories?fields=ID,name,slug,post_count"
        let url = NSURL(string: requestURL)!
        let urlSession = NSURLSession.sharedSession()
        
        let dataTask = urlSession.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                completionHandler(nil, error);
            }
            var jsonError: NSError?
            var jsonResult:AnyObject?
            do {
                jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
            } catch let error as NSError {
                jsonError = error
                jsonResult = nil
            } catch {
                fatalError()
            }
            var categories:Array<Dictionary<String, AnyObject>> = []
            
            // Attention, version Swift 1.2 is required to compile next line !
            if let resultDictionary = jsonResult as? Dictionary<String, AnyObject>, returnedCategories = resultDictionary["categories"] as? [Dictionary<String, AnyObject>]{
                for category in returnedCategories {
                    if let _ = category["ID"] as? Int,
                        _ = category["name"] as? String,
                        _ = category["slug"] as? String,
                        _ = category["post_count"] as? Int
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
        let requestURL = baseURL! + "/posts/?category=\(categoryIdentifier)&fields=ID,title,featured_image"
        let url = NSURL(string: requestURL)!
        let urlSession = NSURLSession.sharedSession()
        
        let dataTask = urlSession.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                completionHandler(nil, error);
            }
            var jsonError: NSError?
            var jsonResult:AnyObject?
            do {
                jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
            } catch let error as NSError {
                jsonError = error
                jsonResult = nil
            } catch {
                fatalError()
            }
            var articles:Array<Dictionary<String, AnyObject>> = []
            
            if let resultDictionary = jsonResult as? Dictionary<String, AnyObject>, posts = resultDictionary["posts"] as? [Dictionary<String, AnyObject>]{
                for post in posts {
                    if let _ = post["ID"] as? Int, _ = post["title"] as? String  {
                        articles.append(post)
                    }
                }
            }
            completionHandler(articles, jsonError);
        })
        
        dataTask.resume()
    }
    
    
    
    func postByIdentifier (identifier:Int, completionHandler:(Dictionary<String, AnyObject>!, NSError!) -> Void) {
        let requestURL = baseURL! + "/posts/\(identifier)?fields=date,title,content"
        let url = NSURL(string: requestURL)!
        let urlSession = NSURLSession.sharedSession()
        
        let dataTask = urlSession.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                completionHandler(nil, error);
            }
            var jsonError: NSError?
            var jsonResult:AnyObject?
            do {
                jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
            } catch let error as NSError {
                jsonError = error
                jsonResult = nil
            } catch {
                fatalError()
            }
            completionHandler(jsonResult as? Dictionary<String, AnyObject>, jsonError);
        })
        
        dataTask.resume()
    }
    
    
    func loadImage (url: String, completionHandler:(UIImage!, NSError!) -> Void) {
        let url = NSURL(string: url)!
        let urlSession = NSURLSession.sharedSession()
        
        let dataTask = urlSession.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            if error == nil {
                let image = UIImage(data:data!);
                completionHandler(image, error);
            }
        })
        
        dataTask.resume()
    }
    
}





