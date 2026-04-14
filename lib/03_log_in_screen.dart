import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '04_forgot_password_screen.dart';
import '05_create_account_screen.dart';
import '07_transition_screen.dart';   // adjust path if needed

// ── Complete translations for all languages ──────────────────────────────────
const Map<String, Map<String, String>> _translations = {
  'EN': {
    'email': 'Email',
    'phone': 'Phone',
    'username': 'Username',
    'email_hint': 'Enter your email',
    'phone_hint': 'Enter phone number',
    'username_hint': 'Enter username',
    'password_hint': 'Password',
    'forgot_password': 'Forgot password?',
    'log_in': 'Log In',
    'or_continue': 'or continue with',
    'continue_google': 'Continue with Google',
    'create_account': 'Create new account',
    'email_empty': 'Please enter your email',
    'email_invalid': 'Enter a valid email address',
    'phone_empty': 'Please enter your phone number',
    'phone_invalid': 'Enter a valid phone number (7-15 digits)',
    'username_empty': 'Please enter your username',
    'username_invalid': 'Username must be at least 3 characters',
    'password_empty': 'Please enter your password',
    'password_short': 'Password must be at least 6 characters',
    'login_success': 'Login Successful',
  },
  'BN': {
    'email': 'ইমেইল',
    'phone': 'ফোন',
    'username': 'ইউজারনেম',
    'email_hint': 'আপনার ইমেইল লিখুন',
    'phone_hint': 'ফোন নম্বর লিখুন',
    'username_hint': 'ইউজারনেম লিখুন',
    'password_hint': 'পাসওয়ার্ড',
    'forgot_password': 'পাসওয়ার্ড ভুলে গেছেন?',
    'log_in': 'লগ ইন',
    'or_continue': 'অথবা দিয়ে চালিয়ে যান',
    'continue_google': 'গুগল দিয়ে চালিয়ে যান',
    'create_account': 'নতুন অ্যাকাউন্ট তৈরি করুন',
    'email_empty': 'আপনার ইমেইল দিন',
    'email_invalid': 'সঠিক ইমেইল দিন',
    'phone_empty': 'আপনার ফোন নম্বর দিন',
    'phone_invalid': 'সঠিক ফোন নম্বর দিন (৭-১৫ সংখ্যা)',
    'username_empty': 'আপনার ইউজারনেম দিন',
    'username_invalid': 'ইউজারনেম কমপক্ষে ৩ অক্ষরের হতে হবে',
    'password_empty': 'আপনার পাসওয়ার্ড দিন',
    'password_short': 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে',
    'login_success': 'লগ ইন সফল হয়েছে',
  },
  'RU': {
    'email': 'Эл. почта',
    'phone': 'Телефон',
    'username': 'Имя пользователя',
    'email_hint': 'Введите ваш email',
    'phone_hint': 'Введите номер телефона',
    'username_hint': 'Введите имя пользователя',
    'password_hint': 'Пароль',
    'forgot_password': 'Забыли пароль?',
    'log_in': 'Войти',
    'or_continue': 'или продолжить с',
    'continue_google': 'Продолжить с Google',
    'create_account': 'Создать новый аккаунт',
    'email_empty': 'Пожалуйста, введите ваш email',
    'email_invalid': 'Введите корректный email',
    'phone_empty': 'Пожалуйста, введите номер телефона',
    'phone_invalid': 'Введите корректный номер телефона (7-15 цифр)',
    'username_empty': 'Пожалуйста, введите имя пользователя',
    'username_invalid': 'Имя пользователя должно содержать не менее 3 символов',
    'password_empty': 'Пожалуйста, введите пароль',
    'password_short': 'Пароль должен содержать не менее 6 символов',
    'login_success': 'Вход выполнен успешно',
  },
  'AR': {
    'email': 'البريد الإلكتروني',
    'phone': 'الهاتف',
    'username': 'اسم المستخدم',
    'email_hint': 'أدخل بريدك الإلكتروني',
    'phone_hint': 'أدخل رقم الهاتف',
    'username_hint': 'أدخل اسم المستخدم',
    'password_hint': 'كلمة المرور',
    'forgot_password': 'نسيت كلمة المرور؟',
    'log_in': 'تسجيل الدخول',
    'or_continue': 'أو تابع مع',
    'continue_google': 'متابعة مع Google',
    'create_account': 'إنشاء حساب جديد',
    'email_empty': 'الرجاء إدخال بريدك الإلكتروني',
    'email_invalid': 'أدخل بريدًا إلكترونيًا صالحًا',
    'phone_empty': 'الرجاء إدخال رقم هاتفك',
    'phone_invalid': 'أدخل رقم هاتف صالحًا (7-15 رقمًا)',
    'username_empty': 'الرجاء إدخال اسم المستخدم',
    'username_invalid': 'اسم المستخدم يجب أن يكون 3 أحرف على الأقل',
    'password_empty': 'الرجاء إدخال كلمة المرور',
    'password_short': 'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
    'login_success': 'تم تسجيل الدخول بنجاح',
  },
  'ES': {
    'email': 'Correo',
    'phone': 'Teléfono',
    'username': 'Usuario',
    'email_hint': 'Ingresa tu correo',
    'phone_hint': 'Ingresa tu número de teléfono',
    'username_hint': 'Ingresa tu nombre de usuario',
    'password_hint': 'Contraseña',
    'forgot_password': '¿Olvidaste tu contraseña?',
    'log_in': 'Iniciar sesión',
    'or_continue': 'o continuar con',
    'continue_google': 'Continuar con Google',
    'create_account': 'Crear nueva cuenta',
    'email_empty': 'Por favor ingresa tu correo',
    'email_invalid': 'Ingresa un correo válido',
    'phone_empty': 'Por favor ingresa tu número de teléfono',
    'phone_invalid': 'Ingresa un número de teléfono válido (7-15 dígitos)',
    'username_empty': 'Por favor ingresa tu nombre de usuario',
    'username_invalid': 'El nombre de usuario debe tener al menos 3 caracteres',
    'password_empty': 'Por favor ingresa tu contraseña',
    'password_short': 'La contraseña debe tener al menos 6 caracteres',
    'login_success': 'Inicio de sesión exitoso',
  },
  'FR': {
    'email': 'E-mail',
    'phone': 'Téléphone',
    'username': "Nom d'utilisateur",
    'email_hint': 'Entrez votre e-mail',
    'phone_hint': 'Entrez votre numéro de téléphone',
    'username_hint': "Entrez votre nom d'utilisateur",
    'password_hint': 'Mot de passe',
    'forgot_password': 'Mot de passe oublié ?',
    'log_in': 'Se connecter',
    'or_continue': 'ou continuer avec',
    'continue_google': 'Continuer avec Google',
    'create_account': 'Créer un nouveau compte',
    'email_empty': 'Veuillez entrer votre e-mail',
    'email_invalid': 'Entrez une adresse e-mail valide',
    'phone_empty': 'Veuillez entrer votre numéro de téléphone',
    'phone_invalid': 'Entrez un numéro de téléphone valide (7-15 chiffres)',
    'username_empty': "Veuillez entrer votre nom d'utilisateur",
    'username_invalid': "Le nom d'utilisateur doit comporter au moins 3 caractères",
    'password_empty': 'Veuillez entrer votre mot de passe',
    'password_short': 'Le mot de passe doit comporter au moins 6 caractères',
    'login_success': 'Connexion réussie',
  },
  'HI': {
    'email': 'ईमेल',
    'phone': 'फ़ोन',
    'username': 'उपयोगकर्ता नाम',
    'email_hint': 'अपना ईमेल दर्ज करें',
    'phone_hint': 'फ़ोन नंबर दर्ज करें',
    'username_hint': 'उपयोगकर्ता नाम दर्ज करें',
    'password_hint': 'पासवर्ड',
    'forgot_password': 'पासवर्ड भूल गए?',
    'log_in': 'लॉग इन',
    'or_continue': 'या जारी रखें',
    'continue_google': 'Google से जारी रखें',
    'create_account': 'नया खाता बनाएं',
    'email_empty': 'कृपया अपना ईमेल दर्ज करें',
    'email_invalid': 'एक वैध ईमेल पता दर्ज करें',
    'phone_empty': 'कृपया अपना फ़ोन नंबर दर्ज करें',
    'phone_invalid': 'एक वैध फ़ोन नंबर दर्ज करें (7-15 अंक)',
    'username_empty': 'कृपया अपना उपयोगकर्ता नाम दर्ज करें',
    'username_invalid': 'उपयोगकर्ता नाम कम से कम 3 अक्षर का होना चाहिए',
    'password_empty': 'कृपया अपना पासवर्ड दर्ज करें',
    'password_short': 'पासवर्ड कम से कम 6 अक्षर का होना चाहिए',
    'login_success': 'लॉगिन सफल हुआ',
  },
  'PT': {
    'email': 'E-mail',
    'phone': 'Telefone',
    'username': 'Usuário',
    'email_hint': 'Digite seu e-mail',
    'phone_hint': 'Digite seu número de telefone',
    'username_hint': 'Digite seu nome de usuário',
    'password_hint': 'Senha',
    'forgot_password': 'Esqueceu a senha?',
    'log_in': 'Entrar',
    'or_continue': 'ou continuar com',
    'continue_google': 'Continuar com Google',
    'create_account': 'Criar nova conta',
    'email_empty': 'Por favor, digite seu e-mail',
    'email_invalid': 'Digite um e-mail válido',
    'phone_empty': 'Por favor, digite seu número de telefone',
    'phone_invalid': 'Digite um número de telefone válido (7-15 dígitos)',
    'username_empty': 'Por favor, digite seu nome de usuário',
    'username_invalid': 'O nome de usuário deve ter pelo menos 3 caracteres',
    'password_empty': 'Por favor, digite sua senha',
    'password_short': 'A senha deve ter pelo menos 6 caracteres',
    'login_success': 'Login bem-sucedido',
  },
  'ZH': {
    'email': '电子邮件',
    'phone': '电话',
    'username': '用户名',
    'email_hint': '输入您的电子邮件',
    'phone_hint': '输入您的电话号码',
    'username_hint': '输入您的用户名',
    'password_hint': '密码',
    'forgot_password': '忘记密码？',
    'log_in': '登录',
    'or_continue': '或继续使用',
    'continue_google': '继续使用Google',
    'create_account': '创建新账户',
    'email_empty': '请输入您的电子邮件',
    'email_invalid': '请输入有效的电子邮件地址',
    'phone_empty': '请输入您的电话号码',
    'phone_invalid': '请输入有效的电话号码（7-15位）',
    'username_empty': '请输入您的用户名',
    'username_invalid': '用户名必须至少3个字符',
    'password_empty': '请输入您的密码',
    'password_short': '密码必须至少6个字符',
    'login_success': '登录成功',
  },
  'JA': {
    'email': 'メール',
    'phone': '電話',
    'username': 'ユーザー名',
    'email_hint': 'メールアドレスを入力してください',
    'phone_hint': '電話番号を入力してください',
    'username_hint': 'ユーザー名を入力してください',
    'password_hint': 'パスワード',
    'forgot_password': 'パスワードをお忘れですか？',
    'log_in': 'ログイン',
    'or_continue': 'または続ける',
    'continue_google': 'Googleで続ける',
    'create_account': '新しいアカウントを作成',
    'email_empty': 'メールアドレスを入力してください',
    'email_invalid': '有効なメールアドレスを入力してください',
    'phone_empty': '電話番号を入力してください',
    'phone_invalid': '有効な電話番号を入力してください（7〜15桁）',
    'username_empty': 'ユーザー名を入力してください',
    'username_invalid': 'ユーザー名は3文字以上である必要があります',
    'password_empty': 'パスワードを入力してください',
    'password_short': 'パスワードは6文字以上である必要があります',
    'login_success': 'ログイン成功',
  },
};

