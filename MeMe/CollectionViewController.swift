//
//  CollectionViewController.swift
//  MeMe
//
//  Created by Seungwook Jeong on 2017. 1. 25..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

private let collectionViewIdentifer = "collectionViewReuseIdentifier"

class CollectionViewController: UICollectionViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource


    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return appDelegate.memes.count
    }

    
    // load data to tableview
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewIdentifer, for: indexPath) as! CollectionViewCell
        let memeItem = appDelegate.memes[indexPath.row]
        cell.memeImageView?.image = memeItem.memedImage
        
        return cell
    }
    
    // event to selected item
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let detailController = storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.memedImage = appDelegate.memes[indexPath.row]
        
        navigationController?.pushViewController(detailController, animated: true)
        
        
        appDelegate.topText = appDelegate.memes[indexPath.row].topText
        
        appDelegate.bottomText = appDelegate.memes[indexPath.row].bottomText
        
        appDelegate.image = appDelegate.memes[indexPath.row].originalImage
        
        
    }

   
}
