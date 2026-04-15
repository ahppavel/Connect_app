import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  final String languageCode;
  final String initialName;
  final String initialUsername;
  final String initialEmail;
  final String initialBio;

  const ProfileScreen({
    super.key,
    required this.languageCode,
    required this.initialName,
    required this.initialUsername,
    this.initialEmail = '',
    this.initialBio = '',
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  static const Color primary = Color(0xFF9d4d36);
  static const Color bg = Color(0xFFF7F9FC);
  static const Color inputBg = Color(0xFFEEEFF4);

  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _usernameController;
  File? _profileImage;
  bool _hasChanges = false;
  bool _isSaving = false;

  // 20-day username lock
  DateTime? _lastUsernameChange;

  final List<Map<String, String>> _links = [];

  late AnimationController _saveAnimController;
  late Animation<double> _saveScaleAnim;

  
  String _t(String key) {
    final Map<String, Map<String, String>> tr = {
      'EN': {
        'profile': 'Profile',
        'name': 'Name',
        'username': 'Username',
        'email': 'Email',
        'bio': 'Bio',
        'save': 'Save',
        'edit_name': 'Edit Name',
        'edit_bio': 'Edit Bio',
        'edit_username': 'Change Username',
        'hint_name': 'Your full name',
        'hint_bio': 'Write something about yourself...',
        'hint_username': 'Enter new username',
        'username_lock': 'You can change your username in',
        'username_lock_days': 'days',
        'username_warning': '⚠️ You can only change your username once every 20 days.',
        'username_min_length': 'Username must be at least 3 characters',
        'username_locked': 'Username (locked',
        'add_your_name': 'Add your name',
        'add_bio': 'Add a bio...',
        'about': 'About',
        'links': 'Links',
        'add_link': 'Add Link',
        'edit_link': 'Edit Link',
        'display_name': 'Display Name',
        'link_url': 'Link (URL)',
        'link_name_hint': 'e.g. Facebook, Instagram, YouTube',
        'link_url_hint': 'https://...',
        'url_invalid': 'URL must start with https://',
        'name_required': 'Enter a display name',
        'url_required': 'Enter a URL',
        'max_links_reached': 'Maximum 4 links reached',
        'add_links': 'Add links',
        'saved': 'Profile saved!',
        'email_address': 'Email address',
        'no_email': 'No email provided',
        'done': 'Done',
        'save_username': 'Save Username',
        'edit_photo': 'Edit photo',
        'change_photo': 'Change Profile Photo',
        'choose_gallery': 'Choose from Gallery',
        'take_photo': 'Take Photo',
        'remove_photo': 'Remove Photo',
      },
      'BN': {
        'profile': 'প্রোফাইল',
        'name': 'নাম',
        'username': 'ব্যবহারকারীর নাম',
        'email': 'ইমেইল',
        'bio': 'বায়ো',
        'save': 'সংরক্ষণ',
        'edit_name': 'নাম সম্পাদনা',
        'edit_bio': 'বায়ো সম্পাদনা',
        'edit_username': 'ব্যবহারকারীর নাম পরিবর্তন',
        'hint_name': 'আপনার পুরো নাম',
        'hint_bio': 'নিজের সম্পর্কে কিছু লিখুন...',
        'hint_username': 'নতুন ব্যবহারকারীর নাম লিখুন',
        'username_lock': 'আপনি আরও',
        'username_lock_days': 'দিন পর ব্যবহারকারীর নাম পরিবর্তন করতে পারবেন',
        'username_warning': '⚠️ আপনি শুধুমাত্র ২০ দিনে একবার ব্যবহারকারীর নাম পরিবর্তন করতে পারবেন।',
        'username_min_length': 'ব্যবহারকারীর নাম কমপক্ষে ৩ অক্ষরের হতে হবে',
        'username_locked': 'ব্যবহারকারীর নাম (লক করা আছে',
        'add_your_name': 'আপনার নাম যোগ করুন',
        'add_bio': 'একটি বায়ো যোগ করুন...',
        'about': 'সম্পর্কে',
        'links': 'লিংক',
        'add_link': 'লিংক যোগ করুন',
        'edit_link': 'লিংক সম্পাদনা',
        'display_name': 'প্রদর্শনের নাম',
        'link_url': 'লিংক (URL)',
        'link_name_hint': 'যেমন: ফেসবুক, ইনস্টাগ্রাম, ইউটিউব',
        'link_url_hint': 'https://...',
        'url_invalid': 'URL অবশ্যই https:// দিয়ে শুরু হবে',
        'name_required': 'একটি প্রদর্শনের নাম লিখুন',
        'url_required': 'একটি URL লিখুন',
        'max_links_reached': 'সর্বোচ্চ ৪টি লিংক যোগ করা যাবে',
        'add_links': 'লিংক যোগ করুন',
        'saved': 'প্রোফাইল সংরক্ষিত!',
        'email_address': 'ইমেইল ঠিকানা',
        'no_email': 'কোনো ইমেইল নেই',
        'done': 'সম্পন্ন',
        'save_username': 'ব্যবহারকারীর নাম সংরক্ষণ',
        'edit_photo': 'ছবি সম্পাদনা',
        'change_photo': 'প্রোফাইল ছবি পরিবর্তন',
        'choose_gallery': 'গ্যালারি থেকে নির্বাচন',
        'take_photo': 'ছবি তুলুন',
        'remove_photo': 'ছবি সরান',
      },
      'RU': {
        'profile': 'Профиль',
        'name': 'Имя',
        'username': 'Имя пользователя',
        'email': 'Эл. почта',
        'bio': 'О себе',
        'save': 'Сохранить',
        'edit_name': 'Изменить имя',
        'edit_bio': 'Изменить описание',
        'edit_username': 'Сменить имя пользователя',
        'hint_name': 'Ваше полное имя',
        'hint_bio': 'Напишите что-то о себе...',
        'hint_username': 'Введите новое имя пользователя',
        'username_lock': 'Вы сможете сменить имя через',
        'username_lock_days': 'дней',
        'username_warning': '⚠️ Вы можете менять имя пользователя только раз в 20 дней.',
        'username_min_length': 'Имя должно содержать минимум 3 символа',
        'username_locked': 'Имя (заблокировано',
        'add_your_name': 'Добавьте имя',
        'add_bio': 'Добавьте описание...',
        'about': 'О себе',
        'links': 'Ссылки',
        'add_link': 'Добавить ссылку',
        'edit_link': 'Изменить ссылку',
        'display_name': 'Отображаемое имя',
        'link_url': 'Ссылка (URL)',
        'link_name_hint': 'например: Facebook, Instagram, YouTube',
        'link_url_hint': 'https://...',
        'url_invalid': 'URL должен начинаться с https://',
        'name_required': 'Введите отображаемое имя',
        'url_required': 'Введите URL',
        'max_links_reached': 'Максимум 4 ссылки',
        'add_links': 'Добавить ссылки',
        'saved': 'Профиль сохранён!',
        'email_address': 'Адрес эл. почты',
        'no_email': 'Эл. почта не указана',
        'done': 'Готово',
        'save_username': 'Сохранить имя',
        'edit_photo': 'Изменить фото',
        'change_photo': 'Изменить фото профиля',
        'choose_gallery': 'Выбрать из галереи',
        'take_photo': 'Сделать фото',
        'remove_photo': 'Удалить фото',
      },
      'AR': {
        'profile': 'الملف الشخصي',
        'name': 'الاسم',
        'username': 'اسم المستخدم',
        'email': 'البريد الإلكتروني',
        'bio': 'السيرة الذاتية',
        'save': 'حفظ',
        'edit_name': 'تعديل الاسم',
        'edit_bio': 'تعديل السيرة',
        'edit_username': 'تغيير اسم المستخدم',
        'hint_name': 'اسمك الكامل',
        'hint_bio': 'اكتب شيئًا عن نفسك...',
        'hint_username': 'أدخل اسم المستخدم الجديد',
        'username_lock': 'يمكنك تغيير اسم المستخدم بعد',
        'username_lock_days': 'يوم',
        'username_warning': '⚠️ يمكنك تغيير اسم المستخدم مرة واحدة فقط كل 20 يومًا.',
        'username_min_length': 'يجب أن يكون اسم المستخدم 3 أحرف على الأقل',
        'username_locked': 'اسم المستخدم (مقفل',
        'add_your_name': 'أضف اسمك',
        'add_bio': 'أضف سيرة...',
        'about': 'عن',
        'links': 'الروابط',
        'add_link': 'إضافة رابط',
        'edit_link': 'تعديل الرابط',
        'display_name': 'الاسم المعروض',
        'link_url': 'الرابط (URL)',
        'link_name_hint': 'مثال: فيسبوك، إنستغرام، يوتيوب',
        'link_url_hint': 'https://...',
        'url_invalid': 'يجب أن يبدأ الرابط بـ https://',
        'name_required': 'أدخل اسمًا معروضًا',
        'url_required': 'أدخل رابطًا',
        'max_links_reached': 'تم الوصول إلى الحد الأقصى 4 روابط',
        'add_links': 'أضف روابط',
        'saved': 'تم حفظ الملف الشخصي!',
        'email_address': 'عنوان البريد الإلكتروني',
        'no_email': 'لا يوجد بريد إلكتروني',
        'done': 'تم',
        'save_username': 'حفظ اسم المستخدم',
        'edit_photo': 'تعديل الصورة',
        'change_photo': 'تغيير صورة الملف الشخصي',
        'choose_gallery': 'اختر من المعرض',
        'take_photo': 'التقاط صورة',
        'remove_photo': 'إزالة الصورة',
      },
      'ES': {
        'profile': 'Perfil',
        'name': 'Nombre',
        'username': 'Usuario',
        'email': 'Correo',
        'bio': 'Biografía',
        'save': 'Guardar',
        'edit_name': 'Editar nombre',
        'edit_bio': 'Editar biografía',
        'edit_username': 'Cambiar usuario',
        'hint_name': 'Tu nombre completo',
        'hint_bio': 'Escribe algo sobre ti...',
        'hint_username': 'Nuevo nombre de usuario',
        'username_lock': 'Puedes cambiar tu usuario en',
        'username_lock_days': 'días',
        'username_warning': '⚠️ Solo puedes cambiar el usuario cada 20 días.',
        'username_min_length': 'El usuario debe tener al menos 3 caracteres',
        'username_locked': 'Usuario (bloqueado',
        'add_your_name': 'Añade tu nombre',
        'add_bio': 'Añade una biografía...',
        'about': 'Acerca de',
        'links': 'Enlaces',
        'add_link': 'Añadir enlace',
        'edit_link': 'Editar enlace',
        'display_name': 'Nombre a mostrar',
        'link_url': 'Enlace (URL)',
        'link_name_hint': 'ej. Facebook, Instagram, YouTube',
        'link_url_hint': 'https://...',
        'url_invalid': 'La URL debe empezar con https://',
        'name_required': 'Ingresa un nombre a mostrar',
        'url_required': 'Ingresa una URL',
        'max_links_reached': 'Máximo 4 enlaces alcanzado',
        'add_links': 'Añadir enlaces',
        'saved': '¡Perfil guardado!',
        'email_address': 'Correo electrónico',
        'no_email': 'No hay correo',
        'done': 'Listo',
        'save_username': 'Guardar usuario',
        'edit_photo': 'Editar foto',
        'change_photo': 'Cambiar foto de perfil',
        'choose_gallery': 'Elegir de galería',
        'take_photo': 'Tomar foto',
        'remove_photo': 'Eliminar foto',
      },
      'FR': {
        'profile': 'Profil',
        'name': 'Nom',
        'username': "Nom d'utilisateur",
        'email': 'E-mail',
        'bio': 'Bio',
        'save': 'Enregistrer',
        'edit_name': 'Modifier le nom',
        'edit_bio': 'Modifier la bio',
        'edit_username': "Changer d'utilisateur",
        'hint_name': 'Votre nom complet',
        'hint_bio': 'Parlez de vous...',
        'hint_username': "Nouveau nom d'utilisateur",
        'username_lock': 'Vous pourrez changer dans',
        'username_lock_days': 'jours',
        'username_warning': "⚠️ Changement d'utilisateur possible tous les 20 jours.",
        'username_min_length': '3 caractères minimum',
        'username_locked': "Utilisateur (bloqué",
        'add_your_name': 'Ajoutez votre nom',
        'add_bio': 'Ajoutez une bio...',
        'about': 'À propos',
        'links': 'Liens',
        'add_link': 'Ajouter un lien',
        'edit_link': 'Modifier le lien',
        'display_name': 'Nom affiché',
        'link_url': 'Lien (URL)',
        'link_name_hint': 'ex: Facebook, Instagram, YouTube',
        'link_url_hint': 'https://...',
        'url_invalid': "L'URL doit commencer par https://",
        'name_required': 'Entrez un nom affiché',
        'url_required': 'Entrez une URL',
        'max_links_reached': 'Maximum 4 liens atteint',
        'add_links': 'Ajouter des liens',
        'saved': 'Profil enregistré !',
        'email_address': 'Adresse e-mail',
        'no_email': 'Pas d\'e-mail',
        'done': 'Terminé',
        'save_username': "Enregistrer l'utilisateur",
        'edit_photo': 'Modifier la photo',
        'change_photo': 'Changer la photo de profil',
        'choose_gallery': 'Choisir dans la galerie',
        'take_photo': 'Prendre une photo',
        'remove_photo': 'Supprimer la photo',
      },
      'HI': {
        'profile': 'प्रोफ़ाइल',
        'name': 'नाम',
        'username': 'उपयोगकर्ता नाम',
        'email': 'ईमेल',
        'bio': 'जीवन परिचय',
        'save': 'सहेजें',
        'edit_name': 'नाम संपादित करें',
        'edit_bio': 'जीवन परिचय संपादित करें',
        'edit_username': 'उपयोगकर्ता नाम बदलें',
        'hint_name': 'आपका पूरा नाम',
        'hint_bio': 'अपने बारे में कुछ लिखें...',
        'hint_username': 'नया उपयोगकर्ता नाम',
        'username_lock': 'आप उपयोगकर्ता नाम बदल सकते हैं',
        'username_lock_days': 'दिनों में',
        'username_warning': '⚠️ आप हर 20 दिनों में केवल एक बार उपयोगकर्ता नाम बदल सकते हैं।',
        'username_min_length': 'उपयोगकर्ता नाम कम से कम 3 अक्षर का होना चाहिए',
        'username_locked': 'उपयोगकर्ता नाम (लॉक है',
        'add_your_name': 'अपना नाम जोड़ें',
        'add_bio': 'एक जीवन परिचय जोड़ें...',
        'about': 'परिचय',
        'links': 'लिंक',
        'add_link': 'लिंक जोड़ें',
        'edit_link': 'लिंक संपादित करें',
        'display_name': 'प्रदर्शित नाम',
        'link_url': 'लिंक (URL)',
        'link_name_hint': 'जैसे: फेसबुक, इंस्टाग्राम, यूट्यूब',
        'link_url_hint': 'https://...',
        'url_invalid': 'URL https:// से शुरू होना चाहिए',
        'name_required': 'प्रदर्शित नाम दर्ज करें',
        'url_required': 'URL दर्ज करें',
        'max_links_reached': 'अधिकतम 4 लिंक हो गए',
        'add_links': 'लिंक जोड़ें',
        'saved': 'प्रोफ़ाइल सहेजी गई!',
        'email_address': 'ईमेल पता',
        'no_email': 'कोई ईमेल नहीं',
        'done': 'हो गया',
        'save_username': 'उपयोगकर्ता नाम सहेजें',
        'edit_photo': 'फोटो संपादित करें',
        'change_photo': 'प्रोफ़ाइल फोटो बदलें',
        'choose_gallery': 'गैलरी से चुनें',
        'take_photo': 'फोटो लें',
        'remove_photo': 'फोटो हटाएँ',
      },
      'PT': {
        'profile': 'Perfil',
        'name': 'Nome',
        'username': 'Usuário',
        'email': 'E-mail',
        'bio': 'Bio',
        'save': 'Salvar',
        'edit_name': 'Editar nome',
        'edit_bio': 'Editar bio',
        'edit_username': 'Alterar usuário',
        'hint_name': 'Seu nome completo',
        'hint_bio': 'Escreva algo sobre você...',
        'hint_username': 'Novo nome de usuário',
        'username_lock': 'Você pode alterar o usuário em',
        'username_lock_days': 'dias',
        'username_warning': '⚠️ Você só pode alterar o usuário a cada 20 dias.',
        'username_min_length': 'O usuário deve ter pelo menos 3 caracteres',
        'username_locked': 'Usuário (bloqueado',
        'add_your_name': 'Adicione seu nome',
        'add_bio': 'Adicione uma bio...',
        'about': 'Sobre',
        'links': 'Links',
        'add_link': 'Adicionar link',
        'edit_link': 'Editar link',
        'display_name': 'Nome de exibição',
        'link_url': 'Link (URL)',
        'link_name_hint': 'ex: Facebook, Instagram, YouTube',
        'link_url_hint': 'https://...',
        'url_invalid': 'A URL deve começar com https://',
        'name_required': 'Digite um nome de exibição',
        'url_required': 'Digite uma URL',
        'max_links_reached': 'Máximo de 4 links atingido',
        'add_links': 'Adicionar links',
        'saved': 'Perfil salvo!',
        'email_address': 'Endereço de e-mail',
        'no_email': 'Nenhum e-mail',
        'done': 'Pronto',
        'save_username': 'Salvar usuário',
        'edit_photo': 'Editar foto',
        'change_photo': 'Alterar foto do perfil',
        'choose_gallery': 'Escolher da galeria',
        'take_photo': 'Tirar foto',
        'remove_photo': 'Remover foto',
      },
      'ZH': {
        'profile': '个人资料',
        'name': '姓名',
        'username': '用户名',
        'email': '电子邮件',
        'bio': '个人简介',
        'save': '保存',
        'edit_name': '编辑姓名',
        'edit_bio': '编辑简介',
        'edit_username': '更改用户名',
        'hint_name': '您的全名',
        'hint_bio': '写一些关于你自己的事...',
        'hint_username': '输入新用户名',
        'username_lock': '您可以在',
        'username_lock_days': '天后更改用户名',
        'username_warning': '⚠️ 每20天只能更改一次用户名。',
        'username_min_length': '用户名至少需要3个字符',
        'username_locked': '用户名（已锁定',
        'add_your_name': '添加您的姓名',
        'add_bio': '添加简介...',
        'about': '关于',
        'links': '链接',
        'add_link': '添加链接',
        'edit_link': '编辑链接',
        'display_name': '显示名称',
        'link_url': '链接（URL）',
        'link_name_hint': '例如：Facebook、Instagram、YouTube',
        'link_url_hint': 'https://...',
        'url_invalid': 'URL必须以https://开头',
        'name_required': '输入显示名称',
        'url_required': '输入URL',
        'max_links_reached': '已达到最多4个链接',
        'add_links': '添加链接',
        'saved': '个人资料已保存！',
        'email_address': '电子邮件地址',
        'no_email': '未提供电子邮件',
        'done': '完成',
        'save_username': '保存用户名',
        'edit_photo': '编辑照片',
        'change_photo': '更改个人资料照片',
        'choose_gallery': '从相册选择',
        'take_photo': '拍照',
        'remove_photo': '移除照片',
      },
      'JA': {
        'profile': 'プロフィール',
        'name': '名前',
        'username': 'ユーザー名',
        'email': 'メール',
        'bio': '自己紹介',
        'save': '保存',
        'edit_name': '名前を編集',
        'edit_bio': '自己紹介を編集',
        'edit_username': 'ユーザー名を変更',
        'hint_name': 'あなたのフルネーム',
        'hint_bio': 'あなたについて書いてください...',
        'hint_username': '新しいユーザー名',
        'username_lock': 'ユーザー名変更可能まで',
        'username_lock_days': '日',
        'username_warning': '⚠️ ユーザー名は20日に1回しか変更できません。',
        'username_min_length': 'ユーザー名は3文字以上必要です',
        'username_locked': 'ユーザー名（ロック中',
        'add_your_name': '名前を追加',
        'add_bio': '自己紹介を追加...',
        'about': '概要',
        'links': 'リンク',
        'add_link': 'リンクを追加',
        'edit_link': 'リンクを編集',
        'display_name': '表示名',
        'link_url': 'リンク（URL）',
        'link_name_hint': '例：Facebook、Instagram、YouTube',
        'link_url_hint': 'https://...',
        'url_invalid': 'URLはhttps://で始まる必要があります',
        'name_required': '表示名を入力してください',
        'url_required': 'URLを入力してください',
        'max_links_reached': '最大4リンクに達しました',
        'add_links': 'リンクを追加',
        'saved': 'プロフィールを保存しました！',
        'email_address': 'メールアドレス',
        'no_email': 'メールアドレスなし',
        'done': '完了',
        'save_username': 'ユーザー名を保存',
        'edit_photo': '写真を編集',
        'change_photo': 'プロフィール写真を変更',
        'choose_gallery': 'ギャラリーから選択',
        'take_photo': '写真を撮る',
        'remove_photo': '写真を削除',
      },
    };
    final code = widget.languageCode.toUpperCase();
    return tr[code]?[key] ?? tr['EN']![key]!;
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _bioController = TextEditingController(text: widget.initialBio);
    _usernameController = TextEditingController(text: widget.initialUsername);

    _nameController.addListener(_onChanged);
    _bioController.addListener(_onChanged);

    _saveAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _saveScaleAnim = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _saveAnimController, curve: Curves.easeInOut),
    );
  }

  void _onChanged() => setState(() => _hasChanges = true);

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    _saveAnimController.dispose();
    super.dispose();
  }

  int get _daysUntilUsernameChange {
    if (_lastUsernameChange == null) return 0;
    final diff = 20 - DateTime.now().difference(_lastUsernameChange!).inDays;
    return diff > 0 ? diff : 0;
  }

  bool get _canChangeUsername => _daysUntilUsernameChange == 0;

  
  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(99)),
            ),
            const SizedBox(height: 20),
            Text(_t('change_photo'),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[800])),
            const SizedBox(height: 20),
            _photoOption(Icons.photo_library_outlined, _t('choose_gallery'), () async {
              Navigator.pop(context);
              final picked = await ImagePicker()
                  .pickImage(source: ImageSource.gallery, imageQuality: 85);
              if (picked != null && mounted) {
                setState(() {
                  _profileImage = File(picked.path);
                  _hasChanges = true;
                });
              }
            }),
            const SizedBox(height: 10),
            _photoOption(Icons.camera_alt_outlined, _t('take_photo'), () async {
              Navigator.pop(context);
              final picked = await ImagePicker()
                  .pickImage(source: ImageSource.camera, imageQuality: 85);
              if (picked != null && mounted) {
                setState(() {
                  _profileImage = File(picked.path);
                  _hasChanges = true;
                });
              }
            }),
            if (_profileImage != null) ...[
              const SizedBox(height: 10),
              _photoOption(Icons.delete_outline, _t('remove_photo'), () {
                Navigator.pop(context);
                setState(() {
                  _profileImage = null;
                  _hasChanges = true;
                });
              }, color: Colors.red),
            ],
          ],
        ),
      ),
    );
  }

  Widget _photoOption(IconData icon, String label, VoidCallback onTap,
      {Color? color}) {
    return Material(
      color: inputBg,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: color ?? primary, size: 22),
              const SizedBox(width: 14),
              Text(label,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: color ?? const Color(0xFF191c1e))),
            ],
          ),
        ),
      ),
    );
  }


  void _editField({
    required String title,
    required TextEditingController controller,
    required String hint,
    int maxLength = 60,
    int maxLines = 1,
  }) {
    final tempController = TextEditingController(text: controller.text);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 24, right: 24, top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(99)),
              ),
            ),
            const SizedBox(height: 20),
            Text(title,
                style: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w800,
                    color: Color(0xFF191c1e))),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                  color: inputBg, borderRadius: BorderRadius.circular(14)),
              child: TextField(
                controller: tempController,
                maxLength: maxLength,
                maxLines: maxLines,
                autofocus: true,
                style: const TextStyle(fontSize: 15),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                  counterStyle: TextStyle(color: Colors.grey[400], fontSize: 11),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  controller.text = tempController.text.trim();
                  setState(() => _hasChanges = true);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999)),
                  elevation: 0,
                ),
                child: Text(_t('done'),
                    style: const TextStyle(
                        color: Colors.white, fontSize: 16,
                        fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  void _editUsername() {
    if (!_canChangeUsername) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🔒 ${_t('username_lock')} $_daysUntilUsernameChange ${_t('username_lock_days')}'),
          backgroundColor: primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    final tempController = TextEditingController(text: _usernameController.text);
    String error = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setInner) => Padding(
          padding: EdgeInsets.only(
            left: 24, right: 24, top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(99)),
                ),
              ),
              const SizedBox(height: 20),
              Text(_t('edit_username'),
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w800,
                      color: Color(0xFF191c1e))),
              const SizedBox(height: 6),
              Text(_t('username_warning'),
                  style: TextStyle(fontSize: 13, color: Colors.orange[700])),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                    color: inputBg, borderRadius: BorderRadius.circular(14)),
                child: TextField(
                  controller: tempController,
                  maxLength: 30,
                  autofocus: true,
                  style: const TextStyle(fontSize: 15),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_]')),
                  ],
                  decoration: InputDecoration(
                    hintText: _t('hint_username'),
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
                    prefixText: '@',
                    prefixStyle: TextStyle(
                        color: primary, fontWeight: FontWeight.w600, fontSize: 15),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                    counterStyle: TextStyle(color: Colors.grey[400], fontSize: 11),
                  ),
                ),
              ),
              if (error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: Text(error,
                      style: const TextStyle(color: Colors.red, fontSize: 12)),
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    final newUsername = tempController.text.trim();
                    if (newUsername.length < 3) {
                      setInner(() => error = _t('username_min_length'));
                      return;
                    }
                    setState(() {
                      _usernameController.text = newUsername;
                      _lastUsernameChange = DateTime.now();
                      _hasChanges = true;
                    });
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999)),
                    elevation: 0,
                  ),
                  child: Text(_t('save_username'),
                      style: const TextStyle(
                          color: Colors.white, fontSize: 16,
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
  void _showAddLinkDialog({int? editIndex}) {
    final nameCtrl = TextEditingController(
        text: editIndex != null ? _links[editIndex]['name'] : '');
    final urlCtrl = TextEditingController(
        text: editIndex != null ? _links[editIndex]['url'] : '');
    String nameError = '';
    String urlError = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setInner) => Padding(
          padding: EdgeInsets.only(
            left: 24, right: 24, top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(99)),
                ),
              ),
              const SizedBox(height: 20),
              Text(editIndex != null ? _t('edit_link') : _t('add_link'),
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w800,
                      color: Color(0xFF191c1e))),
              const SizedBox(height: 16),
              Text(_t('display_name'),
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600,
                      color: Colors.grey[600])),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                    color: inputBg, borderRadius: BorderRadius.circular(14)),
                child: TextField(
                  controller: nameCtrl,
                  maxLength: 30,
                  decoration: InputDecoration(
                    hintText: _t('link_name_hint'),
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    counterText: '',
                  ),
                ),
              ),
              if (nameError.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: Text(nameError,
                      style: const TextStyle(color: Colors.red, fontSize: 12)),
                ),
              const SizedBox(height: 12),
              Text(_t('link_url'),
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600,
                      color: Colors.grey[600])),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                    color: inputBg, borderRadius: BorderRadius.circular(14)),
                child: TextField(
                  controller: urlCtrl,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    hintText: _t('link_url_hint'),
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              if (urlError.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: Text(urlError,
                      style: const TextStyle(color: Colors.red, fontSize: 12)),
                ),
              const SizedBox(height: 20),
              Row(
                children: [
                  if (editIndex != null) ...[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _links.removeAt(editIndex);
                          _hasChanges = true;
                        });
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(14)),
                        child: const Icon(Icons.delete_outline,
                            color: Colors.red, size: 22),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          final name = nameCtrl.text.trim();
                          final url = urlCtrl.text.trim();
                          bool valid = true;
                          setInner(() { nameError = ''; urlError = ''; });

                          if (name.isEmpty) {
                            setInner(() => nameError = _t('name_required'));
                            valid = false;
                          }
                          if (url.isEmpty) {
                            setInner(() => urlError = _t('url_required'));
                            valid = false;
                          } else if (!url.startsWith('http://') &&
                              !url.startsWith('https://')) {
                            setInner(() => urlError = _t('url_invalid'));
                            valid = false;
                          }

                          if (valid) {
                            setState(() {
                              if (editIndex != null) {
                                _links[editIndex] = {'name': name, 'url': url};
                              } else {
                                _links.add({'name': name, 'url': url});
                              }
                              _hasChanges = true;
                            });
                            Navigator.pop(ctx);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999)),
                          elevation: 0,
                        ),
                        child: Text(_t('save'),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // Save profile 
  Future<void> _saveProfile() async {
    if (_isSaving) return;
    HapticFeedback.mediumImpact();

    setState(() => _isSaving = true);
    _saveAnimController.forward().then((_) => _saveAnimController.reverse());

    await Future.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      setState(() {
        _isSaving = false;
        _hasChanges = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(_t('saved')),
            ],
          ),
          backgroundColor: primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 2),
        ),
      );

      Navigator.pop(context, {
        'name': _nameController.text,
        'username': _usernameController.text,
      });
    }
  }

  // ── Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(_t('profile'),
            style: const TextStyle(
                color: Color(0xFF191c1e),
                fontWeight: FontWeight.w800,
                fontSize: 18)),
        actions: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _hasChanges
                ? Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ScaleTransition(
                      scale: _saveScaleAnim,
                      child: TextButton(
                        onPressed: _isSaving ? null : _saveProfile,
                        style: TextButton.styleFrom(
                          backgroundColor: primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                width: 16, height: 16,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2))
                            : Text(_t('save'),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700)),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 32),

            // Profile photo (camera overlay removed)
            Center(
              child: GestureDetector(
                onTap: _showPhotoOptions,
                child: Hero(
                  tag: 'profile_avatar',
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: primary.withOpacity(0.1),
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!) : null,
                    child: _profileImage == null
                        ? Text(
                            _nameController.text.isNotEmpty
                                ? _nameController.text[0].toUpperCase()
                                : '?',
                            style: GoogleFonts.dancingScript(
                                fontSize: 48,
                                fontWeight: FontWeight.w700,
                                color: primary))
                        : null,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            TextButton(
              onPressed: _showPhotoOptions,
              child: Text(_t('edit_photo'),
                  style: const TextStyle(
                      color: primary, fontSize: 14,
                      fontWeight: FontWeight.w600)),
            ),

            const SizedBox(height: 16),

            // Info card
            _card([
              _infoTile(
                icon: Icons.person_outline,
                label: _t('name'),
                value: _nameController.text.isEmpty
                    ? _t('add_your_name') : _nameController.text,
                editable: true,
                valueColor: _nameController.text.isEmpty
                    ? Colors.grey[400] : null,
                onTap: () => _editField(
                    title: _t('edit_name'),
                    controller: _nameController,
                    hint: _t('hint_name'),
                    maxLength: 50),
              ),
              _divider(),
              _infoTile(
                icon: Icons.info_outline,
                label: _t('about'),
                value: _bioController.text.isEmpty
                    ? _t('add_bio') : _bioController.text,
                editable: true,
                valueColor: _bioController.text.isEmpty
                    ? Colors.grey[400] : null,
                onTap: () => _editField(
                    title: _t('edit_bio'),
                    controller: _bioController,
                    hint: _t('hint_bio'),
                    maxLength: 120,
                    maxLines: 3),
              ),
              _divider(),
              // Username with lock
              _infoTile(
                icon: Icons.alternate_email,
                label: _canChangeUsername
                    ? _t('username')
                    : '${_t('username_locked')} $_daysUntilUsernameChange ${_t('username_lock_days')})',
                value: '@${_usernameController.text}',
                editable: true,
                valueColor: !_canChangeUsername ? Colors.grey[500] : null,
                trailingWidget: !_canChangeUsername
                    ? Icon(Icons.lock_clock_outlined,
                        color: Colors.orange[400], size: 18)
                    : null,
                onTap: _editUsername,
              ),
              _divider(),
              // Email - now properly displayed
              _infoTile(
                icon: Icons.email_outlined,
                label: _t('email'),
                value: widget.initialEmail.isNotEmpty
                    ? widget.initialEmail
                    : _t('no_email'),
                editable: false,
              ),
            ]),

            const SizedBox(height: 20),

            // Links card
            _card([
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.link, color: primary, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(_t('links'),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700,
                              color: Color(0xFF191c1e))),
                    ),
                    if (_links.length < 4)
                      GestureDetector(
                        onTap: _showAddLinkDialog,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.add,
                              color: primary, size: 20),
                        ),
                      ),
                  ],
                ),
              ),
              if (_links.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(
                      left: 56, right: 16, bottom: 16),
                  child: GestureDetector(
                    onTap: _showAddLinkDialog,
                    child: Text(_t('add_links'),
                        style: const TextStyle(
                            color: primary, fontSize: 14,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ..._links.asMap().entries.map((entry) {
                final index = entry.key;
                final link = entry.value;
                return Column(
                  children: [
                    _divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          const SizedBox(width: 42),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _openLink(link['url']!),
                              child: Text(
                                link['name']!,
                                style: const TextStyle(
                                    color: primary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                    decorationColor: primary),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _showAddLinkDialog(editIndex: index),
                            child: Icon(Icons.edit_outlined,
                                color: Colors.grey[400], size: 18),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
              if (_links.length == 4)
                Padding(
                  padding: const EdgeInsets.only(
                      left: 56, right: 16, bottom: 14),
                  child: Text(_t('max_links_reached'),
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey[400])),
                ),
              const SizedBox(height: 4),
            ]),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _card(List<Widget> children) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(children: children),
      );

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
    required bool editable,
    VoidCallback? onTap,
    Color? valueColor,
    Widget? trailingWidget,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: editable ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: primary, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey[500],
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 2),
                    Text(value,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600,
                            color: valueColor ?? const Color(0xFF191c1e))),
                  ],
                ),
              ),
              trailingWidget ??
                  (editable
                      ? Icon(Icons.chevron_right,
                          color: Colors.grey[300], size: 20)
                      : Icon(Icons.lock_outline,
                          color: Colors.grey[300], size: 18)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() => const Divider(
      height: 1, thickness: 1, color: Color(0xFFF2F4F7),
      indent: 56, endIndent: 0);
}