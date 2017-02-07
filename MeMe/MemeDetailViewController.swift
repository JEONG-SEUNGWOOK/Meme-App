//
//  DetailMemedViewController.swift
//  MeMe
//
//  Created by Seungwook Jeong on 2017. 1. 25..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

let memeTextAttributes = [
    NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    NSForegroundColorAttributeName : UIColor.white,
    NSStrokeColorAttributeName : UIColor.black,
    NSStrokeWidthAttributeName: -5.0
    ] as [String : Any]


class MemeDetailViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var detailedImageView: UIImageView!
    
    var editButtonFlag = false
    var memedImage : AppDelegate.Meme?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        detailedImageView.image = memedImage?.memedImage
        
    }
    
    //when touch edit Button
    @IBAction func editMemedImage(_ sender: Any) {
        tabBarController?.tabBar.isHidden = false
        self.dismiss(animated: true, completion: nil)
        
    }
}
