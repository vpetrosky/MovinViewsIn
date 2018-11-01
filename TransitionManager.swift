//
//  TransitionManager.swift
//  MovinViewsIn
//
//  Created by Vanessa Petrosky on 9/19/18.
//

import UIKit

public class TransitionManager: NSObject, UIViewControllerTransitioningDelegate {
    
    private let originVC: ImageTransitionable
    private let destinationVC: ImageTransitionable
    
    private let transitionImageView: UIImageView
    
    public init(originViewController: ImageTransitionable, destinationViewController: ImageTransitionable, transitionImageView: UIImageView) {
        self.originVC = originViewController
        self.destinationVC = destinationViewController
        
        self.transitionImageView = transitionImageView
        
        super.init()
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let imageTransitioner = ImageTransitioner(isPresenting: true, transitionImageView: transitionImageView)
        imageTransitioner.fromDelegate = originVC
        imageTransitioner.toDelegate = destinationVC
        
        return imageTransitioner
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let imageTransitioner = ImageTransitioner(isPresenting: false, transitionImageView: transitionImageView)
        imageTransitioner.fromDelegate = destinationVC
        imageTransitioner.toDelegate = originVC
        
        return imageTransitioner
    }
}
