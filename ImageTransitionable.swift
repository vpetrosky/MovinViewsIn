//
//  ImageTransitionable.swift
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
