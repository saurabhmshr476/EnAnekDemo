//
//  FlickrPhoto.swift
//  FlickrImageSearchDemo
//
//  Created by online on 16/09/18.
//  Copyright © 2018 online. All rights reserved.
//

import UIKit

class FlickrPhoto{
    var thumbnail : String?
    var largeImage : String?
    let photoID : String
    let farm : Int
    let server : String
    let secret : String

    init (photoID:String,farm:Int, server:String, secret:String) {
        self.photoID = photoID
        self.farm = farm
        self.server = server
        self.secret = secret
        self.thumbnail = self.flickrImageURLStr()
        self.largeImage = self.flickrImageURLStr("b")
    }
    
    func flickrImageURL(_ size:String = "m") -> URL? {
        if let url =  URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_\(size).jpg") {
            return url
        }
        return nil
    }
    
    func flickrImageURLStr(_ size:String = "m") -> String {
         let urlStr =  "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_\(size).jpg"
        return urlStr
    }
    
    func loadLargeImage(_ completion: @escaping (_ flickrPhoto:FlickrPhoto, _ error: NSError?) -> Void) {
        guard let loadURL = flickrImageURL("b") else {
            DispatchQueue.main.async {
                completion(self, nil)
            }
            return
        }
        
        let loadRequest = URLRequest(url:loadURL)
        
        URLSession.shared.dataTask(with: loadRequest, completionHandler: { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(self, error as NSError?)
                }
                return
            }
            
            guard data != nil else {
                DispatchQueue.main.async {
                    completion(self, nil)
                }
                return
            }
           
            DispatchQueue.main.async {
                completion(self, nil)
            }
        }) .resume()
    }
    
    func sizeToFillWidthOfSize(_ size:CGSize) -> CGSize {
        let returnSize = size
        return returnSize
    }
    
}

