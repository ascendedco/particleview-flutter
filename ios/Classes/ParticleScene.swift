//
//  ParticleScene.swift
//  particle_view
//
//  Created by Christian Wheeler on 2018/12/21.
//

import UIKit
import SpriteKit

class ParticleScene: SKScene {
    
    private var nodes: [Node] = []
    private var edges: [String: Edge] = [:]
    private let nodeCateogry: UInt32 = 0001
    private let edgeCategory: UInt32 = 0010
    private var color: UIColor = UIColor.white
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        self.backgroundColor = UIColor.clear
        
        let divider = CGFloat(UI_USER_INTERFACE_IDIOM() == .phone ? (70 * 70) : (110 * 110))
        let bounds = size.width * size.height / divider
        for index in 0 ..< Int(bounds.rounded()) {
            let shape = createNode(x: CGFloat(drand48()) * size.width, y: CGFloat(drand48()) * size.height)
            nodes.append(Node(shape: shape, index: index))
        }
        
        for node in nodes {
            addChild(node.shape)
            
            for node2 in nodes {
                let shape = createLine(start: CGPoint.zero, end: CGPoint.zero)
                let edge = Edge(shape: shape)
                edges[line(node1: node, node2: node2)] = edge
                addChild(edge.shape)
            }
        }
    }
    
    override func didMove(to view: SKView) {
        let edge = SKPhysicsBody(edgeLoopFrom: frame)
        edge.categoryBitMask = edgeCategory
        edge.contactTestBitMask = nodeCateogry
        edge.collisionBitMask = nodeCateogry
        edge.restitution = 1
        edge.friction = 0
        physicsBody = edge
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        
        for node in nodes { applyImpulse(node: node) }
        print("y \(highestY) x \(highestX)")
    }
    
    // Code that should be executed before rendering the next frame
    override func update(_ currentTime: TimeInterval) {
        for node in nodes {
            if node.shape.physicsBody!.velocity.dx == 0 || node.shape.physicsBody!.velocity.dy == 0 {
                applyImpulse(node: node)
            }
            
            for node2 in nodes {
                if node.shape != node2.shape {
                    let dist = distance(from: node.shape.position, to: node2.shape.position)
                    let e = edge(n1: node, n2: node2)
                    e.path.removeAllPoints()
                    e.shape.path = nil
                    if dist <= 7000 {
                        e.path.move(to: node.shape.position)
                        e.path.addLine(to: node2.shape.position)
                        e.shape.path = e.path.cgPath
                        e.shape.alpha = 1 - (dist / 7000)
                    }
                }
            }
        }
    }
    
    // ?
    override func didEvaluateActions() {
        
    }
    
    // Gravity is applied, and collisions are calculated
    override func didSimulatePhysics() {
        
    }
    
    // If nodes are connected, and updates occur
    override func didApplyConstraints() {
        
    }
    
    // Loop is complete
    override func didFinishUpdate() {
        // isPaused = true
    }
    
    func setColor(color: UIColor) {
        self.color = color
        for node in nodes {
            node.shape.strokeColor = color
            node.shape.fillColor = color
        }
        for edge in edges {
            edge.value.shape.strokeColor = color
        }
    }
    
    private func createNode(x: CGFloat, y: CGFloat) -> SKShapeNode {
        let multiplier = UI_USER_INTERFACE_IDIOM() == .phone ?
            CGFloat.random(min: 0.0045, max: 0.012) :
            CGFloat.random(min: 0.0025, max: 0.007)
        let radius = size.width * multiplier
        let node = SKShapeNode(circleOfRadius: radius)
        node.position = CGPoint(x: x, y: y)
        node.strokeColor = color
        node.glowWidth = 1.0
        node.fillColor = color
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        node.physicsBody?.categoryBitMask = nodeCateogry
        node.physicsBody?.contactTestBitMask = edgeCategory
        node.physicsBody?.collisionBitMask = edgeCategory
        // node.physicsBody?.affectedByGravity = false
        
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.restitution = 1
        node.physicsBody?.linearDamping = 0
        node.physicsBody?.angularDamping = 0
        node.physicsBody?.friction = 0
        
        return node
        // self.addChild(Circle)
    }
    
    private var highestX = 0.0
    private var highestY = 0.0
    
    private func applyImpulse(node: Node) {
        let degrees = Double.random(min: 0, max: 360)
        let radians = degrees * Double.pi
        let speed = UI_USER_INTERFACE_IDIOM() == .phone ?
            Double.random(min: 0.0065, max: 0.0075) :
            Double.random(min: 0.03, max: 0.045)
        let x = cos(radians) * speed
        let y = sin(radians) * speed
        if y > highestY { highestY = y }
        if x > highestX { highestX = x }
        let vector = CGVector(dx: x, dy: y)
        node.shape.physicsBody?.applyImpulse(vector)
    }
    
    private func createLine(start: CGPoint, end: CGPoint) -> SKShapeNode {
        let line = SKShapeNode()
        line.strokeColor = color
        line.lineWidth = 0.8
        line.alpha = 0
        return line
        // addChild(line)
    }
    
    private func distance(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }
    
    private func line(node1: Node, node2: Node) -> String {
        return "\(node1.index)x\(node2.index)"
    }
    
    private func edge(n1: Node, n2: Node) -> Edge {
        return edges[line(node1: n1, node2: n2)]!
    }
    
    class Node {
        
        var shape: SKShapeNode!
        var index: Int!
        
        init(shape: SKShapeNode, index: Int) {
            self.shape = shape
            self.index = index
        }
    }
    
    class Edge {
        
        var shape: SKShapeNode!
        var path: UIBezierPath!
        
        init(shape: SKShapeNode) {
            self.path = UIBezierPath()
            self.shape = shape
        }
    }
}

// MARK: Float Extension

public extension Float {
    
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: Float {
        return Float(arc4random()) / 0xFFFFFFFF
    }
    
    /// Random float between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random float point number between 0 and n max
    public static func random(min: Float, max: Float) -> Float {
        return Float.random * (max - min) + min
    }
}

// MARK: CGFloat Extension

public extension CGFloat {
    
    /// Randomly returns either 1.0 or -1.0.
    public static var randomSign: CGFloat {
        return (arc4random_uniform(2) == 0) ? 1.0 : -1.0
    }
    
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: CGFloat {
        return CGFloat(Float.random)
    }
    
    /// Random CGFloat between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random CGFloat point number between 0 and n max
    public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random * (max - min) + min
    }
}

// MARK: Int Extension

public extension Int {
    
    /// Returns a random Int point number between 0 and Int.max.
    public static var random: Int {
        return Int.random(n: Int.max)
    }
    
    /// Random integer between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random Int point number between 0 and n max
    public static func random(n: Int) -> Int {
        return Int(arc4random_uniform(UInt32(n)))
    }
    
    ///  Random integer between min and max
    ///
    /// - Parameters:
    ///   - min:    Interval minimun
    ///   - max:    Interval max
    /// - Returns:  Returns a random Int point number between 0 and n max
    public static func random(min: Int, max: Int) -> Int {
        return Int.random(n: max - min + 1) + min
        
    }
}

// MARK: Double Extension

public extension Double {
    
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }
    
    /// Random double between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random double point number between 0 and n max
    public static func random(min: Double, max: Double) -> Double {
        return Double.random * (max - min) + min
    }
}
