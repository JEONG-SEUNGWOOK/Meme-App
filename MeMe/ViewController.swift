//
//  ViewController.swift
//  MeMe
//
//  Created by Seungwook Jeong on 2017. 1. 20..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Photos

struct Meme {
    let topText : String
    let bottomText : String
    let originalImage : UIImage
    let memedImage : UIImage
}

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {

    
    var meme : AppDelegate.Meme?
    
    let memeTextAttributes = [
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSForegroundColorAttributeName : UIColor.white,
        NSStrokeColorAttributeName : UIColor.black,
        NSStrokeWidthAttributeName: -5.0
    ] as [String : Any]
    
    @IBOutlet weak var pickerImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.delegate = self
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .center
        
        bottomTextField.delegate = self
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = .center
        
        shareButton.isEnabled = false
        
        let ad = UIApplication.shared.delegate as? AppDelegate
        
        if let topText = ad?.topText {
            topTextField.text = topText
            ad?.topText = nil
        }
        else {
            topTextField.text = "TOP"
        }
        
        if let bottomText = ad?.bottomText {
            bottomTextField.text = bottomText
            ad?.bottomText = nil
        }
        else {
            bottomTextField.text = "BOTTOM"
        }
        
        if let image = ad?.image {
            pickerImageView.image = image
            shareButton.isEnabled = true
            ad?.image = nil
        }
        else {
            pickerImageView.image = nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //카메라 사용 가능한지
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        self.subscribeToKeyboardNotifications()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    /* when pick an image in Image Picker Controller */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pickerImageView.image = image
            shareButton.isEnabled = true
        }
        
        picker.dismiss(animated: true, completion: nil)
    }

    /* when cancel Image Picker Controller */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    /* when touch text field */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    /* when touch Return button */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    /* move the frame up */
    func keyboardWillShow(_ notification:Notification) {
        
        self.view.frame.origin.y = 0 - getKeyboardHeight(notification)
    }
    
    /* move the frame into position */
    func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    /* return Keyboard height */
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    // subscribe observer for keyboard
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_ :)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_ :)), name: .UIKeyboardWillHide, object: nil)
    }
    
    // unsubscribe observer for keyboard
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardDidHide, object: nil)
    }
    
    // when event to touch anywhere
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // generate image
    func generateMemedImage() -> UIImage {
        //hidden navigation Bar, Toolbar
        hiddenUI(hidden: true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //show navigation Bar, Toolbar
        hiddenUI(hidden: false)
        return memedImage
    }
    
    // save memed image
    func save() {
        meme = AppDelegate.Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: pickerImageView.image!, memedImage: generateMemedImage())
    }
    
    // hide toolbar, naviBar
    func hiddenUI(hidden: Bool){
        self.toolbar.isHidden = hidden
        self.navigationBar.isHidden = hidden
    }
    
    // when touch album button
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true)
    }
    
    // when touch camera button
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }

    // share to memed image
    @IBAction func shardMemedImage(_ sender: Any) {
        save()
        let memedImage : Any = meme?.memedImage as Any
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = completionHandler
    }
    
    
    // when share alert handler event
    func completionHandler(activityType: UIActivityType?, shared: Bool, items: [Any]?, error: Error?) {
        if (shared) {
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.append(meme!)
            dismiss(animated: true, completion: nil)
        }
        else {
            print("Cancel to share")
        }
    }
    
    // touch cancel button
    @IBAction func touchCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

