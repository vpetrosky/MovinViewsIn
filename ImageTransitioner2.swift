//
//  ImageTransitioner2.swift
//  MovinViewsIn
//
//  Created by Vanessa Petrosky on 10/6/18.
//

import UIKit

class ImageTransitioner2: NSObject, UIViewControllerAnimatedTransitioning {
    
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
        
        fromDelegate?.transitioningImageView.alpha = 0
        
        guard let transitionImage = transitionImageView.image,
            let destinationVC = transitionContext.viewController(forKey: .to),
            let originVC = transitionContext.viewController(forKey: .from),
            let destinationSnapshot = destinationVC.view.snapshotView(afterScreenUpdates: true),
            let originSnapshot = originVC.view.snapshotView(afterScreenUpdates: true) else {
                return
        }
        
        destinationVC.view.frame = originVC.view.frame
        
        let container = transitionContext.containerView
        
        originSnapshot.frame = originVC.view.frame
        container.addSubview(originSnapshot)
        
        destinationSnapshot.frame = originVC.view.frame
        container.addSubview(destinationSnapshot)
        destinationSnapshot.alpha = 0
        
        let animatingImageView = UIImageView(image: transitionImage)
        animatingImageView.frame = fromDelegate?.transitioningImageViewFrame ?? CGRect.zero
        animatingImageView.contentMode = toDelegate?.transitioningImageView.contentMode ?? .scaleAspectFit
        container.addSubview(animatingImageView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: { [weak self] in
            
            guard let strongSelf = self,
                let toDelegate = strongSelf.toDelegate else {
                    return
            }

            animatingImageView.frame = toDelegate.transitioningImageViewFrame
            animatingImageView.contentMode = toDelegate.transitioningImageView.contentMode
            animatingImageView.clipsToBounds = toDelegate.transitioningImageView.clipsToBounds
            
            destinationSnapshot.alpha = 1
            
           toDelegate.transitioningImageView.alpha = 1
            
        }) { [weak self] (completed) in
            
            animatingImageView.removeFromSuperview()
            destinationSnapshot.removeFromSuperview()
            originSnapshot.removeFromSuperview()
            
            self?.toDelegate?.transitioningImageView.image = transitionImage
            
            if !transitionContext.transitionWasCancelled {
                container.addSubview(destinationVC.view)
            }
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
