//
//  ImageTransitioner.swift
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
    private let transitionImage: UIImage
    private let animatingImageView: UIImageView
    
    init(isPresenting: Bool, transitionImageView: UIImageView) {
        self.isPresenting = isPresenting
        self.transitionImageView = transitionImageView
        self.transitionImage = transitionImageView.image ?? UIImage()
        self.animatingImageView = UIImageView(image: transitionImage)

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
}

// MARK: - Private

private extension ImageTransitioner {
    
    func performImageTransition(withTransitionContext transitionContext: UIViewControllerContextTransitioning) {
        guard let destinationVC = transitionContext.viewController(forKey: .to),
            let originVC = transitionContext.viewController(forKey: .from),
            let toDelegate = toDelegate,
            let fromDelegate = fromDelegate else {
                return
        }
        
        fromDelegate.transitioningImageView.alpha = 0
        toDelegate.transitioningImageView.alpha = 0
        
        guard let originSnapshot = takeOriginScreenshot(),
            let destinationView = destinationVC.view else {
                return
        }
        
        setupAnimation(container: transitionContext.containerView, originVC: originVC, originSnapshot: originSnapshot, destinationView: destinationView)
        
        animateTransition(withTransitionContext: transitionContext, toDelegate: toDelegate, fromDelegate: fromDelegate, destinationView: destinationView, originSnapshot: originSnapshot)
    }
    
    func setupAnimation(container: UIView, originVC: UIViewController, originSnapshot: UIImageView, destinationView: UIView) {
        animatingImageView.frame = fromDelegate?.transitioningImageViewFrame ?? CGRect.zero
        
        originSnapshot.frame = originVC.view.frame
        container.addSubview(originSnapshot)
        
        destinationView.frame = originVC.view.frame
        container.addSubview(destinationView)
        
        destinationView.alpha = 0
        
        container.addSubview(animatingImageView)
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
    
    func animateTransition(withTransitionContext transitionContext: UIViewControllerContextTransitioning, toDelegate: ImageTransitionable, fromDelegate: ImageTransitionable, destinationView: UIView, originSnapshot: UIImageView) {
        
        if isPresenting {
            destinationView.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: { [weak self] in
            
            self?.animatingImageView.frame = toDelegate.transitioningImageViewFrame
            self?.animatingImageView.contentMode = toDelegate.transitioningImageView.contentMode
            self?.animatingImageView.clipsToBounds = toDelegate.transitioningImageView.clipsToBounds
            
            destinationView.alpha = 1
            
            fromDelegate.transitioningImageView.alpha = 0
            
        }) { [weak self] (completed) in
            
            self?.animatingImageView.removeFromSuperview()
            destinationView.removeFromSuperview()
            originSnapshot.removeFromSuperview()
            
            self?.toDelegate?.transitioningImageView.alpha = 1
            self?.toDelegate?.transitioningImageView.image = self?.transitionImage
            
            if !transitionContext.transitionWasCancelled {
                transitionContext.containerView.addSubview(destinationView)
            }
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
