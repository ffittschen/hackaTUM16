//
//  GaugeView.swift
//  MPiccinato
//
//  Created by Piccinato, Mathew on 12/26/15.
//  Copyright © 2015 Piccinato, Mathew. All rights reserved.
//

//  Swift 3 version of https://github.com/MPiccinato/GaugeView

import Foundation
import UIKit
import Darwin

@IBDesignable class GaugeView: UIView {
    
    // Style
    var stops: Array<(stop: Double, color: UIColor)> = [ (0.0, UIColor.green) ] {
        didSet {
            self.fillLayer.stops = self.stops
        }
    }
    var borderColor: UIColor = UIColor.gray
    var width: CGFloat = 30.0
    
    var animateUpdates: Bool = true
    
    // Data
    private var _progress: Double = 0.0
    private var _previousProgress: Double = 0.0
    var progress: Double {
        get {
            return _progress
        }
        set(value){
            _previousProgress = _progress
            _progress = value > 1 ? 1 : value < 0 ? 0 : value
            
            if self.animateUpdates {
                self.fillLayer.progress = _progress
                self.animate()
            } else {
                self.fillLayer.progress = _progress
                self.fillLayer.setNeedsDisplay()
            }
        }
    }
    
    // Layers
    private let fillLayer: GaugeLayer = GaugeLayer()
    private let borderLayer: CAShapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    func commonInit() {
        self.backgroundColor = UIColor.white
        
        self.initBorderLayer()
        self.initFillLayer()
        
        self.layer.addSublayer(self.fillLayer)
        self.layer.addSublayer(self.borderLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.initBorderLayer()
        self.initFillLayer()
    }
    
    // Parts
    func getArcCenter() -> CGPoint {
        return CGPoint(x: self.bounds.midX, y: self.bounds.maxY)
    }
    
    func getRadius() -> CGFloat {
        return self.bounds.midX
    }
    
    func initFillLayer() {
        self.fillLayer.stops = self.stops
        self.fillLayer.frame = self.bounds
        self.fillLayer.progress = self.progress
        self.fillLayer.width = Double(self.width)
    }
    
    func initBorderLayer() {
        let arcCenter = self.getArcCenter()
        let radius = self.getRadius()
        
        let borderPath = UIBezierPath()
        borderPath.move(to: CGPoint(x: 0, y: self.bounds.size.height))
        borderPath.addArc(withCenter: arcCenter, radius: radius, startAngle: CGFloat(M_PI), endAngle: CGFloat(-2.0 * M_PI), clockwise: true)
        borderPath.addLine(to: CGPoint(x: self.bounds.size.width - self.width, y: self.bounds.size.height))
        borderPath.addArc(withCenter: arcCenter, radius: radius - self.width, startAngle: CGFloat(-2.0 * M_PI), endAngle: CGFloat(M_PI), clockwise: false)
        borderPath.addLine(to: CGPoint(x: 0, y: self.bounds.size.height))
        
        self.borderLayer.path = borderPath.cgPath
        self.borderLayer.position = CGPoint(x: 0, y: 0)
        
        self.borderLayer.lineWidth = 1
        self.borderLayer.fillColor = UIColor.clear.cgColor
        self.borderLayer.strokeColor = self.borderColor.cgColor
        self.borderLayer.fillRule = kCAFillRuleEvenOdd
    }
    
    // Animation
    func animate() {
        if self.superview == nil {
            return
        }
        
        let animation = CABasicAnimation(keyPath: "progress")
        animation.duration = 1
        animation.fromValue = self._previousProgress
        animation.toValue = self.progress
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = true
        self.fillLayer.add(animation, forKey: "progress")
    }
}

class GaugeLayer: CALayer {
    
    var progress: Double = 0.0
    var stops: Array<(stop: Double, color: UIColor)> = [ (0.0, UIColor.green) ]
    var width: Double = 10.0
    
    private var color: UIColor {
        get {
            if self.stops.count == 1 {
                return stops.first!.color
            }
            
            var c: UIColor = stops.first!.color
            
            for (value, color) in self.stops {
                if value <= self.progress {
                    c = color
                }
            }
            
            return c
        }
    }
    
    override init() {
        super.init()
        
        self.contentsScale = UIScreen.main.scale
        self.setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        
        if let other = layer as? GaugeLayer {
            self.width = other.width
            self.stops = other.stops
        }
    }
    
    override class func needsDisplay(forKey key: String) -> Bool {
        if key == "progress" {
            return true
        }
        return super.needsDisplay(forKey: key)
    }
    
    override func draw(in ctx: CGContext) {
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.maxY)
        let radius = self.bounds.midX
        
        let endAngle = CGFloat((M_PI - (M_PI * self.progress)) * -1)
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(M_PI), endAngle: endAngle, clockwise: true)
        path.addLine(to: center)
        
        let innerPath = UIBezierPath(arcCenter: center, radius: radius - CGFloat(self.width), startAngle: CGFloat(M_PI), endAngle: endAngle, clockwise: true)
        innerPath.addLine(to: center)
        
        path.append(innerPath)
        path.usesEvenOddFillRule = true
        
        ctx.addPath(path.cgPath)
        
        ctx.setFillColor(self.color.cgColor)
        
        path.usesEvenOddFillRule = true
        ctx.fillPath(using: CGPathFillRule.evenOdd)
    }
    
}
