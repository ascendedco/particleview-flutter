package studio.ascended.particleview

import io.flutter.plugin.common.PluginRegistry.Registrar

class ParticleViewPlugin {

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      registrar.platformViewRegistry()
          .registerViewFactory("studio.ascended.particleview/particleview", ParticleViewFactory(registrar.messenger()))
    }
  }
}
