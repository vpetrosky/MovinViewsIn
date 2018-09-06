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
    var transitioningImage: UIImage? { get }
//    func transitionSetup()
//    func transitionCleanup(image: UIImage?)
//    func imageWindowFrame() -> CGRect
}

public class ImageTransitioner: NSObject, UIViewControllerAnimatedTransitioning {
    
    public static let instance = ImageTransitioner()
    
    private override init() {}
    
    private static let imageTransitionDuration: TimeInterval = 0.6
    
    private var image: UIImage?
//    private weak var fromDelegate: ImageTransition?
//    private weak var toDelegate: ImageTransition?
    
    private var originImageViewFrame: CGRect?
    private var destinationImageViewFrame: CGRect?
    
    private var originImageView: UIImageView?
    private var destinationImageView: UIImageView?
    
//    init(originImageView: UIImageView, destinationImageView: UIImageView) {
//        self.originImageView = originImageView
//        self.image = originImageView.image
//
//        self.destinationImageView = destinationImageView
//
//        super.init()
//    }
    
//    init(image: UIImage, fromDelegate: ImageTransition, toDelegate: ImageTransition) {
//        self.image = image
//        self.fromDelegate = fromDelegate
//        self.toDelegate = toDelegate
//
//        super.init()
//    }
    
    // MARK: UIViewController Animated Transitioning
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return ImageTransitioner.imageTransitionDuration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard var toVC = transitionContext.viewController(forKey: .to),
            var fromVC = transitionContext.viewController(forKey: .from) else {
                return
        }
        
        if let navVC = toVC as? UINavigationController,
            let topVC = navVC.topViewController {
            toVC = topVC
        }
        
        if let navVC = fromVC as? UINavigationController,
            let topVC = navVC.topViewController {
            fromVC = topVC
        }
        
        guard let originVC = fromVC as? ImageTransitionable,
            let destinationVC = toVC as? ImageTransitionable else {
                return
        }
        
        originImageViewFrame = originVC.transitioningImageViewFrame
        originImageView = originVC.transitioningImageView
        
        image = originVC.transitioningImage
        
        destinationImageViewFrame = destinationVC.transitioningImageViewFrame
        destinationImageView = destinationVC.transitioningImageView
        
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
//        toDelegate?.transitionSetup()
//        fromDelegate?.transitionSetup()
        
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
//        imageView.frame = CGRect.zero
        
        imageView.frame = originImageViewFrame
        imageView.clipsToBounds = true
        container.addSubview(imageView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
            toSnapshot.alpha = 1
            imageView.frame = destinationImageViewFrame
        }) { [weak self] completed in
            
            
            self?.destinationImageView?.image = self?.image
            self?.originImageView?.alpha = 1
            
//            self?.toDelegate?.transitionCleanup(image: self?.image)
//            self?.fromDelegate?.transitionCleanup(image: self?.image)
            
            imageView.removeFromSuperview()
            toSnapshot.removeFromSuperview()
            fromSnapshot.removeFromSuperview()
            
            if !transitionContext.transitionWasCancelled {
                container.addSubview(toView)
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
