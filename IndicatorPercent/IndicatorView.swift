//
//  IndicatorView.swift
//  IndicatorPercent
//
//  Created by Dung Vu on 11/15/16.
//  Copyright © 2016 Zinio Pro. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class IndicatorView: UIView {
    
    @IBInspectable var strokeWidth: CGFloat = 10 {
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable var colorStrokeBackground: UIColor = #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1) {
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable var colorStrokeProcess: UIColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var ratio: CGFloat = 1 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var percent: CGFloat = 0 {
        didSet{
            var nValue = percent
            nValue = min(nValue, 1)
            nValue = max(nValue, 0)
            processLayer?.strokeEnd = nValue
        }
    }
    
    fileprivate var processLayer: CAShapeLayer?
    
    override func draw(_ rect: CGRect) {
        
        let bgShape = self.createCircleLayer(colorStroke: colorStrokeBackground,
                                             strokeWidth: strokeWidth,
                                             delta: strokeWidth * ratio / 2)
        bgShape.strokeEnd = 1
        
        let pShape = self.createCircleLayer(start: -90,
                                            end: 270,
                                            colorStroke: colorStrokeProcess,
                                            strokeWidth: strokeWidth * ratio)
        pShape.strokeStart = 0
        pShape.strokeEnd = percent
        processLayer = pShape
        
        self.layer.addSublayer(bgShape)
        self.layer.addSublayer(pShape)
    }
    
    fileprivate func createCircleLayer(start: Double = 0,
                           end: Double = 360,
                           colorStroke: UIColor,
                           strokeWidth: CGFloat,
                           delta: CGFloat = 0) -> CAShapeLayer {
        
        let side = min(self.bounds.width, self.bounds.height)
        let fullRadius = side - strokeWidth
        let frameCircle: CGRect = CGRect(origin: CGPoint.zero, size: CGSize(width: fullRadius, height: fullRadius))
        let circle = CAShapeLayer()
        circle.frame = frameCircle
        
        let start = Measurement(value: start, unit: UnitAngle.degrees).converted(to: .radians).value
        let end = Measurement(value: end, unit: UnitAngle.degrees).converted(to: .radians).value
        
        let benzier = UIBezierPath(arcCenter: CGPoint(x: fullRadius / 2, y: fullRadius / 2),
                                   radius: (fullRadius - delta) / 2,
                                   startAngle: CGFloat(start),
                                   endAngle: CGFloat(end),
                                   clockwise: true)
        
        circle.strokeColor = colorStroke.cgColor
        circle.lineWidth = strokeWidth
        circle.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        circle.path = benzier.cgPath
        circle.backgroundColor = UIColor.clear.cgColor
        circle.fillColor = UIColor.clear.cgColor
        circle.lineCap = kCALineCapRound
        
        return circle
    }
    
}

