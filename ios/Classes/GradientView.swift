//
//  GradientView.swift
//  particle_view
//
//  Created by Christian Wheeler on 2018/12/21.
//

import UIKit

@IBDesignable class GradientView: UIView {
    
    @IBInspectable var x: CGFloat = 0 { didSet { layout() } }
    @IBInspectable var y: CGFloat = 0 { didSet { layout() } }
    @IBInspectable var width: CGFloat = 80 { didSet { layout() } }
    @IBInspectable var height: CGFloat = 5 { didSet { layout() } }
    @IBInspectable var relativeToParent: Bool = false { didSet { layout() } }
    @IBInspectable var colors: [UIColor] = [UIColor.clear] { didSet { layout() } }
    @IBInspectable var fromTop: Bool = false { didSet { layout() } }
    @IBInspectable var fromBottom: Bool = false { didSet { layout() } }
    @IBInspectable var fromLeft: Bool = false { didSet { layout() } }
    @IBInspectable var fromRight: Bool = false { didSet { layout() } }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        layout()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layout()
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
    
    private func layout() {
        let w = relativeToParent ? superview!.frame.width : UIScreen.main.bounds.width
        let h = relativeToParent ? superview!.frame.height : UIScreen.main.bounds.height
        
        frame.size.width = w * width / 100
        frame.size.height = h * height / 100
        frame.origin.x = w * x / 100
        frame.origin.y = h * y / 100
        
        gradientLayer.colors = colors.map { color in color.cgColor }
        gradientLayer.frame.size = frame.size
        
        if fromLeft {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        }
        else if fromRight {
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        }
        else if fromTop {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        }
        else if fromBottom {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        }
        else {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        }
    }
}
