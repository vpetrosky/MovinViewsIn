//
//  ModalViewControlleer.swift
//  MovinViewsIn_Example
//
//  Created by Vanessa Petrosky on 9/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import MovinViewsIn

protocol ModalDelegate: class {
    func modalViewControllerDidClose(_ modalVC: ModalViewController)
}

class ModalViewController: UIViewController {
    
    weak var modalDelegate: ModalDelegate?
    
    @IBOutlet weak var heroImageView: UIImageView!
    
    @IBAction func close(_ sender: UIButton) {
        modalDelegate?.modalViewControllerDidClose(self)
    }
}

extension ModalViewController: ImageTransitionable {
    var transitioningImageView: UIImageView {
        return heroImageView
    }
    
    var transitioningImageViewFrame: CGRect {
        return heroImageView.frame
    }
    
    var transitioningImage: UIImage? {
        return heroImageView.image
    }
}
