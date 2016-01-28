//
//  String+html.swift
//  WordPress-API
//
//  Created by Pierre Marty on 28/01/2016.
//  Copyright © 2016 Pierre Marty. All rights reserved.
//

import UIKit

// http://stackoverflow.com/questions/25607247/how-do-i-decode-html-entities-in-swift

extension String {
    init(htmlEncodedString: String) {
        let encodedData = htmlEncodedString.dataUsingEncoding(NSUTF8StringEncoding)!
        let attributedOptions : [String: AnyObject] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
        ]
        
        var attributedString:NSAttributedString?
        
        do{
            attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
        }catch{
            print(error)
        }
        
        self.init(attributedString!.string)
    }
}
