import 'package:flutter/material.dart';
import '02_language_screen.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _morphController;
  late AnimationController _pulseController;
  late Animation<double> _floatAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    _morphController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: 0, end: -14).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _morphController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Stack(
        children: [
          Positioned(
            top: size.height * 0.05,
            right: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF9d4d36).withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: size.height * 0.1,
            left: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF8cf1e1).withOpacity(0.07),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 1),

                // Floating orb
                AnimatedBuilder(
                  animation: Listenable.merge(
                      [_floatAnimation, _morphController, _scaleAnimation]),
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _floatAnimation.value),
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
                        child: SizedBox(
                          width: 220,
                          height: 220,
                          child: CustomPaint(
                            painter: MorphOrbPainter(_morphController.value),
                            child: Center(
                              child: AnimatedBuilder(
                                animation: _pulseController,
                                builder: (context, child) {
                                  return Icon(
                                    Icons.hub_rounded,
                                    size: 60 + (_pulseController.value * 3),
                                    color: const Color(0xFF9d4d36),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Text section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'ENTER THE',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3c4a3d),
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Connect',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF9d4d36),
                          letterSpacing: -2,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Step into a new era of secure,\ntransparent communication.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF3c4a3d),
                          fontWeight: FontWeight.w500,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 1),

                // Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LanguageScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9d4d36),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                        elevation: 8,
                        shadowColor:
                            const Color(0xFF9d4d36).withOpacity(0.4),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Start Journey',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12),
                          Icon(Icons.arrow_forward,
                              color: Colors.white, size: 22),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MorphOrbPainter extends CustomPainter {
  final double progress;
  MorphOrbPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.38;

    final glowPaint = Paint()
      ..color = const Color(0xFF9d4d36).withOpacity(0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25);
    canvas.drawCircle(center, radius * 1.2, glowPaint);

    final paint = Paint()
      ..color = const Color(0xFFffdcd2).withOpacity(0.85)
      ..style = PaintingStyle.fill;

    final path = _buildSmoothMorphPath(center, radius, progress);
    canvas.drawPath(path, paint);

    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(path, borderPaint);
  }

  Path _buildSmoothMorphPath(Offset center, double radius, double t) {
    final path = Path();
    const points = 200;
    for (int i = 0; i <= points; i++) {
      final angle = (i / points) * 2 * math.pi;
      final wave1 = math.sin(angle * 2 + t * 2 * math.pi) * 0.08;
      final wave2 = math.cos(angle * 3 + t * 2 * math.pi) * 0.06;
      final r = radius * (1 + wave1 + wave2);
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(MorphOrbPainter old) => old.progress != progress;
}