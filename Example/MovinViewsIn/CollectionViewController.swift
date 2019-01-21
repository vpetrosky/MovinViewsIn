//
//  CollectionViewController.swift
//  MovinViewsIn_Example
//
//  Created by Vanessa Petrosky on 10/7/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import MovinViewsIn

class CollectionViewController: UICollectionViewController {
    
    let thumbnails: [UIImage] = [UIImage(named: "puppy1"),
                                 UIImage(named: "puppy2"),
                                 UIImage(named: "puppy3"),
                                 UIImage(named: "puppy4"),
                                 UIImage(named: "puppy5"),
                                 UIImage(named: "puppy6")].compactMap({$0})
    
    private static let cellIdentifier: String = "Thumbnail Cell"
    private static let thumbnailSegue: String = "Thumbnail Segue"
    
    private var selectedImageView: UIImageView?
    private var selectedCell: UICollectionViewCell?
    
    private var transitionManager: TransitionManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewController.cellIdentifier)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == CollectionViewController.thumbnailSegue,
            let modalVC = segue.destination as? ModalViewController,
            let selectedImageView = selectedImageView {
            
            transitionManager = TransitionManager(originViewController: self, destinationViewController: modalVC, transitionImageView: selectedImageView)
            modalVC.transitioningDelegate = transitionManager
            modalVC.modalDelegate = self
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbnails.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewController.cellIdentifier, for: indexPath)
        
        let image = thumbnails[indexPath.row]
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        cell.backgroundView = imageView
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = collectionView.cellForItem(at: indexPath)
        let imageView = selectedCell?.backgroundView as? UIImageView
        selectedImageView = imageView
        
        performSegue(withIdentifier: CollectionViewController.thumbnailSegue, sender: nil)
    }
}

extension CollectionViewController: ImageTransitionable {
    var transitioningImageView: UIImageView {
        return selectedImageView ?? UIImageView()
    }
    
    var transitioningImageViewFrame: CGRect {
        guard let selectedCell = selectedCell else { return CGRect.zero }
        let frame = view.convert(selectedCell.frame, from: collectionView)
        return frame
    }
}

extension CollectionViewController: ModalDelegate {
    func modalViewControllerDidClose(_ modalVC: ModalViewController) {
        dismiss(animated: true, completion: nil)
    }
}
