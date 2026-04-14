import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '09_profile_screen.dart';
import '10_group_screen.dart';
import '11_calls_screen.dart'; // Import your CallsScreen

class HomeScreen extends StatefulWidget {
  final String languageCode;
  final String languageName;
  final String fullName;
  final String username;
  final String email;

  const HomeScreen({
    super.key,
    required this.languageCode,
    required this.languageName,
    required this.fullName,
    required this.username,
    required this.email,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum MessageStatus { sending, sent, delivered, seen }

class ChatPreview {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;
  final bool isGroup;
  final bool isDeleted;
  final bool isMissedCall;
  final bool isMe;
  final MessageStatus status;
  final String avatarLetters;
  final Color avatarColor;

  const ChatPreview({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.isOnline,
    required this.isGroup,
    required this.isDeleted,
    required this.isMissedCall,
    required this.isMe,
    required this.status,
    required this.avatarLetters,
    required this.avatarColor,
  });
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;
  bool _isDarkMode = false;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  late String _displayName;
  late String _displayUsername;

  static const Color primary = Color(0xFF9d4d36);
  static const Color lightBg = Color(0xFFF7F9FC);
  static const Color lightCardBg = Color(0xFFEEEFF4);
  static const Color onlineGreen = Color(0xFF25D366);

  final List<ChatPreview> _chats = [];

  @override
  void initState() {
    super.initState();
    _displayName = widget.fullName;
    _displayUsername = widget.username;
  }

  Color get bg => _isDarkMode ? const Color(0xFF121212) : lightBg;
  Color get cardBg => _isDarkMode ? const Color(0xFF1E1E1E) : lightCardBg;
  Color get navBg => _isDarkMode ? const Color(0xFF181818) : Colors.white;
  Color get textPrimary =>
      _isDarkMode ? Colors.white : const Color(0xFF191c1e);
  Color get textSecondary =>
      _isDarkMode ? Colors.grey[400]! : Colors.grey[500]!;
  Color get iconMuted => _isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
  Color get dividerColor =>
      _isDarkMode ? Colors.white.withOpacity(0.06) : Colors.grey[200]!;

  List<ChatPreview> get _filteredChats {
    if (_searchQuery.isEmpty) return _chats;
    return _chats
        .where(
          (c) =>
              c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              c.lastMessage.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  String _t(String key) {
    final Map<String, Map<String, String>> tr = {
      'EN': {
        'chats': 'Chats',
        'stories': 'Stories',
        'calls': 'Calls',
        'settings': 'Settings',
        'search': 'Search or start new chat',
        'no_chats': 'No chats yet',
        'no_chats_sub': 'Tap the pencil button to start a conversation!',
        'no_results': 'No results found',
        'day_mode': 'Day mode',
        'night_mode': 'Night mode',
        'new_group': 'New group',
        'new_group_title': 'New Group',
        'new_group_sub': 'Create your new group here',
      },
      'BN': {
        'chats': 'চ্যাট',
        'stories': 'স্টোরি',
        'calls': 'কল',
        'settings': 'সেটিংস',
        'search': 'খুঁজুন বা নতুন চ্যাট শুরু করুন',
        'no_chats': 'এখনো কোনো চ্যাট নেই',
        'no_chats_sub': 'নতুন কথোপকথন শুরু করতে পেন্সিল বাটন চাপুন!',
        'no_results': 'কোনো ফলাফল পাওয়া যায়নি',
        'day_mode': 'ডে মোড',
        'night_mode': 'নাইট মোড',
        'new_group': 'নতুন গ্রুপ',
        'new_group_title': 'নতুন গ্রুপ',
        'new_group_sub': 'এখানে নতুন গ্রুপ তৈরি করুন',
      },
      'RU': {
        'chats': 'Чаты',
        'stories': 'Истории',
        'calls': 'Звонки',
        'settings': 'Настройки',
        'search': 'Поиск или новый чат',
        'no_chats': 'Нет чатов',
        'no_chats_sub': 'Нажмите карандаш!',
        'no_results': 'Ничего не найдено',
        'day_mode': 'Дневной режим',
        'night_mode': 'Ночной режим',
        'new_group': 'Новая группа',
        'new_group_title': 'Новая группа',
        'new_group_sub': 'Создайте новую группу здесь',
      },
      'AR': {
        'chats': 'المحادثات',
        'stories': 'القصص',
        'calls': 'المكالمات',
        'settings': 'الإعدادات',
        'search': 'بحث أو بدء محادثة',
        'no_chats': 'لا توجد محادثات',
        'no_chats_sub': 'اضغط على القلم!',
        'no_results': 'لا توجد نتائج',
        'day_mode': 'الوضع النهاري',
        'night_mode': 'الوضع الليلي',
        'new_group': 'مجموعة جديدة',
        'new_group_title': 'مجموعة جديدة',
        'new_group_sub': 'أنشئ مجموعتك الجديدة هنا',
      },
      'ES': {
        'chats': 'Chats',
        'stories': 'Historias',
        'calls': 'Llamadas',
        'settings': 'Ajustes',
        'search': 'Buscar o iniciar chat',
        'no_chats': 'Sin chats aún',
        'no_chats_sub': '¡Toca el lápiz!',
        'no_results': 'Sin resultados',
        'day_mode': 'Modo día',
        'night_mode': 'Modo noche',
        'new_group': 'Nuevo grupo',
        'new_group_title': 'Nuevo grupo',
        'new_group_sub': 'Crea tu nuevo grupo aquí',
      },
      'FR': {
        'chats': 'Discussions',
        'stories': 'Statuts',
        'calls': 'Appels',
        'settings': 'Paramètres',
        'search': 'Rechercher ou nouveau chat',
        'no_chats': 'Pas de discussions',
        'no_chats_sub': 'Appuyez sur le crayon!',
        'no_results': 'Aucun résultat',
        'day_mode': 'Mode jour',
        'night_mode': 'Mode nuit',
        'new_group': 'Nouveau groupe',
        'new_group_title': 'Nouveau groupe',
        'new_group_sub': 'Créez votre nouveau groupe ici',
      },
      'HI': {
        'chats': 'चैट',
        'stories': 'स्टोरी',
        'calls': 'कॉल',
        'settings': 'सेटिंग',
        'search': 'खोजें या नई चैट शुरू करें',
        'no_chats': 'कोई चैट नहीं',
        'no_chats_sub': 'पेंसिल बटन दबाएं!',
        'no_results': 'कोई परिणाम नहीं',
        'day_mode': 'डे मोड',
        'night_mode': 'नाइट मोड',
        'new_group': 'नया ग्रुप',
        'new_group_title': 'नया ग्रुप',
        'new_group_sub': 'यहाँ नया ग्रुप बनाएं',
      },
      'PT': {
        'chats': 'Conversas',
        'stories': 'Status',
        'calls': 'Chamadas',
        'settings': 'Config.',
        'search': 'Pesquisar ou nova conversa',
        'no_chats': 'Sem conversas',
        'no_chats_sub': 'Toque no lápis!',
        'no_results': 'Sem resultados',
        'day_mode': 'Modo dia',
        'night_mode': 'Modo noite',
        'new_group': 'Novo grupo',
        'new_group_title': 'Novo grupo',
        'new_group_sub': 'Crie seu novo grupo aqui',
      },
      'ZH': {
        'chats': '聊天',
        'stories': '动态',
        'calls': '通话',
        'settings': '设置',
        'search': '搜索或开始新聊天',
        'no_chats': '暂无聊天',
        'no_chats_sub': '点击铅笔按钮开始！',
        'no_results': '未找到结果',
        'day_mode': '日间模式',
        'night_mode': '夜间模式',
        'new_group': '新建群组',
        'new_group_title': '新建群组',
        'new_group_sub': '在这里创建你的新群组',
      },
      'JA': {
        'chats': 'チャット',
        'stories': 'ストーリー',
        'calls': '通話',
        'settings': '設定',
        'search': '検索または新しいチャット',
        'no_chats': 'チャットはまだありません',
        'no_chats_sub': '鉛筆ボタンをタップ！',
        'no_results': '結果が見つかりません',
        'day_mode': 'デイモード',
        'night_mode': 'ナイトモード',
        'new_group': '新しいグループ',
        'new_group_title': '新しいグループ',
        'new_group_sub': 'ここで新しいグループを作成します',
      },
    };

    final code = widget.languageCode.toUpperCase();
    return tr[code]?[key] ?? tr['EN']![key]!;
  }

  void _openProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileScreen(
          languageCode: widget.languageCode,
          initialName: _displayName,
          initialUsername: _displayUsername,
          initialEmail: widget.email,
          initialBio: '',
        ),
      ),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        if (result['name'] != null) _displayName = result['name']!;
        if (result['username'] != null) {
          _displayUsername = result['username']!;
        }
      });
    }
  }

