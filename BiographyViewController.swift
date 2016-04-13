//
//  BiographyViewController.swift
//  Instagram
//
//  Created by Matthew Bracamonte on 4/12/16.
//  Copyright © 2016 id. All rights reserved.
//

import UIKit

protocol AddBiographyControllerDelegate {
    func saveBiography(controller:BiographyViewController, text:String)
}

class BiographyViewController: UIViewController, UITextViewDelegate  {

    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var counterLbl: UILabel!
    var delegate: AddBiographyControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButton.layer.cornerRadius = 5.0
    }
    
    @IBAction func updateButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        let biographyText = textView.text
        if let delegate = self.delegate {
            delegate.saveBiography(self, text: biographyText)
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    
        return textView.text.characters.count + (text.characters.count - range.length) <= 70
    }
}
