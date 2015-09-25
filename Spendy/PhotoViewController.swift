//
//  PhotoViewController.swift
//  Spendy
//
//  Created by Dave Vo on 9/24/15.
//  Copyright © 2015 Cheetah. All rights reserved.
//

import UIKit
import VIPhotoView
import PhotoTweaks

@objc protocol PhotoViewControllerDelegate {
    optional func photoViewController(photoViewController: PhotoViewController, didUpdateImage image: UIImage)
}

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var changeButton: UIButton!
    
    @IBOutlet weak var editButton: UIButton!
    
    var selectedImage: UIImage?

    var cancelButton: UIButton?
    var saveButton: UIButton?
    
    var photoView: VIPhotoView!
    var imagePicker: UIImagePickerController!
    
    weak var delegate: PhotoViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBarButton()
        
        if tabBarController != nil {
            tabBarController!.tabBar.hidden = true
        }
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if selectedImage != nil {
            setPhoto()
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        photoView.removeFromSuperview()
        setPhoto()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setPhoto() {
        photoView = VIPhotoView(frame: self.view.bounds, andImage: selectedImage)
        self.view.addSubview(photoView)
        self.view.bringSubviewToFront(changeButton)
        self.view.bringSubviewToFront(editButton)
    }
    
    // MARK: Button
    
    func addBarButton() {
        
        saveButton = UIButton()
        Helper.sharedInstance.customizeBarButton(self, button: saveButton!, imageName: "Bar-Tick", isLeft: false)
        saveButton!.addTarget(self, action: "onSaveButton:", forControlEvents: UIControlEvents.TouchUpInside)
        
        cancelButton = UIButton()
        Helper.sharedInstance.customizeBarButton(self, button: cancelButton!, imageName: "Bar-Back", isLeft: true)
        cancelButton!.addTarget(self, action: "onCancelButton:", forControlEvents: UIControlEvents.TouchUpInside)
    }

    func onSaveButton(sender: UIButton!) {
        print("on Save", terminator: "\n")
        delegate?.photoViewController!(self, didUpdateImage: selectedImage!)
        navigationController?.popViewControllerAnimated(true)
    }
    
    func onCancelButton(sender: UIButton!) {
        print("on Cancel", terminator: "\n")
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func onChangeButton(sender: UIButton) {
        print("on Change", terminator: "\n")
        Helper.sharedInstance.showActionSheet(self, imagePicker: imagePicker)
    }
    
    @IBAction func onEditButton(sender: UIButton) {
        print("on Edit", terminator: "\n")
        let photoTweaksViewController = PhotoTweaksViewController(image: selectedImage)
        photoTweaksViewController.delegate = self
        self.presentViewController(photoTweaksViewController, animated: true, completion: nil)
    }

}

// MARK: UIImagePickerController

extension PhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let photoTweaksViewController = PhotoTweaksViewController(image: pickedImage)
            photoTweaksViewController.delegate = self
            imagePicker.pushViewController(photoTweaksViewController, animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: Photo Tweaks

extension PhotoViewController: PhotoTweaksViewControllerDelegate {
    
    func photoTweaksController(controller: PhotoTweaksViewController!, didFinishWithCroppedImage croppedImage: UIImage!) {
        print("update new image", terminator: "\n")
        selectedImage = croppedImage
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func photoTweaksControllerDidCancel(controller: PhotoTweaksViewController!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
