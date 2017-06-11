//
//  ViewController.swift
//  DownloadManager
//
//  Created by Kedar Navgire on 14/01/17.
//  Copyright © 2017 kedar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageTableView: UITableView!
    
    fileprivate let placeHolderImage = UIImage(named: "placeholder")
    fileprivate var scrollcount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //replace usrername with any tumblr username with lots of photos
        // default username is flowersonly
        // example https://highclasscars.tumblr.com/
        // replace floweronly with highclasscars
        
        
        Model.username = "flowersonly"
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        
        print(documentsPath)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let objectArray = DownloadManager.getCacheForFile(key: "response") is NSNull ? nil : DownloadManager.getCacheForFile(key: "response") as? Array<String>
        
        
        if objectArray != nil
        {
            
            Model.photoObject = objectArray!
            imageTableView.reloadData()
            
        }
        else
        {
            
            Model.imagesContainsInCache{
                bol in
                
                if bol
                {
                    self.imageTableView.reloadData()
                }else
                {
                    Model.fetchImageData(completion: {boolValue in
                        
                        if boolValue == true
                        {
                            DispatchQueue.main.sync{
                                
                                self.imageTableView.reloadData()
                            }
                            
                        }
                        
                    })
                }
            }
            
            
        }
        
    }
    
    @IBAction func clearcache(_ sender: UIButton) {
        
        Model.clearCache{
                bol in
            
            if bol
            {
                DownloadManager.sharedCache.removeAllObjects()
                Model.photoObject = []
                Model.fetchImageData(completion: { boolValue in
                    
                    if boolValue == true
                    {
                        DispatchQueue.main.sync{
                            
                            self.imageTableView.reloadData()
                        }
                        
                    }
                    
                })
            }
        
        }
        
        
    }
    
    @IBAction func changeuser(_ sender: UIButton) {
        
        let alertcontroller = UIAlertController(title: "Tumblr Username", message: "Type Tumblr username with lots of photos, please wait a little for images to load after done click", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        let done = UIAlertAction(title: "Done", style: .default, handler: {
            action in
            
            let username = alertcontroller.textFields?.first?.text ?? "flowersonly"
            
            Model.username = username
            
            Model.clearCache{
                bol in
                
                if bol
                {
                    DownloadManager.sharedCache.removeAllObjects()
                    Model.photoObject = []
                    Model.fetchImageData(completion: { boolValue in
                        
                        if boolValue == true
                        {
                            DispatchQueue.main.sync{
                                
                                self.imageTableView.reloadData()
                            }
                            
                        }
                        
                    })
                }
                
            }

        
        })
        
        alertcontroller.addTextField(configurationHandler: {
            texfld in
            
            texfld.placeholder = "type tumblr username"
            
        })
        
        alertcontroller.addAction(cancel)
        alertcontroller.addAction(done)
        
        present(alertcontroller, animated: true, completion: nil)
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if Model.photoObject.count == 0
        {
            return 0
        }else
        {
            return Model.photoObject.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "imgcell", for: indexPath) as! imageCell
        
        let imageName = Model.photoObject[indexPath.row]
        
        cell.imgVw.photoWithPlaceHolder(imageurl: imageName, placeHolder: placeHolderImage!, key: String(indexPath.row))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        scrollcount = 0
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        scrollcount = scrollcount + 1
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView.contentSize.height - scrollView.contentOffset.y > 0 && scrollcount == 2
        {
            fetchMore()
        }else
        {
            scrollcount = 0
        }
        
    }
    
    private func fetchMore()
    {
        Model.numOfLoadPages += 1
        
        Model.fetchImageData(completion: { boolValue in
            
            if boolValue == true
            {
                DispatchQueue.main.sync{
                    
                    self.imageTableView.reloadData()
                }
                
            }
            
        })
    }
    
}