  void _onMenuSelected(String value) {
    if (value == 'theme') {
      setState(() {
        _isDarkMode = !_isDarkMode;
      });
    } else if (value == 'group') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NewGroupScreen(
            languageCode: widget.languageCode,
            isDarkMode: _isDarkMode,
          ),
        ),
      );
    }
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
        automaticallyImplyLeading: false,
        title: Text(
          'Connect',
          style: GoogleFonts.dancingScript(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: primary,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: _openProfile,
            child: Container(
              margin: const EdgeInsets.only(right: 4),
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primary,
                border: Border.all(
                  color: primary.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  _displayName.isNotEmpty ? _displayName[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: iconMuted, size: 24),
            color: navBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            onSelected: _onMenuSelected,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'theme',
                child: Row(
                  children: [
                    Icon(
                      _isDarkMode
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode_outlined,
                      color: primary,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _isDarkMode ? _t('day_mode') : _t('night_mode'),
                      style: TextStyle(color: textPrimary),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'group',
                child: Row(
                  children: [
                    const Icon(
                      Icons.group_add_outlined,
                      color: primary,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _t('new_group'),
                      style: TextStyle(color: textPrimary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar – shown only on Chats tab (index 0)
          if (_currentTab == 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: textPrimary, fontSize: 15),
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: _t('search'),
                    hintStyle: TextStyle(color: textSecondary, fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: textSecondary, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.close, color: textSecondary, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                ),
              ),
            ),
          Expanded(
            child: IndexedStack(
              index: _currentTab,
              children: [
                // Tab 0: Chats
                _filteredChats.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                        padding: const EdgeInsets.only(top: 4),
                        itemCount: _filteredChats.length,
                        separatorBuilder: (_, __) => Divider(
                          height: 0.5,
                          color: dividerColor,
                          indent: 84,
                        ),
                        itemBuilder: (context, index) =>
                            _chatTile(_filteredChats[index]),
                      ),
                // Tab 1: Stories (placeholder)
                Center(
                  child: Text(
                    'Stories Screen – coming soon',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
                // Tab 2: Calls – integrate CallsScreen
                CallsScreen(
                  languageCode: widget.languageCode,
                  isDarkMode: _isDarkMode,
                ),
                // Tab 3: Settings (placeholder)
                Center(
                  child: Text(
                    'Settings Screen – coming soon',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: navBg,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isDarkMode ? 0.18 : 0.06),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(
                  0,
                  Icons.chat_bubble_rounded,
                  Icons.chat_bubble_outline_rounded,
                  _t('chats'),
                ),
                _navItem(
                  1,
                  Icons.auto_stories,
                  Icons.auto_stories_outlined,
                  _t('stories'),
                ),
                _navItem(
                  2,
                  Icons.call_rounded,
                  Icons.call_outlined,
                  _t('calls'),
                ),
                _navItem(
                  3,
                  Icons.settings_rounded,
                  Icons.settings_outlined,
                  _t('settings'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: primary,
        elevation: 4,
        child: const Icon(Icons.edit_outlined, color: Colors.white, size: 24),
      ),
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
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primary.withOpacity(0.08),
              ),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                size: 50,
                color: primary.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _searchQuery.isNotEmpty ? _t('no_results') : _t('no_chats'),
              style: TextStyle(
                color: textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (_searchQuery.isEmpty) ...[
              const SizedBox(height: 8),
              Text(
                _t('no_chats_sub'),
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

  Widget _navItem(
    int index,
    IconData activeIcon,
    IconData inactiveIcon,
    String label,
  ) {
    final isActive = _currentTab == index;
    return GestureDetector(
      onTap: () => setState(() => _currentTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : inactiveIcon,
              color: isActive ? primary : textSecondary,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isActive ? primary : textSecondary,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chatTile(ChatPreview chat) {
    return InkWell(
      onTap: () {},
      splashColor: primary.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: chat.avatarColor,
                  ),
                  child: Center(
                    child: Text(
                      chat.avatarLetters,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                if (chat.isOnline)
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        color: onlineGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: bg, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          chat.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: textPrimary,
                            fontWeight: chat.unreadCount > 0
                                ? FontWeight.w700
                                : FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Text(
                        chat.time,
                        style: TextStyle(
                          color: chat.unreadCount > 0 ? primary : textSecondary,
                          fontSize: 12,
                          fontWeight: chat.unreadCount > 0
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          chat.lastMessage,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: chat.isMissedCall
                                ? Colors.redAccent
                                : textSecondary,
                            fontSize: 13,
                            fontStyle: chat.isDeleted
                                ? FontStyle.italic
                                : FontStyle.normal,
                          ),
                        ),
                      ),
                      if (chat.unreadCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            chat.unreadCount > 99
                                ? '99+'
                                : chat.unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}