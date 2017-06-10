//
//  Extension.swift
//  DownloadManager
//
//  Created by Kedar Navgire on 14/01/17.
//  Copyright © 2017 kedar. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView
{
    
    func photoWithPlaceHolder(imageurl:String,placeHolder:UIImage,key:String)
    {
        self.image = UIImage(named: "placeholder")
        
        let objectFile = DownloadManager.getCacheForFile(key: key) is NSNull ? nil : DownloadManager.getCacheForFile(key: key) as? UIImage
        
        if objectFile != nil
        {
            let img = objectFile
            
            self.image = img
            return
        }
        
        Model.getImageFromCacheDirectory(indexItem: key){
            bol,localImageUrl in
            
            if bol
            {
                DispatchQueue.main.async {
                    
                    let img = UIImage(contentsOfFile: localImageUrl!.path)
                    self.image = img!
                    
                }
            }else
            {
                
                DownloadManager.downloadFromUrl(stringUrl: imageurl, completion: {
                    url,response,error in
                    
                    guard error == nil
                        else
                    {
                        print("Error Occurred \(error?.localizedDescription)")
                        return
                    }
                    
                    do
                    {
                        let data = try Data(contentsOf: url!)
                        
                        DispatchQueue.main.async {
                            
                            let img = UIImage(data: data)
                            self.image = img!
                            
                            DownloadManager.storeCacheForFile(file: img!, key: String(key))
                            
                        }
                        
                        let name = key + imageurl.components(separatedBy: "/").last!
                        
                        Model.storeToCacheDirectory(filename: name,data: data)
                        
                    }catch let erro as NSError
                    {
                        print("error while fetching content of file",erro.localizedDescription)
                    }
                    
                })
            }
        
        }
        
        
    
        
        
    }
    
}
