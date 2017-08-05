//
//  Model.swift
//  DownloadManager
//
//  Created by Kedar Navgire on 15/01/17.
//  Copyright © 2017 kedar. All rights reserved.
//

import Foundation
import UIKit

class Model
{
    static var numOfLoadPages = 20
    static var username = ""
    static var photoObject:Array<String> = Array<String>()
    static let localCacheURL =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    fileprivate static let fileManager = FileManager.default
    
    
    class func fetchImageData(completion: @escaping (Bool)-> Void)
    {
        
        DownloadManager.downloadFrom(stringUrl: "http://\(username).tumblr.com/api/read/json?num=\(numOfLoadPages)", completion: {
            url,response,error in
            
            guard error == nil
                else
            {
                print("Error Occurred \(error!.localizedDescription)")
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
                    
                    DownloadManager.storeCache(forFile: photoObject as AnyObject, cost: photoObject.capacity, key: "response")
                    
                    
                }catch let error
                {
                    print("error is--->",error.localizedDescription)
                    completion(false)
                }
                
            }
        })
        
    }
    
    
    
    class func clearCache(completion: (Bool)-> Void){
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try fileManager.contentsOfDirectory( at: localCacheURL, includingPropertiesForKeys: nil, options: [])
            for file in directoryContents {
                do {
                    
                    try fileManager.removeItem(at: file)
                }
                catch let error as NSError {
                    print("something went wrong: \(error)")
                }
                
            }
            completion(true)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        completion(false)
    }
    
    class func storeToCacheDirectory(filename:String,data:Data)
    {
        let cachePath = localCacheURL.appendingPathComponent("imagecache")
        let imagePath = cachePath.appendingPathComponent(filename)
        
        if !FileManager.default.fileExists(atPath: cachePath.path)
        {
            do {
                try FileManager.default.createDirectory(atPath: cachePath.path, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription);
            }
        }
        
        do
        {
            try  data.write(to: imagePath, options: .atomic)
            
        }catch let error as NSError
        {
            print("error in writting to cache directory",error)
        }
        
    }
    
    class func getImageFromCacheDirectory(indexItem:String,completion: (Bool,URL?) -> Void)
    {
        let cachePath = localCacheURL.appendingPathComponent("imagecache")
        
        if fileManager.fileExists(atPath: cachePath.path)
        {
            do
            {
                let directory = try fileManager.contentsOfDirectory(atPath: cachePath.path)
                
                for imagefile in directory
                {
                    
                    if imagefile.components(separatedBy: "-").first! == indexItem
                    {
                        let imagePath = cachePath.appendingPathComponent(imagefile)
                        completion(true,imagePath)
                    }
                }
                
            }catch let error as NSError
            {
                print("error in getting image from directory",error.localizedDescription)
            }
            
        }
        
        completion(false,nil)
    }
    
    class func imagesContainsInCache(completion: (Bool)-> Void)
    {
        let cachePath = localCacheURL.appendingPathComponent("imagecache")
        
        if fileManager.fileExists(atPath: cachePath.path)
        {
            do
            {
                let directory = try fileManager.contentsOfDirectory(atPath: cachePath.path)
                
                if directory.count > 0
                {
                    Model.photoObject = directory
                    completion(true)
                }
                
            }catch let err as NSError
            {
                print("images not contain",err.localizedDescription)
            }
        }
        
        completion(false)
    }
    
}


