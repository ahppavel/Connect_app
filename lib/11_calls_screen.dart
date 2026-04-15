import 'package:flutter/material.dart';

enum CallType { incoming, outgoing, missed }

class CallRecord {
  final String id;
  final String name;
  final String avatarLetters;
  final Color avatarColor;
  final CallType type;
  final DateTime dateTime;
  final bool isVideo;
  final int count;

  const CallRecord({
    required this.id,
    required this.name,
    required this.avatarLetters,
    required this.avatarColor,
    required this.type,
    required this.dateTime,
    this.isVideo = false,
    this.count = 1,
  });
}

class CallsScreen extends StatefulWidget {
  final String languageCode;
  final bool isDarkMode;

  const CallsScreen({
    super.key,
    required this.languageCode,
    required this.isDarkMode,
  });

  @override
  State<CallsScreen> createState() => _CallsScreenState();
}

class _CallsScreenState extends State<CallsScreen>
    with SingleTickerProviderStateMixin {
  static const Color primary = Color(0xFF9d4d36);
  static const Color green = Color(0xFF25D366);
  static const Color missedColor = Colors.redAccent;

  late TabController _tabController;
  bool _showSearch = false;
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  // Default empty list
  // Real calls will be added here later
  final List<CallRecord> _calls = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  String t(String key) {
    final code = widget.languageCode.toUpperCase();
    return (_tr[code] ?? _tr['EN']!)[key] ?? _tr['EN']![key]!;
  }

  Color get bgColor =>
      widget.isDarkMode ? const Color(0xFF111B21) : const Color(0xFFF7F9FC);

  Color get cardColor =>
      widget.isDarkMode ? const Color(0xFF1F2C34) : Colors.white;

  Color get textColor =>
      widget.isDarkMode ? Colors.white : const Color(0xFF191c1e);

  Color get subTextColor =>
      widget.isDarkMode ? const Color(0xFF8696A0) : Colors.grey.shade500;

  Color get dividerColor =>
      widget.isDarkMode ? const Color(0xFF2A3942) : const Color(0xFFF2F4F7);

  String _formatTime(DateTime dt) {
    final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt).inDays;
    if (diff == 0) return _formatTime(dt);
    if (diff == 1) return t('yesterday');
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    if (diff < 7) return days[dt.weekday - 1];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}';
  }

  String _headerLabel(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt).inDays;
    if (diff == 0) return t('today');
    if (diff == 1) return t('yesterday');
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[dt.month - 1]} ${dt.day}';
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  List<CallRecord> get _filteredCalls {
    var list = _tabController.index == 1
        ? _calls.where((c) => c.type == CallType.missed).toList()
        : List<CallRecord>.from(_calls);

    if (_searchQuery.isNotEmpty) {
      list = list
          .where(
            (c) => c.name.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: _showSearch ? _searchBar() : _appBar(),
      body: Column(
        children: [
          Container(
            color: cardColor,
            child: TabBar(
              controller: _tabController,
              labelColor: primary,
              unselectedLabelColor: subTextColor,
              indicatorColor: primary,
              indicatorWeight: 2.5,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              tabs: [
                Tab(text: t('recent')),
                Tab(text: t('missed')),
              ],
            ),
          ),
          Expanded(
            child: _filteredCalls.isEmpty
                ? _emptyState()
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _filteredCalls.length,
                    itemBuilder: (context, index) {
                      final call = _filteredCalls[index];
                      final showHeader = index == 0 ||
                          !_sameDay(
                            _filteredCalls[index - 1].dateTime,
                            call.dateTime,
                          );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showHeader)
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 6),
                              child: Text(
                                _headerLabel(call.dateTime),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: subTextColor,
                                ),
                              ),
                            ),
                          _callTile(call),
                          Divider(
                            height: 0.5,
                            color: dividerColor,
                            indent: 80,
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: cardColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text(
        t('calls'),
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w800,
          fontSize: 22,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: subTextColor),
          onPressed: () => setState(() => _showSearch = true),
        ),
      ],
    );
  }

  PreferredSizeWidget _searchBar() {
    return AppBar(
      backgroundColor: cardColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: primary),
        onPressed: () {
          setState(() {
            _showSearch = false;
            _searchQuery = '';
            _searchCtrl.clear();
          });
        },
      ),
      title: TextField(
        controller: _searchCtrl,
        autofocus: true,
        style: TextStyle(color: textColor, fontSize: 16),
        onChanged: (v) => setState(() => _searchQuery = v),
        decoration: InputDecoration(
          hintText: t('search_calls'),
          hintStyle: TextStyle(color: subTextColor, fontSize: 15),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _callTile(CallRecord call) {
    final isMissed = call.type == CallType.missed;

    IconData arrowIcon;
    Color arrowColor;

    switch (call.type) {
      case CallType.incoming:
        arrowIcon = Icons.call_received_rounded;
        arrowColor = green;
        break;
      case CallType.outgoing:
        arrowIcon = Icons.call_made_rounded;
        arrowColor = green;
        break;
      case CallType.missed:
        arrowIcon = Icons.call_missed_rounded;
        arrowColor = missedColor;
        break;
    }

    return InkWell(
      onTap: () => _showCallDetail(call),
      splashColor: primary.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: call.avatarColor.withOpacity(0.2),
                  child: Text(
                    call.avatarLetters,
                    style: TextStyle(
                      color: call.avatarColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (call.isVideo)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: cardColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.videocam_rounded,
                        color: primary,
                        size: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    call.count > 1 ? '${call.name} (${call.count})' : call.name,
                    style: TextStyle(
                      color: isMissed ? missedColor : textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(arrowIcon, color: arrowColor, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${call.isVideo ? t('video_call') : t('voice_call')} · ${_formatDate(call.dateTime)}',
                        style: TextStyle(color: subTextColor, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => _callBack(call),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  call.isVideo ? Icons.videocam_outlined : Icons.call_outlined,
                  color: primary,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCallDetail(CallRecord call) {
    showModalBottomSheet(
      context: context,
      backgroundColor: cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: dividerColor,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 36,
              backgroundColor: call.avatarColor.withOpacity(0.2),
              child: Text(
                call.avatarLetters,
                style: TextStyle(
                  color: call.avatarColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              call.name,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatDate(call.dateTime),
              style: TextStyle(color: subTextColor, fontSize: 13),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _actionBtn(
                    icon: Icons.call_outlined,
                    label: t('voice_call'),
                    onTap: () {
                      Navigator.pop(context);
                      _callBack(call);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _actionBtn(
                    icon: Icons.videocam_outlined,
                    label: t('video_call'),
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _actionBtn(
                    icon: Icons.message_outlined,
                    label: t('message'),
                    onTap: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _actionBtn({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: primary, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _callBack(CallRecord call) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${t("calling")} ${call.name}...'),
        backgroundColor: primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
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
                Icons.call_outlined,
                size: 44,
                color: primary.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              t('no_calls'),
              style: TextStyle(
                color: textColor,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              t('no_calls_sub'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: subTextColor,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const Map<String, Map<String, String>> _tr = {
  'EN': {
    'calls': 'Calls',
    'recent': 'Recent',
    'missed': 'Missed',
    'today': 'Today',
    'yesterday': 'Yesterday',
    'voice_call': 'Voice call',
    'video_call': 'Video call',
    'message': 'Message',
    'calling': 'Calling',
    'no_calls': 'No calls yet',
    'search_calls': 'Search calls',
    'no_calls_sub': 'Your recent calls will appear here.',
  },
  'BN': {
    'calls': 'কল',
    'recent': 'সাম্প্রতিক',
    'missed': 'মিসড',
    'today': 'আজ',
    'yesterday': 'গতকাল',
    'voice_call': 'ভয়েস কল',
    'video_call': 'ভিডিও কল',
    'message': 'মেসেজ',
    'calling': 'কল করা হচ্ছে',
    'no_calls': 'কোনো কল নেই',
    'search_calls': 'কল খুঁজুন',
    'no_calls_sub': 'আপনার সাম্প্রতিক কলগুলো এখানে দেখাবে।',
  },
  'RU': {
    'calls': 'Звонки',
    'recent': 'Недавние',
    'missed': 'Пропущенные',
    'today': 'Сегодня',
    'yesterday': 'Вчера',
    'voice_call': 'Голосовой',
    'video_call': 'Видеозвонок',
    'message': 'Сообщение',
    'calling': 'Звоним',
    'no_calls': 'Нет звонков',
    'search_calls': 'Поиск',
    'no_calls_sub': 'Здесь появятся ваши недавние звонки.',
  },
  'AR': {
    'calls': 'المكالمات',
    'recent': 'الأخيرة',
    'missed': 'الفائتة',
    'today': 'اليوم',
    'yesterday': 'أمس',
    'voice_call': 'مكالمة صوتية',
    'video_call': 'مكالمة فيديو',
    'message': 'رسالة',
    'calling': 'جارٍ الاتصال',
    'no_calls': 'لا توجد مكالمات',
    'search_calls': 'بحث',
    'no_calls_sub': 'ستظهر مكالماتك الأخيرة هنا.',
  },
  'ES': {
    'calls': 'Llamadas',
    'recent': 'Recientes',
    'missed': 'Perdidas',
    'today': 'Hoy',
    'yesterday': 'Ayer',
    'voice_call': 'Voz',
    'video_call': 'Video',
    'message': 'Mensaje',
    'calling': 'Llamando',
    'no_calls': 'Sin llamadas',
    'search_calls': 'Buscar',
    'no_calls_sub': 'Tus llamadas recientes aparecerán aquí.',
  },
  'FR': {
    'calls': 'Appels',
    'recent': 'Récents',
    'missed': 'Manqués',
    'today': "Aujourd'hui",
    'yesterday': 'Hier',
    'voice_call': 'Vocal',
    'video_call': 'Vidéo',
    'message': 'Message',
    'calling': 'Appel',
    'no_calls': 'Aucun appel',
    'search_calls': 'Rechercher',
    'no_calls_sub': 'Vos appels récents apparaîtront ici.',
  },
  'HI': {
    'calls': 'कॉल',
    'recent': 'हाल के',
    'missed': 'छूटे',
    'today': 'आज',
    'yesterday': 'कल',
    'voice_call': 'वॉइस कॉल',
    'video_call': 'वीडियो कॉल',
    'message': 'संदेश',
    'calling': 'कॉल हो रही है',
    'no_calls': 'कोई कॉल नहीं',
    'search_calls': 'खोजें',
    'no_calls_sub': 'आपकी हाल की कॉल यहाँ दिखेंगी।',
  },
  'PT': {
    'calls': 'Chamadas',
    'recent': 'Recentes',
    'missed': 'Perdidas',
    'today': 'Hoje',
    'yesterday': 'Ontem',
    'voice_call': 'Voz',
    'video_call': 'Vídeo',
    'message': 'Mensagem',
    'calling': 'Chamando',
    'no_calls': 'Sem chamadas',
    'search_calls': 'Pesquisar',
    'no_calls_sub': 'Suas chamadas recentes aparecerão aqui.',
  },
  'ZH': {
    'calls': '通话',
    'recent': '最近',
    'missed': '未接',
    'today': '今天',
    'yesterday': '昨天',
    'voice_call': '语音',
    'video_call': '视频',
    'message': '消息',
    'calling': '拨打中',
    'no_calls': '暂无通话',
    'search_calls': '搜索',
    'no_calls_sub': '您最近的通话将显示在这里。',
  },
  'JA': {
    'calls': '通話',
    'recent': '最近',
    'missed': '不在着信',
    'today': '今日',
    'yesterday': '昨日',
    'voice_call': '音声',
    'video_call': 'ビデオ',
    'message': 'メッセージ',
    'calling': '発信中',
    'no_calls': '通話なし',
    'search_calls': '検索',
    'no_calls_sub': '最近の通話がここに表示されます。',
  },
};
