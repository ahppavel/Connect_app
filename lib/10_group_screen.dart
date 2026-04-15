import 'package:flutter/material.dart';

class NewGroupScreen extends StatefulWidget {
  final String languageCode;
  final bool isDarkMode;

  const NewGroupScreen({
    super.key,
    required this.languageCode,
    required this.isDarkMode,
  });

  @override
  State<NewGroupScreen> createState() => _NewGroupScreenState();
}

class GroupMember {
  final String id;
  final String name;
  final String username;
  final String avatarLetters;
  final Color avatarColor;
  bool isSelected;

  GroupMember({
    required this.id,
    required this.name,
    required this.username,
    required this.avatarLetters,
    required this.avatarColor,
    this.isSelected = false,
  });
}

class _NewGroupScreenState extends State<NewGroupScreen> {
  static const Color primary = Color(0xFF9d4d36);
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final List<GroupMember> _selectedMembers = [];

  // TODO: Replace with real Firebase contacts stream
  final List<GroupMember> _contacts = [];

  Color get bg => widget.isDarkMode
      ? const Color(0xFF121212)
      : const Color(0xFFF7F9FC);
  Color get cardBg =>
      widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
  Color get textPrimary =>
      widget.isDarkMode ? Colors.white : const Color(0xFF191c1e);
  Color get textSecondary =>
      widget.isDarkMode ? Colors.grey[400]! : Colors.grey[500]!;
  Color get dividerColor => widget.isDarkMode
      ? Colors.white.withOpacity(0.06)
      : Colors.grey[200]!;
  Color get inputBg => widget.isDarkMode
      ? const Color(0xFF2A2A2A)
      : const Color(0xFFEEEFF4);

  String _t(String key) {
    final Map<String, Map<String, String>> tr = {
      'EN': {
        'new_group': 'New Group',
        'search': 'Search name or number...',
        'next': 'Next',
        'selected': 'selected',
        'contacts': 'Contacts',
        'no_contacts': 'No contacts yet',
        'no_contacts_sub': 'Your contacts will appear here once\nthey join Connect.',
        'no_results': 'No results found',
      },
      'BN': {
        'new_group': 'নতুন গ্রুপ',
        'search': 'নাম বা নম্বর খুঁজুন...',
        'next': 'পরবর্তী',
        'selected': 'নির্বাচিত',
        'contacts': 'পরিচিতি',
        'no_contacts': 'এখনো কোনো পরিচিতি নেই',
        'no_contacts_sub': 'আপনার বন্ধুরা Connect-এ যোগ দিলে\nএখানে দেখা যাবে।',
        'no_results': 'কোনো ফলাফল পাওয়া যায়নি',
      },
      'RU': {
        'new_group': 'Новая группа',
        'search': 'Поиск...',
        'next': 'Далее',
        'selected': 'выбрано',
        'contacts': 'Контакты',
        'no_contacts': 'Нет контактов',
        'no_contacts_sub': 'Ваши контакты появятся здесь,\nкогда они присоединятся.',
        'no_results': 'Ничего не найдено',
      },
      'AR': {
        'new_group': 'مجموعة جديدة',
        'search': 'بحث...',
        'next': 'التالي',
        'selected': 'محدد',
        'contacts': 'جهات الاتصال',
        'no_contacts': 'لا توجد جهات اتصال',
        'no_contacts_sub': 'ستظهر جهات اتصالك هنا عند انضمامهم.',
        'no_results': 'لا توجد نتائج',
      },
      'ES': {
        'new_group': 'Nuevo grupo',
        'search': 'Buscar...',
        'next': 'Siguiente',
        'selected': 'seleccionado',
        'contacts': 'Contactos',
        'no_contacts': 'Sin contactos aún',
        'no_contacts_sub': 'Tus contactos aparecerán aquí\ncuando se unan a Connect.',
        'no_results': 'Sin resultados',
      },
      'FR': {
        'new_group': 'Nouveau groupe',
        'search': 'Rechercher...',
        'next': 'Suivant',
        'selected': 'sélectionné',
        'contacts': 'Contacts',
        'no_contacts': 'Pas encore de contacts',
        'no_contacts_sub': 'Vos contacts apparaîtront ici\nlorsqu\'ils rejoindront Connect.',
        'no_results': 'Aucun résultat',
      },
      'HI': {
        'new_group': 'नया ग्रुप',
        'search': 'खोजें...',
        'next': 'आगे',
        'selected': 'चुना गया',
        'contacts': 'संपर्क',
        'no_contacts': 'अभी कोई संपर्क नहीं',
        'no_contacts_sub': 'जब आपके संपर्क Connect से जुड़ेंगे\nतो यहाँ दिखेंगे।',
        'no_results': 'कोई परिणाम नहीं',
      },
      'PT': {
        'new_group': 'Novo grupo',
        'search': 'Pesquisar...',
        'next': 'Próximo',
        'selected': 'selecionado',
        'contacts': 'Contatos',
        'no_contacts': 'Sem contatos ainda',
        'no_contacts_sub': 'Seus contatos aparecerão aqui\nquando entrarem no Connect.',
        'no_results': 'Sem resultados',
      },
      'ZH': {
        'new_group': '新建群组',
        'search': '搜索...',
        'next': '下一步',
        'selected': '已选择',
        'contacts': '联系人',
        'no_contacts': '暂无联系人',
        'no_contacts_sub': '当您的联系人加入 Connect 后\n将在此处显示。',
        'no_results': '未找到结果',
      },
      'JA': {
        'new_group': '新しいグループ',
        'search': '検索...',
        'next': '次へ',
        'selected': '選択済み',
        'contacts': '連絡先',
        'no_contacts': '連絡先はまだありません',
        'no_contacts_sub': '連絡先が Connect に参加すると\nここに表示されます。',
        'no_results': '結果が見つかりません',
      },
    };
    final code = widget.languageCode.toUpperCase();
    return tr[code]?[key] ?? tr['EN']![key]!;
  }

