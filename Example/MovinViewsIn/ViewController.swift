//
//  ViewController.swift
//  MovinViewsIn
//
//  Created by Vanessa Petrosky on 08/16/2018.
//  Copyright (c) 2018 Vanessa Petrosky. All rights reserved.
//

import UIKit
import MovinViewsIn

class ViewController: UIViewController {

    static let imageSegue: String = "Image Segue"
    
    @IBOutlet weak var surferButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        surferButton.imageView?.contentMode = .scaleAspectFit
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ViewController.imageSegue {
            segue.destination.transitioningDelegate = ImageTransitioner.instance
            
            if let modalVC = segue.destination as? ModalViewController {
                modalVC.modalDelegate = self
            }
        }
    }
}

// MARK: Image Transitionable
extension ViewController: ImageTransitionable {
    var transitioningImageView: UIImageView {
        return surferButton.imageView ?? UIImageView()
    }
    
    var transitioningImageViewFrame: CGRect {
        return surferButton.frame
    }
}

// MARK: Modal Delegate
extension ViewController: ModalDelegate {
    
    func modalViewControllerDidClose(_ modalVC: ModalViewController) {
        dismiss(animated: true, completion: nil)
    }
}

