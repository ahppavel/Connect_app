import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import '07_transition_screen.dart';

class AccountCreatedScreen extends StatefulWidget {
  final String languageCode;
  final String languageName;
  final String fullName;
  final String username;

  const AccountCreatedScreen({
    super.key,
    required this.languageCode,
    required this.languageName,
    required this.fullName,
    required this.username,
  });

  @override
  State<AccountCreatedScreen> createState() => _AccountCreatedScreenState();
}

class _AccountCreatedScreenState extends State<AccountCreatedScreen>
    with TickerProviderStateMixin {
  late AnimationController _checkController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  static const Color primary = Color(0xFF9d4d36);
  static const Color green = Color(0xFF25d366);
  static const Color bg = Color(0xFFF7F9FC);

  Map<Permission, bool> _permissionGranted = {};

  String t(String key) {
    final code = widget.languageCode.toUpperCase();
    return (_tr[code] ?? _tr['EN']!)[key] ?? _tr['EN']![key]!;
  }

  @override
  void initState() {
    super.initState();

    _checkController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _checkController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _initPermissionStates();

    Future.delayed(const Duration(milliseconds: 300), () {
      _checkController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      _fadeController.forward();
    });
  }

  Future<void> _initPermissionStates() async {
    final notificationStatus = await Permission.notification.status;
    final cameraStatus = await Permission.camera.status;
    final microphoneStatus = await Permission.microphone.status;

    setState(() {
      _permissionGranted[Permission.notification] = notificationStatus.isGranted;
      _permissionGranted[Permission.camera] = cameraStatus.isGranted;
      _permissionGranted[Permission.microphone] = microphoneStatus.isGranted;
    });
  }

  Future<void> _requestPermission(Permission permission) async {
    final status = await permission.request();
    setState(() {
      _permissionGranted[permission] = status.isGranted;
    });
  }

  void _denyPermission(Permission permission) {
    setState(() {
      _permissionGranted[permission] = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${permission.toString()} ${t('denied')}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  void dispose() {
    _checkController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: green.withOpacity(0.1),
                    border: Border.all(color: green.withOpacity(0.3), width: 2),
                  ),
                  child: const Icon(Icons.check_circle_rounded, size: 80, color: green),
                ),
              ),
              const SizedBox(height: 32),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  t('all_set'),
                  style: GoogleFonts.dancingScript(
                    fontSize: 42,
                    fontWeight: FontWeight.w700,
                    color: primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  '${t('welcome')}, ${widget.fullName}! 🎉',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF191c1e),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: primary.withOpacity(0.2), width: 1),
                  ),
                  child: Text(
                    '@${widget.username}',
                    style: const TextStyle(
                      color: primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  t('account_ready'),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.grey[600], height: 1.6),
                ),
              ),
              const SizedBox(height: 32),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t('enable_permissions'),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Color(0xFF191c1e),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _permissionTile(
                        icon: Icons.notifications_active_outlined,
                        title: t('notifications'),
                        permission: Permission.notification,
                      ),
                      const SizedBox(height: 8),
                      _permissionTile(
                        icon: Icons.camera_alt_outlined,
                        title: t('camera'),
                        permission: Permission.camera,
                      ),
                      const SizedBox(height: 8),
                      _permissionTile(
                        icon: Icons.mic_outlined,
                        title: t('microphone'),
                        permission: Permission.microphone,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              // No-splash button: GestureDetector + Container
              FadeTransition(
                opacity: _fadeAnimation,
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: GestureDetector(
                    onTap: () {
                      // Dismiss keyboard to avoid any visual glitch
                      FocusScope.of(context).unfocus();
                      // Slight delay to let keyboard close
                      Future.delayed(const Duration(milliseconds: 50), () {
                        if (!mounted) return;
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => TransitionScreen(
                              languageCode: widget.languageCode,
                              languageName: widget.languageName,
                              fullName: widget.fullName,
                              username: widget.username,
                            ),
                            transitionsBuilder: (_, anim, __, child) =>
                                FadeTransition(opacity: anim, child: child),
                            transitionDuration: const Duration(milliseconds: 600),
                          ),
                        );
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        t('go_to_login'),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _permissionTile({
    required IconData icon,
    required String title,
    required Permission permission,
  }) {
    final isGranted = _permissionGranted[permission] ?? false;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        if (isGranted)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: green.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check, size: 14, color: green),
                const SizedBox(width: 4),
                Text(t('allowed'), style: const TextStyle(fontSize: 12, color: green)),
              ],
            ),
          )
        else
          Row(
            children: [
              _permButton(t('allow'), () => _requestPermission(permission)),
              const SizedBox(width: 8),
              _permButton(t('dont_allow'), () => _denyPermission(permission), isAllow: false),
            ],
          ),
      ],
    );
  }

  Widget _permButton(String text, VoidCallback onTap, {bool isAllow = true}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isAllow ? primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isAllow ? primary : Colors.grey[400]!, width: 1),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isAllow ? Colors.white : Colors.grey[700],
          ),
        ),
      ),
    );
  }
}

