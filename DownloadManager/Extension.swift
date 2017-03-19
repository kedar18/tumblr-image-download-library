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
        
        let objectFile = DownloadManager.getCacheForFile(key: key) is NSNull ? nil : DownloadManager.getCacheForFile(key: key) as! UIImage
        
        if objectFile != nil
        {
            let img = objectFile
            
            self.image = img
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
                if let data = try? Data(contentsOf: url!)
                {
                    
                    DispatchQueue.main.async {
                        
                        let img = UIImage(data: data)
                        
                        self.image = img!
                       DownloadManager.storeCacheForFile(file: img!, key: String(key))
                        
                    }
                }
                
            }catch let error as Error{
                
                print("Error while extracting data from url \(error.localizedDescription)")
            }
            
        
        })
        
        }
        
       
        
    }
    
}