enum LoginMethod { email, phone, username }

class LoginScreen extends StatefulWidget {
  final String languageName;
  final String languageCode;

  const LoginScreen({
    super.key,
    required this.languageName,
    required this.languageCode,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String _identifierError = '';
  String _passwordError = '';

  LoginMethod _selectedMethod = LoginMethod.email;

  static const Color primaryBrown = Color(0xFF9d4d36);
  static const Color lightBg = Color(0xFFF7F9FC);
  static const Color inputBg = Color(0xFFEEEFF4);

  String t(String key) {
    final code = widget.languageCode.toUpperCase();
    return _translations[code]?[key] ?? _translations['EN']![key]!;
  }

  bool get isRTL => widget.languageCode.toUpperCase() == 'AR';

  // Build user data from identifier (demo only)
  Map<String, String> _buildUserData(String identifier) {
    switch (_selectedMethod) {
      case LoginMethod.email:
        final email = identifier;
        final username = email.split('@').first;
        final fullName = username;
        return {'fullName': fullName, 'username': username, 'email': email};
      case LoginMethod.phone:
        final phone = identifier;
        final username = phone;
        final fullName = 'User';
        final email = '$phone@phone.local';
        return {'fullName': fullName, 'username': username, 'email': email};
      case LoginMethod.username:
        final username = identifier;
        final fullName = username;
        final email = '$username@username.local';
        return {'fullName': fullName, 'username': username, 'email': email};
    }
  }

  // New animated success message with better design
  void _showTopSuccessMessage() {
    final overlay = Overlay.of(context);

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 70,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: scale.clamp(0.0, 1.0),
                  child: child,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(
                  color: primaryBrown.withOpacity(0.15),
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryBrown.withOpacity(0.12),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: primaryBrown,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      t('login_success'),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  void _validateAndLogin() async {
    setState(() {
      _identifierError = '';
      _passwordError = '';
    });

    final identifier = _identifierController.text.trim();
    final password = _passwordController.text;
    bool hasError = false;

    // Validation (same as before)
    switch (_selectedMethod) {
      case LoginMethod.email:
        if (identifier.isEmpty) {
          setState(() => _identifierError = t('email_empty'));
          hasError = true;
        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(identifier)) {
          setState(() => _identifierError = t('email_invalid'));
          hasError = true;
        }
        break;
      case LoginMethod.phone:
        if (identifier.isEmpty) {
          setState(() => _identifierError = t('phone_empty'));
          hasError = true;
        } else if (!RegExp(r'^\d{7,15}$').hasMatch(identifier)) {
          setState(() => _identifierError = t('phone_invalid'));
          hasError = true;
        }
        break;
      case LoginMethod.username:
        if (identifier.isEmpty) {
          setState(() => _identifierError = t('username_empty'));
          hasError = true;
        } else if (identifier.length < 3) {
          setState(() => _identifierError = t('username_invalid'));
          hasError = true;
        }
        break;
    }

    if (password.isEmpty) {
      setState(() => _passwordError = t('password_empty'));
      hasError = true;
    } else if (password.length < 6) {
      setState(() => _passwordError = t('password_short'));
      hasError = true;
    }

    if (hasError) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2)); // simulate auth

    if (!mounted) return;
    setState(() => _isLoading = false);

    _showTopSuccessMessage();

    final userData = _buildUserData(identifier);

    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => TransitionScreen(
          languageCode: widget.languageCode,
          languageName: widget.languageName,
          fullName: userData['fullName']!,
          username: userData['username']!,
          email: userData['email']!,
        ),
      ),
    );
  }

