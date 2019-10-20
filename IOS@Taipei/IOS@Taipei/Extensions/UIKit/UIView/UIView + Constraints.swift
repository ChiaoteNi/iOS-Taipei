//
//  UIView + Constraints.swift
//  IOS@Taipei
//
//  Created by Aaron_Ni on 2019/10/20.
//  Copyright © 2019 iOS@Taipei. All rights reserved.
//

import UIKit

extension UIView {
    
    // MARK: - NSLayoutAnchor
    @discardableResult
    func anchor<LayoutType: NSLayoutAnchor<AnchorType>, AnchorType> (
        _ keyPath: KeyPath<UIView, LayoutType>,
        _ relation: NSLayoutConstraint.Relation = .equal,
        to anchor: LayoutType,
        constant: CGFloat = 0,
        multiplier: CGFloat? = nil,
        priority: UILayoutPriority = .required) -> Self {
        
        constraint(keyPath, relation, to: anchor, constant: constant, multiplier: multiplier, priority: priority)
        return self
    }
    
    @discardableResult
    func constraint
        <LayoutType: NSLayoutAnchor<AnchorType>, AnchorType>
        (_ keyPath: KeyPath<UIView, LayoutType>,
         _ relation: NSLayoutConstraint.Relation = .equal,
         to anchor: LayoutType,
         constant: CGFloat = 0,
         multiplier: CGFloat? = nil,
         priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        
        if let multiplier = multiplier,
            let dimension = self[keyPath: keyPath] as? NSLayoutDimension,
            let anchor = anchor as? NSLayoutDimension {
            
            switch relation {
            case .equal:
                constraint = dimension.constraint(equalTo: anchor, multiplier: multiplier, constant: constant)
            case .greaterThanOrEqual:
                constraint = dimension.constraint(greaterThanOrEqualTo: anchor, multiplier: multiplier, constant: constant)
            case .lessThanOrEqual:
                constraint = dimension.constraint(lessThanOrEqualTo: anchor, multiplier: multiplier, constant: constant)
            @unknown default:
                constraint = dimension.constraint(equalTo: anchor, multiplier: multiplier, constant: constant)
            }
        } else {
            switch relation {
            case .equal:
                constraint = self[keyPath: keyPath].constraint(equalTo: anchor, constant: constant)
            case .greaterThanOrEqual:
                constraint = self[keyPath: keyPath].constraint(greaterThanOrEqualTo: anchor, constant: constant)
            case .lessThanOrEqual:
                constraint = self[keyPath: keyPath].constraint(lessThanOrEqualTo: anchor, constant: constant)
            @unknown default:
                constraint = self[keyPath: keyPath].constraint(equalTo: anchor, constant: constant)
            }
        }
        translatesAutoresizingMaskIntoConstraints = false
        constraint.priority = priority
        constraint.isActive = true
        
        return constraint
    }
    
    // MARK: - NSLayoutDimension
    @discardableResult
    func anchor(_ anchor: KeyPath<UIView, NSLayoutDimension>,
                _ relation: NSLayoutConstraint.Relation = .equal,
                to constant: CGFloat) -> Self {
        
        constraint(anchor, relation, to: constant)
        return self
    }
    
    @discardableResult
    func constraint(_ keyPath: KeyPath<UIView, NSLayoutDimension>,
                    _ relation: NSLayoutConstraint.Relation = .equal,
                    to constant: CGFloat = 0) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        
        switch relation {
        case .equal:
            constraint = self[keyPath: keyPath].constraint(equalToConstant: constant)
        case .greaterThanOrEqual:
            constraint = self[keyPath: keyPath].constraint(greaterThanOrEqualToConstant: constant)
        case .lessThanOrEqual:
            constraint = self[keyPath: keyPath].constraint(lessThanOrEqualToConstant: constant)
        }
        
        constraint.isActive = true
        return constraint
    }
}
