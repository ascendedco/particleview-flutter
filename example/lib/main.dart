import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:particle_view/particle_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(),
          title: const Text('ParticleView Plugin'),
        ),
        body: Center(
          child: Container(
            color: Colors.black,
            child: ParticleView(
              params: {
                'inner': '#F8F8F8',
                'outer': '#CCCCCC',
                'nodes': '#ACACAC',
                'minRadius': 11.0,
                'maxRadius': 13.5,
                'lineDistance': 400.0,
                'lineWidth': 4.0,
                'nodeCount': 50
              },
            ),
          ),
        ),
      ),
    );
  }
}
