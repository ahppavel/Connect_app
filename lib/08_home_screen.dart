import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '09_profile_screen.dart';


class HomeScreen extends StatefulWidget {
  final String languageCode;
  final String languageName;
  final String fullName;
  final String username;

  const HomeScreen({
    super.key,
    required this.languageCode,
    required this.languageName,
    required this.fullName,
    required this.username,
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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static const Color primary = Color(0xFF9d4d36);
  static const Color bg = Color(0xFFF7F9FC);
  static const Color cardBg = Color(0xFFEEEFF4);
  static const Color onlineGreen = Color(0xFF25D366);
  static const Color seenYellow = Color(0xFFFFD700);

  // TODO: Replace with real Firebase data later
  // Empty list — chats will appear when users actually message each other
  final List<ChatPreview> _chats = [];

  List<ChatPreview> get _filteredChats {
    if (_searchQuery.isEmpty) return _chats;
    return _chats
        .where((c) =>
            c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            c.lastMessage.toLowerCase().contains(_searchQuery.toLowerCase()))
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
      },
      'RU': {
        'chats': 'Чаты',
        'stories': 'Истории',
        'calls': 'Звонки',
        'settings': 'Настройки',
        'search': 'Поиск или новый чат',
        'no_chats': 'Нет чатов',
        'no_chats_sub': 'Нажмите кнопку карандаша, чтобы начать!',
        'no_results': 'Ничего не найдено',
      },
      'AR': {
        'chats': 'المحادثات',
        'stories': 'القصص',
        'calls': 'المكالمات',
        'settings': 'الإعدادات',
        'search': 'بحث أو بدء محادثة',
        'no_chats': 'لا توجد محادثات',
        'no_chats_sub': 'اضغط على زر القلم لبدء محادثة!',
        'no_results': 'لا توجد نتائج',
      },
      'ES': {
        'chats': 'Chats',
        'stories': 'Historias',
        'calls': 'Llamadas',
        'settings': 'Ajustes',
        'search': 'Buscar o iniciar chat',
        'no_chats': 'Sin chats aún',
        'no_chats_sub': '¡Toca el botón de lápiz para comenzar!',
        'no_results': 'Sin resultados',
      },
      'FR': {
        'chats': 'Discussions',
        'stories': 'Statuts',
        'calls': 'Appels',
        'settings': 'Paramètres',
        'search': 'Rechercher ou nouveau chat',
        'no_chats': 'Pas encore de discussions',
        'no_chats_sub': 'Appuyez sur le crayon pour commencer!',
        'no_results': 'Aucun résultat',
      },
      'HI': {
        'chats': 'चैट',
        'stories': 'स्टोरी',
        'calls': 'कॉल',
        'settings': 'सेटिंग',
        'search': 'खोजें या नई चैट शुरू करें',
        'no_chats': 'अभी कोई चैट नहीं',
        'no_chats_sub': 'बातचीत शुरू करने के लिए पेंसिल बटन दबाएं!',
        'no_results': 'कोई परिणाम नहीं',
      },
      'PT': {
        'chats': 'Conversas',
        'stories': 'Status',
        'calls': 'Chamadas',
        'settings': 'Config.',
        'search': 'Pesquisar ou nova conversa',
        'no_chats': 'Sem conversas ainda',
        'no_chats_sub': 'Toque no lápis para começar!',
        'no_results': 'Sem resultados',
      },
      'ZH': {
        'chats': '聊天',
        'stories': '动态',
        'calls': '通话',
        'settings': '设置',
        'search': '搜索或开始新聊天',
        'no_chats': '暂无聊天',
        'no_chats_sub': '点击铅笔按钮开始对话！',
        'no_results': '未找到结果',
      },
      'JA': {
        'chats': 'チャット',
        'stories': 'ストーリー',
        'calls': '通話',
        'settings': '設定',
        'search': '検索または新しいチャット',
        'no_chats': 'チャットはまだありません',
        'no_chats_sub': '鉛筆ボタンをタップして会話を始めましょう！',
        'no_results': '結果が見つかりません',
      },
    };
    final code = widget.languageCode.toUpperCase();
    return tr[code]?[key] ?? tr['EN']![key]!;
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
          // Profile avatar
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileScreen(
                    languageCode: widget.languageCode,
                    initialName: widget.fullName,
                    initialUsername: widget.username,
                    initialEmail: '', // TODO: Add email when available
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 4),
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primary,
                border: Border.all(
                    color: primary.withOpacity(0.3), width: 2),
              ),
              child: Center(
                child: Text(
                  widget.fullName.isNotEmpty
                      ? widget.fullName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.more_vert,
                color: Colors.grey[600], size: 24),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileScreen(
                    languageCode: widget.languageCode,
                    initialName: widget.fullName,
                    initialUsername: widget.username,
                    initialEmail: '', // TODO: Add email when available
                  ),
                ),
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [
          // Search bar
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(999),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(
                    color: Color(0xFF191c1e), fontSize: 15),
                onChanged: (val) =>
                    setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: _t('search'),
                  hintStyle: TextStyle(
                      color: Colors.grey[400], fontSize: 14),
                  prefixIcon: Icon(Icons.search,
                      color: Colors.grey[400], size: 20),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.close,
                              color: Colors.grey[400], size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 13),
                ),
              ),
            ),
          ),

          const SizedBox(height: 4),

          // Chat list
          Expanded(
            child: _filteredChats.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.only(top: 4),
                    itemCount: _filteredChats.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 0.5,
                      color: Colors.grey[200],
                      indent: 84,
                    ),
                    itemBuilder: (context, index) =>
                        _chatTile(_filteredChats[index]),
                  ),
          ),
        ],
      ),

      // Bottom navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
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
                _navItem(0, Icons.chat_bubble_rounded,
                    Icons.chat_bubble_outline_rounded, _t('chats')),
                _navItem(1, Icons.auto_stories,
                    Icons.auto_stories_outlined, _t('stories')),
                _navItem(2, Icons.call_rounded,
                    Icons.call_outlined, _t('calls')),
                _navItem(3, Icons.settings_rounded,
                    Icons.settings_outlined, _t('settings')),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: primary,
        elevation: 4,
        child: const Icon(Icons.edit_outlined,
            color: Colors.white, size: 24),
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
              _searchQuery.isNotEmpty
                  ? _t('no_results')
                  : _t('no_chats'),
              style: const TextStyle(
                color: Color(0xFF191c1e),
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
                  color: Colors.grey[500],
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

  Widget _navItem(int index, IconData activeIcon,
      IconData inactiveIcon, String label) {
    final isActive = _currentTab == index;
    return GestureDetector(
      onTap: () => setState(() => _currentTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : inactiveIcon,
              color: isActive ? primary : Colors.grey[400],
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isActive ? primary : Colors.grey[400],
                fontWeight: isActive
                    ? FontWeight.w600
                    : FontWeight.w400,
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
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Avatar
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
                        border: Border.all(
                            color: bg, width: 2),
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
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            if (chat.isGroup)
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 4),
                                child: Icon(Icons.group,
                                    size: 14,
                                    color: Colors.grey[400]),
                              ),
                            Flexible(
                              child: Text(
                                chat.name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: const Color(0xFF191c1e),
                                  fontWeight: chat.unreadCount > 0
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        chat.time,
                        style: TextStyle(
                          color: chat.unreadCount > 0
                              ? primary
                              : Colors.grey[400],
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
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            if (chat.isMe && !chat.isDeleted)
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 4),
                                child: _buildTick(chat.status),
                              ),
                            Expanded(
                              child: Text(
                                chat.lastMessage,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: chat.isDeleted
                                      ? Colors.grey[400]
                                      : chat.isMissedCall
                                          ? Colors.redAccent
                                          : Colors.grey[500],
                                  fontSize: 13,
                                  fontStyle: chat.isDeleted
                                      ? FontStyle.italic
                                      : FontStyle.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (chat.unreadCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: primary,
                            borderRadius:
                                BorderRadius.circular(999),
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

  Widget _buildTick(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return Icon(Icons.access_time,
            size: 14, color: Colors.grey[400]);
      case MessageStatus.sent:
        return Icon(Icons.check, size: 14, color: Colors.grey[400]);
      case MessageStatus.delivered:
        return Stack(
          children: [
            Icon(Icons.check, size: 14, color: Colors.grey[400]),
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Icon(Icons.check,
                  size: 14, color: Colors.grey[400]),
            ),
          ],
        );
      case MessageStatus.seen:
        return Stack(
          children: const [
            Icon(Icons.check, size: 14, color: seenYellow),
            Padding(
              padding: EdgeInsets.only(left: 6),
              child: Icon(Icons.check,
                  size: 14, color: seenYellow),
            ),
          ],
        );
    }
  }
}