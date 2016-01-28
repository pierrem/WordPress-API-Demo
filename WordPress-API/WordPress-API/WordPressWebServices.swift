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
    
    // your site url here !
    
    //    static let sharedInstance = WordPressWebServices(url:"https://public-api.wordpress.com/rest/v1.1/sites/developer.wordpress.com")
    
    static let sharedInstance = WordPressWebServices(url:"https://public-api.wordpress.com/rest/v1.1/sites/www.alpeslog.com")
    
    private var baseURL:String?;
    
    convenience init(url: String) {
        self.init()
        self.baseURL = url
    }
    
    
    func postByIdentifier (identifier:Int, completionHandler:(Dictionary<String, AnyObject>?, NSError?) -> Void) {
        let requestURL = baseURL! + "/posts/\(identifier)?fields=date,title,content"
        let url = NSURL(string: requestURL)!
        let urlSession = NSURLSession.sharedSession()
        
        let dataTask = urlSession.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                completionHandler(nil, error);
                return;
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
    
    
    func postsForPage (page:Int, number:Int, completionHandler:(Array<Dictionary<String, AnyObject>>?, NSError?) -> Void) {
        let requestURL = baseURL! + "/posts/?page=\(page)&number=\(number)&fields=ID,title,featured_image"
        let url = NSURL(string: requestURL)!
        let urlSession = NSURLSession.sharedSession()
        
        let dataTask = urlSession.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                completionHandler(nil, error);
                return;
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
            
            if let resultDictionary = jsonResult as? Dictionary<String, AnyObject>,
                posts = resultDictionary["posts"] as? [Dictionary<String, AnyObject>] {
                    for post in posts {
                        if let _ = post["ID"] as? Int,
                            _ = post["title"] as? String  {
                                articles.append(post)
                        }
                    }
            }
            completionHandler(articles, jsonError);
        })
        
        dataTask.resume()
    }
    
    
    func loadImage (url: String, completionHandler:(UIImage?, NSError?) -> Void) {
        let url = NSURL(string: url)!
        let urlSession = NSURLSession.sharedSession()
        
        let dataTask = urlSession.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            if error == nil {
                let image = UIImage(data:data!);
                completionHandler(image, nil);
            }
            else {
                completionHandler(nil, error);
            }
        })
        
        dataTask.resume()
    }
    
}





