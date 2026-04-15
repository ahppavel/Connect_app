import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '08_home_screen.dart';

// bubbles 
class _BubbleData {
  String text;
  double startX;
  double size;
  double speed;
  bool isLeft;
  Color color;
  double y;

  _BubbleData({
    required this.text,
    required this.startX,
    required this.size,
    required this.speed,
    required this.isLeft,
    required this.color,
    required this.y,
  });
}

// aniimated bubble layer
class _BubbleLayer extends StatefulWidget {
  const _BubbleLayer();

  @override
  State<_BubbleLayer> createState() => _BubbleLayerState();
}

class _BubbleLayerState extends State<_BubbleLayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_BubbleData> _bubbles = [];
  final math.Random _random = math.Random();

  final List<String> _messages = [
    'Hey! 👋', 'How are you?', 'Miss you!',
    '😂😂😂', 'See you soon!', 'Let\'s meet!',
    'Good morning ☀️', 'On my way!', '❤️',
    'Call me!', 'OK sure!', 'Haha yes!',
    '👍👍', 'Coming!', 'Wait...',
  ];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 12; i++) { // more bubbles for richness
      _bubbles.add(_createBubble(initialY: _random.nextDouble() * 800));
    }
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..addListener(() {
        setState(() {
          for (var bubble in _bubbles) {
            bubble.y -= bubble.speed;
            if (bubble.y < -100) {
              final index = _bubbles.indexOf(bubble);
              _bubbles[index] = _createBubble(initialY: 900);
            }
          }
        });
      })
      ..repeat();
  }

  _BubbleData _createBubble({double? initialY}) {
    final isLeft = _random.nextBool();
    final colors = [
      const Color(0xFF9d4d36).withOpacity(0.08),
      const Color(0xFF9d4d36).withOpacity(0.06),
      const Color(0xFF8cf1e1).withOpacity(0.1),
      const Color(0xFFffdcd2).withOpacity(0.5),
      const Color(0xFF9d4d36).withOpacity(0.12),
      const Color(0xFFffdcd2).withOpacity(0.3),
    ];
    return _BubbleData(
      text: _messages[_random.nextInt(_messages.length)],
      startX: _random.nextDouble() * 280 + 20,
      size: _random.nextDouble() * 10 + 12,
      speed: _random.nextDouble() * 0.8 + 0.4,
      isLeft: isLeft,
      color: colors[_random.nextInt(colors.length)],
      y: initialY ?? 900,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _bubbles.map((bubble) {
        return Positioned(
          left: bubble.isLeft ? bubble.startX * 0.4 : null,
          right: bubble.isLeft ? null : bubble.startX * 0.3,
          top: bubble.y,
          child: Opacity(
            opacity: 0.7,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: bubble.color,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: bubble.isLeft
                      ? const Radius.circular(4)
                      : const Radius.circular(16),
                  bottomRight: bubble.isLeft
                      ? const Radius.circular(16)
                      : const Radius.circular(4),
                ),
                border: Border.all(
                  color: const Color(0xFF9d4d36).withOpacity(0.1),
                  width: 0.5,
                ),
              ),
              child: Text(
                bubble.text,
                style: TextStyle(
                  fontSize: bubble.size,
                  color: const Color(0xFF9d4d36).withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}


class TransitionScreen extends StatefulWidget {
  final String languageCode;
  final String languageName;
  final String fullName;
  final String username;
  final String email;

  const TransitionScreen({
    super.key,
    required this.languageCode,
    required this.languageName,
    required this.fullName,
    required this.username,
    required this.email,
  });

  @override
  State<TransitionScreen> createState() => _TransitionScreenState();
}

class _TransitionScreenState extends State<TransitionScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeInController;
  late AnimationController _fadeOutController;
  late AnimationController _textController;

  late Animation<double> _fadeInAnim;
  late Animation<double> _fadeOutAnim;
  late Animation<double> _textFadeAnim;
  late Animation<double> _textSlideAnim;

  static const Color primary = Color(0xFF9d4d36);

  @override
  void initState() {
    super.initState();

    // Fade in
    _fadeInController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeInAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeInController, curve: Curves.easeOut),
    );

    // Fade out before leaving
    _fadeOutController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeOutAnim = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _fadeOutController, curve: Curves.easeIn),
    );

    // Text animation
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _textFadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );
    _textSlideAnim = Tween<double>(begin: 20, end: 0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    // Start sequence
    _startSequence();
  }

  void _startSequence() async {
    _fadeInController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) _textController.forward();

    await Future.delayed(const Duration(milliseconds: 4000));
    if (mounted) {
      await _fadeOutController.forward();
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            languageCode: widget.languageCode,
            languageName: widget.languageName,
            fullName: widget.fullName,
            username: widget.username,
            email: widget.email,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _fadeInController.dispose();
    _fadeOutController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Stack(
        children: [
          // Bubble background (animated)
          const _BubbleLayer(),
          
          AnimatedBuilder(
            animation: Listenable.merge([_fadeInController, _fadeOutController, _textController]),
            builder: (context, child) {
              final opacity = _fadeInAnim.value * _fadeOutAnim.value;
              return Opacity(
                opacity: opacity.clamp(0.0, 1.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      Opacity(
                        opacity: (_textFadeAnim.value * _fadeOutAnim.value).clamp(0.0, 1.0),
                        child: Transform.translate(
                          offset: Offset(0, _textSlideAnim.value),
                          child: Text(
                            'Connect',
                            style: GoogleFonts.dancingScript(
                              fontSize: 52,
                              fontWeight: FontWeight.w700,
                              color: primary,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Tagline
                      Opacity(
                        opacity: (_textFadeAnim.value * _fadeOutAnim.value).clamp(0.0, 1.0),
                        child: Transform.translate(
                          offset: Offset(0, _textSlideAnim.value * 1.2),
                          child: Text(
                            'Secure. Simple. Reliable.',
                            style: GoogleFonts.dmMono(
                              fontSize: 13,
                              color: const Color(0xFF6c7b6b),
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}