import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final String? avatarUrl;
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
    this.avatarUrl,
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
  static const Color bg = Color(0xFF111111);
  static const Color cardBg = Color(0xFF1A1A1A);
  static const Color onlineGreen = Color(0xFF25D366);
  static const Color seenYellow = Color(0xFFFFD700);

  final List<ChatPreview> _dummyChats = [
    ChatPreview(
      id: '1',
      name: 'Sarah Johnson',
      lastMessage: 'Hey! Are you coming tonight? 🎉',
      time: '12:18 AM',
      unreadCount: 3,
      isOnline: true,
      isGroup: false,
      isDeleted: false,
      isMissedCall: false,
      isMe: false,
      status: MessageStatus.seen,
      avatarLetters: 'SJ',
      avatarColor: const Color(0xFF6C63FF),
    ),
    ChatPreview(
      id: '2',
      name: 'Ahmed Ali',
      lastMessage: '📷 Photo',
      time: '12:11 AM',
      unreadCount: 0,
      isOnline: false,
      isGroup: false,
      isDeleted: false,
      isMissedCall: false,
      isMe: true,
      status: MessageStatus.seen,
      avatarLetters: 'AA',
      avatarColor: const Color(0xFF25D366),
    ),
    ChatPreview(
      id: '3',
      name: 'Team Connect 🔥',
      lastMessage: 'Fahim: Let\'s meet tomorrow morning',
      time: 'Yesterday',
      unreadCount: 5,
      isOnline: false,
      isGroup: true,
      isDeleted: false,
      isMissedCall: false,
      isMe: false,
      status: MessageStatus.delivered,
      avatarLetters: 'TC',
      avatarColor: primary,
    ),
    ChatPreview(
      id: '4',
      name: 'Mila Rahman',
      lastMessage: 'You deleted this message',
      time: 'Yesterday',
      unreadCount: 0,
      isOnline: true,
      isGroup: false,
      isDeleted: true,
      isMissedCall: false,
      isMe: false,
      status: MessageStatus.delivered,
      avatarLetters: 'MR',
      avatarColor: const Color(0xFF0088CC),
    ),
    ChatPreview(
      id: '5',
      name: 'University CSE-63',
      lastMessage: 'Arif: Anyone done the assignment?',
      time: 'Yesterday',
      unreadCount: 12,
      isOnline: false,
      isGroup: true,
      isDeleted: false,
      isMissedCall: false,
      isMe: false,
      status: MessageStatus.sent,
      avatarLetters: 'UC',
      avatarColor: const Color(0xFFFF6B6B),
    ),
    ChatPreview(
      id: '6',
      name: 'Balbu',
      lastMessage: '🎤 Voice message',
      time: 'Yesterday',
      unreadCount: 0,
      isOnline: false,
      isGroup: false,
      isDeleted: false,
      isMissedCall: false,
      isMe: true,
      status: MessageStatus.delivered,
      avatarLetters: 'BA',
      avatarColor: const Color(0xFF4ECDC4),
    ),
    ChatPreview(
      id: '7',
      name: 'Arif Hossain',
      lastMessage: '📞 Missed voice call',
      time: '4/10/26',
      unreadCount: 1,
      isOnline: false,
      isGroup: false,
      isDeleted: false,
      isMissedCall: true,
      isMe: false,
      status: MessageStatus.sent,
      avatarLetters: 'AH',
      avatarColor: const Color(0xFFFFBE0B),
    ),
    ChatPreview(
      id: '8',
      name: 'Anurbo Emon',
      lastMessage: 'Send me the file bro',
      time: '4/3/26',
      unreadCount: 0,
      isOnline: true,
      isGroup: false,
      isDeleted: false,
      isMissedCall: false,
      isMe: false,
      status: MessageStatus.seen,
      avatarLetters: 'AE',
      avatarColor: const Color(0xFFFF006E),
    ),
  ];

  List<ChatPreview> get _filteredChats {
    if (_searchQuery.isEmpty) return _dummyChats;
    return _dummyChats
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
        'search': 'Search',
        'no_chats': 'No chats yet',
        'no_chats_sub': 'Start a conversation!',
        'no_results': 'No results found',
        'online': 'Online',
      },
      'BN': {
        'chats': 'চ্যাট',
        'stories': 'স্টোরি',
        'calls': 'কল',
        'settings': 'সেটিংস',
        'search': 'খুঁজুন',
        'no_chats': 'এখনো কোনো চ্যাট নেই',
        'no_chats_sub': 'কথা শুরু করুন!',
        'no_results': 'কোনো ফলাফল পাওয়া যায়নি',
        'online': 'অনলাইন',
      },
      // ... other languages (keep as in your original)
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
        title: Text(
          'Connect',
          style: GoogleFonts.dancingScript(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: primary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined, color: Colors.white70),
            onPressed: () {},
          ),
          CircleAvatar(
            radius: 18,
            backgroundColor: primary,
            child: Text(
              widget.fullName.isNotEmpty ? widget.fullName[0].toUpperCase() : '?',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(999),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white70),
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: _t('search'),
                  hintStyle: const TextStyle(color: Colors.white38),
                  prefixIcon: const Icon(Icons.search, color: Colors.white38),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, color: Colors.white38),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          // Chat list
          Expanded(
            child: _filteredChats.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: _filteredChats.length,
                    itemBuilder: (context, index) => _chatTile(_filteredChats[index]),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: cardBg,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primary,
        unselectedItemColor: Colors.white38,
        currentIndex: _currentTab,
        onTap: (index) => setState(() => _currentTab = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: _t('chats')),
          BottomNavigationBarItem(icon: Icon(Icons.auto_stories_outlined), label: _t('stories')),
          BottomNavigationBarItem(icon: Icon(Icons.call_outlined), label: _t('calls')),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: _t('settings')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: primary,
        child: const Icon(Icons.edit_outlined),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 80, color: Colors.white12),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty ? _t('no_results') : _t('no_chats'),
            style: const TextStyle(color: Colors.white38, fontSize: 18),
          ),
          if (_searchQuery.isEmpty)
            Text(_t('no_chats_sub'), style: const TextStyle(color: Colors.white24)),
        ],
      ),
    );
  }

  Widget _chatTile(ChatPreview chat) {
    return ListTile(
      onTap: () {},
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: chat.avatarColor,
            child: Text(chat.avatarLetters, style: const TextStyle(color: Colors.white)),
          ),
          if (chat.isOnline)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: onlineGreen,
                  shape: BoxShape.circle,
                  border: Border.all(color: bg, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          if (chat.isGroup) const Icon(Icons.group, size: 14, color: Colors.white38),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              chat.name,
              style: TextStyle(
                color: chat.unreadCount > 0 ? Colors.white : Colors.white70,
                fontWeight: chat.unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          Text(
            chat.time,
            style: TextStyle(
              color: chat.unreadCount > 0 ? primary : Colors.white38,
              fontSize: 12,
            ),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          if (chat.isMe && !chat.isDeleted)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: _buildTick(chat.status),
            ),
          Expanded(
            child: Text(
              chat.lastMessage,
              style: TextStyle(
                color: chat.isDeleted
                    ? Colors.white24
                    : chat.isMissedCall
                        ? Colors.redAccent
                        : Colors.white38,
                fontSize: 13,
                fontStyle: chat.isDeleted ? FontStyle.italic : FontStyle.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (chat.unreadCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                chat.unreadCount > 99 ? '99+' : chat.unreadCount.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTick(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return const Icon(Icons.access_time, size: 14, color: Colors.white38);
      case MessageStatus.sent:
        return const Icon(Icons.check, size: 14, color: Colors.white38);
      case MessageStatus.delivered:
        return const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check, size: 14, color: Colors.white38),
            SizedBox(width: -6),
            Icon(Icons.check, size: 14, color: Colors.white38),
          ],
        );
      case MessageStatus.seen:
        return const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check, size: 14, color: seenYellow),
            SizedBox(width: -6),
            Icon(Icons.check, size: 14, color: seenYellow),
          ],
        );
    }
  }
}