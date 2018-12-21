//
//  ParticleViewFactory.swift
//  particle_view
//
//  Created by Christian Wheeler on 2018/12/21.
//

import Flutter

class ParticleViewFactory: NSObject, FlutterPlatformViewFactory {
    
    var messenger: FlutterBinaryMessenger!
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
    }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return ParticleView(frame: frame, messenger: messenger, id: viewId, args: args)
    }
}
