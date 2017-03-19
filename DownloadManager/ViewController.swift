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
    
    let placeHolderImage = UIImage(named: "placeholder")
    var scrollcount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //replace usrername with any tumblr username
        
        Model.username = "flowersonly"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let objectArray = DownloadManager.getCacheForFile(key: "response") is NSNull ? nil : DownloadManager.getCacheForFile(key: "response") as? Array<String>
        
        
        if objectArray != nil
        {
            
            Model.photoObject = objectArray!
            imageTableView.reloadData()
            
        }else
        {
            Model.fetchData(completion: {[unowned self] boolValue in
            
                if boolValue == true
                {
                    DispatchQueue.main.sync{
                        
                        self.imageTableView.reloadData()
                    }
                    
                }
                
            })
        }
        
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
        Model.num += 20
        
        Model.fetchData(completion: {[unowned self] boolValue in
            
            if boolValue == true
            {
                DispatchQueue.main.sync{
                    
                    self.imageTableView.reloadData()
                }
                
            }
            
        })
    }
    
}

