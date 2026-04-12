import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum ResetMethod { email, phone, username }
enum RecoveryStep {
  enterIdentifier,
  selectAccount,
  chooseDelivery,
  verifyCode,
  resetPassword,
  success,
}

class MockAccount {
  final String id;
  final String username;
  final String email;
  final String phone;
  final String profileImage;

  MockAccount({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    this.profileImage = '',
  });
}

class ForgotPasswordScreen extends StatefulWidget {
  final String languageCode;
  final String languageName;

  const ForgotPasswordScreen({
    super.key,
    required this.languageCode,
    required this.languageName,
  });

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  ResetMethod _selectedMethod = ResetMethod.email;
  RecoveryStep _currentStep = RecoveryStep.enterIdentifier;
  bool _isLoading = false;
  String _inputError = '';
  String _enteredIdentifier = '';
  String _selectedDelivery = 'email';
  MockAccount? _selectedAccount;
  List<MockAccount> _foundAccounts = [];
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  static const Color primaryBrown = Color(0xFF9d4d36);
  static const Color lightBg = Color(0xFFF7F9FC);
  static const Color inputBg = Color(0xFFEEEFF4);

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _searchController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String t(String key) {
    final code = widget.languageCode.toUpperCase();
    return (_fpTranslations[code] ?? _fpTranslations['EN']!)[key] ??
        _fpTranslations['EN']![key]!;
  }

  bool get isRTL => widget.languageCode.toUpperCase() == 'AR';

  String get _identifierHint {
    switch (_selectedMethod) {
      case ResetMethod.email:
        return t('input_hint_email');
      case ResetMethod.phone:
        return t('input_hint_phone');
      case ResetMethod.username:
        return t('input_hint_username');
    }
  }

  TextInputType get _keyboardType {
    switch (_selectedMethod) {
      case ResetMethod.email:
        return TextInputType.emailAddress;
      case ResetMethod.phone:
        return TextInputType.phone;
      case ResetMethod.username:
        return TextInputType.text;
    }
  }

  IconData get _prefixIcon {
    switch (_selectedMethod) {
      case ResetMethod.email:
        return Icons.mail_outline;
      case ResetMethod.phone:
        return Icons.phone_outlined;
      case ResetMethod.username:
        return Icons.person_outline;
    }
  }

