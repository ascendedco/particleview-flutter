#import "ParticleViewPlugin.h"
#import <particle_view/particle_view-Swift.h>

@implementation ParticleViewPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftParticleViewPlugin registerWithRegistrar:registrar];
}
@end