// Complete translations for all 10 languages
const Map<String, Map<String, String>> _tr = {
  'EN': {
    'all_set': "You're all set!",
    'welcome': 'Welcome',
    'account_ready': 'Your account has been created successfully.\nYou can now log in and start connecting.',
    'enable_permissions': 'Enable permissions for better experience',
    'notifications': 'Notifications',
    'camera': 'Camera',
    'microphone': 'Microphone',
    'allow': 'Allow',
    'dont_allow': "Don't Allow",
    'allowed': 'Allowed',
    'denied': 'denied',
    'go_to_login': 'Start Connecting →',
  },
  'BN': {
    'all_set': 'সব প্রস্তুত!',
    'welcome': 'স্বাগতম',
    'account_ready': 'আপনার অ্যাকাউন্ট সফলভাবে তৈরি হয়েছে।\nএখন লগ ইন করে সংযোগ শুরু করুন।',
    'enable_permissions': 'ভালো অভিজ্ঞতার জন্য অনুমতি দিন',
    'notifications': 'বিজ্ঞপ্তি',
    'camera': 'ক্যামেরা',
    'microphone': 'মাইক্রোফোন',
    'allow': 'অনুমতি দিন',
    'dont_allow': 'অনুমতি দেবেন না',
    'allowed': 'অনুমতি দেওয়া হয়েছে',
    'denied': 'অস্বীকৃত',
    'go_to_login': 'সংযোগ শুরু করুন →',
  },
  'RU': {
    'all_set': 'Всё готово!',
    'welcome': 'Добро пожаловать',
    'account_ready': 'Ваш аккаунт успешно создан.\nТеперь войдите и начните общение.',
    'enable_permissions': 'Разрешите доступ для лучшего опыта',
    'notifications': 'Уведомления',
    'camera': 'Камера',
    'microphone': 'Микрофон',
    'allow': 'Разрешить',
    'dont_allow': 'Запретить',
    'allowed': 'Разрешено',
    'denied': 'Отказано',
    'go_to_login': 'Начать общение →',
  },
  'AR': {
    'all_set': '!كل شيء جاهز',
    'welcome': 'مرحباً',
    'account_ready': 'تم إنشاء حسابك بنجاح.',
    'enable_permissions': 'تمكين الأذونات لتجربة أفضل',
    'notifications': 'الإشعارات',
    'camera': 'الكاميرا',
    'microphone': 'الميكروفون',
    'allow': 'سماح',
    'dont_allow': 'لا تسمح',
    'allowed': 'مسموح',
    'denied': 'مرفوض',
    'go_to_login': 'ابدأ التواصل →',
  },
  'ES': {
    'all_set': '¡Todo listo!',
    'welcome': 'Bienvenido',
    'account_ready': 'Tu cuenta ha sido creada exitosamente.\nAhora puedes iniciar sesión.',
    'enable_permissions': 'Habilita permisos para una mejor experiencia',
    'notifications': 'Notificaciones',
    'camera': 'Cámara',
    'microphone': 'Micrófono',
    'allow': 'Permitir',
    'dont_allow': 'No permitir',
    'allowed': 'Permitido',
    'denied': 'Denegado',
    'go_to_login': 'Comenzar a conectar →',
  },
  'FR': {
    'all_set': 'Tout est prêt !',
    'welcome': 'Bienvenue',
    'account_ready': 'Votre compte a été créé avec succès.\nVous pouvez maintenant vous connecter.',
    'enable_permissions': 'Activez les autorisations pour une meilleure expérience',
    'notifications': 'Notifications',
    'camera': 'Caméra',
    'microphone': 'Microphone',
    'allow': 'Autoriser',
    'dont_allow': 'Ne pas autoriser',
    'allowed': 'Autorisé',
    'denied': 'Refusé',
    'go_to_login': 'Commencer à connecter →',
  },
  'HI': {
    'all_set': 'सब तैयार है!',
    'welcome': 'स्वागत है',
    'account_ready': 'आपका खाता सफलतापूर्वक बनाया गया है।\nअब लॉग इन करें।',
    'enable_permissions': 'बेहतर अनुभव के लिए अनुमतियाँ सक्षम करें',
    'notifications': 'सूचनाएं',
    'camera': 'कैमरा',
    'microphone': 'माइक्रोफोन',
    'allow': 'अनुमति दें',
    'dont_allow': 'अनुमति न दें',
    'allowed': 'अनुमति दी गई',
    'denied': 'अस्वीकृत',
    'go_to_login': 'जोड़ना शुरू करें →',
  },
  'PT': {
    'all_set': 'Tudo pronto!',
    'welcome': 'Bem-vindo',
    'account_ready': 'Sua conta foi criada com sucesso.\nAgora você pode fazer login.',
    'enable_permissions': 'Ative as permissões para uma melhor experiência',
    'notifications': 'Notificações',
    'camera': 'Câmera',
    'microphone': 'Microfone',
    'allow': 'Permitir',
    'dont_allow': 'Não permitir',
    'allowed': 'Permitido',
    'denied': 'Negado',
    'go_to_login': 'Começar a conectar →',
  },
  'ZH': {
    'all_set': '一切就绪！',
    'welcome': '欢迎',
    'account_ready': '您的账户已成功创建。\n现在您可以登录并开始连接。',
    'enable_permissions': '启用权限以获得更好体验',
    'notifications': '通知',
    'camera': '相机',
    'microphone': '麦克风',
    'allow': '允许',
    'dont_allow': '不允许',
    'allowed': '已允许',
    'denied': '已拒绝',
    'go_to_login': '开始连接 →',
  },
  'JA': {
    'all_set': '準備完了！',
    'welcome': 'ようこそ',
    'account_ready': 'アカウントが正常に作成されました。\nログインして接続を開始できます。',
    'enable_permissions': 'より良い体験のために権限を有効にする',
    'notifications': '通知',
    'camera': 'カメラ',
    'microphone': 'マイク',
    'allow': '許可',
    'dont_allow': '許可しない',
    'allowed': '許可済み',
    'denied': '拒否',
    'go_to_login': '接続を開始 →',
  },
};