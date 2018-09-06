//
//  Transitioner.swift
//  MovinViewsIn
//
//  Created by Vanessa Petrosky on 8/16/18.
//

import Foundation
import UIKit

enum TransitionStyle {
    case scale, fade, fall, surf
}

class ViewControllerTransitioner: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let isPresenting: Bool
    private let style: TransitionStyle
    private let transitionImage: UIImageView?
    
    private var image: UIImage?
    private weak var fromDelegate: ImageTransitionable?
    private weak var toDelegate: ImageTransitionable?
    
    init(isPresenting: Bool, style: TransitionStyle, transitionImage: UIImageView?) {
        self.isPresenting = isPresenting
        self.style = style
        self.transitionImage = transitionImage
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        switch style {
        case .fall:
            return 0.5
        case .surf:
            return 0.6
        default:
            return 0.3
        }
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to),
            let fromVC = transitionContext.viewController(forKey: .from) else {
                return
        }
        
        switch style {
        case .scale:
            performScaleTransition(toView: toVC.view, fromView: fromVC.view, transitionContext: transitionContext)
        case .fade:
            performFadeTransition(toView: toVC.view, fromView: fromVC.view, transitionContext: transitionContext)
        case .fall:
            performFallTransition(toView: toVC.view, fromView: fromVC.view, transitionContext: transitionContext)
        case .surf:
            break
//            performPhotoTransition(toView: toVC.view, fromView: fromVC.view, transitionContext: transitionContext)
        }
    }
    
//    func setupImageTransition(image: UIImage, fromDelegate: ImageTransition, toDelegate: ImageTransition) {
//        self.image = image
//        self.fromDelegate = fromDelegate
//        self.toDelegate = toDelegate
//    }
    
//    private func performPhotoTransition(toView: UIView, fromView: UIView, transitionContext: UIViewControllerContextTransitioning) {
//        toView.frame = fromView.frame
//
////        toDelegate?.transitionSetup()
////        fromDelegate?.transitionSetup()
//
//        guard let fromSnapshot = fromView.snapshotView(afterScreenUpdates: true),
//            let toSnapshot = toView.snapshotView(afterScreenUpdates: true) else {
//                return
//        }
//
//        let container = transitionContext.containerView
//
//        fromSnapshot.frame = fromView.frame
//        container.addSubview(fromSnapshot)
//
//        toSnapshot.frame = fromView.frame
//        container.addSubview(toSnapshot)
//        toSnapshot.alpha = 0
//
//        let imageView = UIImageView(image: image)
//        imageView.contentMode = .scaleAspectFit
//        imageView.frame = CGRect.zero
//
//        imageView.frame = fromDelegate?.imageWindowFrame() ?? CGRect.zero
//        imageView.clipsToBounds = true
//        container.addSubview(imageView)
//
//        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
//            toSnapshot.alpha = 1
//            imageView.frame = self.toDelegate?.imageWindowFrame() ?? CGRect.zero
//        }) { [weak self] completed in
//            self?.toDelegate?.transitionCleanup(image: self?.image)
//            self?.fromDelegate?.transitionCleanup(image: self?.image)
//
//            imageView.removeFromSuperview()
//            toSnapshot.removeFromSuperview()
//            fromSnapshot.removeFromSuperview()
//
//            if !transitionContext.transitionWasCancelled {
//                container.addSubview(toView)
//            }
//
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//
//        }
//    }
    
    private func performScaleTransition(toView: UIView, fromView: UIView, transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            transitionContext.containerView.addSubview(toView)
            toView.alpha = 0.0
            toView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        } else {
            transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            if self.isPresenting {
                toView.transform = CGAffineTransform(scaleX: 1, y: 1)
                toView.alpha = 1.0
            } else {
                fromView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                fromView.alpha = 0.0
            }
            
        }) { completed in
            fromView.transform = .identity
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    private func performFadeTransition(toView: UIView, fromView: UIView, transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            transitionContext.containerView.addSubview(toView)
            toView.alpha = 0.0
        } else {
            transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            if self.isPresenting {
                toView.alpha = 1.0
            } else {
                fromView.alpha = 0.0
            }
            
        }) { completed in
            fromView.transform = .identity
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    private func performFallTransition(toView: UIView, fromView: UIView, transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            transitionContext.containerView.addSubview(toView)
            toView.layer.position.y = (toView.layer.position.y - toView.frame.height)
        } else {
            transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            if self.isPresenting {
                toView.layer.position.y = (toView.layer.position.y + toView.frame.height)
            } else {
                fromView.layer.position.y = (fromView.layer.position.y - fromView.frame.height)
            }
            
        }) { completed in
            fromView.transform = .identity
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    private func performSurfTransition(transitionImage: UIImageView?, toView: UIView, fromView: UIView, transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            transitionContext.containerView.addSubview(toView)
            
            if let imageView = transitionImage {
                toView.addSubview(imageView)
            }
            
            toView.alpha = 0.0
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toView.alpha = 1.0
        }) { completed in
            fromView.transform = .identity
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
