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
    func photoWith(imageUrl:String,andPlaceHolder:UIImage,key:String)
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
                guard Reachability().isInternetAvailable() else
                {
                    print("Internet not available")
                    return
                }
                
                DownloadManager.downloadFrom(stringUrl: imageUrl, completion: {
                    url,response,error in
                    
                    guard error == nil
                        else
                    {
                        print("Error Occurred \(error!.localizedDescription)")
                        return
                    }
                    
                    do
                    {
                        let data = try Data(contentsOf: url!)
                        
                        DispatchQueue.main.async {
                            
                            let img = UIImage(data: data)
                            self.image = img!
                            
                            let cost = self.costFor(image: img!)
                            
                            DownloadManager.storeCache(forFile: img!,cost: cost, key: String(key))
                            let name = key + "-" + imageUrl.components(separatedBy: "/").last!
                            Model.storeToCacheDirectory(filename: name,data: data)
                        }
                        
                    }catch let erro as NSError
                    {
                        print("error while fetching content of file",erro.localizedDescription)
                    }
                    
                })
            }
            
        }
        
        
    }
    
    func costFor(image: UIImage) -> Int {
        let imageRef = image.cgImage
        return imageRef!.bytesPerRow * imageRef!.height
    }
    
}

extension UIViewController
{
    
    internal func showAlert(message:String)
    {
        showAlert(message: message, title: "")
    }
    
    internal func showAlert(message: String, title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}

class removeableCache:NSCache<AnyObject, AnyObject>
{
    
}
