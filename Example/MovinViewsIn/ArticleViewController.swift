//
//  ArticleViewController.swift
//  MovinViewsIn
//
//  Created by Vanessa Petrosky on 08/16/2018.
//  Copyright (c) 2018 Vanessa Petrosky. All rights reserved.
//

import UIKit
import MovinViewsIn

class ArticleViewController: UIViewController {
    
    static let imageSegue: String = "Image Segue"
    
    @IBOutlet weak var surferButton: UIButton!
    
    private var transitionManager: TransitionManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        surferButton.imageView?.contentMode = .scaleAspectFit
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ArticleViewController.imageSegue,
            let modalVC = segue.destination as? ModalViewController,
            let transitionImageView = surferButton.imageView {
            
            transitionManager = TransitionManager(originViewController: self, destinationViewController: modalVC, transitionImageView: transitionImageView)
            segue.destination.transitioningDelegate = transitionManager
            
            modalVC.modalDelegate = self
        }
    }
}

// MARK: Image Transitionable
extension ArticleViewController: ImageTransitionable {
    var transitioningImageView: UIImageView {
        return surferButton.imageView ?? UIImageView()
    }
    
    var transitioningImageViewFrame: CGRect {
        return surferButton.frame
    }
}

// MARK: Modal Delegate
extension ArticleViewController: ModalDelegate {
    
    func modalViewControllerDidClose(_ modalVC: ModalViewController) {
        dismiss(animated: true, completion: nil)
    }
}

