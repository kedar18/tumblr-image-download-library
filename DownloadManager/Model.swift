//
//  Model.swift
//  DownloadManager
//
//  Created by Kedar Navgire on 15/01/17.
//  Copyright © 2017 kedar. All rights reserved.
//

import Foundation


class Model
{
    static var num = 20
    static var username = "flowersonly"
    static let sharedCache: NSCache = { () -> NSCache<AnyObject, AnyObject> in 
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = 100
        cache.totalCostLimit = 10*1024*1024 // Max 10MB used.
        return cache
    }()
    
    
    static var photoObject:Array<String> = Array<String>()
    
    
    
    // this method only works for the tumblr public read json api
    // replace username with http://(username).tumblr.com/api/read/json
    //the response posts object should only have Type as photo
    
    class func fetchData(completion: @escaping (Bool)-> Void)
    {
        
        DownloadManager.downloadFromUrl(stringUrl: "http://\(username).tumblr.com/api/read/json?num=\(num)", completion: {
            url,response,error in
            
            guard error == nil
                else
            {
                print("Error Occurred \(error?.localizedDescription)")
                return
            }
            
            // beware content type is application/javascript
            
            if let data = try? Data(contentsOf: url!)
            {
                do
                {
                    // response trimming operation to a valid json
                    let dataString = String(data: data, encoding: .ascii)
                    let fistIndex = dataString!.index(dataString!.startIndex, offsetBy: 22)
                    let stringForJson = dataString!.substring(from: fistIndex)
                    let lastIndex = stringForJson.index(stringForJson.endIndex, offsetBy: -2)
                    let stringRemovingColon = stringForJson.substring(to: lastIndex)
                    
                    //print(stringRemovingColon)
                    
                    let data = stringRemovingColon.data(using: .utf8)
                    
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                    
                    //print(json["posts"]!)
                    
                    for object in (json["posts"]! as! NSArray)
                    {
                        let tempObject = object as! NSDictionary
                        if (tempObject.value(forKey: "photo-url-100") != nil)
                        {
                        photoObject.append(tempObject.value(forKey: "photo-url-100") as! String)
                        }
                    }
                    
                    completion(true)
                    
                    DownloadManager.storeCacheForFile(file: photoObject as AnyObject, key: "response")
                    
                    
                }catch let error
                {
                    print("error is--->",error.localizedDescription)
                    completion(false)
                }
                
            }
        })

    }
    
}
