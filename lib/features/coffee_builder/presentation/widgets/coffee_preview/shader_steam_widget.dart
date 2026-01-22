import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../../domain/enums/temperature.dart';

class ShaderSteamWidget extends StatefulWidget {
  final Temperature temperature;

  const ShaderSteamWidget({
    super.key,
    required this.temperature,
  });

  @override
  State<ShaderSteamWidget> createState() => _ShaderSteamWidgetState();
}

class _ShaderSteamWidgetState extends State<ShaderSteamWidget>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  double _time = 0.0;
  ui.FragmentShader? _shader;
  bool _shaderLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadShader();
    _ticker = createTicker(_onTick);
    _ticker.start();
  }

  Future<void> _loadShader() async {
    try {
      final program =
          await ui.FragmentProgram.fromAsset('shaders/coffee_steam.frag');
      setState(() {
        _shader = program.fragmentShader();
        _shaderLoaded = true;
      });
    } catch (e) {
      debugPrint('Error loading shader: $e');
    }
  }

  void _onTick(Duration elapsed) {
    setState(() {
      _time = elapsed.inMilliseconds / 1000.0;
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    _shader?.dispose();
    super.dispose();
  }

  double _getIntensity(Temperature temp) {
    switch (temp) {
      case Temperature.iced:
        return 0.0;
      case Temperature.warm:
        return 0.4;
      case Temperature.hot:
        return 0.7;
      case Temperature.extraHot:
        return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final intensity = _getIntensity(widget.temperature);

    if (intensity == 0.0 || !_shaderLoaded || _shader == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: 120,
      height: 180,
      child: CustomPaint(
        painter: _SteamShaderPainter(
          shader: _shader!,
          time: _time,
          intensity: intensity,
        ),
        child: Container(color: Colors.transparent),
      ),
    );
  }
}

class _SteamShaderPainter extends CustomPainter {
  final ui.FragmentShader shader;
  final double time;
  final double intensity;

  _SteamShaderPainter({
    required this.shader,
    required this.time,
    required this.intensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, time);
    shader.setFloat(3, intensity);

    final paint = Paint()
      ..shader = shader
      ..blendMode = BlendMode.srcOver
      ..isAntiAlias = true;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(_SteamShaderPainter oldDelegate) {
    return oldDelegate.time != time || oldDelegate.intensity != intensity;
  }
}
