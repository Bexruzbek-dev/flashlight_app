import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FlashlightPage(),
    );

  }
  
}


class FlashlightPage extends StatefulWidget {
  @override
  _FlashlightPageState createState() => _FlashlightPageState();
}

class _FlashlightPageState extends State<FlashlightPage> {
  static const platform = MethodChannel('flashlight');
  bool _isOn = false;

  Future<void> _toggleFlashlight() async {
    try {
      await platform.invokeMethod('toggleFlashlight', {'isOn': !_isOn});
      setState(() {
        _isOn = !_isOn;
      });
    } on PlatformException catch (e) {
      print("Failed to toggle flashlight: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flashlight'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _toggleFlashlight,
          child: Text(_isOn ? 'Turn off' : 'Turn on'),
        ),
      ),
    );
  }
}
