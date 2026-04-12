import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '04_forgot_password_screen.dart';
import '05_create_account_screen.dart';

// ── Translations (updated with username hints) ───────────────────────────────
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
  },
  // ... (add similar translations for other languages: RU, AR, ES, FR, HI, PT, ZH, JA)
  // For brevity, I'm showing only EN and BN. You can extend the map with all languages.
  'RU': {
      'alreadyAccount': 'Уже есть аккаунт? Войти',
      'email': 'Email или номер телефона',
      'password': 'Пароль',
      'login': 'Войти',
      'forgotPassword': 'Забыли пароль?',
      'orWith': 'или продолжить с',
      'googleSignIn': 'Продолжить с Google',
      'passError': 'Пароль должен содержать не менее 5 символов!',
      'emailError': 'Введите email или телефон!',
      'newAccount': 'Создать новый аккаунт',
    },
    'AR': {
      'alreadyAccount': 'لديك حساب بالفعل؟ تسجيل الدخول',
      'email': 'البريد الإلكتروني أو رقم الهاتف',
      'password': 'كلمة المرور',
      'login': 'تسجيل الدخول',
      'forgotPassword': 'نسيت كلمة المرور؟',
      'orWith': 'أو تابع مع',
      'googleSignIn': 'تابع مع Google',
      'passError': 'كلمة المرور يجب أن تكون 5 أحرف على الأقل!',
      'emailError': 'أدخل بريدك الإلكتروني أو هاتفك!',
      'newAccount': 'إنشاء حساب جديد',
    },
    'ES': {
      'alreadyAccount': '¿Ya tienes cuenta? Inicia sesión',
      'email': 'Correo o número de teléfono',
      'password': 'Contraseña',
      'login': 'Iniciar sesión',
      'forgotPassword': '¿Olvidaste tu contraseña?',
      'orWith': 'o continuar con',
      'googleSignIn': 'Continuar con Google',
      'passError': '¡La contraseña debe tener al menos 5 caracteres!',
      'emailError': '¡Ingresa tu correo o teléfono!',
      'newAccount': 'Crear nueva cuenta',
    },
    'FR': {
      'alreadyAccount': 'Déjà un compte? Se connecter',
      'email': 'Email ou numéro de téléphone',
      'password': 'Mot de passe',
      'login': 'Se connecter',
      'forgotPassword': 'Mot de passe oublié?',
      'orWith': 'ou continuer avec',
      'googleSignIn': 'Continuer avec Google',
      'passError': 'Le mot de passe doit contenir au moins 5 caractères!',
      'emailError': 'Entrez votre email ou téléphone!',
      'newAccount': 'Créer un nouveau compte',
    },
    'HI': {
      'alreadyAccount': 'पहले से खाता है? साइन इन करें',
      'email': 'ईमेल या फोन नंबर',
      'password': 'पासवर्ड',
      'login': 'लॉग इन',
      'forgotPassword': 'पासवर्ड भूल गए?',
      'orWith': 'या जारी रखें',
      'googleSignIn': 'Google से जारी रखें',
      'passError': 'पासवर्ड कम से कम 5 अक्षर का होना चाहिए!',
      'emailError': 'अपना ईमेल या फोन नंबर दर्ज करें!',
      'newAccount': 'नया खाता बनाएं',
    },
    'PT': {
      'alreadyAccount': 'Já tem uma conta? Entrar',
      'email': 'Email ou número de telefone',
      'password': 'Senha',
      'login': 'Entrar',
      'forgotPassword': 'Esqueceu a senha?',
      'orWith': 'ou continuar com',
      'googleSignIn': 'Continuar com Google',
      'passError': 'A senha deve ter pelo menos 5 caracteres!',
      'emailError': 'Digite seu email ou telefone!',
      'newAccount': 'Criar nova conta',
    },
    'ZH': {
      'alreadyAccount': '已有账户？登录',
      'email': '电子邮件或电话号码',
      'password': '密码',
      'login': '登录',
      'forgotPassword': '忘记密码？',
      'orWith': '或继续使用',
      'googleSignIn': '使用Google继续',
      'passError': '密码至少需要5个字符！',
      'emailError': '请输入您的电子邮件或电话！',
      'newAccount': '创建新账户',
    },
    'JA': {
      'alreadyAccount': 'すでにアカウントをお持ちですか？サインイン',
      'email': 'メールまたは電話番号',
      'password': 'パスワード',
      'login': 'ログイン',
      'forgotPassword': 'パスワードをお忘れですか？',
      'orWith': 'または続ける',
      'googleSignIn': 'Googleで続ける',
      'passError': 'パスワードは5文字以上必要です！',
      'emailError': 'メールまたは電話番号を入力してください！',
      'newAccount': '新しいアカウントを作成',
    },
  };

