import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '03_log_in_screen.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selected = 'en';

  final List<Map<String, String>> _languages = [
    {'code': 'EN', 'name': 'English', 'subtitle': "Device's language"},
    {'code': 'BN', 'name': 'বাংলা', 'subtitle': 'Bangla'},
    {'code': 'RU', 'name': 'Русский', 'subtitle': 'Russian'},
    {'code': 'AR', 'name': 'العربية', 'subtitle': 'Arabic'},
    {'code': 'ES', 'name': 'Español', 'subtitle': 'Spanish'},
    {'code': 'FR', 'name': 'Français', 'subtitle': 'French'},
    {'code': 'HI', 'name': 'हिन्दी', 'subtitle': 'Hindi'},
    {'code': 'PT', 'name': 'Português', 'subtitle': 'Portuguese'},
    {'code': 'ZH', 'name': '中文', 'subtitle': 'Chinese'},
    {'code': 'JA', 'name': '日本語', 'subtitle': 'Japanese'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Column(
          children: [
            // Top
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close,
                        color: Color(0xFF9d4d36), size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Select your language',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9d4d36),
                    ),
                  ),
                ],
              ),
            ),

            // icon
            const SizedBox(height: 16),
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF9d4d36).withOpacity(0.08),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.language,
                  size: 44,
                  color: Color(0xFF9d4d36),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Choose your language',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF191c1e),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Personalize your experience by selecting\nyour preferred language.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF3c4a3d),
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            // Language 
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _languages.length,
                itemBuilder: (context, index) {
                  final lang = _languages[index];
                  final isSelected =
                      _selected == lang['code']!.toLowerCase();

                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _selected = lang['code']!.toLowerCase();
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF9d4d36).withOpacity(0.05)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF9d4d36)
                              : Colors.transparent,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected
                                ? const Color(0xFF9d4d36).withOpacity(0.1)
                                : Colors.black.withOpacity(0.04),
                            blurRadius: isSelected ? 12 : 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Code badge
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF9d4d36).withOpacity(0.15)
                                  : const Color(0xFFF2F4F7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                lang['code']!,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? const Color(0xFF9d4d36)
                                      : const Color(0xFF3c4a3d),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Lan name
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lang['name']!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                    color: const Color(0xFF191c1e),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  lang['subtitle']!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isSelected
                                        ? const Color(0xFF9d4d36)
                                        : const Color(0xFF6c7b6b),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Animated button
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF9d4d36)
                                    : const Color(0xFFbbcbb9),
                                width: 2,
                              ),
                              color: isSelected
                                  ? const Color(0xFF9d4d36)
                                  : Colors.transparent,
                            ),
                            child: isSelected
                                ? const Icon(Icons.check,
                                    size: 14, color: Colors.white)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Arrow
            Padding(
              padding: const EdgeInsets.all(24),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    final selected = _languages.firstWhere(
                      (l) => l['code']!.toLowerCase() == _selected,
                    );
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder:
                            (context, animation, secondaryAnimation) =>
                                LoginScreen(
                          languageName: selected['name']!,
                          languageCode: selected['code']!,
                        ),
                        transitionsBuilder: (context, animation,
                            secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.1, 0),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOut,
                              )),
                              child: child,
                            ),
                          );
                        },
                        transitionDuration:
                            const Duration(milliseconds: 400),
                      ),
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF9d4d36),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF9d4d36).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.arrow_forward,
                        color: Colors.white, size: 26),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}