  void _searchAccounts() {
    final query = _searchController.text.trim();
    setState(() => _inputError = '');

    if (query.isEmpty) {
      setState(() => _inputError = t('input_empty'));
      return;
    }

    bool valid = false;
    switch (_selectedMethod) {
      case ResetMethod.email:
        valid = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(query);
        if (!valid) {
          setState(() => _inputError = t('email_invalid'));
          return;
        }
        break;
      case ResetMethod.phone:
        valid = RegExp(r'^\+?\d{7,15}$').hasMatch(query);
        if (!valid) {
          setState(() => _inputError = t('phone_invalid'));
          return;
        }
        break;
      case ResetMethod.username:
        valid = query.length >= 3;
        if (!valid) {
          setState(() => _inputError = t('username_invalid'));
          return;
        }
        break;
    }

    setState(() => _isLoading = true);
    _enteredIdentifier = query;

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        if (_selectedMethod == ResetMethod.email) {
          if (query.contains('test')) {
            _foundAccounts = [
              MockAccount(
                id: '1',
                username: 'john_doe',
                email: query,
                phone: '+1234567890',
                profileImage: 'assets/avatar1.png',
              ),
              MockAccount(
                id: '2',
                username: 'john_doe_work',
                email: query,
                phone: '+1234567890',
                profileImage: 'assets/avatar2.png',
              ),
            ];
          } else {
            _foundAccounts = [
              MockAccount(
                id: '1',
                username: 'user_' + query.split('@')[0],
                email: query,
                phone: '+9876543210',
              ),
            ];
          }
        } else if (_selectedMethod == ResetMethod.phone) {
          _foundAccounts = [
            MockAccount(
              id: '1',
              username: 'phone_user',
              email: 'user@example.com',
              phone: query,
            ),
          ];
        } else {
          _foundAccounts = [
            MockAccount(
              id: '1',
              username: query,
              email: '$query@example.com',
              phone: '+1112223333',
            ),
          ];
        }
        _currentStep = RecoveryStep.selectAccount;
        _animController.reset();
        _animController.forward();
      });
    });
  }

  void _selectAccount(MockAccount account) {
    setState(() {
      _selectedAccount = account;
      _currentStep = RecoveryStep.chooseDelivery;
      _animController.reset();
      _animController.forward();
    });
  }

  void _sendVerificationCode() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _currentStep = RecoveryStep.verifyCode;
        _animController.reset();
        _animController.forward();
      });
    });
  }

  void _verifyCode() {
    final code = _codeController.text.trim();
    if (code.length != 6) {
      setState(() => _inputError = t('invalid_code'));
      return;
    }
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _currentStep = RecoveryStep.resetPassword;
        _inputError = '';
        _animController.reset();
        _animController.forward();
      });
    });
  }

  void _resetPassword() {
    final newPass = _newPasswordController.text;
    final confirm = _confirmPasswordController.text;
    setState(() => _inputError = '');
    if (newPass.isEmpty) {
      setState(() => _inputError = t('password_empty'));
      return;
    }
    if (newPass.length < 6) {
      setState(() => _inputError = t('password_short'));
      return;
    }
    if (newPass != confirm) {
      setState(() => _inputError = t('password_mismatch'));
      return;
    }

    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _currentStep = RecoveryStep.success;
        _animController.reset();
        _animController.forward();
      });
    });
  }

  void _goBack() {
    if (_currentStep == RecoveryStep.enterIdentifier) {
      Navigator.pop(context);
    } else if (_currentStep == RecoveryStep.selectAccount) {
      setState(() {
        _currentStep = RecoveryStep.enterIdentifier;
        _foundAccounts.clear();
        _selectedAccount = null;
      });
    } else if (_currentStep == RecoveryStep.chooseDelivery) {
      setState(() => _currentStep = RecoveryStep.selectAccount);
    } else if (_currentStep == RecoveryStep.verifyCode) {
      setState(() => _currentStep = RecoveryStep.chooseDelivery);
    } else if (_currentStep == RecoveryStep.resetPassword) {
      setState(() => _currentStep = RecoveryStep.verifyCode);
    } else {
      Navigator.pop(context);
    }
    _animController.reset();
    _animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: lightBg,
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildCurrentStep(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    String title;
    switch (_currentStep) {
      case RecoveryStep.enterIdentifier:
        title = t('page_title');
        break;
      case RecoveryStep.selectAccount:
        title = t('select_account_title');
        break;
      case RecoveryStep.chooseDelivery:
        title = t('choose_delivery_title');
        break;
      case RecoveryStep.verifyCode:
        title = t('verify_code_title');
        break;
      case RecoveryStep.resetPassword:
        title = t('reset_password_title');
        break;
      case RecoveryStep.success:
        title = t('success_title');
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: _goBack,
            icon: const Icon(Icons.arrow_back, color: primaryBrown),
          ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: primaryBrown),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case RecoveryStep.enterIdentifier:
        return _buildEnterIdentifier();
      case RecoveryStep.selectAccount:
        return _buildSelectAccount();
      case RecoveryStep.chooseDelivery:
        return _buildChooseDelivery();
      case RecoveryStep.verifyCode:
        return _buildVerifyCode();
      case RecoveryStep.resetPassword:
        return _buildResetPassword();
      case RecoveryStep.success:
        return _buildSuccess();
    }
  }

  Widget _buildEnterIdentifier() {
    return Column(
      children: [
        const SizedBox(height: 32),
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: primaryBrown.withOpacity(0.12), blurRadius: 40, spreadRadius: 8),
            ],
          ),
          child: const Center(
            child: Icon(Icons.manage_accounts_rounded, size: 64, color: primaryBrown),
          ),
        ),
        const SizedBox(height: 32),
        Text(
          t('find_title'),
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(fontSize: 26, fontWeight: FontWeight.w800, color: const Color(0xFF191c1e)),
        ),
        const SizedBox(height: 12),
        Text(
          t('find_subtitle'),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Colors.grey[600], height: 1.5),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: inputBg, borderRadius: BorderRadius.circular(30)),
          child: Row(
            children: [
              _buildMethodButton(ResetMethod.email, t('chip_email')),
              _buildMethodButton(ResetMethod.phone, t('chip_phone')),
              _buildMethodButton(ResetMethod.username, t('chip_username')),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(color: inputBg, borderRadius: BorderRadius.circular(16)),
          child: TextField(
            controller: _searchController,
            keyboardType: _keyboardType,
            onSubmitted: (_) => _searchAccounts(),
            decoration: InputDecoration(
              hintText: _identifierHint,
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
              prefixIcon: Icon(_prefixIcon, color: primaryBrown, size: 22),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            ),
          ),
        ),
        if (_inputError.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 6),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(_inputError, style: const TextStyle(color: Colors.red, fontSize: 12)),
            ),
          ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _searchAccounts,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBrown,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              elevation: 4,
              shadowColor: primaryBrown.withOpacity(0.4),
            ),
            child: _isLoading
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                : Text(t('search_btn'), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white)),
          ),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () => _showCantAccessDialog(),
          child: Text(t('cant_access'), style: const TextStyle(color: primaryBrown, fontSize: 14, fontWeight: FontWeight.w500)),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildMethodButton(ResetMethod method, String label) {
    final isSelected = _selectedMethod == method;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedMethod = method;
            _searchController.clear();
            _inputError = '';
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

  Widget _buildSelectAccount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          t('accounts_found') + ' (${_foundAccounts.length})',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          t('select_account_subtitle'),
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 20),
        ..._foundAccounts.map((account) => _buildAccountTile(account)),
        const SizedBox(height: 24),
        TextButton(
          onPressed: () {
            setState(() {
              _currentStep = RecoveryStep.enterIdentifier;
              _foundAccounts.clear();
            });
          },
          child: Text(t('not_my_account'), style: const TextStyle(color: primaryBrown)),
        ),
      ],
    );
  }

  Widget _buildAccountTile(MockAccount account) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: primaryBrown.withOpacity(0.1),
          child: Text(
            account.username.substring(0, 1).toUpperCase(),
            style: const TextStyle(color: primaryBrown, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        title: Text(account.username, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(account.email, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            if (account.phone.isNotEmpty)
              Text(account.phone, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
          ],
        ),
        trailing: const Icon(Icons.chevron_right, color: primaryBrown),
        onTap: () => _selectAccount(account),
      ),
    );
  }

  Widget _buildChooseDelivery() {
    final account = _selectedAccount!;
    final hasEmail = account.email.isNotEmpty;
    final hasPhone = account.phone.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          t('choose_delivery_subtitle'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          t('choose_delivery_desc') + ' ${account.username}',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 24),
        if (hasEmail)
          _buildDeliveryOption(
            icon: Icons.email_outlined,
            title: t('send_to_email'),
            subtitle: account.email,
            value: 'email',
          ),
        if (hasPhone)
          _buildDeliveryOption(
            icon: Icons.sms_outlined,
            title: t('send_to_phone'),
            subtitle: account.phone,
            value: 'phone',
          ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _sendVerificationCode,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBrown,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(t('send_code_btn'), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
  }) {
    final isSelected = _selectedDelivery == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedDelivery = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? primaryBrown : Colors.transparent, width: 2),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
        ),
        child: Row(
          children: [
            Icon(icon, color: primaryBrown, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: primaryBrown),
          ],
        ),
      ),
    );
  }

  Widget _buildVerifyCode() {
    final deliveryTarget = _selectedDelivery == 'email'
        ? _selectedAccount!.email
        : _selectedAccount!.phone;
    return Column(
      children: [
        const SizedBox(height: 32),
        Icon(Icons.security, size: 80, color: primaryBrown),
        const SizedBox(height: 24),
        Text(
          t('enter_code_title'),
          style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Text(
          '${t('code_sent_to')} $deliveryTarget',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Colors.grey[600]),
        ),
        const SizedBox(height: 32),
        TextField(
          controller: _codeController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, letterSpacing: 8, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: '------',
            hintStyle: TextStyle(color: Colors.grey[400], letterSpacing: 8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            filled: true,
            fillColor: inputBg,
            counterText: '',
          ),
        ),
        if (_inputError.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(_inputError, style: const TextStyle(color: Colors.red)),
          ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _verifyCode,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBrown,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(t('verify_btn'), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white)),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(t('didnt_receive'), style: TextStyle(color: Colors.grey[600])),
            TextButton(
              onPressed: _sendVerificationCode,
              child: Text(t('resend_code'), style: const TextStyle(color: primaryBrown, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResetPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Text(
          t('create_new_password'),
          style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          t('password_requirements'),
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(color: inputBg, borderRadius: BorderRadius.circular(16)),
          child: TextField(
            controller: _newPasswordController,
            obscureText: _obscureNewPassword,
            decoration: InputDecoration(
              hintText: t('new_password_hint'),
              prefixIcon: Icon(Icons.lock_outline, color: primaryBrown),
              suffixIcon: IconButton(
                icon: Icon(_obscureNewPassword ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(color: inputBg, borderRadius: BorderRadius.circular(16)),
          child: TextField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            decoration: InputDecoration(
              hintText: t('confirm_password_hint'),
              prefixIcon: Icon(Icons.lock_outline, color: primaryBrown),
              suffixIcon: IconButton(
                icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            ),
          ),
        ),
        if (_inputError.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 8),
            child: Text(_inputError, style: const TextStyle(color: Colors.red)),
          ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _resetPassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBrown,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(t('reset_password_btn'), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccess() {
    return Column(
      children: [
        const SizedBox(height: 60),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green.withOpacity(0.1),
          ),
          child: const Icon(Icons.check_circle, size: 80, color: Colors.green),
        ),
        const SizedBox(height: 32),
        Text(
          t('password_changed'),
          style: GoogleFonts.plusJakartaSans(fontSize: 26, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        Text(
          t('password_changed_desc'),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 48),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBrown,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
            ),
            child: Text(t('back_to_login'), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white)),
          ),
        ),
      ],
    );
  }

  void _showCantAccessDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t('cant_access_title'), style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(t('cant_access_body'), style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: primaryBrown, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999))),
                child: Text(t('got_it'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── COMPLETE TRANSLATIONS (11 LANGUAGES) ─────────────────────────────────────
const Map<String, Map<String, String>> _fpTranslations = {
  'EN': {
    'page_title': 'Account Recovery',
    'find_title': 'Find Your Account',
    'find_subtitle': 'Enter your email, phone, or username.',
    'input_hint_email': 'Enter your email',
    'input_hint_phone': 'Enter your phone number',
    'input_hint_username': 'Enter your username',
    'chip_email': 'Email',
    'chip_phone': 'Phone',
    'chip_username': 'Username',
    'search_btn': 'Continue',
    'cant_access': "Can't access your email or phone?",
    'cant_access_title': 'Need more help?',
    'cant_access_body': 'If you can\'t access your email or phone, please contact our support team.',
    'got_it': 'Got it',
    'input_empty': 'Please enter your information',
    'email_invalid': 'Enter a valid email address',
    'phone_invalid': 'Enter a valid phone number (7-15 digits)',
    'username_invalid': 'Username must be at least 3 characters',
    'select_account_title': 'Select Account',
    'accounts_found': 'Accounts found',
    'select_account_subtitle': 'Choose the account you want to recover',
    'not_my_account': 'Not my account? Search again',
    'choose_delivery_title': 'Verify Identity',
    'choose_delivery_subtitle': 'Where should we send the code?',
    'choose_delivery_desc': 'Select a delivery method for',
    'send_to_email': 'Send to Email',
    'send_to_phone': 'Send to Phone',
    'send_code_btn': 'Send Code',
    'verify_code_title': 'Enter Code',
    'enter_code_title': 'Verification Code',
    'code_sent_to': 'We sent a 6-digit code to',
    'verify_btn': 'Verify',
    'didnt_receive': "Didn't receive code?",
    'resend_code': 'Resend',
    'invalid_code': 'Please enter a valid 6-digit code',
    'reset_password_title': 'Reset Password',
    'create_new_password': 'Create new password',
    'password_requirements': 'Your password must be at least 6 characters.',
    'new_password_hint': 'New password',
    'confirm_password_hint': 'Confirm new password',
    'password_empty': 'Password cannot be empty',
    'password_short': 'Password must be at least 6 characters',
    'password_mismatch': 'Passwords do not match',
    'reset_password_btn': 'Reset Password',
    'success_title': 'Success!',
    'password_changed': 'Password Changed',
    'password_changed_desc': 'Your password has been changed successfully.',
    'back_to_login': 'Back to Log In',
  },
  'BN': {
    'page_title': 'অ্যাকাউন্ট রিকভারি',
    'find_title': 'আপনার অ্যাকাউন্ট খুঁজুন',
    'find_subtitle': 'আপনার ইমেইল, ফোন বা ইউজারনেম দিন।',
    'input_hint_email': 'আপনার ইমেইল লিখুন',
    'input_hint_phone': 'আপনার ফোন নম্বর লিখুন',
    'input_hint_username': 'আপনার ইউজারনেম লিখুন',
    'chip_email': 'ইমেইল',
    'chip_phone': 'ফোন',
    'chip_username': 'ইউজারনেম',
    'search_btn': 'চালিয়ে যান',
    'cant_access': 'ইমেইল বা ফোনে প্রবেশ করতে পারছেন না?',
    'cant_access_title': 'আরও সাহায্য দরকার?',
    'cant_access_body': 'আপনি যদি ইমেইল বা ফোনে প্রবেশ করতে না পারেন, আমাদের সাপোর্ট টিমে যোগাযোগ করুন।',
    'got_it': 'বুঝলাম',
    'input_empty': 'আপনার তথ্য দিন',
    'email_invalid': 'সঠিক ইমেইল দিন',
    'phone_invalid': 'সঠিক ফোন নম্বর দিন (৭-১৫ সংখ্যা)',
    'username_invalid': 'ইউজারনেম কমপক্ষে ৩ অক্ষরের হতে হবে',
    'select_account_title': 'অ্যাকাউন্ট নির্বাচন করুন',
    'accounts_found': 'অ্যাকাউন্ট পাওয়া গেছে',
    'select_account_subtitle': 'আপনি যে অ্যাকাউন্টটি পুনরুদ্ধার করতে চান তা বেছে নিন',
    'not_my_account': 'আমার অ্যাকাউন্ট নয়? আবার খুঁজুন',
    'choose_delivery_title': 'পরিচয় যাচাই',
    'choose_delivery_subtitle': 'কোডটি কোথায় পাঠাবো?',
    'choose_delivery_desc': 'এর জন্য ডেলিভারি পদ্ধতি নির্বাচন করুন',
    'send_to_email': 'ইমেইলে পাঠান',
    'send_to_phone': 'ফোনে পাঠান',
    'send_code_btn': 'কোড পাঠান',
    'verify_code_title': 'কোড লিখুন',
    'enter_code_title': 'ভেরিফিকেশন কোড',
    'code_sent_to': 'আমরা একটি ৬ সংখ্যার কোড পাঠিয়েছি',
    'verify_btn': 'যাচাই করুন',
    'didnt_receive': 'কোড পাননি?',
    'resend_code': 'আবার পাঠান',
    'invalid_code': 'সঠিক ৬ সংখ্যার কোড লিখুন',
    'reset_password_title': 'পাসওয়ার্ড রিসেট',
    'create_new_password': 'নতুন পাসওয়ার্ড তৈরি করুন',
    'password_requirements': 'আপনার পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে।',
    'new_password_hint': 'নতুন পাসওয়ার্ড',
    'confirm_password_hint': 'নতুন পাসওয়ার্ড নিশ্চিত করুন',
    'password_empty': 'পাসওয়ার্ড খালি রাখা যাবে না',
    'password_short': 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে',
    'password_mismatch': 'পাসওয়ার্ড মিলছে না',
    'reset_password_btn': 'পাসওয়ার্ড রিসেট করুন',
    'success_title': 'সফল!',
    'password_changed': 'পাসওয়ার্ড পরিবর্তন হয়েছে',
    'password_changed_desc': 'আপনার পাসওয়ার্ড সফলভাবে পরিবর্তন করা হয়েছে।',
    'back_to_login': 'লগইনে ফিরে যান',
  },
  'RU': {
    'page_title': 'Восстановление аккаунта',
    'find_title': 'Найти аккаунт',
    'find_subtitle': 'Введите email, телефон или имя пользователя.',
    'input_hint_email': 'Введите эл. почту',
    'input_hint_phone': 'Введите номер телефона',
    'input_hint_username': 'Введите имя пользователя',
    'chip_email': 'Почта',
    'chip_phone': 'Телефон',
    'chip_username': 'Имя',
    'search_btn': 'Продолжить',
    'cant_access': 'Нет доступа к почте или телефону?',
    'cant_access_title': 'Нужна помощь?',
    'cant_access_body': 'Если у вас нет доступа, обратитесь в службу поддержки.',
    'got_it': 'Понятно',
    'input_empty': 'Введите данные',
    'email_invalid': 'Некорректный email',
    'phone_invalid': 'Некорректный номер (7-15 цифр)',
    'username_invalid': 'Имя должно быть не менее 3 символов',
    'select_account_title': 'Выберите аккаунт',
    'accounts_found': 'Найдено аккаунтов',
    'select_account_subtitle': 'Выберите аккаунт для восстановления',
    'not_my_account': 'Не мой аккаунт? Искать снова',
    'choose_delivery_title': 'Подтверждение',
    'choose_delivery_subtitle': 'Куда отправить код?',
    'choose_delivery_desc': 'Выберите способ получения кода для',
    'send_to_email': 'На Email',
    'send_to_phone': 'На телефон',
    'send_code_btn': 'Отправить код',
    'verify_code_title': 'Введите код',
    'enter_code_title': 'Код подтверждения',
    'code_sent_to': 'Мы отправили 6-значный код на',
    'verify_btn': 'Подтвердить',
    'didnt_receive': 'Не получили код?',
    'resend_code': 'Отправить снова',
    'invalid_code': 'Введите корректный 6-значный код',
    'reset_password_title': 'Сброс пароля',
    'create_new_password': 'Придумайте новый пароль',
    'password_requirements': 'Пароль должен содержать не менее 6 символов.',
    'new_password_hint': 'Новый пароль',
    'confirm_password_hint': 'Подтвердите пароль',
    'password_empty': 'Пароль не может быть пустым',
    'password_short': 'Пароль должен быть не менее 6 символов',
    'password_mismatch': 'Пароли не совпадают',
    'reset_password_btn': 'Сбросить пароль',
    'success_title': 'Успешно!',
    'password_changed': 'Пароль изменён',
    'password_changed_desc': 'Ваш пароль успешно изменён.',
    'back_to_login': 'Вернуться ко входу',
  },
  'AR': {
    'page_title': 'استرداد الحساب',
    'find_title': 'ابحث عن حسابك',
    'find_subtitle': 'أدخل بريدك الإلكتروني أو رقم الهاتف أو اسم المستخدم.',
    'input_hint_email': 'أدخل بريدك الإلكتروني',
    'input_hint_phone': 'أدخل رقم الهاتف',
    'input_hint_username': 'أدخل اسم المستخدم',
    'chip_email': 'البريد',
    'chip_phone': 'الهاتف',
    'chip_username': 'اسم المستخدم',
    'search_btn': 'متابعة',
    'cant_access': 'لا يمكنك الوصول إلى بريدك أو هاتفك؟',
    'cant_access_title': 'تحتاج مساعدة؟',
    'cant_access_body': 'إذا لم تتمكن من الوصول، يرجى التواصل مع فريق الدعم.',
    'got_it': 'حسنًا',
    'input_empty': 'أدخل معلوماتك',
    'email_invalid': 'بريد إلكتروني غير صالح',
    'phone_invalid': 'رقم هاتف غير صالح (7-15 رقمًا)',
    'username_invalid': 'اسم المستخدم يجب أن يكون 3 أحرف على الأقل',
    'select_account_title': 'اختر الحساب',
    'accounts_found': 'تم العثور على حسابات',
    'select_account_subtitle': 'اختر الحساب الذي تريد استرداده',
    'not_my_account': 'ليس حسابي؟ ابحث مرة أخرى',
    'choose_delivery_title': 'التحقق من الهوية',
    'choose_delivery_subtitle': 'أين نرسل الرمز؟',
    'choose_delivery_desc': 'اختر طريقة الاستلام لـ',
    'send_to_email': 'إرسال إلى البريد',
    'send_to_phone': 'إرسال إلى الهاتف',
    'send_code_btn': 'إرسال الرمز',
    'verify_code_title': 'أدخل الرمز',
    'enter_code_title': 'رمز التحقق',
    'code_sent_to': 'أرسلنا رمزًا مكونًا من 6 أرقام إلى',
    'verify_btn': 'تحقق',
    'didnt_receive': 'لم تستلم الرمز؟',
    'resend_code': 'إعادة الإرسال',
    'invalid_code': 'أدخل رمزًا صحيحًا مكونًا من 6 أرقام',
    'reset_password_title': 'إعادة تعيين كلمة المرور',
    'create_new_password': 'أنشئ كلمة مرور جديدة',
    'password_requirements': 'يجب أن تحتوي كلمة المرور على 6 أحرف على الأقل.',
    'new_password_hint': 'كلمة المرور الجديدة',
    'confirm_password_hint': 'تأكيد كلمة المرور الجديدة',
    'password_empty': 'لا يمكن ترك كلمة المرور فارغة',
    'password_short': 'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
    'password_mismatch': 'كلمات المرور غير متطابقة',
    'reset_password_btn': 'إعادة تعيين كلمة المرور',
    'success_title': 'تم بنجاح!',
    'password_changed': 'تم تغيير كلمة المرور',
    'password_changed_desc': 'تم تغيير كلمة المرور الخاصة بك بنجاح.',
    'back_to_login': 'العودة لتسجيل الدخول',
  },
  'ES': {
    'page_title': 'Recuperar cuenta',
    'find_title': 'Encuentra tu cuenta',
    'find_subtitle': 'Ingresa tu correo, teléfono o nombre de usuario.',
    'input_hint_email': 'Ingresa tu correo',
    'input_hint_phone': 'Ingresa tu teléfono',
    'input_hint_username': 'Ingresa tu usuario',
    'chip_email': 'Correo',
    'chip_phone': 'Teléfono',
    'chip_username': 'Usuario',
    'search_btn': 'Continuar',
    'cant_access': '¿No puedes acceder a tu correo o teléfono?',
    'cant_access_title': '¿Necesitas ayuda?',
    'cant_access_body': 'Si no puedes acceder, contacta a soporte.',
    'got_it': 'Entendido',
    'input_empty': 'Ingresa tu información',
    'email_invalid': 'Correo inválido',
    'phone_invalid': 'Teléfono inválido (7-15 dígitos)',
    'username_invalid': 'El usuario debe tener al menos 3 caracteres',
    'select_account_title': 'Selecciona cuenta',
    'accounts_found': 'Cuentas encontradas',
    'select_account_subtitle': 'Elige la cuenta que deseas recuperar',
    'not_my_account': '¿No es mi cuenta? Buscar de nuevo',
    'choose_delivery_title': 'Verificar identidad',
    'choose_delivery_subtitle': '¿Dónde enviamos el código?',
    'choose_delivery_desc': 'Selecciona un método para',
    'send_to_email': 'Enviar al correo',
    'send_to_phone': 'Enviar al teléfono',
    'send_code_btn': 'Enviar código',
    'verify_code_title': 'Ingresa el código',
    'enter_code_title': 'Código de verificación',
    'code_sent_to': 'Enviamos un código de 6 dígitos a',
    'verify_btn': 'Verificar',
    'didnt_receive': '¿No recibiste el código?',
    'resend_code': 'Reenviar',
    'invalid_code': 'Ingresa un código válido de 6 dígitos',
    'reset_password_title': 'Restablecer contraseña',
    'create_new_password': 'Crea una nueva contraseña',
    'password_requirements': 'La contraseña debe tener al menos 6 caracteres.',
    'new_password_hint': 'Nueva contraseña',
    'confirm_password_hint': 'Confirma la nueva contraseña',
    'password_empty': 'La contraseña no puede estar vacía',
    'password_short': 'La contraseña debe tener al menos 6 caracteres',
    'password_mismatch': 'Las contraseñas no coinciden',
    'reset_password_btn': 'Restablecer contraseña',
    'success_title': '¡Éxito!',
    'password_changed': 'Contraseña cambiada',
    'password_changed_desc': 'Tu contraseña ha sido cambiada exitosamente.',
    'back_to_login': 'Volver a iniciar sesión',
  },
  'FR': {
    'page_title': 'Récupération de compte',
    'find_title': 'Trouvez votre compte',
    'find_subtitle': 'Entrez votre e-mail, téléphone ou nom d\'utilisateur.',
    'input_hint_email': 'Entrez votre e-mail',
    'input_hint_phone': 'Entrez votre téléphone',
    'input_hint_username': 'Entrez votre nom d\'utilisateur',
    'chip_email': 'E-mail',
    'chip_phone': 'Téléphone',
    'chip_username': 'Nom d\'utilisateur',
    'search_btn': 'Continuer',
    'cant_access': 'Vous ne pouvez pas accéder à votre e-mail ou téléphone ?',
    'cant_access_title': 'Besoin d\'aide ?',
    'cant_access_body': 'Si vous ne pouvez pas accéder, contactez le support.',
    'got_it': 'Compris',
    'input_empty': 'Entrez vos informations',
    'email_invalid': 'E-mail invalide',
    'phone_invalid': 'Numéro invalide (7-15 chiffres)',
    'username_invalid': 'Le nom doit contenir au moins 3 caractères',
    'select_account_title': 'Sélectionnez un compte',
    'accounts_found': 'Comptes trouvés',
    'select_account_subtitle': 'Choisissez le compte à récupérer',
    'not_my_account': 'Pas mon compte ? Rechercher à nouveau',
    'choose_delivery_title': 'Vérification',
    'choose_delivery_subtitle': 'Où envoyer le code ?',
    'choose_delivery_desc': 'Choisissez une méthode pour',
    'send_to_email': 'Envoyer par e-mail',
    'send_to_phone': 'Envoyer par téléphone',
    'send_code_btn': 'Envoyer le code',
    'verify_code_title': 'Saisir le code',
    'enter_code_title': 'Code de vérification',
    'code_sent_to': 'Nous avons envoyé un code à 6 chiffres à',
    'verify_btn': 'Vérifier',
    'didnt_receive': 'Code non reçu ?',
    'resend_code': 'Renvoyer',
    'invalid_code': 'Veuillez saisir un code à 6 chiffres valide',
    'reset_password_title': 'Réinitialiser le mot de passe',
    'create_new_password': 'Créez un nouveau mot de passe',
    'password_requirements': 'Le mot de passe doit contenir au moins 6 caractères.',
    'new_password_hint': 'Nouveau mot de passe',
    'confirm_password_hint': 'Confirmer le mot de passe',
    'password_empty': 'Le mot de passe ne peut pas être vide',
    'password_short': 'Le mot de passe doit contenir au moins 6 caractères',
    'password_mismatch': 'Les mots de passe ne correspondent pas',
    'reset_password_btn': 'Réinitialiser',
    'success_title': 'Succès !',
    'password_changed': 'Mot de passe modifié',
    'password_changed_desc': 'Votre mot de passe a été modifié avec succès.',
    'back_to_login': 'Retour à la connexion',
  },
  'HI': {
    'page_title': 'खाता पुनः प्राप्ति',
    'find_title': 'अपना खाता खोजें',
    'find_subtitle': 'अपना ईमेल, फ़ोन या यूज़रनेम दर्ज करें।',
    'input_hint_email': 'अपना ईमेल दर्ज करें',
    'input_hint_phone': 'फ़ोन नंबर दर्ज करें',
    'input_hint_username': 'यूज़रनेम दर्ज करें',
    'chip_email': 'ईमेल',
    'chip_phone': 'फ़ोन',
    'chip_username': 'यूज़रनेम',
    'search_btn': 'जारी रखें',
    'cant_access': 'ईमेल या फ़ोन तक पहुंच नहीं?',
    'cant_access_title': 'और सहायता चाहिए?',
    'cant_access_body': 'यदि पहुंच नहीं है, तो सपोर्ट से संपर्क करें।',
    'got_it': 'समझ गया',
    'input_empty': 'अपनी जानकारी दर्ज करें',
    'email_invalid': 'अमान्य ईमेल',
    'phone_invalid': 'अमान्य फ़ोन नंबर (7-15 अंक)',
    'username_invalid': 'यूज़रनेम कम से कम 3 अक्षर का होना चाहिए',
    'select_account_title': 'खाता चुनें',
    'accounts_found': 'खाते मिले',
    'select_account_subtitle': 'वह खाता चुनें जिसे आप पुनर्प्राप्त करना चाहते हैं',
    'not_my_account': 'मेरा खाता नहीं? फिर से खोजें',
    'choose_delivery_title': 'पहचान सत्यापित करें',
    'choose_delivery_subtitle': 'कोड कहाँ भेजें?',
    'choose_delivery_desc': 'के लिए डिलीवरी विधि चुनें',
    'send_to_email': 'ईमेल पर भेजें',
    'send_to_phone': 'फ़ोन पर भेजें',
    'send_code_btn': 'कोड भेजें',
    'verify_code_title': 'कोड दर्ज करें',
    'enter_code_title': 'सत्यापन कोड',
    'code_sent_to': 'हमने 6 अंकों का कोड भेजा है',
    'verify_btn': 'सत्यापित करें',
    'didnt_receive': 'कोड नहीं मिला?',
    'resend_code': 'पुनः भेजें',
    'invalid_code': 'कृपया एक मान्य 6-अंकीय कोड दर्ज करें',
    'reset_password_title': 'पासवर्ड रीसेट करें',
    'create_new_password': 'नया पासवर्ड बनाएं',
    'password_requirements': 'आपका पासवर्ड कम से कम 6 वर्णों का होना चाहिए।',
    'new_password_hint': 'नया पासवर्ड',
    'confirm_password_hint': 'नए पासवर्ड की पुष्टि करें',
    'password_empty': 'पासवर्ड खाली नहीं हो सकता',
    'password_short': 'पासवर्ड कम से कम 6 वर्णों का होना चाहिए',
    'password_mismatch': 'पासवर्ड मेल नहीं खाते',
    'reset_password_btn': 'पासवर्ड रीसेट करें',
    'success_title': 'सफल!',
    'password_changed': 'पासवर्ड बदल गया',
    'password_changed_desc': 'आपका पासवर्ड सफलतापूर्वक बदल दिया गया है।',
    'back_to_login': 'लॉग इन पर वापस जाएं',
  },
  'PT': {
    'page_title': 'Recuperar conta',
    'find_title': 'Encontre sua conta',
    'find_subtitle': 'Digite seu e-mail, telefone ou nome de usuário.',
    'input_hint_email': 'Digite seu e-mail',
    'input_hint_phone': 'Digite seu telefone',
    'input_hint_username': 'Digite seu usuário',
    'chip_email': 'E-mail',
    'chip_phone': 'Telefone',
    'chip_username': 'Usuário',
    'search_btn': 'Continuar',
    'cant_access': 'Não consegue acessar seu e-mail ou telefone?',
    'cant_access_title': 'Precisa de ajuda?',
    'cant_access_body': 'Se não conseguir acessar, entre em contato com o suporte.',
    'got_it': 'Entendi',
    'input_empty': 'Digite suas informações',
    'email_invalid': 'E-mail inválido',
    'phone_invalid': 'Telefone inválido (7-15 dígitos)',
    'username_invalid': 'Usuário deve ter pelo menos 3 caracteres',
    'select_account_title': 'Selecionar conta',
    'accounts_found': 'Contas encontradas',
    'select_account_subtitle': 'Escolha a conta que deseja recuperar',
    'not_my_account': 'Não é minha conta? Pesquisar novamente',
    'choose_delivery_title': 'Verificar identidade',
    'choose_delivery_subtitle': 'Para onde enviar o código?',
    'choose_delivery_desc': 'Selecione um método para',
    'send_to_email': 'Enviar para e-mail',
    'send_to_phone': 'Enviar para telefone',
    'send_code_btn': 'Enviar código',
    'verify_code_title': 'Digite o código',
    'enter_code_title': 'Código de verificação',
    'code_sent_to': 'Enviamos um código de 6 dígitos para',
    'verify_btn': 'Verificar',
    'didnt_receive': 'Não recebeu o código?',
    'resend_code': 'Reenviar',
    'invalid_code': 'Digite um código válido de 6 dígitos',
    'reset_password_title': 'Redefinir senha',
    'create_new_password': 'Crie uma nova senha',
    'password_requirements': 'A senha deve ter pelo menos 6 caracteres.',
    'new_password_hint': 'Nova senha',
    'confirm_password_hint': 'Confirmar nova senha',
    'password_empty': 'A senha não pode ficar vazia',
    'password_short': 'A senha deve ter pelo menos 6 caracteres',
    'password_mismatch': 'As senhas não coincidem',
    'reset_password_btn': 'Redefinir senha',
    'success_title': 'Sucesso!',
    'password_changed': 'Senha alterada',
    'password_changed_desc': 'Sua senha foi alterada com sucesso.',
    'back_to_login': 'Voltar para entrar',
  },
  'ZH': {
    'page_title': '账户恢复',
    'find_title': '查找您的账户',
    'find_subtitle': '输入您的电子邮件、手机号码或用户名。',
    'input_hint_email': '输入您的电子邮件',
    'input_hint_phone': '输入手机号码',
    'input_hint_username': '输入用户名',
    'chip_email': '邮件',
    'chip_phone': '手机',
    'chip_username': '用户名',
    'search_btn': '继续',
    'cant_access': '无法访问您的邮件或手机？',
    'cant_access_title': '需要更多帮助？',
    'cant_access_body': '如果您无法访问，请联系我们的支持团队。',
    'got_it': '明白了',
    'input_empty': '请输入您的信息',
    'email_invalid': '无效的电子邮件',
    'phone_invalid': '无效的手机号码 (7-15位)',
    'username_invalid': '用户名至少需要3个字符',
    'select_account_title': '选择账户',
    'accounts_found': '找到的账户',
    'select_account_subtitle': '选择您要恢复的账户',
    'not_my_account': '不是我的账户？重新搜索',
    'choose_delivery_title': '验证身份',
    'choose_delivery_subtitle': '将验证码发送到哪里？',
    'choose_delivery_desc': '选择接收方式',
    'send_to_email': '发送到邮箱',
    'send_to_phone': '发送到手机',
    'send_code_btn': '发送验证码',
    'verify_code_title': '输入验证码',
    'enter_code_title': '验证码',
    'code_sent_to': '我们已将6位验证码发送至',
    'verify_btn': '验证',
    'didnt_receive': '没有收到验证码？',
    'resend_code': '重新发送',
    'invalid_code': '请输入有效的6位验证码',
    'reset_password_title': '重置密码',
    'create_new_password': '创建新密码',
    'password_requirements': '密码至少需要6个字符。',
    'new_password_hint': '新密码',
    'confirm_password_hint': '确认新密码',
    'password_empty': '密码不能为空',
    'password_short': '密码至少需要6个字符',
    'password_mismatch': '密码不匹配',
    'reset_password_btn': '重置密码',
    'success_title': '成功！',
    'password_changed': '密码已更改',
    'password_changed_desc': '您的密码已成功更改。',
    'back_to_login': '返回登录',
  },
  'JA': {
    'page_title': 'アカウント回復',
    'find_title': 'アカウントを探す',
    'find_subtitle': 'メールアドレス、電話番号、またはユーザー名を入力してください。',
    'input_hint_email': 'メールアドレスを入力',
    'input_hint_phone': '電話番号を入力',
    'input_hint_username': 'ユーザー名を入力',
    'chip_email': 'メール',
    'chip_phone': '電話',
    'chip_username': 'ユーザー名',
    'search_btn': '続ける',
    'cant_access': 'メールや電話にアクセスできませんか？',
    'cant_access_title': 'さらにサポートが必要ですか？',
    'cant_access_body': 'アクセスできない場合は、サポートチームにお問い合わせください。',
    'got_it': 'わかりました',
    'input_empty': '情報を入力してください',
    'email_invalid': '無効なメールアドレス',
    'phone_invalid': '無効な電話番号 (7-15桁)',
    'username_invalid': 'ユーザー名は3文字以上必要です',
    'select_account_title': 'アカウントを選択',
    'accounts_found': '見つかったアカウント',
    'select_account_subtitle': '回復するアカウントを選択してください',
    'not_my_account': 'アカウントが違いますか？再検索',
    'choose_delivery_title': '本人確認',
    'choose_delivery_subtitle': 'コードの送信先を選択',
    'choose_delivery_desc': 'の受信方法を選択',
    'send_to_email': 'メールで送信',
    'send_to_phone': '電話で送信',
    'send_code_btn': 'コードを送信',
    'verify_code_title': 'コードを入力',
    'enter_code_title': '確認コード',
    'code_sent_to': '6桁のコードを送信しました',
    'verify_btn': '確認',
    'didnt_receive': 'コードが届きませんか？',
    'resend_code': '再送信',
    'invalid_code': '有効な6桁のコードを入力してください',
    'reset_password_title': 'パスワードをリセット',
    'create_new_password': '新しいパスワードを作成',
    'password_requirements': 'パスワードは6文字以上必要です。',
    'new_password_hint': '新しいパスワード',
    'confirm_password_hint': '新しいパスワードを確認',
    'password_empty': 'パスワードを入力してください',
    'password_short': 'パスワードは6文字以上必要です',
    'password_mismatch': 'パスワードが一致しません',
    'reset_password_btn': 'パスワードをリセット',
    'success_title': '成功！',
    'password_changed': 'パスワードが変更されました',
    'password_changed_desc': 'パスワードが正常に変更されました。',
    'back_to_login': 'ログインに戻る',
  },
};