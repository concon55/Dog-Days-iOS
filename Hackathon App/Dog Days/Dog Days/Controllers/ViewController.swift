//
//  ViewController.swift
//  Dog Days
//
//  Created by Connie Guan on 7/18/17.
//  Copyright © 2017 Connie Guan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseAuthUI
import Kingfisher
import FirebaseStorage


class ViewController: UIViewController{
    
    
    var authHandle: AuthStateDidChangeListenerHandle?
    var ref: DatabaseReference!
    let photoHelper = DDPhotoHelper()
    
   
    @IBOutlet weak var descriptionText: UITextView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var uploadButton: UIButton!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
   
    @IBOutlet weak var imagePreview: UIImageView!
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let imageURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/dog-days.appspot.com/o/images%2Fposts%2FlqMxdDiJBiSuSnmDCF5HxDkEWoH3%2F2017-07-21T15%3A17%3A06Z.jpg?alt=media&token=4589ccb8-a8ce-48fa-9290-6c2e784ca82b")
        imageView?.kf.setImage(with: imageURL!)
        
        let description = "🚒😩🐎🚲"
        descriptionLabel?.text = description
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        ref = Database.database().reference()
        
        photoHelper.completionHandler = { image in
            PostService.create(for: image)
            self.imagePreview.image = image
        }
        
        authHandle = Auth.auth().addStateDidChangeListener() { [unowned self] (auth, user) in
            guard user == nil else { return }
            
            let loginViewController = UIStoryboard.initialViewController(for: .login)
            self.view.window?.rootViewController = loginViewController
            self.view.window?.makeKeyAndVisible()
        }
    }
    
   
    
    deinit {
        if let authHandle = authHandle {
            Auth.auth().removeStateDidChangeListener(authHandle)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func uploadButtonTapped(_ sender: UIButton) {
        photoHelper.presentActionSheet(from: self)
        
    }
 
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        ref.child("posts").child(User.current.uid).childByAutoId().setValue(descriptionText.text)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        } catch let error as NSError {
            assertionFailure("Error signing out: \(error.localizedDescription)")
        }
    }
    
   

}










