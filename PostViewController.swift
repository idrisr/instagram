//
//  PostViewController.swift
//  Instagram
//
//  Created by dp on 4/11/16.
//  Copyright © 2016 id. All rights reserved.
//

import UIKit
import CoreImage

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    let connectionController = ConnectionController.sharedConnection

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    func noCamera() {
        let alertVC = UIAlertController(title: "No Camera",
                                        message: "This device does not have a camera",
                                        preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertVC.addAction(okAction)
        presentViewController(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func onImagePickerButtonTapped(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func onCameraButtonTapped(sender: AnyObject) {
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.cameraCaptureMode = .Photo
            imagePicker.modalPresentationStyle = .FullScreen
            presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }
    
    @IBAction func onButtonPressed(sender: AnyObject) {
        let post = Post(image: imageView.image!, user: self.connectionController.user!)
        connectionController.savePost(post)
        navigationController!.popViewControllerAnimated(true)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .ScaleAspectFit
            imageView.image = pickedImage
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
