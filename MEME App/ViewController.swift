//
//  ViewController.swift
//  MEME App
//
//  Created by Ahmed Maad on 8/8/20.
//  Copyright © 2020 Next Trend. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var toolbar: UIToolbar!
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        shareButton.isEnabled = false
        configureMemeTextField(textField: topText)
        configureMemeTextField(textField: bottomText)
    }
    
    func configureMemeTextField(textField: UITextField) {
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    @IBAction func pickImage(_ sender: Any) {
        openImagePicker(sourceType: .photoLibrary)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            shareButton.isEnabled = true
        }
    }

    @IBAction func openCamera(_ sender: Any) {
        openImagePicker(sourceType: .camera)
    }
    
    func openImagePicker(sourceType: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == bottomText && bottomText.text == "BOTTOM"{
            bottomText.text = ""
        }
        else if textField == topText && topText.text == "TOP"{
            topText.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomText.isFirstResponder{
        view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func generateMemedImage() -> UIImage {
     
        shareButton.isHidden = true
        toolbar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        shareButton.isHidden = false
        toolbar.isHidden = false
        
        return memedImage
    }
    
    func save(){
        let meme =  Meme(topString: topText.text!, bottomString: bottomText.text!, image: imageView!, memedImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    
    @IBAction func shareMeme(_ sender: Any) {
        let shareActivity = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        present(shareActivity, animated: true, completion: nil)
        shareActivity.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if completed {
                print("Meme is saved")
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
            else{
                print("Meme is not saved")
            }
        }
    }
    
    
}
