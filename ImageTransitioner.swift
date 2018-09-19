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

public class ImageTransitioner: NSObject, UIViewControllerAnimatedTransitioning {
    
    public static let instance = ImageTransitioner()
    
    private override init() {}
    
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
        guard let toVC = transitionContext.viewController(forKey: .to),
            let fromVC = transitionContext.viewController(forKey: .from) else {
                return
        }
        
        // Need to handle tab bars
        
        if let destinationVC = toVC as? ImageTransitionable {
            destinationImageViewFrame = destinationVC.transitioningImageViewFrame
            destinationImageView = destinationVC.transitioningImageView
        } else if let navVC = toVC as? UINavigationController,
            let topVC = navVC.topViewController as? ImageTransitionable {
            destinationImageViewFrame = topVC.transitioningImageViewFrame
            destinationImageView = topVC.transitioningImageView
        }
        
        if let originVC = fromVC as? ImageTransitionable {
            originImageViewFrame = originVC.transitioningImageViewFrame
            originImageView = originVC.transitioningImageView
            image = originVC.transitioningImageView.image
        }
        else if let navVC = fromVC as? UINavigationController,
            let topVC = navVC.topViewController as? ImageTransitionable {
            originImageViewFrame = topVC.transitioningImageViewFrame
            originImageView = topVC.transitioningImageView
            image = topVC.transitioningImageView.image
        }
        
        performPhotoTransition(toView: toVC.view, fromView: fromVC.view, transitionContext: transitionContext)
    }
    
    // MARK: Private
    
    private func performPhotoTransition(toView: UIView, fromView: UIView, transitionContext: UIViewControllerContextTransitioning) {
        guard let originImageViewFrame = originImageViewFrame,
            let destinationImageViewFrame = destinationImageViewFrame else {
                return
        }
        
        toView.frame = fromView.frame
        
        originImageView?.alpha = 0
        destinationImageView?.alpha = 0
        
        guard let fromSnapshot = fromView.snapshotView(afterScreenUpdates: true),
            let toSnapshot = toView.snapshotView(afterScreenUpdates: true) else {
                return
        }
        
        let container = transitionContext.containerView
        
        fromSnapshot.frame = fromView.frame
        container.addSubview(fromSnapshot)
        
        toSnapshot.frame = fromView.frame
        container.addSubview(toSnapshot)
        toSnapshot.alpha = 0
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = destinationImageView?.contentMode ?? .scaleAspectFit
        
        imageView.frame = originImageViewFrame
        imageView.clipsToBounds = true
        container.addSubview(imageView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
            toSnapshot.alpha = 1
            debugPrint("Destination frame: \(destinationImageViewFrame)")
            imageView.frame = destinationImageViewFrame
        }) { [weak self] completed in
            
            
            self?.destinationImageView?.image = self?.image
            self?.originImageView?.image = self?.image
            
            self?.destinationImageView?.alpha = 1
            self?.originImageView?.alpha = 1
            
            imageView.removeFromSuperview()
            toSnapshot.removeFromSuperview()
            fromSnapshot.removeFromSuperview()
            
            if !transitionContext.transitionWasCancelled {
                container.addSubview(toView)
                
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

extension ImageTransitioner: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImageTransitioner.instance
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImageTransitioner.instance
    }
}
