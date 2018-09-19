//
//  TransitionManager.swift
//  MovinViewsIn
//
//  Created by Vanessa Petrosky on 9/19/18.
//

import UIKit

public class TransitionManager: NSObject, UIViewControllerTransitioningDelegate {
    
    private let originVC: UIViewController
    private let destinationVC: UIViewController
    
    public init(originViewController: UIViewController, destinationViewController: UIViewController) {
        self.originVC = originViewController
        self.destinationVC = destinationViewController
        
        super.init()
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImageTransitioner(originViewController: originVC, destinationViewController: destinationVC)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImageTransitioner(originViewController: destinationVC, destinationViewController: originVC)
    }
}
