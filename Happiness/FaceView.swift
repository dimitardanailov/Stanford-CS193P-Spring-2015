//
//  FaceView.swift
//  Happiness
//
//  Created by dimitar on 8/25/15.
//  Copyright (c) 2015 dimityr.danailov. All rights reserved.
//

import UIKit

class FaceView: UIView
{
    var lineWidth: CGFloat = 3 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var color: UIColor = UIColor.blueColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var scale: CGFloat = 0.90 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var faceCenter: CGPoint {
        return convertPoint(center, fromView: superview)
    }
    
    var faceRadius: CGFloat {
        return (min(bounds.size.width, bounds.size.height) / 2) * scale
    }
    
    private struct Scaling
    {
        static let FaceRadiusToEyeRadiusRatio: CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3
        static let FaceRadiusToEyeSeperationRatio: CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio: CGFloat = 1
        static let FaceRadiusToMouthHeightRatio: CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio: CGFloat = 3
    }
    
    private enum Eye {
        case Left, Right
    }
    
    private func bezierPathForEye(whichEye: Eye) -> UIBezierPath
    {
        var eyeCenter = faceCenter
        
        // Calculate eyeCenter.x
        let eyeHorizontalSepration = (faceRadius / Scaling.FaceRadiusToEyeSeperationRatio) / 2
        switch whichEye {
        case .Left: eyeCenter.x -= eyeHorizontalSepration
        case .Right: eyeCenter.x += eyeHorizontalSepration
        }
        
        // Calculate eyeCenter.y
        eyeCenter.y -= (faceRadius / Scaling.FaceRadiusToEyeOffsetRatio)
        
        let eyeRadius = (faceRadius / Scaling.FaceRadiusToEyeRadiusRatio)
        
        let path = UIBezierPath(
            arcCenter: eyeCenter,
            radius: eyeRadius,
            startAngle: 0,
            endAngle: CGFloat(2 * M_PI),
            clockwise: true
        )
        path.lineWidth = lineWidth
        
        return path
    }
    
    private func bezierPathForSmile(fractionOfMaxSmile: Double) -> UIBezierPath
    {
        // Calculate Mouth Proportions
        let mouthWidth = (faceRadius / Scaling.FaceRadiusToMouthWidthRatio)
        let mouthHeight = (faceRadius / Scaling.FaceRadiusToMouthHeightRatio)
        let mouthVerticalOffset = (faceRadius / Scaling.FaceRadiusToMouthOffsetRatio)
        
        let smileHeight = CGFloat(max(min(fractionOfMaxSmile, 1), -1)) * mouthHeight
        
        
        let path = UIBezierPath()
        
        let startPoint = CGPoint(x: faceCenter.x - (mouthWidth / 2), y: faceCenter.y + mouthVerticalOffset)
        path.moveToPoint(startPoint)
        
        let endPoint = CGPoint(x: startPoint.x + mouthWidth, y: startPoint.y)
        let controlPoint1 = CGPoint(x: startPoint.x + (mouthWidth / 3), y: startPoint.y + smileHeight)
        let controlPoint2 = CGPoint(x: endPoint.x - (mouthWidth / 3), y: controlPoint1.y)
        
        // Function declaration: 
        // func addCurveToPoint(_ endPoint: CGPoint, controlPoint1 controlPoint1: CGPoint, controlPoint2 controlPoint2: CGPoint)
        path.addCurveToPoint(
            endPoint,
            controlPoint1: controlPoint1,
            controlPoint2: controlPoint2
        )
        
        path.lineWidth = lineWidth
        
        return path
    }
    
    override func drawRect(rect: CGRect)
    {
        let facePath = UIBezierPath(
            arcCenter: faceCenter,
            radius: faceRadius,
            startAngle: 0,
            endAngle: CGFloat(2 * M_PI),
            clockwise: true
        )
        facePath.lineWidth = lineWidth
        color.set()
        facePath.stroke()
        
        bezierPathForEye(.Left).stroke()
        bezierPathForEye(.Right).stroke()
        
        let smiliness = 0.75
        let smilePath = bezierPathForSmile(smiliness)
        smilePath.stroke()
    }
}