  // ─────────────── UI Getters ───────────────
  String get _identifierHint {
    switch (_selectedMethod) {
      case LoginMethod.email:
        return t('email_hint');
      case LoginMethod.phone:
        return t('phone_hint');
      case LoginMethod.username:
        return t('username_hint');
    }
  }

  TextInputType get _keyboardType {
    switch (_selectedMethod) {
      case LoginMethod.email:
        return TextInputType.emailAddress;
      case LoginMethod.phone:
        return TextInputType.phone;
      case LoginMethod.username:
        return TextInputType.text;
    }
  }

  IconData get _prefixIcon {
    switch (_selectedMethod) {
      case LoginMethod.email:
        return Icons.mail_outline;
      case LoginMethod.phone:
        return Icons.phone_outlined;
      case LoginMethod.username:
        return Icons.person_outline;
    }
  }

  // ─────────────── UI Building ───────────────
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Top bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: primaryBrown),
                      padding: EdgeInsets.zero,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: lightBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.language, size: 16, color: Colors.black87),
                            const SizedBox(width: 6),
                            Text(
                              widget.languageName,
                              style: const TextStyle(fontSize: 14, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // App name
                Center(
                  child: Text(
                    'Connect',
                    style: GoogleFonts.dancingScript(
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      color: primaryBrown,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Login method selector
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: lightBg,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      _buildMethodButton(LoginMethod.email, t('email')),
                      _buildMethodButton(LoginMethod.phone, t('phone')),
                      _buildMethodButton(LoginMethod.username, t('username')),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Identifier field
                _buildInputField(
                  controller: _identifierController,
                  hint: _identifierHint,
                  icon: _prefixIcon,
                  errorText: _identifierError,
                  keyboardType: _keyboardType,
                ),

                const SizedBox(height: 14),

                // Password field
                _buildPasswordField(),

                const SizedBox(height: 8),

                // Forgot password
                Align(
                  alignment: isRTL ? Alignment.centerLeft : Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ForgotPasswordScreen(
                            languageCode: widget.languageCode,
                            languageName: widget.languageName,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      t('forgot_password'),
                      style: const TextStyle(color: primaryBrown, fontSize: 14),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Log In button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _validateAndLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBrown,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      shadowColor: primaryBrown.withOpacity(0.4),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2.5),
                          )
                        : Text(
                            t('log_in'),
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 28),

                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider(color: Color(0xFFDDDDDD))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        t('or_continue'),
                        style: TextStyle(color: Colors.grey[500], fontSize: 13),
                      ),
                    ),
                    const Expanded(child: Divider(color: Color(0xFFDDDDDD))),
                  ],
                ),

                const SizedBox(height: 20),

                // Google button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: Google Sign-In
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFDDDDDD)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '🅶',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          t('continue_google'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Create account
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CreateAccountScreen(
                            languageCode: widget.languageCode,
                            languageName: widget.languageName,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      t('create_account'),
                      style: const TextStyle(
                        color: primaryBrown,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMethodButton(LoginMethod method, String label) {
    final isSelected = _selectedMethod == method;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedMethod = method;
            _identifierController.clear();
            _identifierError = '';
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? primaryBrown : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black54,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required String errorText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: inputBg, borderRadius: BorderRadius.circular(14)),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
              prefixIcon: Icon(icon, color: primaryBrown.withOpacity(0.7), size: 22),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            ),
          ),
        ),
        if (errorText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: Text(errorText,
                style: const TextStyle(color: Colors.red, fontSize: 12)),
          ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: inputBg, borderRadius: BorderRadius.circular(14)),
          child: TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              hintText: t('password_hint'),
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
              prefixIcon: Icon(Icons.lock_outline,
                  color: primaryBrown.withOpacity(0.7), size: 22),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey[400],
                  size: 22,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            ),
          ),
        ),
        if (_passwordError.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: Text(_passwordError,
                style: const TextStyle(color: Colors.red, fontSize: 12)),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}