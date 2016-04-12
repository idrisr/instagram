//
//  PostViewController.swift
//  Instagram
//
//  Created by dp on 4/11/16.
//  Copyright © 2016 id. All rights reserved.
//

import UIKit
import CoreImage

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var captionTextField: UITextField!
    
    let imagePicker = UIImagePickerController()
    let connectionController = ConnectionController.sharedConnection
    
    var filterNames: [String] = ["Instant", "Chrome", "Noir", "None"]
    var filters: [String] = ["CIPhotoEffectInstant", "CIPhotoEffectChrome", "CIPhotoEffectNoir", "CIColorControls"]
    
    var originalImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        captionTextField.delegate = self
        onCameraButtonTapped(self)
        
    }
    
    func noCamera() {
        let alertVC = UIAlertController(title: "No Camera",
                                        message: "This device does not have a camera. Please select image from your photo gallery",
                                        preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: onImagePickerButtonTapped)
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
            let post = Post(image: imageView.image!, caption: captionTextField.text!)
            connectionController.savePost(post)
            navigationController!.popViewControllerAnimated(true)

    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .ScaleAspectFit
            imageView.image = pickedImage
            self.originalImage = imageView.image!
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    // MARK: - TableView Delegate Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filters.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FilterCell", forIndexPath: indexPath)
        cell.textLabel?.text = filterNames[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let CIfilterName = filters[indexPath.row]
        print(CIfilterName)
        
        let context = CIContext(options: nil)
        let startImage = CIImage(image: self.originalImage)
        
        let filteredImage = startImage?.imageByApplyingFilter(CIfilterName, withInputParameters: nil)
        let renderedImage = context.createCGImage(filteredImage!, fromRect: filteredImage!.extent)
        
        imageView.image = UIImage(CGImage: renderedImage)
    }
    
    
    // MARK: - TextField Delegate Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    
}