// Enum for login method
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

  LoginMethod _selectedMethod = LoginMethod.email; // default to email

  static const Color primaryBrown = Color(0xFF9d4d36);
  static const Color lightBg = Color(0xFFF7F9FC);
  static const Color inputBg = Color(0xFFEEEFF4);

  String t(String key) {
    final code = widget.languageCode.toUpperCase();
    return _translations[code]?[key] ?? _translations['EN']![key]!;
  }

  bool get isRTL => widget.languageCode.toUpperCase() == 'AR';

  void _validateAndLogin() {
    setState(() {
      _identifierError = '';
      _passwordError = '';
    });

    final identifier = _identifierController.text.trim();
    final password = _passwordController.text;
    bool hasError = false;

    // Validate based on selected method
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

    if (!hasError) {
      setState(() => _isLoading = true);
      // TODO: Connect Firebase Auth here
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _isLoading = false);
      });
    }
  }

  // Helper to get hint text based on selected method
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

  // Helper to get keyboard type
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

  // Helper to get prefix icon
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

                // ── Top bar ────────────────────────────────────────
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: lightBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.language,
                                size: 16, color: Colors.black87),
                            const SizedBox(width: 6),
                            Text(
                              widget.languageName,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // ── App name ───────────────────────────────────────
                Center(
                  child: Text(
                    'Connect',
                    style: GoogleFonts.dancingScript(
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF9d4d36),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // ── Login Method Selector (Email / Phone / Username) ──
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

                // ── Identifier field (email/phone/username) ─────────
                _buildInputField(
                  controller: _identifierController,
                  hint: _identifierHint,
                  icon: _prefixIcon,
                  errorText: _identifierError,
                  keyboardType: _keyboardType,
                ),

                const SizedBox(height: 14),

                // ── Password field ─────────────────────────────────
                _buildPasswordField(),

                const SizedBox(height: 8),

                // ── Forgot password ────────────────────────────────
                Align(
                  alignment:
                      isRTL ? Alignment.centerLeft : Alignment.centerRight,
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
                      style: const TextStyle(
                          color: primaryBrown, fontSize: 14),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // ── Log In button ──────────────────────────────────
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

                // ── Divider ────────────────────────────────────────
                Row(
                  children: [
                    const Expanded(
                        child: Divider(color: Color(0xFFDDDDDD))),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        t('or_continue'),
                        style: TextStyle(
                            color: Colors.grey[500], fontSize: 13),
                      ),
                    ),
                    const Expanded(
                        child: Divider(color: Color(0xFFDDDDDD))),
                  ],
                ),

                const SizedBox(height: 20),

                // ── Google button ──────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: Google Sign-In with Firebase
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

                // ── Create account ─────────────────────────────────
                Center(
                  child: TextButton(
                    onPressed: () {
                      // TODO: Navigate to register screen
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
            _identifierController.clear(); // optional: clear field when switching
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
            textDirection:
                isRTL ? TextDirection.rtl : TextDirection.ltr,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle:
                  TextStyle(color: Colors.grey[500], fontSize: 15),
              prefixIcon: Icon(icon,
                  color: primaryBrown.withOpacity(0.7), size: 22),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 18, horizontal: 16),
            ),
          ),
        ),
        if (errorText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: Text(errorText,
                style:
                    const TextStyle(color: Colors.red, fontSize: 12)),
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
              hintStyle:
                  TextStyle(color: Colors.grey[500], fontSize: 15),
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
                onPressed: () => setState(
                    () => _obscurePassword = !_obscurePassword),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 18, horizontal: 16),
            ),
          ),
        ),
        if (_passwordError.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: Text(_passwordError,
                style:
                    const TextStyle(color: Colors.red, fontSize: 12)),
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