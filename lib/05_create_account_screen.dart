import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '06_account_created_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  final String languageCode;
  final String languageName;

  const CreateAccountScreen({
    super.key,
    required this.languageCode,
    required this.languageName,
  });

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes =
      List.generate(4, (_) => FocusNode());

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  bool _isSendingCode = false;
  bool _emailVerified = false;
  bool _usernameAvailable = false;
  bool _isCheckingUsername = false;
  File? _profileImage;
  String _selectedGender = '';
  DateTime? _birthDate;
  String _errorMessage = '';

  // Country code and phone number
  String _selectedCountryCode = '+1';
  String _selectedCountryName = 'United States';
  final TextEditingController _phoneNumberController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  static const Color primary = Color(0xFF9d4d36);
  static const Color bg = Color(0xFFF7F9FC);
  static const Color inputBg = Color(0xFFEEEFF4);
  static const Color green = Color(0xFF25d366);

  // Comprehensive list of countries (code, name, flag emoji) - expanded
  final List<Map<String, String>> _allCountries = [
    {'code': '+1', 'name': 'United States', 'flag': '🇺🇸'},
    {'code': '+1', 'name': 'Canada', 'flag': '🇨🇦'},
    {'code': '+44', 'name': 'United Kingdom', 'flag': '🇬🇧'},
    {'code': '+91', 'name': 'India', 'flag': '🇮🇳'},
    {'code': '+61', 'name': 'Australia', 'flag': '🇦🇺'},
    {'code': '+49', 'name': 'Germany', 'flag': '🇩🇪'},
    {'code': '+33', 'name': 'France', 'flag': '🇫🇷'},
    {'code': '+81', 'name': 'Japan', 'flag': '🇯🇵'},
    {'code': '+86', 'name': 'China', 'flag': '🇨🇳'},
    {'code': '+7', 'name': 'Russia', 'flag': '🇷🇺'},
    {'code': '+55', 'name': 'Brazil', 'flag': '🇧🇷'},
    {'code': '+39', 'name': 'Italy', 'flag': '🇮🇹'},
    {'code': '+34', 'name': 'Spain', 'flag': '🇪🇸'},
    {'code': '+52', 'name': 'Mexico', 'flag': '🇲🇽'},
    {'code': '+82', 'name': 'South Korea', 'flag': '🇰🇷'},
    {'code': '+971', 'name': 'United Arab Emirates', 'flag': '🇦🇪'},
    {'code': '+966', 'name': 'Saudi Arabia', 'flag': '🇸🇦'},
    {'code': '+20', 'name': 'Egypt', 'flag': '🇪🇬'},
    {'code': '+27', 'name': 'South Africa', 'flag': '🇿🇦'},
    {'code': '+90', 'name': 'Turkey', 'flag': '🇹🇷'},
    {'code': '+62', 'name': 'Indonesia', 'flag': '🇮🇩'},
    {'code': '+63', 'name': 'Philippines', 'flag': '🇵🇭'},
    {'code': '+66', 'name': 'Thailand', 'flag': '🇹🇭'},
    {'code': '+60', 'name': 'Malaysia', 'flag': '🇲🇾'},
    {'code': '+84', 'name': 'Vietnam', 'flag': '🇻🇳'},
    {'code': '+65', 'name': 'Singapore', 'flag': '🇸🇬'},
    {'code': '+64', 'name': 'New Zealand', 'flag': '🇳🇿'},
    {'code': '+47', 'name': 'Norway', 'flag': '🇳🇴'},
    {'code': '+46', 'name': 'Sweden', 'flag': '🇸🇪'},
    {'code': '+45', 'name': 'Denmark', 'flag': '🇩🇰'},
    {'code': '+358', 'name': 'Finland', 'flag': '🇫🇮'},
    {'code': '+31', 'name': 'Netherlands', 'flag': '🇳🇱'},
    {'code': '+32', 'name': 'Belgium', 'flag': '🇧🇪'},
    {'code': '+41', 'name': 'Switzerland', 'flag': '🇨🇭'},
    {'code': '+43', 'name': 'Austria', 'flag': '🇦🇹'},
    {'code': '+48', 'name': 'Poland', 'flag': '🇵🇱'},
    {'code': '+420', 'name': 'Czech Republic', 'flag': '🇨🇿'},
    {'code': '+36', 'name': 'Hungary', 'flag': '🇭🇺'},
    {'code': '+40', 'name': 'Romania', 'flag': '🇷🇴'},
    {'code': '+380', 'name': 'Ukraine', 'flag': '🇺🇦'},
    {'code': '+30', 'name': 'Greece', 'flag': '🇬🇷'},
    {'code': '+351', 'name': 'Portugal', 'flag': '🇵🇹'},
    {'code': '+353', 'name': 'Ireland', 'flag': '🇮🇪'},
    {'code': '+354', 'name': 'Iceland', 'flag': '🇮🇸'},
    {'code': '+972', 'name': 'Israel', 'flag': '🇮🇱'},
    {'code': '+98', 'name': 'Iran', 'flag': '🇮🇷'},
    {'code': '+92', 'name': 'Pakistan', 'flag': '🇵🇰'},
    {'code': '+94', 'name': 'Sri Lanka', 'flag': '🇱🇰'},
    {'code': '+880', 'name': 'Bangladesh', 'flag': '🇧🇩'},
    {'code': '+977', 'name': 'Nepal', 'flag': '🇳🇵'},
    {'code': '+856', 'name': 'Laos', 'flag': '🇱🇦'},
    {'code': '+855', 'name': 'Cambodia', 'flag': '🇰🇭'},
    {'code': '+95', 'name': 'Myanmar', 'flag': '🇲🇲'},
    {'code': '+998', 'name': 'Uzbekistan', 'flag': '🇺🇿'},
    {'code': '+992', 'name': 'Tajikistan', 'flag': '🇹🇯'},
    {'code': '+993', 'name': 'Turkmenistan', 'flag': '🇹🇲'},
    {'code': '+996', 'name': 'Kyrgyzstan', 'flag': '🇰🇬'},
    {'code': '+374', 'name': 'Armenia', 'flag': '🇦🇲'},
    {'code': '+994', 'name': 'Azerbaijan', 'flag': '🇦🇿'},
    {'code': '+995', 'name': 'Georgia', 'flag': '🇬🇪'},
    {'code': '+373', 'name': 'Moldova', 'flag': '🇲🇩'},
    {'code': '+371', 'name': 'Latvia', 'flag': '🇱🇻'},
    {'code': '+370', 'name': 'Lithuania', 'flag': '🇱🇹'},
    {'code': '+372', 'name': 'Estonia', 'flag': '🇪🇪'},
    {'code': '+7', 'name': 'Kazakhstan', 'flag': '🇰🇿'},
    {'code': '+961', 'name': 'Lebanon', 'flag': '🇱🇧'},
    {'code': '+963', 'name': 'Syria', 'flag': '🇸🇾'},
    {'code': '+964', 'name': 'Iraq', 'flag': '🇮🇶'},
    {'code': '+965', 'name': 'Kuwait', 'flag': '🇰🇼'},
    {'code': '+968', 'name': 'Oman', 'flag': '🇴🇲'},
    {'code': '+974', 'name': 'Qatar', 'flag': '🇶🇦'},
    {'code': '+973', 'name': 'Bahrain', 'flag': '🇧🇭'},
    {'code': '+218', 'name': 'Libya', 'flag': '🇱🇾'},
    {'code': '+216', 'name': 'Tunisia', 'flag': '🇹🇳'},
    {'code': '+213', 'name': 'Algeria', 'flag': '🇩🇿'},
    {'code': '+212', 'name': 'Morocco', 'flag': '🇲🇦'},
    {'code': '+222', 'name': 'Mauritania', 'flag': '🇲🇷'},
    {'code': '+223', 'name': 'Mali', 'flag': '🇲🇱'},
    {'code': '+226', 'name': 'Burkina Faso', 'flag': '🇧🇫'},
    {'code': '+227', 'name': 'Niger', 'flag': '🇳🇪'},
    {'code': '+229', 'name': 'Benin', 'flag': '🇧🇯'},
    {'code': '+228', 'name': 'Togo', 'flag': '🇹🇬'},
    {'code': '+233', 'name': 'Ghana', 'flag': '🇬🇭'},
    {'code': '+225', 'name': 'Ivory Coast', 'flag': '🇨🇮'},
    {'code': '+224', 'name': 'Guinea', 'flag': '🇬🇳'},
    {'code': '+231', 'name': 'Liberia', 'flag': '🇱🇷'},
    {'code': '+232', 'name': 'Sierra Leone', 'flag': '🇸🇱'},
    {'code': '+245', 'name': 'Guinea-Bissau', 'flag': '🇬🇼'},
    {'code': '+220', 'name': 'Gambia', 'flag': '🇬🇲'},
    {'code': '+221', 'name': 'Senegal', 'flag': '🇸🇳'},
    {'code': '+234', 'name': 'Nigeria', 'flag': '🇳🇬'},
    {'code': '+237', 'name': 'Cameroon', 'flag': '🇨🇲'},
    {'code': '+235', 'name': 'Chad', 'flag': '🇹🇩'},
    {'code': '+236', 'name': 'Central African Republic', 'flag': '🇨🇫'},
    {'code': '+242', 'name': 'Congo', 'flag': '🇨🇬'},
    {'code': '+243', 'name': 'DR Congo', 'flag': '🇨🇩'},
    {'code': '+254', 'name': 'Kenya', 'flag': '🇰🇪'},
    {'code': '+255', 'name': 'Tanzania', 'flag': '🇹🇿'},
    {'code': '+256', 'name': 'Uganda', 'flag': '🇺🇬'},
    {'code': '+250', 'name': 'Rwanda', 'flag': '🇷🇼'},
    {'code': '+257', 'name': 'Burundi', 'flag': '🇧🇮'},
    {'code': '+258', 'name': 'Mozambique', 'flag': '🇲🇿'},
    {'code': '+260', 'name': 'Zambia', 'flag': '🇿🇲'},
    {'code': '+263', 'name': 'Zimbabwe', 'flag': '🇿🇼'},
    {'code': '+265', 'name': 'Malawi', 'flag': '🇲🇼'},
    {'code': '+266', 'name': 'Lesotho', 'flag': '🇱🇸'},
    {'code': '+267', 'name': 'Botswana', 'flag': '🇧🇼'},
    {'code': '+268', 'name': 'Eswatini', 'flag': '🇸🇿'},
    {'code': '+264', 'name': 'Namibia', 'flag': '🇳🇦'},
    {'code': '+211', 'name': 'South Sudan', 'flag': '🇸🇸'},
    {'code': '+249', 'name': 'Sudan', 'flag': '🇸🇩'},
    {'code': '+251', 'name': 'Ethiopia', 'flag': '🇪🇹'},
    {'code': '+252', 'name': 'Somalia', 'flag': '🇸🇴'},
    {'code': '+253', 'name': 'Djibouti', 'flag': '🇩🇯'},
    {'code': '+291', 'name': 'Eritrea', 'flag': '🇪🇷'},
    {'code': '+230', 'name': 'Mauritius', 'flag': '🇲🇺'},
    {'code': '+248', 'name': 'Seychelles', 'flag': '🇸🇨'},
    {'code': '+269', 'name': 'Comoros', 'flag': '🇰🇲'},
    {'code': '+262', 'name': 'Réunion', 'flag': '🇷🇪'},
    {'code': '+509', 'name': 'Haiti', 'flag': '🇭🇹'},
    {'code': '+1', 'name': 'Jamaica', 'flag': '🇯🇲'},
    {'code': '+1', 'name': 'Bahamas', 'flag': '🇧🇸'},
    {'code': '+1', 'name': 'Barbados', 'flag': '🇧🇧'},
    {'code': '+1', 'name': 'Trinidad and Tobago', 'flag': '🇹🇹'},
    {'code': '+1', 'name': 'Dominican Republic', 'flag': '🇩🇴'},
    {'code': '+53', 'name': 'Cuba', 'flag': '🇨🇺'},
    {'code': '+57', 'name': 'Colombia', 'flag': '🇨🇴'},
    {'code': '+58', 'name': 'Venezuela', 'flag': '🇻🇪'},
    {'code': '+51', 'name': 'Peru', 'flag': '🇵🇪'},
    {'code': '+56', 'name': 'Chile', 'flag': '🇨🇱'},
    {'code': '+54', 'name': 'Argentina', 'flag': '🇦🇷'},
    {'code': '+598', 'name': 'Uruguay', 'flag': '🇺🇾'},
    {'code': '+595', 'name': 'Paraguay', 'flag': '🇵🇾'},
    {'code': '+591', 'name': 'Bolivia', 'flag': '🇧🇴'},
    {'code': '+593', 'name': 'Ecuador', 'flag': '🇪🇨'},
    {'code': '+507', 'name': 'Panama', 'flag': '🇵🇦'},
    {'code': '+506', 'name': 'Costa Rica', 'flag': '🇨🇷'},
    {'code': '+505', 'name': 'Nicaragua', 'flag': '🇳🇮'},
    {'code': '+504', 'name': 'Honduras', 'flag': '🇭🇳'},
    {'code': '+503', 'name': 'El Salvador', 'flag': '🇸🇻'},
    {'code': '+502', 'name': 'Guatemala', 'flag': '🇬🇹'},
    {'code': '+501', 'name': 'Belize', 'flag': '🇧🇿'},
    {'code': '+679', 'name': 'Fiji', 'flag': '🇫🇯'},
    {'code': '+682', 'name': 'Cook Islands', 'flag': '🇨🇰'},
    {'code': '+685', 'name': 'Samoa', 'flag': '🇼🇸'},
    {'code': '+676', 'name': 'Tonga', 'flag': '🇹🇴'},
    {'code': '+687', 'name': 'New Caledonia', 'flag': '🇳🇨'},
    {'code': '+689', 'name': 'French Polynesia', 'flag': '🇵🇫'},
  ];

  String t(String key) {
    final code = widget.languageCode.toUpperCase();
    return (_tr[code] ?? _tr['EN']!)[key] ?? _tr['EN']![key]!;
  }

  bool get isRTL => widget.languageCode.toUpperCase() == 'AR';

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    for (var c in _otpControllers) c.dispose();
    for (var f in _otpFocusNodes) f.dispose();
    super.dispose();
  }

  // image picker
  Future<void> _showImageSourceModal() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: primary),
              title: Text(t('gallery')),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: primary),
              title: Text(t('camera')),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (picked != null) {
        setState(() {
          _profileImage = File(picked.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _sendCode() async {
    final email = _emailController.text.trim();
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      setState(() => _errorMessage = t('email_invalid'));
      return;
    }
    setState(() {
      _isSendingCode = true;
      _errorMessage = '';
    });
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isSendingCode = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t('code_sent')),
          backgroundColor: primary,
        ),
      );
    }
  }

  void _verifyOtp() {
    final code = _otpControllers.map((c) => c.text).join();
    if (code.length < 4) {
      setState(() => _errorMessage = t('invalid_code'));
      return;
    }
    setState(() {
      _emailVerified = true;
      _errorMessage = '';
    });
    HapticFeedback.lightImpact();
  }

  void _checkUsername() async {
    final username = _usernameController.text.trim();
    if (username.length < 5) {
      setState(() => _errorMessage = t('username_invalid_min5'));
      return;
    }
    setState(() => _isCheckingUsername = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      final taken = ['admin', 'test', 'connect'].contains(username.toLowerCase());
      setState(() {
        _usernameAvailable = !taken;
        _isCheckingUsername = false;
        _errorMessage = taken ? t('username_taken') : '';
      });
      HapticFeedback.lightImpact();
    }
  }

  // country picker
  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        String searchQuery = '';
        List<Map<String, String>> filteredCountries = List.from(_allCountries);
        
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.9,
              minChildSize: 0.5,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: inputBg,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextField(
                          autofocus: false,
                          onChanged: (value) {
                            searchQuery = value.toLowerCase().trim();
                            setModalState(() {
                              if (searchQuery.isEmpty) {
                                filteredCountries = List.from(_allCountries);
                              } else {
                                filteredCountries = _allCountries.where((country) {
                                  final name = country['name']!.toLowerCase();
                                  final code = country['code']!;
                                  return name.contains(searchQuery) || code.contains(searchQuery);
                                }).toList();
                              }
                            });
                          },
                          decoration: InputDecoration(
                            hintText: t('search_country'),
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: filteredCountries.isEmpty
                          ? Center(
                              child: Text(
                                t('no_results'),
                                style: const TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              controller: scrollController,
                              itemCount: filteredCountries.length,
                              itemBuilder: (context, index) {
                                final country = filteredCountries[index];
                                return ListTile(
                                  leading: Text(country['flag']!),
                                  title: Text(country['name']!),
                                  trailing: Text(country['code']!),
                                  onTap: () {
                                    setState(() {
                                      _selectedCountryCode = country['code']!;
                                      _selectedCountryName = country['name']!;
                                    });
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  void _submit() {
    setState(() => _errorMessage = '');

    if (_fullNameController.text.trim().isEmpty) {
      setState(() => _errorMessage = t('fullname_required'));
      return;
    }
    if (_usernameController.text.trim().isEmpty || !_usernameAvailable) {
      setState(() => _errorMessage = t('username_required'));
      return;
    }
    if (!_emailVerified) {
      setState(() => _errorMessage = t('email_not_verified'));
      return;
    }
    // Phone validation
    final phoneNumber = _phoneNumberController.text.trim();
    if (phoneNumber.isNotEmpty) {
      if (!RegExp(r'^\d{6,15}$').hasMatch(phoneNumber)) {
        setState(() => _errorMessage = t('phone_invalid'));
        return;
      }
    }
    if (_passwordController.text.length < 6) {
      setState(() => _errorMessage = t('password_short'));
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _errorMessage = t('password_mismatch'));
      return;
    }
    if (_birthDate == null) {
      setState(() => _errorMessage = t('birthday_required'));
      return;
    }
    if (_selectedGender.isEmpty) {
      setState(() => _errorMessage = t('gender_required'));
      return;
    }

    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AccountCreatedScreen(
            languageCode: widget.languageCode,
            languageName: widget.languageName,
            fullName: _fullNameController.text.trim(),
            username: _usernameController.text.trim(),
            email: _emailController.text.trim(),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: primary),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(t('create_account'),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: primary)),
              const SizedBox(width: 8),
              Text('Connect',
                  style: GoogleFonts.dancingScript(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: primary)),
            ],
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile photo
                Center(
                  child: GestureDetector(
                    onTap: _showImageSourceModal,
                    child: Stack(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: inputBg,
                            border: Border.all(
                                color: primary.withOpacity(0.3), width: 2),
                          ),
                          child: ClipOval(
                            child: _profileImage != null
                                ? Image.file(
                                    _profileImage!,
                                    fit: BoxFit.cover,
                                    width: 90,
                                    height: 90,
                                  )
                                : Icon(
                                    Icons.person_outline,
                                    size: 46,
                                    color: primary.withOpacity(0.4),
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                                color: primary, shape: BoxShape.circle),
                            child: const Icon(Icons.add,
                                size: 14, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Full name
                _label(t('full_name')),
                _field(
                  controller: _fullNameController,
                  hint: t('full_name_hint'),
                  icon: Icons.person_outline,
                ),

                const SizedBox(height: 14),

                // Username 
                _label(t('username_label')),
                Row(
                  children: [
                    Expanded(
                      child: _field(
                        controller: _usernameController,
                        hint: t('username_hint_min5'),
                        icon: Icons.alternate_email,
                        onChanged: (_) => setState(
                            () => _usernameAvailable = false),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _actionBtn(
                      label: _usernameAvailable
                          ? t('available')
                          : t('check'),
                      isLoading: _isCheckingUsername,
                      color: _usernameAvailable ? green : primary,
                      onTap: _checkUsername,
                    ),
                  ],
                ),
                if (_usernameAvailable)
                  _successText(t('username_ok')),

                const SizedBox(height: 14),

                // Email
                _label(t('email_label')),
                _field(
                  controller: _emailController,
                  hint: t('email_hint'),
                  icon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                  enabled: !_emailVerified,
                ),
                const SizedBox(height: 8),

                // OTP row
                if (!_emailVerified) ...[
                  Row(
                    children: [
                      ...List.generate(4, (i) => _otpBox(i)),
                      const SizedBox(width: 8),
                      _actionBtn(
                        label: t('get_code'),
                        isLoading: _isSendingCode,
                        color: primary,
                        onTap: _sendCode,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      TextButton(
                        onPressed: _sendCode,
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero),
                        child: Text(t('resend_code'),
                            style: const TextStyle(
                                color: primary, fontSize: 12)),
                      ),
                      const SizedBox(width: 16),
                      TextButton(
                        onPressed: _verifyOtp,
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero),
                        child: Text(t('verify_email'),
                            style: const TextStyle(
                                color: primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ] else
                  _successText(t('email_verified')),

                const SizedBox(height: 14),

                // phone number
                _label(t('phone_optional')),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Country code picker button
                    GestureDetector(
                      onTap: _showCountryPicker,
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: inputBg,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _selectedCountryCode,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_drop_down, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Phone number input
                    Expanded(
                      child: _field(
                        controller: _phoneNumberController,
                        hint: t('phone_hint'),
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Password
                _label(t('password_label')),
                _field(
                  controller: _passwordController,
                  hint: t('password_hint'),
                  icon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  suffix: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                    onPressed: () => setState(
                        () => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: 8),
                _field(
                  controller: _confirmPasswordController,
                  hint: t('confirm_password'),
                  icon: Icons.lock_outline,
                  obscureText: _obscureConfirm,
                  suffix: IconButton(
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),

                const SizedBox(height: 14),

                // Birthday + Gender
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(t('birthday_label'),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54)),
                              const SizedBox(width: 4),
                              Text('16+',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: primary.withOpacity(0.7),
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now()
                                    .subtract(const Duration(days: 365 * 20)),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now().subtract(
                                    const Duration(days: 365 * 16)),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                          primary: primary),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null) {
                                setState(() => _birthDate = picked);
                              }
                            },
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12),
                              decoration: BoxDecoration(
                                color: inputBg,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today,
                                      size: 18,
                                      color: primary.withOpacity(0.7)),
                                  const SizedBox(width: 8),
                                  Text(
                                    _birthDate == null
                                        ? 'mm/dd/yyyy'
                                        : '${_birthDate!.month}/${_birthDate!.day}/${_birthDate!.year}',
                                    style: TextStyle(
                                      color: _birthDate == null
                                          ? Colors.grey[400]
                                          : Colors.black87,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t('gender_label'),
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54)),
                          const SizedBox(height: 6),
                          Container(
                            height: 50,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: inputBg,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: ['M', 'F', '?'].map((g) {
                                final labels = {
                                  'M': t('male'),
                                  'F': t('female'),
                                  '?': t('other')
                                };
                                final isSelected = _selectedGender == g;
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(
                                        () => _selectedGender = g),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                          milliseconds: 200),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? primary
                                            : Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          labels[g]!,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Error message
                if (_errorMessage.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.red.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: Colors.red, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(_errorMessage,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 13)),
                        ),
                      ],
                    ),
                  ),

                // Sign Up button (no splash)
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: GestureDetector(
                    onTap: _isLoading ? null : _submit,
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
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2.5),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(t('sign_up'),
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white)),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward,
                                    color: Colors.white, size: 20),
                              ],
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Terms
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: t('agree_to') + ' ',
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey[500]),
                      children: [
                        TextSpan(
                          text: t('terms'),
                          style: const TextStyle(
                              color: primary,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
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

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 2),
      child: Text(text,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
              letterSpacing: 0.5)),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffix,
    bool enabled = true,
    Function(String)? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
          color: inputBg, borderRadius: BorderRadius.circular(14)),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        enabled: enabled,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon:
              Icon(icon, color: primary.withOpacity(0.7), size: 20),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }

  Widget _otpBox(int index) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 6),
        height: 50,
        decoration: BoxDecoration(
          color: inputBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _otpControllers[index].text.isNotEmpty
                ? primary
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: TextField(
          controller: _otpControllers[index],
          focusNode: _otpFocusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w700, color: primary),
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: '',
          ),
          onChanged: (val) {
            setState(() {});
            if (val.isNotEmpty && index < 3) {
              _otpFocusNodes[index + 1].requestFocus();
            }
            if (val.isEmpty && index > 0) {
              _otpFocusNodes[index - 1].requestFocus();
            }
          },
        ),
      ),
    );
  }

  Widget _actionBtn({
    required String label,
    required bool isLoading,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2))
            : Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
      ),
    );
  }

  Widget _successText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 14, color: green),
          const SizedBox(width: 4),
          Text(text,
              style: const TextStyle(color: green, fontSize: 12)),
        ],
      ),
    );
  }
}