  List<GroupMember> get _filteredContacts {
    if (_searchQuery.isEmpty) return _contacts;
    return _contacts
        .where((c) =>
            c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            c.username.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _t('new_group'),
              style: TextStyle(
                color: textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
            if (_selectedMembers.isNotEmpty)
              Text(
                '${_selectedMembers.length} ${_t('selected')}',
                style: TextStyle(color: primary, fontSize: 12),
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Selected members chips
          if (_selectedMembers.isNotEmpty)
            Container(
              height: 90,
              color: cardBg,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                itemCount: _selectedMembers.length,
                itemBuilder: (_, i) {
                  final m = _selectedMembers[i];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: m.avatarColor,
                              child: Text(m.avatarLetters,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700)),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    m.isSelected = false;
                                    _selectedMembers.remove(m);
                                  });
                                },
                                child: Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[600],
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: cardBg, width: 1.5),
                                  ),
                                  child: const Icon(Icons.close,
                                      color: Colors.white, size: 11),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          m.name.split(' ')[0],
                          style: TextStyle(
                              fontSize: 11, color: textSecondary),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: inputBg,
                borderRadius: BorderRadius.circular(999),
              ),
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: textPrimary, fontSize: 15),
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: InputDecoration(
                  hintText: _t('search'),
                  hintStyle:
                      TextStyle(color: textSecondary, fontSize: 14),
                  prefixIcon: Icon(Icons.search,
                      color: textSecondary, size: 20),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          // Contacts label
          Padding(
            padding:
                const EdgeInsets.only(left: 16, top: 4, bottom: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _t('contacts'),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          // Contact list or empty state
          Expanded(
            child: _filteredContacts.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    itemCount: _filteredContacts.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 0.5,
                      color: dividerColor,
                      indent: 76,
                    ),
                    itemBuilder: (_, i) {
                      final contact = _filteredContacts[i];
                      return InkWell(
                        onTap: () {
                          setState(() {
                            contact.isSelected = !contact.isSelected;
                            if (contact.isSelected) {
                              _selectedMembers.add(contact);
                            } else {
                              _selectedMembers.remove(contact);
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 26,
                                backgroundColor: contact.avatarColor,
                                child: Text(contact.avatarLetters,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15)),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(contact.name,
                                        style: TextStyle(
                                            color: textPrimary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15)),
                                    Text(contact.username,
                                        style: TextStyle(
                                            color: textSecondary,
                                            fontSize: 13)),
                                  ],
                                ),
                              ),
                              AnimatedContainer(
                                duration:
                                    const Duration(milliseconds: 200),
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: contact.isSelected
                                      ? primary
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: contact.isSelected
                                        ? primary
                                        : textSecondary,
                                    width: 2,
                                  ),
                                ),
                                child: contact.isSelected
                                    ? const Icon(Icons.check,
                                        color: Colors.white, size: 16)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // Next FAB
      floatingActionButton: _selectedMembers.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => _GroupSetupScreen(
                      languageCode: widget.languageCode,
                      isDarkMode: widget.isDarkMode,
                      members: _selectedMembers,
                    ),
                  ),
                );
              },
              backgroundColor: primary,
              child: const Icon(Icons.arrow_forward,
                  color: Colors.white, size: 26),
            )
          : null,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primary.withOpacity(0.08),
              ),
              child: Icon(
                Icons.people_outline,
                size: 44,
                color: primary.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _searchQuery.isNotEmpty
                  ? _t('no_results')
                  : _t('no_contacts'),
              style: TextStyle(
                color: textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (_searchQuery.isEmpty) ...[
              const SizedBox(height: 8),
              Text(
                _t('no_contacts_sub'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Screen 2: Group Setup
class _GroupSetupScreen extends StatefulWidget {
  final String languageCode;
  final bool isDarkMode;
  final List<GroupMember> members;

  const _GroupSetupScreen({
    required this.languageCode,
    required this.isDarkMode,
    required this.members,
  });

  @override
  State<_GroupSetupScreen> createState() => _GroupSetupScreenState();
}

class _GroupSetupScreenState extends State<_GroupSetupScreen> {
  static const Color primary = Color(0xFF9d4d36);
  final TextEditingController _nameController = TextEditingController();

  bool _membersCanEditSettings = true;
  bool _membersCanSendMessages = true;
  bool _membersCanAddOthers = true;
  bool _membersCanInviteViaLink = false;
  bool _adminsApproveNewMembers = false;
  bool _showPermissions = false;

  Color get bg => widget.isDarkMode
      ? const Color(0xFF121212)
      : const Color(0xFFF7F9FC);
  Color get cardBg =>
      widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
  Color get textPrimary =>
      widget.isDarkMode ? Colors.white : const Color(0xFF191c1e);
  Color get textSecondary =>
      widget.isDarkMode ? Colors.grey[400]! : Colors.grey[500]!;
  Color get dividerColor => widget.isDarkMode
      ? Colors.white.withOpacity(0.06)
      : Colors.grey[200]!;

  String _t(String key) {
    final Map<String, Map<String, String>> tr = {
      'EN': {
        'new_group': 'New Group',
        'group_name_hint': 'Group name (optional)',
        'group_permissions': 'Group permissions',
        'members_can': 'Members can:',
        'admins_can': 'Admins can:',
        'edit_group_settings': 'Edit group settings',
        'edit_group_settings_sub': 'Name, icon, description and more.',
        'send_messages': 'Send new messages',
        'add_members': 'Add other members',
        'invite_via_link': 'Invite via link or QR code',
        'approve_members': 'Approve new members',
        'approve_members_sub': 'Admins must approve anyone who wants to join.',
        'members': 'Members',
        'create': 'Create',
        'group_created': 'Group created!',
      },
      'BN': {
        'new_group': 'নতুন গ্রুপ',
        'group_name_hint': 'গ্রুপের নাম (ঐচ্ছিক)',
        'group_permissions': 'গ্রুপ অনুমতি',
        'members_can': 'সদস্যরা পারবেন:',
        'admins_can': 'অ্যাডমিনরা পারবেন:',
        'edit_group_settings': 'গ্রুপ সেটিংস সম্পাদনা',
        'edit_group_settings_sub': 'নাম, আইকন, বিবরণ।',
        'send_messages': 'নতুন বার্তা পাঠান',
        'add_members': 'অন্য সদস্য যোগ করুন',
        'invite_via_link': 'লিংক বা QR দিয়ে আমন্ত্রণ',
        'approve_members': 'নতুন সদস্য অনুমোদন',
        'approve_members_sub': 'অ্যাডমিনকে যোগদান অনুমোদন করতে হবে।',
        'members': 'সদস্য',
        'create': 'তৈরি করুন',
        'group_created': 'গ্রুপ তৈরি হয়েছে!',
      },
      'RU': {
        'new_group': 'Новая группа',
        'group_name_hint': 'Название (необязательно)',
        'group_permissions': 'Разрешения',
        'members_can': 'Участники могут:',
        'admins_can': 'Администраторы могут:',
        'edit_group_settings': 'Изменять настройки',
        'edit_group_settings_sub': 'Название, иконка, описание.',
        'send_messages': 'Отправлять сообщения',
        'add_members': 'Добавлять участников',
        'invite_via_link': 'Приглашать по ссылке',
        'approve_members': 'Одобрять участников',
        'approve_members_sub': 'Администраторы одобряют вступление.',
        'members': 'Участники',
        'create': 'Создать',
        'group_created': 'Группа создана!',
      },
      'AR': {
        'new_group': 'مجموعة جديدة',
        'group_name_hint': 'اسم المجموعة (اختياري)',
        'group_permissions': 'الأذونات',
        'members_can': 'يمكن للأعضاء:',
        'admins_can': 'يمكن للمشرفين:',
        'edit_group_settings': 'تعديل الإعدادات',
        'edit_group_settings_sub': 'الاسم والأيقونة والوصف.',
        'send_messages': 'إرسال رسائل',
        'add_members': 'إضافة أعضاء',
        'invite_via_link': 'الدعوة عبر رابط',
        'approve_members': 'الموافقة على الأعضاء',
        'approve_members_sub': 'يجب على المشرفين الموافقة.',
        'members': 'الأعضاء',
        'create': 'إنشاء',
        'group_created': 'تم إنشاء المجموعة!',
      },
      'ES': {
        'new_group': 'Nuevo grupo',
        'group_name_hint': 'Nombre (opcional)',
        'group_permissions': 'Permisos',
        'members_can': 'Los miembros pueden:',
        'admins_can': 'Los admins pueden:',
        'edit_group_settings': 'Editar configuración',
        'edit_group_settings_sub': 'Nombre, icono, descripción.',
        'send_messages': 'Enviar mensajes',
        'add_members': 'Agregar miembros',
        'invite_via_link': 'Invitar por enlace',
        'approve_members': 'Aprobar miembros',
        'approve_members_sub': 'Los admins deben aprobar.',
        'members': 'Miembros',
        'create': 'Crear',
        'group_created': '¡Grupo creado!',
      },
      'FR': {
        'new_group': 'Nouveau groupe',
        'group_name_hint': 'Nom (optionnel)',
        'group_permissions': 'Autorisations',
        'members_can': 'Les membres peuvent:',
        'admins_can': 'Les admins peuvent:',
        'edit_group_settings': 'Modifier les paramètres',
        'edit_group_settings_sub': 'Nom, icône, description.',
        'send_messages': 'Envoyer des messages',
        'add_members': 'Ajouter des membres',
        'invite_via_link': 'Inviter par lien',
        'approve_members': 'Approuver les membres',
        'approve_members_sub': 'Les admins doivent approuver.',
        'members': 'Membres',
        'create': 'Créer',
        'group_created': 'Groupe créé !',
      },
      'HI': {
        'new_group': 'नया ग्रुप',
        'group_name_hint': 'ग्रुप का नाम (वैकल्पिक)',
        'group_permissions': 'अनुमतियाँ',
        'members_can': 'सदस्य कर सकते हैं:',
        'admins_can': 'एडमिन कर सकते हैं:',
        'edit_group_settings': 'सेटिंग संपादित करें',
        'edit_group_settings_sub': 'नाम, आइकन, विवरण।',
        'send_messages': 'संदेश भेजें',
        'add_members': 'सदस्य जोड़ें',
        'invite_via_link': 'लिंक से आमंत्रित करें',
        'approve_members': 'सदस्यों को स्वीकृत करें',
        'approve_members_sub': 'एडमिन अनुमति देंगे।',
        'members': 'सदस्य',
        'create': 'बनाएं',
        'group_created': 'ग्रुप बनाया गया!',
      },
      'PT': {
        'new_group': 'Novo grupo',
        'group_name_hint': 'Nome (opcional)',
        'group_permissions': 'Permissões',
        'members_can': 'Membros podem:',
        'admins_can': 'Admins podem:',
        'edit_group_settings': 'Editar configurações',
        'edit_group_settings_sub': 'Nome, ícone, descrição.',
        'send_messages': 'Enviar mensagens',
        'add_members': 'Adicionar membros',
        'invite_via_link': 'Convidar por link',
        'approve_members': 'Aprovar membros',
        'approve_members_sub': 'Admins devem aprovar.',
        'members': 'Membros',
        'create': 'Criar',
        'group_created': 'Grupo criado!',
      },
      'ZH': {
        'new_group': '新建群组',
        'group_name_hint': '群组名称（可选）',
        'group_permissions': '权限',
        'members_can': '成员可以：',
        'admins_can': '管理员可以：',
        'edit_group_settings': '编辑设置',
        'edit_group_settings_sub': '名称、图标、描述。',
        'send_messages': '发送消息',
        'add_members': '添加成员',
        'invite_via_link': '通过链接邀请',
        'approve_members': '批准成员',
        'approve_members_sub': '管理员必须批准。',
        'members': '成员',
        'create': '创建',
        'group_created': '群组已创建！',
      },
      'JA': {
        'new_group': '新しいグループ',
        'group_name_hint': 'グループ名（任意）',
        'group_permissions': '権限',
        'members_can': 'メンバーができること：',
        'admins_can': '管理者ができること：',
        'edit_group_settings': '設定を編集',
        'edit_group_settings_sub': '名前、アイコン、説明。',
        'send_messages': 'メッセージを送信',
        'add_members': 'メンバーを追加',
        'invite_via_link': 'リンクで招待',
        'approve_members': 'メンバーを承認',
        'approve_members_sub': '管理者が承認する必要があります。',
        'members': 'メンバー',
        'create': '作成',
        'group_created': 'グループが作成されました！',
      },
    };
    final code = widget.languageCode.toUpperCase();
    return tr[code]?[key] ?? tr['EN']![key]!;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Widget _permTile({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
                if (subtitle != null) ...[
                  const SizedBox(height: 3),
                  Text(subtitle,
                      style: TextStyle(
                          color: textSecondary,
                          fontSize: 12,
                          height: 1.4)),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: primary,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(_t('new_group'),
            style: TextStyle(
                color: textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Group photo + name
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: primary.withOpacity(0.3), width: 1.5),
                      ),
                      child: Icon(Icons.add_a_photo_outlined,
                          color: primary, size: 26),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(14),
                        border: Border(
                            bottom: BorderSide(color: primary, width: 2)),
                      ),
                      child: TextField(
                        controller: _nameController,
                        maxLength: 50,
                        style: TextStyle(
                            color: textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          hintText: _t('group_name_hint'),
                          hintStyle: TextStyle(
                              color: textSecondary, fontSize: 15),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                          counterText: '',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Permissions
            Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => setState(
                        () => _showPermissions = !_showPermissions),
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.settings_outlined,
                                color: primary, size: 20),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(_t('group_permissions'),
                                style: TextStyle(
                                    color: textPrimary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700)),
                          ),
                          Icon(
                            _showPermissions
                                ? Icons.expand_less
                                : Icons.expand_more,
                            color: textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_showPermissions) ...[
                    Divider(height: 1, color: dividerColor, indent: 16),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, top: 12, bottom: 4),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(_t('members_can'),
                            style: TextStyle(
                                color: textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                    _permTile(
                      title: _t('edit_group_settings'),
                      subtitle: _t('edit_group_settings_sub'),
                      value: _membersCanEditSettings,
                      onChanged: (v) =>
                          setState(() => _membersCanEditSettings = v),
                    ),
                    Divider(height: 1, color: dividerColor, indent: 16),
                    _permTile(
                      title: _t('send_messages'),
                      value: _membersCanSendMessages,
                      onChanged: (v) =>
                          setState(() => _membersCanSendMessages = v),
                    ),
                    Divider(height: 1, color: dividerColor, indent: 16),
                    _permTile(
                      title: _t('add_members'),
                      value: _membersCanAddOthers,
                      onChanged: (v) =>
                          setState(() => _membersCanAddOthers = v),
                    ),
                    Divider(height: 1, color: dividerColor, indent: 16),
                    _permTile(
                      title: _t('invite_via_link'),
                      value: _membersCanInviteViaLink,
                      onChanged: (v) =>
                          setState(() => _membersCanInviteViaLink = v),
                    ),
                    Divider(height: 1, color: dividerColor, indent: 16),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, top: 12, bottom: 4),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(_t('admins_can'),
                            style: TextStyle(
                                color: textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                    _permTile(
                      title: _t('approve_members'),
                      subtitle: _t('approve_members_sub'),
                      value: _adminsApproveNewMembers,
                      onChanged: (v) =>
                          setState(() => _adminsApproveNewMembers = v),
                    ),
                    const SizedBox(height: 8),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Members
            Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.group_outlined,
                              color: primary, size: 20),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          '${_t('members')}: ${widget.members.length}',
                          style: TextStyle(
                              color: textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: widget.members.map((m) {
                        return Column(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: m.avatarColor,
                              child: Text(m.avatarLetters,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              m.name.split(' ')[0],
                              style: TextStyle(
                                  fontSize: 12, color: textSecondary),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),

      // Create FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Create group in Firebase
          final name = _nameController.text.trim();
          Navigator.pop(context);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle,
                      color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(name.isEmpty
                      ? _t('group_created')
                      : '"$name" ${_t('group_created')}'),
                ],
              ),
              backgroundColor: primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        },
        backgroundColor: primary,
        child:
            const Icon(Icons.check, color: Colors.white, size: 28),
      ),
    );
  }
}