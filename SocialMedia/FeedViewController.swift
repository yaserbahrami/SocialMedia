//
//  FeedViewController.swift
//  SocialMedia
//
//  Created by yaser on 10/20/16.
//  Copyright © 2016 yaserBahrami. All rights reserved.
//

import UIKit
import Firebase
class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var showcaseImg2: UIImageView!
    var posts = [Post]()
    static var imageCache = NSCache<AnyObject, AnyObject>()
    
    @IBOutlet weak var imageSelector: UIImageView!
    @IBOutlet weak var PostTexField: MaterialTextField!
    
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FeedViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 381
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { snapshot in
//            print(snapshot?.value)
            self.posts = []
            if let snapshots = snapshot?.children.allObjects as? [FDataSnapshot] {
               
                for snap in snapshots{
//                   print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject>{
                        let key = snap.key
                        let post = Post(postKey: key!, dictionary: postDict)
                        
                        self.posts.append(post)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row] 
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell{
            
            cell.request?.cancel()
            
            var img: UIImage?
            if let url = post.imageUrl{
                img = FeedViewController.imageCache.object(forKey: url as AnyObject) as? UIImage
            }
            cell.configureCell(post: post, img: img)
            
            return cell
        }else{
            return PostCell()
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let post = posts[indexPath.row]
        
        if post.imageUrl == "" || post.imageUrl == nil {
            return tableView.estimatedRowHeight - 150
        }else{
            return tableView.estimatedRowHeight
        }

    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        imageSelector.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    @IBAction func selectImage(_ sender: UITapGestureRecognizer) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func makePost(_ sender: AnyObject) {
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
