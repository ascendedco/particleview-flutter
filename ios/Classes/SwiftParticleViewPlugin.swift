import Flutter
import UIKit

public class SwiftParticleViewPlugin: NSObject, FlutterPlugin {
  
    public static func register(with registrar: FlutterPluginRegistrar) {
        let id = "studio.ascended.particleview/particleview"
        registrar.register(ParticleViewFactory(messenger: registrar.messenger()), withId: id)
    }
}
