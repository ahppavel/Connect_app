import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:math' as math;
import '02_language_screen.dart';

class WelcomeScreen extends StatefulWidget {
  final String languageName;
  final String languageCode;

  const WelcomeScreen({
    super.key,
    required this.languageName,
    required this.languageCode,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _BubbleData {
  final String text;
  final double startX;
  final double size;
  final double speed;
  final bool isLeft;
  final Color color;
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

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _bubbleController;
  late Animation<double> _floatAnimation;

  final List<_BubbleData> _bubbles = [];
  final math.Random _random = math.Random();

  final List<String> _messages = [
    'Hey! 👋',
    'How are you?',
    'Miss you!',
    '😂😂😂',
    'See you soon!',
    'Let\'s meet!',
    'Good morning ☀️',
    'On my way!',
    '❤️',
    'Call me!',
    'OK sure!',
    'Haha yes!',
    '👍👍',
    'Coming!',
    'Wait...',
  ];

  final Map<String, Map<String, String>> _translations = {
    'EN': {
      'getStarted': 'Get Started',
      'alreadyAccount': 'Already have an account? Sign in',
    },
    'BN': {
      'getStarted': 'শুরু করুন',
      'alreadyAccount': 'ইতিমধ্যে অ্যাকাউন্ট আছে? সাইন ইন করুন',
    },
    'RU': {
      'getStarted': 'Начать',
      'alreadyAccount': 'Уже есть аккаунт? Войти',
    },
    'AR': {
      'getStarted': 'ابدأ الآن',
      'alreadyAccount': 'لديك حساب بالفعل؟ تسجيل الدخول',
    },
    'ES': {
      'getStarted': 'Empezar',
      'alreadyAccount': '¿Ya tienes cuenta? Inicia sesión',
    },
    'FR': {
      'getStarted': 'Commencer',
      'alreadyAccount': 'Déjà un compte? Se connecter',
    },
    'HI': {
      'getStarted': 'शुरू करें',
      'alreadyAccount': 'पहले से खाता है? साइन इन करें',
    },
    'PT': {
      'getStarted': 'Começar',
      'alreadyAccount': 'Já tem uma conta? Entrar',
    },
    'ZH': {
      'getStarted': '开始使用',
      'alreadyAccount': '已有账户？登录',
    },
    'JA': {
      'getStarted': '始める',
      'alreadyAccount': 'すでにアカウントをお持ちですか？サインイン',
    },
  };

  String _t(String key) {
    final code = widget.languageCode.toUpperCase();
    return _translations[code]?[key] ?? _translations['EN']![key]!;
  }

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: 0, end: -12).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Initialize bubbles
    for (int i = 0; i < 8; i++) {
      _bubbles.add(_createBubble(initialY: _random.nextDouble() * 800));
    }

    _bubbleController = AnimationController(
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
    ];

    return _BubbleData(
      text: _messages[_random.nextInt(_messages.length)],
      startX: _random.nextDouble() * 300 + 20,
      size: _random.nextDouble() * 10 + 12,
      speed: _random.nextDouble() * 0.8 + 0.4,
      isLeft: isLeft,
      color: colors[_random.nextInt(colors.length)],
      y: initialY ?? 900,
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Stack(
          children: [
            // Floating chat bubbles background
            ..._bubbles.map((bubble) {
              return Positioned(
                left: bubble.isLeft ? bubble.startX * 0.4 : null,
                right: bubble.isLeft ? null : bubble.startX * 0.3,
                top: bubble.y,
                child: Opacity(
                  opacity: 0.7,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
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
                        color: const Color(0xFF9d4d36).withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),

            // Main content
            Column(
              children: [
                // Top bar
                FadeInDown(
                  duration: const Duration(milliseconds: 600),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LanguageScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECEEF1),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.language,
                                    size: 18, color: Color(0xFF191c1e)),
                                const SizedBox(width: 8),
                                Text(
                                  widget.languageName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF191c1e),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                // Floating logo
                ElasticIn(
                  duration: const Duration(milliseconds: 900),
                  child: AnimatedBuilder(
                    animation: _floatAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _floatAnimation.value),
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF9d4d36)
                                    .withOpacity(0.15),
                                blurRadius: 30,
                                spreadRadius: 8,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.mark_chat_unread_rounded,
                              size: 50,
                              color: Color(0xFF9d4d36),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const Spacer(flex: 1),

                // Connect
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  duration: const Duration(milliseconds: 700),
                  child: Text(
                    'Connect',
                    style: GoogleFonts.dancingScript(
                      fontSize: 58,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF9d4d36),
                      letterSpacing: 1,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Tagline
                FadeInUp(
                  delay: const Duration(milliseconds: 450),
                  duration: const Duration(milliseconds: 700),
                  child: Text(
                    'Secure. Simple. Reliable.',
                    style: GoogleFonts.dmMono(
                      fontSize: 13,
                      color: const Color(0xFF6c7b6b),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2,
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                // Get Started button
                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  duration: const Duration(milliseconds: 700),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9d4d36),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                          elevation: 8,
                          shadowColor:
                              const Color(0xFF9d4d36).withOpacity(0.4),
                        ),
                        child: Text(
                          _t('getStarted'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Sign in
                FadeInUp(
                  delay: const Duration(milliseconds: 750),
                  duration: const Duration(milliseconds: 700),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      _t('alreadyAccount'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF9d4d36),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ],
        ),
      ),
    );
  }
}