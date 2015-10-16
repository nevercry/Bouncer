//
//  BouncerBehavior.swift
//  Bouncer
//
//  Created by nevercry on 10/11/15.
//  Copyright © 2015 nevercry. All rights reserved.
//

import UIKit

class BouncerBehavior: UIDynamicBehavior {
    let gravity = UIGravityBehavior()
    
    lazy var collider: UICollisionBehavior = {
        let lazilyCreatedCollider = UICollisionBehavior()
        lazilyCreatedCollider.translatesReferenceBoundsIntoBoundary = true
        return lazilyCreatedCollider
        }()
    
    lazy var blockBehavior: UIDynamicItemBehavior = {
        let lazilyCreatedBlockBehavior = UIDynamicItemBehavior()
        lazilyCreatedBlockBehavior.allowsRotation = true
        lazilyCreatedBlockBehavior.elasticity = CGFloat(NSUserDefaults.standardUserDefaults().doubleForKey("BouncerBehaivor.Elasticity"))
        lazilyCreatedBlockBehavior.resistance = 0
        lazilyCreatedBlockBehavior.friction = 0
        NSNotificationCenter.defaultCenter().addObserverForName(NSUserDefaultsDidChangeNotification, object: nil, queue: nil) { (notification) -> Void in
            lazilyCreatedBlockBehavior.elasticity = CGFloat(NSUserDefaults.standardUserDefaults().doubleForKey("BouncerBehaivor.Elasticity"))
        }
        
        return lazilyCreatedBlockBehavior
        }()
    
    override init() {
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(blockBehavior)
    }
    
    func addBarrier(path: UIBezierPath, named name: String) {
        collider.removeBoundaryWithIdentifier(name)
        collider.addBoundaryWithIdentifier(name, forPath: path)
    }
    
    func addBlock(block: UIView) {
        dynamicAnimator?.referenceView?.addSubview(block)
        gravity.addItem(block)
        collider.addItem(block)
        blockBehavior.addItem(block)
    }
    
    func removeBlock(block: UIView) {
        gravity.removeItem(block)
        collider.removeItem(block)
        blockBehavior.removeItem(block)
        block.removeFromSuperview()
    }
}
