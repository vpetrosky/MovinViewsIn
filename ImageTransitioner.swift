//
//  ImageTransitioner.swift
//  AnimationStation
//
//  Created by Vanessa Petrosky on 9/4/18.
//  Copyright © 2018 Vanessa Petrosky. All rights reserved.
//

import UIKit

public protocol ImageTransitionable: class {
    var transitioningImageView: UIImageView { get }
    var transitioningImageViewFrame: CGRect { get }
}

class ImageTransitioner: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let originVC: UIViewController
    private let destinationVC: UIViewController
    
    init(originViewController: UIViewController, destinationViewController: UIViewController) {
        self.originVC = originViewController
        self.destinationVC = destinationViewController
        
        super.init()
    }
    
    private static let imageTransitionDuration: TimeInterval = 0.6
    
    private var image: UIImage?
    
    private var originImageViewFrame: CGRect?
    private var destinationImageViewFrame: CGRect?
    
    private var originImageView: UIImageView?
    private var destinationImageView: UIImageView?
    
    // MARK: UIViewController Animated Transitioning
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return ImageTransitioner.imageTransitionDuration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // Need to handle tab bars
        
        guard let destination = destinationVC as? ImageTransitionable,
            let origin = originVC as? ImageTransitionable else {
                return
        }
        destinationImageViewFrame = destination.transitioningImageViewFrame
        destinationImageView = destination.transitioningImageView
        
        originImageViewFrame = origin.transitioningImageViewFrame
        originImageView = origin.transitioningImageView
        
        image = origin.transitioningImageView.image
        
        performPhotoTransition(destinationView: destinationVC.view, originView: originVC.view, transitionContext: transitionContext)
    }
    
    // MARK: Private
    
    private func performPhotoTransition(destinationView: UIView, originView: UIView, transitionContext: UIViewControllerContextTransitioning) {
        guard let originImageViewFrame = originImageViewFrame,
            let destinationImageViewFrame = destinationImageViewFrame,
            let fromSnapshot = originView.snapshotView(afterScreenUpdates: true),
            let toSnapshot = destinationView.snapshotView(afterScreenUpdates: true) else {
                return
        }
        
        // Set destination frame to same frame as origin
        destinationView.frame = originView.frame
        
        // Set both image views' alpha to zero
        originImageView?.alpha = 0
        destinationImageView?.alpha = 0
        
        let container = transitionContext.containerView
        
        // Add origin snapshot to frame
        fromSnapshot.frame = originView.frame
        container.addSubview(fromSnapshot)
        
        // Add destination snapshot to frame and set alpha to zero
        toSnapshot.frame = originView.frame
        container.addSubview(toSnapshot)
        toSnapshot.alpha = 0
        
        let animatingImageView = UIImageView(image: image)
        animatingImageView.contentMode = destinationImageView?.contentMode ?? .scaleAspectFit
        
        animatingImageView.frame = originImageViewFrame
        animatingImageView.clipsToBounds = true
        container.addSubview(animatingImageView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
            toSnapshot.alpha = 1
            debugPrint("Destination frame: \(destinationImageViewFrame)")
            animatingImageView.frame = destinationImageViewFrame
        }) { [weak self] completed in
            
            
            self?.destinationImageView?.image = self?.image
//            self?.originImageView?.image = self?.image
            
            self?.destinationImageView?.alpha = 1
            self?.originImageView?.alpha = 1
            
            animatingImageView.removeFromSuperview()
            toSnapshot.removeFromSuperview()
            fromSnapshot.removeFromSuperview()
            
            if !transitionContext.transitionWasCancelled {
                container.addSubview(destinationView)
                
                self?.destinationImageViewFrame = nil
                self?.destinationImageView = nil
                self?.originImageViewFrame = nil
                self?.originImageView = nil
                self?.image = nil
            }
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
