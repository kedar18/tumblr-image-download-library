//
//  DownloadManager.swift
//  DownloadManager
//
//  Created by Kedar Navgire on 14/01/17.
//  Copyright © 2017 kedar. All rights reserved.
//

import Foundation
import UIKit

class DownloadManager
{
     static let session = URLSession.shared
     static let queue = DispatchQueue(label: "download_manager")
    
    
    class func downloadFromUrl(stringUrl:String,completion: @escaping (URL?,URLResponse?,Error?) -> Void)
    {
        guard let url = URL(string: stringUrl) else{
            print("url failed to create")
            return}
        
        
        queue.async {
            
            let downloadTask = session.downloadTask(with: url, completionHandler: completion)
            downloadTask.resume()
        }
    
    }
    
    
    class func storeCacheForFile(file:AnyObject,key:String)
    {
        //print(key)
        Model.sharedCache.setObject(file, forKey: key as NSString)
        
        //print(objectCache)
    }
    
    class func getCacheForFile(key:String) -> AnyObject
    {
        //print(key)
        //print(Model.sharedCache.object(forKey: key as AnyObject)  )
        
        return Model.sharedCache.object(forKey: key as NSString) as AnyObject
    }

    
}
