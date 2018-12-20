import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/*class ParticleView {
  static const MethodChannel _channel =
      const MethodChannel('particle_view');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}*/

typedef void ParticleViewCreatedCallback(ParticleViewController controller);

class ParticleView extends StatefulWidget {

  final Map<String, dynamic> params;

  const ParticleView({ Key key, this.params }): super(key: key);

  @override
  State<StatefulWidget> createState() => ParticleViewState();
}

class ParticleViewState extends State<ParticleView> {

  ParticleViewController controller;

  @override
  Widget build(BuildContext context) {

    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'studio.ascended.particleview/particleview',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }
    else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'studio.ascended.particleview/particleview',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }
    else return Text('Your platform is not supported by this plugin.');
  }

  void _onPlatformViewCreated(int id) {
    controller = ParticleViewController._(id);
    controller.setParameters(widget.params);
  }
}

class ParticleViewController {

  ParticleViewController._(int id) : _channel = new MethodChannel('studio.ascended.particleview/particleview_$id');

  final MethodChannel _channel;

  Future<void> setParameters(dynamic text) async {
    assert(text != null);
    return _channel.invokeMethod('setParameters', text);
  }
}