const Map<String, Map<String, String>> _tr = {
  'EN': {
    'create_account': 'Create Account',
    'gallery': 'Gallery',
    'google_photos': 'Google Photos',
    'full_name': 'FULL NAME',
    'full_name_hint': 'John Doe',
    'fullname_required': 'Full name is required',
    'username_label': 'UNIQUE USERNAME',
    'username_hint': 'johndoe_connect',
    'username_hint_min5': 'Minimum 5 characters',
    'username_required': 'Please check username availability',
    'username_invalid': 'Username must be at least 3 characters',
    'username_invalid_min5': 'Username must be at least 5 characters',
    'username_taken': 'This username is already taken',
    'username_ok': 'Username is available!',
    'check': 'Check',
    'available': 'Available ✓',
    'email_label': 'EMAIL ADDRESS',
    'email_hint': 'name@example.com',
    'email_invalid': 'Enter a valid email address',
    'email_not_verified': 'Please verify your email first',
    'email_verified': 'Email verified!',
    'get_code': 'Get Code',
    'resend_code': 'Resend Code',
    'verify_email': 'Verify →',
    'code_sent': 'Verification code sent to your email!',
    'invalid_code': 'Please enter all 4 digits',
    'phone_optional': 'PHONE NUMBER (OPTIONAL)',
    'phone_hint': 'Enter phone number',
    'phone_invalid': 'Enter a valid phone number (at least 6 digits)',
    'password_label': 'PASSWORD',
    'password_hint': 'New password (min 6 chars)',
    'confirm_password': 'Confirm password',
    'password_short': 'Password must be at least 6 characters',
    'password_mismatch': 'Passwords do not match',
    'birthday_label': 'BIRTHDAY',
    'birthday_required': 'Please select your birth date',
    'gender_label': 'GENDER',
    'gender_required': 'Please select your gender',
    'male': 'Male',
    'female': 'Female',
    'other': 'Other',
    'sign_up': 'Sign Up',
    'agree_to': 'By signing up, you agree to our',
    'terms': 'Terms of Service',
    'add_photo': 'Add photo',
    'camera': 'Camera',
    'search_country': 'Search country or code...',
    'no_results': 'No results found',
  },
  'BN': {
    'create_account': 'অ্যাকাউন্ট তৈরি',
    'gallery': 'গ্যালারি',
    'google_photos': 'গুগল ফটো',
    'full_name': 'পুরো নাম',
    'full_name_hint': 'আপনার পুরো নাম',
    'fullname_required': 'পুরো নাম দিন',
    'username_label': 'ইউনিক ইউজারনেম',
    'username_hint': 'ইউজারনেম বেছে নিন',
    'username_hint_min5': 'কমপক্ষে ৫ অক্ষর',
    'username_required': 'ইউজারনেম চেক করুন',
    'username_invalid': 'ইউজারনেম কমপক্ষে ৩ অক্ষরের হতে হবে',
    'username_invalid_min5': 'ইউজারনেম কমপক্ষে ৫ অক্ষরের হতে হবে',
    'username_taken': 'এই ইউজারনেম আগেই নেওয়া হয়েছে',
    'username_ok': 'ইউজারনেম পাওয়া যাচ্ছে!',
    'check': 'চেক',
    'available': 'পাওয়া যাচ্ছে ✓',
    'email_label': 'ইমেইল ঠিকানা',
    'email_hint': 'name@example.com',
    'email_invalid': 'সঠিক ইমেইল দিন',
    'email_not_verified': 'আগে ইমেইল যাচাই করুন',
    'email_verified': 'ইমেইল যাচাই হয়েছে!',
    'get_code': 'কোড পান',
    'resend_code': 'আবার পাঠান',
    'verify_email': 'যাচাই করুন →',
    'code_sent': 'যাচাই কোড পাঠানো হয়েছে!',
    'invalid_code': 'সব ৪টি সংখ্যা দিন',
    'phone_optional': 'ফোন নম্বর (ঐচ্ছিক)',
    'phone_hint': 'ফোন নম্বর লিখুন',
    'phone_invalid': 'সঠিক ফোন নম্বর দিন (কমপক্ষে ৬ সংখ্যা)',
    'password_label': 'পাসওয়ার্ড',
    'password_hint': 'নতুন পাসওয়ার্ড (কমপক্ষে ৬ অক্ষর)',
    'confirm_password': 'পাসওয়ার্ড নিশ্চিত করুন',
    'password_short': 'কমপক্ষে ৬ অক্ষর',
    'password_mismatch': 'পাসওয়ার্ড মিলছে না',
    'birthday_label': 'জন্মদিন',
    'birthday_required': 'জন্মতারিখ বেছে নিন',
    'gender_label': 'লিঙ্গ',
    'gender_required': 'লিঙ্গ বেছে নিন',
    'male': 'পুরুষ',
    'female': 'মহিলা',
    'other': 'অন্য',
    'sign_up': 'সাইন আপ',
    'agree_to': 'সাইন আপ করে আপনি আমাদের',
    'terms': 'শর্তাবলীতে সম্মত হচ্ছেন',
    'add_photo': 'ছবি যোগ করুন',
    'camera': 'ক্যামেরা',
    'search_country': 'দেশ বা কোড খুঁজুন...',
    'no_results': 'কোনো ফলাফল পাওয়া যায়নি',
  },
  'RU': {
    'create_account': 'Создать аккаунт',
    'gallery': 'Галерея',
    'google_photos': 'Google Фото',
    'full_name': 'ПОЛНОЕ ИМЯ',
    'full_name_hint': 'Иван Иванов',
    'fullname_required': 'Введите полное имя',
    'username_label': 'ИМЯ ПОЛЬЗОВАТЕЛЯ',
    'username_hint': 'ivan_connect',
    'username_hint_min5': 'Минимум 5 символов',
    'username_required': 'Проверьте доступность имени',
    'username_invalid': 'Минимум 3 символа',
    'username_invalid_min5': 'Имя пользователя должно содержать не менее 5 символов',
    'username_taken': 'Это имя уже занято',
    'username_ok': 'Имя доступно!',
    'check': 'Проверить',
    'available': 'Доступно ✓',
    'email_label': 'EMAIL',
    'email_hint': 'name@example.com',
    'email_invalid': 'Введите корректный email',
    'email_not_verified': 'Сначала подтвердите email',
    'email_verified': 'Email подтверждён!',
    'get_code': 'Код',
    'resend_code': 'Отправить снова',
    'verify_email': 'Подтвердить →',
    'code_sent': 'Код отправлен!',
    'invalid_code': 'Введите все 4 цифры',
    'phone_optional': 'ТЕЛЕФОН (необязательно)',
    'phone_hint': 'Введите номер телефона',
    'phone_invalid': 'Введите корректный номер телефона (не менее 6 цифр)',
    'password_label': 'ПАРОЛЬ',
    'password_hint': 'Новый пароль (мин. 6)',
    'confirm_password': 'Подтвердите пароль',
    'password_short': 'Минимум 6 символов',
    'password_mismatch': 'Пароли не совпадают',
    'birthday_label': 'ДАТА РОЖДЕНИЯ',
    'birthday_required': 'Выберите дату рождения',
    'gender_label': 'ПОЛ',
    'gender_required': 'Выберите пол',
    'male': 'Муж.',
    'female': 'Жен.',
    'other': 'Другой',
    'sign_up': 'Зарегистрироваться',
    'agree_to': 'Регистрируясь, вы соглашаетесь с',
    'terms': 'Условиями использования',
    'add_photo': 'Добавить фото',
    'camera': 'Камера',
    'search_country': 'Поиск страны или кода...',
    'no_results': 'Ничего не найдено',
  },
  'AR': {
    'create_account': 'إنشاء حساب',
    'gallery': 'المعرض',
    'google_photos': 'صور Google',
    'full_name': 'الاسم الكامل',
    'full_name_hint': 'أدخل اسمك الكامل',
    'fullname_required': 'الاسم الكامل مطلوب',
    'username_label': 'اسم المستخدم',
    'username_hint': 'اختر اسم مستخدم فريد',
    'username_hint_min5': 'الحد الأدنى 5 أحرف',
    'username_required': 'تحقق من توفر اسم المستخدم',
    'username_invalid': '3 أحرف على الأقل',
    'username_invalid_min5': 'اسم المستخدم يجب أن يكون 5 أحرف على الأقل',
    'username_taken': 'اسم المستخدم محجوز',
    'username_ok': 'اسم المستخدم متاح!',
    'check': 'تحقق',
    'available': 'متاح ✓',
    'email_label': 'البريد الإلكتروني',
    'email_hint': 'name@example.com',
    'email_invalid': 'أدخل بريدًا إلكترونيًا صحيحًا',
    'email_not_verified': 'يرجى التحقق من البريد أولاً',
    'email_verified': 'تم التحقق!',
    'get_code': 'احصل على الرمز',
    'resend_code': 'إعادة الإرسال',
    'verify_email': 'تحقق →',
    'code_sent': 'تم إرسال الرمز!',
    'invalid_code': 'أدخل جميع الأرقام الأربعة',
    'phone_optional': 'الهاتف (اختياري)',
    'phone_hint': 'أدخل رقم الهاتف',
    'phone_invalid': 'أدخل رقم هاتف صالحًا (6 أرقام على الأقل)',
    'password_label': 'كلمة المرور',
    'password_hint': 'كلمة مرور جديدة (6 أحرف)',
    'confirm_password': 'تأكيد كلمة المرور',
    'password_short': '6 أحرف على الأقل',
    'password_mismatch': 'كلمتا المرور غير متطابقتين',
    'birthday_label': 'تاريخ الميلاد',
    'birthday_required': 'اختر تاريخ ميلادك',
    'gender_label': 'الجنس',
    'gender_required': 'اختر جنسك',
    'male': 'ذكر',
    'female': 'أنثى',
    'other': 'آخر',
    'sign_up': 'إنشاء الحساب',
    'agree_to': 'بالتسجيل، أنت توافق على',
    'terms': 'شروط الخدمة',
    'add_photo': 'أضف صورة',
    'camera': 'الكاميرا',
    'search_country': 'البحث عن بلد أو رمز...',
    'no_results': 'لا توجد نتائج',
  },
  'ES': {
    'create_account': 'Crear cuenta',
    'gallery': 'Galería',
    'google_photos': 'Google Fotos',
    'full_name': 'NOMBRE COMPLETO',
    'full_name_hint': 'Juan García',
    'fullname_required': 'El nombre es requerido',
    'username_label': 'NOMBRE DE USUARIO',
    'username_hint': 'juan_connect',
    'username_hint_min5': 'Mínimo 5 caracteres',
    'username_required': 'Verifica la disponibilidad',
    'username_invalid': 'Mínimo 3 caracteres',
    'username_invalid_min5': 'El nombre de usuario debe tener al menos 5 caracteres',
    'username_taken': 'Este nombre ya está tomado',
    'username_ok': '¡Nombre disponible!',
    'check': 'Verificar',
    'available': 'Disponible ✓',
    'email_label': 'CORREO ELECTRÓNICO',
    'email_hint': 'nombre@ejemplo.com',
    'email_invalid': 'Ingresa un correo válido',
    'email_not_verified': 'Primero verifica tu correo',
    'email_verified': '¡Correo verificado!',
    'get_code': 'Código',
    'resend_code': 'Reenviar',
    'verify_email': 'Verificar →',
    'code_sent': '¡Código enviado!',
    'invalid_code': 'Ingresa los 4 dígitos',
    'phone_optional': 'TELÉFONO (OPCIONAL)',
    'phone_hint': 'Ingresa número de teléfono',
    'phone_invalid': 'Ingresa un número válido (al menos 6 dígitos)',
    'password_label': 'CONTRASEÑA',
    'password_hint': 'Nueva contraseña (mín. 6)',
    'confirm_password': 'Confirmar contraseña',
    'password_short': 'Mínimo 6 caracteres',
    'password_mismatch': 'Las contraseñas no coinciden',
    'birthday_label': 'CUMPLEAÑOS',
    'birthday_required': 'Selecciona tu fecha de nacimiento',
    'gender_label': 'GÉNERO',
    'gender_required': 'Selecciona tu género',
    'male': 'Masc.',
    'female': 'Fem.',
    'other': 'Otro',
    'sign_up': 'Registrarse',
    'agree_to': 'Al registrarte, aceptas nuestros',
    'terms': 'Términos de Servicio',
    'add_photo': 'Agregar foto',
    'camera': 'Cámara',
    'search_country': 'Buscar país o código...',
    'no_results': 'No se encontraron resultados',
  },
  'FR': {
    'create_account': 'Créer un compte',
    'gallery': 'Galerie',
    'google_photos': 'Google Photos',
    'full_name': 'NOM COMPLET',
    'full_name_hint': 'Jean Dupont',
    'fullname_required': 'Le nom est requis',
    'username_label': 'NOM D\'UTILISATEUR',
    'username_hint': 'jean_connect',
    'username_hint_min5': 'Minimum 5 caractères',
    'username_required': 'Vérifiez la disponibilité',
    'username_invalid': 'Minimum 3 caractères',
    'username_invalid_min5': 'Le nom d\'utilisateur doit comporter au moins 5 caractères',
    'username_taken': 'Ce nom est déjà pris',
    'username_ok': 'Nom disponible !',
    'check': 'Vérifier',
    'available': 'Disponible ✓',
    'email_label': 'ADRESSE E-MAIL',
    'email_hint': 'nom@exemple.com',
    'email_invalid': 'Entrez un e-mail valide',
    'email_not_verified': 'Vérifiez d\'abord votre e-mail',
    'email_verified': 'E-mail vérifié !',
    'get_code': 'Code',
    'resend_code': 'Renvoyer',
    'verify_email': 'Vérifier →',
    'code_sent': 'Code envoyé !',
    'invalid_code': 'Entrez les 4 chiffres',
    'phone_optional': 'TÉLÉPHONE (OPTIONNEL)',
    'phone_hint': 'Entrez le numéro de téléphone',
    'phone_invalid': 'Entrez un numéro valide (au moins 6 chiffres)',
    'password_label': 'MOT DE PASSE',
    'password_hint': 'Nouveau mot de passe (mín. 6)',
    'confirm_password': 'Confirmer le mot de passe',
    'password_short': 'Minimum 6 caractères',
    'password_mismatch': 'Les mots de passe ne correspondent pas',
    'birthday_label': 'DATE DE NAISSANCE',
    'birthday_required': 'Sélectionnez votre date de naissance',
    'gender_label': 'GENRE',
    'gender_required': 'Sélectionnez votre genre',
    'male': 'Homme',
    'female': 'Femme',
    'other': 'Autre',
    'sign_up': 'S\'inscrire',
    'agree_to': 'En vous inscrivant, vous acceptez nos',
    'terms': 'Conditions d\'utilisation',
    'add_photo': 'Ajouter une photo',
    'camera': 'Appareil photo',
    'search_country': 'Rechercher un pays ou un code...',
    'no_results': 'Aucun résultat trouvé',
  },
  'HI': {
    'create_account': 'खाता बनाएं',
    'gallery': 'गैलरी',
    'google_photos': 'Google Photos',
    'full_name': 'पूरा नाम',
    'full_name_hint': 'राम कुमार',
    'fullname_required': 'पूरा नाम आवश्यक है',
    'username_label': 'यूजरनेम',
    'username_hint': 'ram_connect',
    'username_hint_min5': 'कम से कम 5 अक्षर',
    'username_required': 'यूजरनेम उपलब्धता जांचें',
    'username_invalid': 'कम से कम 3 अक्षर',
    'username_invalid_min5': 'यूजरनेम कम से कम 5 अक्षर का होना चाहिए',
    'username_taken': 'यह यूजरनेम पहले से लिया गया है',
    'username_ok': 'यूजरनेम उपलब्ध है!',
    'check': 'जांचें',
    'available': 'उपलब्ध ✓',
    'email_label': 'ईमेल पता',
    'email_hint': 'naam@udaahran.com',
    'email_invalid': 'वैध ईमेल दर्ज करें',
    'email_not_verified': 'पहले ईमेल सत्यापित करें',
    'email_verified': 'ईमेल सत्यापित!',
    'get_code': 'कोड पाएं',
    'resend_code': 'फिर से भेजें',
    'verify_email': 'सत्यापित करें →',
    'code_sent': 'कोड भेज दिया गया!',
    'invalid_code': 'सभी 4 अंक दर्ज करें',
    'phone_optional': 'फोन नंबर (वैकल्पिक)',
    'phone_hint': 'फोन नंबर दर्ज करें',
    'phone_invalid': 'एक वैध फोन नंबर दर्ज करें (कम से कम 6 अंक)',
    'password_label': 'पासवर्ड',
    'password_hint': 'नया पासवर्ड (न्यूनतम 6)',
    'confirm_password': 'पासवर्ड की पुष्टि करें',
    'password_short': 'कम से कम 6 अक्षर',
    'password_mismatch': 'पासवर्ड मेल नहीं खाते',
    'birthday_label': 'जन्मदिन',
    'birthday_required': 'जन्म तिथि चुनें',
    'gender_label': 'लिंग',
    'gender_required': 'लिंग चुनें',
    'male': 'पुरुष',
    'female': 'महिला',
    'other': 'अन्य',
    'sign_up': 'साइन अप',
    'agree_to': 'साइन अप करके, आप हमारी',
    'terms': 'सेवा शर्तों से सहमत हैं',
    'add_photo': 'फोटो जोड़ें',
    'camera': 'कैमरा',
    'search_country': 'देश या कोड खोजें...',
    'no_results': 'कोई परिणाम नहीं मिला',
  },
  'PT': {
    'create_account': 'Criar conta',
    'gallery': 'Galeria',
    'google_photos': 'Google Fotos',
    'full_name': 'NOME COMPLETO',
    'full_name_hint': 'João Silva',
    'fullname_required': 'Nome é obrigatório',
    'username_label': 'NOME DE USUÁRIO',
    'username_hint': 'joao_connect',
    'username_hint_min5': 'Mínimo 5 caracteres',
    'username_required': 'Verifique a disponibilidade',
    'username_invalid': 'Mínimo 3 caracteres',
    'username_invalid_min5': 'O nome de usuário deve ter pelo menos 5 caracteres',
    'username_taken': 'Este nome já está em uso',
    'username_ok': 'Nome disponível!',
    'check': 'Verificar',
    'available': 'Disponível ✓',
    'email_label': 'ENDEREÇO DE E-MAIL',
    'email_hint': 'nome@exemplo.com',
    'email_invalid': 'Digite um e-mail válido',
    'email_not_verified': 'Verifique seu e-mail primeiro',
    'email_verified': 'E-mail verificado!',
    'get_code': 'Código',
    'resend_code': 'Reenviar',
    'verify_email': 'Verificar →',
    'code_sent': 'Código enviado!',
    'invalid_code': 'Digite os 4 dígitos',
    'phone_optional': 'TELEFONE (OPCIONAL)',
    'phone_hint': 'Digite o número de telefone',
    'phone_invalid': 'Digite um número válido (pelo menos 6 dígitos)',
    'password_label': 'SENHA',
    'password_hint': 'Nova senha (mín. 6)',
    'confirm_password': 'Confirmar senha',
    'password_short': 'Mínimo 6 caracteres',
    'password_mismatch': 'As senhas não coincidem',
    'birthday_label': 'DATA DE NASCIMENTO',
    'birthday_required': 'Selecione sua data de nascimento',
    'gender_label': 'GÊNERO',
    'gender_required': 'Selecione seu gênero',
    'male': 'Masc.',
    'female': 'Fem.',
    'other': 'Outro',
    'sign_up': 'Cadastrar',
    'agree_to': 'Ao se cadastrar, você concorda com nossos',
    'terms': 'Termos de Serviço',
    'add_photo': 'Adicionar foto',
    'camera': 'Câmera',
    'search_country': 'Pesquisar país ou código...',
    'no_results': 'Nenhum resultado encontrado',
  },
  'ZH': {
    'create_account': '创建账户',
    'gallery': '图库',
    'google_photos': 'Google相册',
    'full_name': '全名',
    'full_name_hint': '张伟',
    'fullname_required': '全名为必填项',
    'username_label': '用户名',
    'username_hint': 'zhang_connect',
    'username_hint_min5': '至少5个字符',
    'username_required': '请检查用户名可用性',
    'username_invalid': '至少3个字符',
    'username_invalid_min5': '用户名必须至少5个字符',
    'username_taken': '此用户名已被使用',
    'username_ok': '用户名可用！',
    'check': '检查',
    'available': '可用 ✓',
    'email_label': '电子邮件地址',
    'email_hint': 'name@example.com',
    'email_invalid': '请输入有效的电子邮件',
    'email_not_verified': '请先验证邮箱',
    'email_verified': '邮箱已验证！',
    'get_code': '获取验证码',
    'resend_code': '重新发送',
    'verify_email': '验证 →',
    'code_sent': '验证码已发送！',
    'invalid_code': '请输入所有4位数字',
    'phone_optional': '手机号（可选）',
    'phone_hint': '输入手机号码',
    'phone_invalid': '请输入有效的手机号码（至少6位数字）',
    'password_label': '密码',
    'password_hint': '新密码（最少6位）',
    'confirm_password': '确认密码',
    'password_short': '至少6个字符',
    'password_mismatch': '密码不匹配',
    'birthday_label': '生日',
    'birthday_required': '请选择您的出生日期',
    'gender_label': '性别',
    'gender_required': '请选择您的性别',
    'male': '男',
    'female': '女',
    'other': '其他',
    'sign_up': '注册',
    'agree_to': '注册即表示您同意我们的',
    'terms': '服务条款',
    'add_photo': '添加照片',
    'camera': '相机',
    'search_country': '搜索国家或代码...',
    'no_results': '未找到结果',
  },
  'JA': {
    'create_account': 'アカウント作成',
    'gallery': 'ギャラリー',
    'google_photos': 'Googleフォト',
    'full_name': 'フルネーム',
    'full_name_hint': '山田 太郎',
    'fullname_required': 'フルネームは必須です',
    'username_label': 'ユーザー名',
    'username_hint': 'yamada_connect',
    'username_hint_min5': '最小5文字',
    'username_required': 'ユーザー名の確認をしてください',
    'username_invalid': '3文字以上必要です',
    'username_invalid_min5': 'ユーザー名は5文字以上必要です',
    'username_taken': 'このユーザー名は使用中です',
    'username_ok': 'ユーザー名は使用可能です！',
    'check': '確認',
    'available': '利用可能 ✓',
    'email_label': 'メールアドレス',
    'email_hint': 'name@example.com',
    'email_invalid': '有効なメールを入力してください',
    'email_not_verified': 'まずメールを確認してください',
    'email_verified': 'メール確認済み！',
    'get_code': 'コード取得',
    'resend_code': '再送信',
    'verify_email': '確認 →',
    'code_sent': 'コードを送信しました！',
    'invalid_code': '4桁すべて入力してください',
    'phone_optional': '電話番号（任意）',
    'phone_hint': '電話番号を入力',
    'phone_invalid': '有効な電話番号を入力してください（6桁以上）',
    'password_label': 'パスワード',
    'password_hint': '新しいパスワード（6文字以上）',
    'confirm_password': 'パスワードの確認',
    'password_short': '6文字以上必要です',
    'password_mismatch': 'パスワードが一致しません',
    'birthday_label': '誕生日',
    'birthday_required': '生年月日を選択してください',
    'gender_label': '性別',
    'gender_required': '性別を選択してください',
    'male': '男性',
    'female': '女性',
    'other': 'その他',
    'sign_up': 'サインアップ',
    'agree_to': 'サインアップすることで、',
    'terms': '利用規約に同意します',
    'add_photo': '写真を追加',
    'camera': 'カメラ',
    'search_country': '国名またはコードを検索...',
    'no_results': '結果が見つかりません',
  },
};