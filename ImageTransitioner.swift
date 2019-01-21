//
//  ImageTransitioner2.swift
//  MovinViewsIn
//
//  Created by Vanessa Petrosky on 10/6/18.
//

import UIKit

class ImageTransitioner: NSObject, UIViewControllerAnimatedTransitioning {
    
    weak var fromDelegate: ImageTransitionable?
    weak var toDelegate: ImageTransitionable?
    
    private let isPresenting: Bool
    private let transitionImageView: UIImageView
    
    init(isPresenting: Bool, transitionImageView: UIImageView) {
        self.isPresenting = isPresenting
        self.transitionImageView = transitionImageView
        
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return isPresenting ? 0.6 : 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        DispatchQueue.main.async {
            self.performImageTransition(withTransitionContext: transitionContext)
        }
    }
    
    func performImageTransition(withTransitionContext transitionContext: UIViewControllerContextTransitioning) {
        
        guard let transitionImage = transitionImageView.image,
            let destinationVC = transitionContext.viewController(forKey: .to),
            let originVC = transitionContext.viewController(forKey: .from),
            let toDelegate = toDelegate,
            let fromDelegate = fromDelegate else {
                return
        }
        
        fromDelegate.transitioningImageView.alpha = 0
        toDelegate.transitioningImageView.alpha = 0

        let container = transitionContext.containerView
        let animatingImageView = UIImageView(image: transitionImage)
        animatingImageView.frame = fromDelegate.transitioningImageViewFrame
        
        guard let originSnapshot = takeOriginScreenshot(),
            let destinationSnapshot = destinationVC.view else {
                return
        }
        
        destinationVC.view.frame = originVC.view.frame
        
        originSnapshot.frame = originVC.view.frame
        container.addSubview(originSnapshot)
        
        destinationSnapshot.frame = originVC.view.frame
        container.addSubview(destinationSnapshot)
        destinationSnapshot.alpha = 0

        container.addSubview(animatingImageView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
            
            animatingImageView.frame = toDelegate.transitioningImageViewFrame
            animatingImageView.contentMode = toDelegate.transitioningImageView.contentMode
            animatingImageView.clipsToBounds = toDelegate.transitioningImageView.clipsToBounds
            
            destinationSnapshot.alpha = 1
            
            fromDelegate.transitioningImageView.alpha = 0
            
        }) { [weak self] (completed) in
            
            animatingImageView.removeFromSuperview()
            destinationSnapshot.removeFromSuperview()
            originSnapshot.removeFromSuperview()
            
            self?.toDelegate?.transitioningImageView.alpha = 1
            self?.toDelegate?.transitioningImageView.image = transitionImage
            
            if !transitionContext.transitionWasCancelled {
                container.addSubview(destinationVC.view)
            }
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func takeOriginScreenshot() -> UIImageView? {
        guard let layer = UIApplication.shared.keyWindow?.layer else { return nil }
                
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in:context)
        let screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return UIImageView(image: screenshotImage)
    }
}
