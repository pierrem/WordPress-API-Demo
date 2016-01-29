//
//  PostTableViewCell.swift
//  WordPress-API
//
//  Created by Pierre Marty on 29/01/2016.
//  Copyright © 2016 Pierre Marty. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var featuredImageView: UIImageView!
    
    var postIdentifier:Int = 0
    var imageRequestedForIdentifier:Int = 0
    
    func configureWithPostDictionary (post:Dictionary<String, AnyObject>) {
        
        let title = post["title"] as? String
        self.titleLabel!.text = String(htmlEncodedString: title!)
        
        self.dateLabel!.text = nil;
        
        if let dateStringFull = post["date"] as? String {
            // date is in the format "2016-01-29T01:45:33+02:00",
            let dateString = dateStringFull.substringToIndex(dateStringFull.startIndex.advancedBy(10))  // keep only the date part
            
            let parsingDateFormatter = NSDateFormatter()        // TODO: a static var
            parsingDateFormatter.dateFormat = "yyyy-MM-dd"
            let date = parsingDateFormatter.dateFromString(dateString)
            
            let printingDateFormatter = NSDateFormatter()       // TODO: a static var
            printingDateFormatter.dateStyle = .LongStyle
            printingDateFormatter.timeStyle = .NoStyle
            
            self.dateLabel!.text = printingDateFormatter.stringFromDate(date!)
        }
        
        self.featuredImageView!.image = nil;
        if let idf = post["ID"] as? Int {
            postIdentifier = idf
        }
        
        if let url = post["featured_image"] as? String {    // there is a link to an image
            if url != "" {
                imageRequestedForIdentifier = postIdentifier
                WordPressWebServices.sharedInstance.loadImage (url, completionHandler: {(image, error) -> Void in
                    dispatch_async(dispatch_get_main_queue(), {
                        // test if the cell has been recycled since we request the image !
                       if self.postIdentifier == self.imageRequestedForIdentifier {
                            self.featuredImageView!.image = image;
                            self.setNeedsLayout()
                        }
                        else {
                            print("postIdentifier: \(self.postIdentifier) different from imageRequestedForIdentifier: \(self.imageRequestedForIdentifier)")
                        }
                    })
                })
            }
        }
        
    }
    
}

