import 'dart:math';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final WidgetBuilder next;
  const SplashScreen({super.key, required this.next});
 

  @override
  State<SplashScreen> createState() => _SplashRevealDemoState();
}

class _SplashRevealDemoState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Background overlay
  late final Animation<double> _bgDarkOpacity;

  // Circle
  late final Animation<double> _circleScale;
  late final Animation<double> _circleOpacity;

  // Corner images (قبل اللوجو)
  late final Animation<double> _cornersOpacity;
  late final Animation<double> _vUpDy;   // ينزل من فوق
  late final Animation<double> _vDownDy; // يطلع من تحت

  // Logo
  late final Animation<Offset> _logoOffset;
  late final Animation<double> _logoOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    );

    // 0 -> 55%: background darkens
    _bgDarkOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeInOutCubic),
      ),
    );

    // 0 -> 55%: circle grows
    _circleScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeInOutCubic),
      ),
    );

    // 55 -> 70%: circle fades out
    // ✅ 40 -> 55%: circle fades out BEFORE the screen gets fully dark
_circleOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
  CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.40, 0.55, curve: Curves.easeOutCubic),
  ),
);


    // ✅ Corner images تظهر قبل اللوجو
    // Opacity: 0.60 -> 0.72
    _cornersOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.60, 0.72, curve: Curves.easeIn),
      ),
    );

    // ✅ حركة vup: نزول من فوق (Pixel-based) 0.60 -> 0.78
    _vUpDy = Tween<double>(begin: -420.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.60, 0.78, curve: Curves.easeOutCubic),
      ),
    );

    // ✅ حركة vdown: طلوع من تحت (Pixel-based) 0.60 -> 0.78
    _vDownDy = Tween<double>(begin: 420.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.60, 0.78, curve: Curves.easeOutCubic),
      ),
    );

    // 70 -> 100%: logo comes in
    _logoOffset = Tween<Offset>(
      begin: const Offset(0, 9.0),
      end: const Offset(0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.70, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.70, 0.85, curve: Curves.easeIn),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });


    WidgetsBinding.instance.addPostFrameCallback((_) async {
  await _controller.forward();
  if (!mounted) return;

  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: widget.next),
  );
});

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _backgroundOpacity() {
    // 0..0.55: darken
    if (_controller.value <= 0.55) return _bgDarkOpacity.value;

    // 0.55..0.70: fade out
    if (_controller.value <= 0.70) {
      final t = (_controller.value - 0.55) / (0.70 - 0.55);
      return (1.0 - t).clamp(0.0, 1.0);
    }

    return 0.0;
  }

  // ✅ اللون حسب حجم الدائرة
  Color _circleColorByScale() {
    const grey = Color(0xFFBDBDBD);
    const greyUntil = 0.20;
    const transitionBand = 0.06;

    final s = _circleScale.value;

    if (s <= greyUntil) return grey;
    if (s >= greyUntil + transitionBand) return Colors.black;

    final t = (s - greyUntil) / transitionBand;
    return Color.lerp(grey, Colors.black, t)!;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxDiameter =
        sqrt(size.width * size.width + size.height * size.height);
    const baseDiameter = 120.0;

    return Scaffold(
      body: Stack(
        children: [
          // base background
          const Positioned.fill(
            child: ColoredBox(color: Colors.white),
          ),

          // dark overlay
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return Opacity(
                    opacity: _backgroundOpacity(),
                    child: const ColoredBox(color: Colors.black),
                  );
                },
              ),
            ),
          ),

          // circle
          Center(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final diameter = baseDiameter +
                      (maxDiameter - baseDiameter) * _circleScale.value;

                  return Opacity(
                    opacity: _circleOpacity.value,
                    child: Container(
                      width: diameter,
                      height: diameter,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _circleColorByScale(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // ✅ الصور قبل اللوجو (Fade + Translate)
          IgnorePointer(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return Opacity(
                  opacity: _cornersOpacity.value,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Transform.translate(
                          offset: Offset(0, _vUpDy.value),
                          child: Image.asset(
                            'assets/images/vup.png',
                            width: 170,
                            fit: BoxFit.contain,
                            package: 'shared_ui',
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Transform.translate(
                          offset: Offset(0, _vDownDy.value),
                          child: Image.asset(
                            'assets/images/vdown.png',
                            width: 170,
                            fit: BoxFit.contain,
                            package: 'shared_ui',
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // logo
          Align(
            alignment: Alignment.center,
            child: FadeTransition(
              opacity: _logoOpacity,
              child: SlideTransition(
                position: _logoOffset,
                child: Image.asset(
                  'assets/images/rntls_logo.png',
                  package: 'shared_ui',
                  width: 220,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
