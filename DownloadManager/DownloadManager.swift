//
//  DownloadManager.swift
//  DownloadManager
//
//  Created by Kedar Navgire on 14/01/17.
//  Copyright © 2017 kedar. All rights reserved.
//

import Foundation
import UIKit

open class DownloadManager
{
    fileprivate static let session = URLSession.shared
    fileprivate static let queue = DispatchQueue(label: "download_manager")
    static let sharedCache: NSCache = { () -> NSCache<AnyObject, AnyObject> in
        let cache = NSCache<AnyObject, AnyObject>()
        cache.totalCostLimit = 60*1024*1024 // 60mb
        return cache
    }()
    
    
    open class func downloadFrom(stringUrl:String,completion: @escaping (URL?,URLResponse?,Error?) -> Void)
    {
        guard let url = URL(string: stringUrl) else{
            print("url failed to create")
            return}
        
        queue.async {
            
            let downloadTask = session.downloadTask(with: url, completionHandler: completion)
            downloadTask.resume()
        }
        
    }
    
    open class func storeCache(forFile:AnyObject,cost:Int,key:String)
    {
        sharedCache.setObject(forFile, forKey: key as AnyObject, cost: cost)
    }
    
    open class func getCacheForFile(key:String) -> AnyObject
    {
        return sharedCache.object(forKey: key as NSString) as AnyObject
    }
    
}
