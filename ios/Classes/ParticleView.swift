//
//  ParticleView.swift
//  particle_view
//
//  Created by Christian Wheeler on 2018/12/21.
//

import UIKit
import SpriteKit
import Flutter

class ParticleView: UIView, FlutterPlatformView {
    
    private var channel: FlutterMethodChannel!
    private var particles: ParticleScene!
    private var gradient: GradientView!
    
    init(frame: CGRect, messenger: FlutterBinaryMessenger, id: Int64, args: Any?) {
        super.init(frame: frame)
        self.frame = frame
        
        let name = "studio.ascended.particleview/particleview_\(id)"
        channel = FlutterMethodChannel(name: name, binaryMessenger: messenger)
        channel.setMethodCallHandler(handle(_:result:))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func view() -> UIView {
        gradient = GradientView()
        gradient.x = 0
        gradient.y = 0
        gradient.width = 100
        gradient.height = 100
        gradient.colors = [.black, .white, .white, .black]
        gradient.fromBottom = true
        addSubview(gradient)
        
        particles = ParticleScene(size: gradient.frame.size)
        particles.setColor(color: .red)
        
        let skView = SKView(frame: gradient.frame)
        skView.backgroundColor = .clear
        skView.presentScene(particles)
        addSubview(skView)
        
        return self
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        print("call arguments \(call.arguments!)")
        
        let args = call.arguments as! NSDictionary
        
        var nodeColor = args["nodes"] as! String
        var innerColor = args["inner"] as! String
        var outerColor = args["outer"] as! String
        
        nodeColor.append("ff")
        innerColor.append("ff")
        outerColor.append("ff")
        
        let inner = UIColor(hexString: innerColor)!
        let outer = UIColor(hexString: outerColor)!
    
        particles.setColor(color: UIColor(hexString: nodeColor)!)
        gradient.colors = [outer, inner, outer]
        
        result("iOS " + UIDevice.current.systemVersion)
    }
}

extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}
