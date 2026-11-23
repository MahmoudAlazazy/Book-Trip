import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_navigation_bar.dart';
import 'profile_page_scaffold.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) => ProfilePageScaffold(
    title: context.tr('Help & Support'),
    selectedIndex: -1,
    child: Column(
      children: [
        _SupportHero(
          title: context.tr('How can we help?'),
          subtitle: context.tr(
            'Our travel concierge is ready whenever you need us.',
          ),
          icon: Icons.support_agent_rounded,
        ),
        const SizedBox(height: 18),
        TextField(
          decoration: InputDecoration(
            hintText: context.tr('Search for help'),
            prefixIcon: const Icon(Icons.search_rounded),
            filled: true,
            fillColor: Theme.of(context).scaffoldBackgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 22),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            context.tr('How can we help you?'),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(height: 10),
        _SupportTile(
          icon: Icons.auto_awesome_outlined,
          title: context.tr('Frequently Asked Questions'),
          subtitle: context.tr('Find quick answers to common questions'),
          onTap: () => context.push(AppRoutes.faq),
        ),
        _SupportTile(
          icon: Icons.forum_outlined,
          title: context.tr('Chat with Support'),
          subtitle: context.tr('Talk to our team in real time'),
          onTap: () => context.push(AppRoutes.supportChat),
        ),
        _SupportTile(
          icon: Icons.mail_outline_rounded,
          title: context.tr('Contact Us'),
          subtitle: context.tr('Reach us by email or phone'),
          onTap: () => context.push(AppRoutes.contactSupport),
        ),
      ],
    ),
  );
}

class FrequentlyAskedQuestionsScreen extends StatelessWidget {
  const FrequentlyAskedQuestionsScreen({super.key});

  static const _questions = [
    (
      'How do I book a trip?',
      'Choose a trip, select your transport and seats, then confirm your booking.',
    ),
    (
      'Can I cancel my booking?',
      'Cancellation depends on the trip policy. Contact our concierge for help.',
    ),
    (
      'How can I track my trip?',
      'Open My Trips and tap Track Trip on your upcoming booking.',
    ),
    (
      'What payment methods are available?',
      'We currently support the payment methods shown at checkout.',
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    appBar: MediaQuery.sizeOf(context).width < 900
        ? _supportAppBar(context, context.tr('Frequently Asked Questions'))
        : null,
    body: AppNavigationBody(
      selectedIndex: -1,
      backgroundImage: 'assets/images/خلفية سفر عصرية بخريطة وطائرة.webp',
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (Theme.of(context).brightness != Brightness.dark)
            Image.asset(
              'assets/images/خلفية سفر عصرية بخريطة وطائرة.webp',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 32, 18, 18),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.darkTeal,
                          AppColors.teal.withValues(alpha: .88),
                        ],
                        begin: AlignmentDirectional.topStart,
                        end: AlignmentDirectional.bottomEnd,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.darkTeal.withValues(alpha: .18),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .16),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: .28),
                            ),
                          ),
                          child: const Icon(
                            Icons.quiz_outlined,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.tr('Frequently Asked Questions'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                context.tr(
                                  'Find quick answers to the questions travelers ask most.',
                                ),
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: .82),
                                  height: 1.4,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      context.tr('Frequently asked questions'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkTeal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ..._questions.asMap().entries.map(
                    (entry) => Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFDCE8E6)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0D163D4B),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(18),
                          clipBehavior: Clip.antiAlias,
                          child: ExpansionTile(
                            tilePadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                            ),
                            childrenPadding: const EdgeInsets.fromLTRB(
                              56,
                              0,
                              16,
                              16,
                            ),
                            leading: CircleAvatar(
                              radius: 16,
                              backgroundColor: AppColors.teal.withValues(
                                alpha: .12,
                              ),
                              child: Text(
                                '${entry.key + 1}',
                                style: const TextStyle(
                                  color: AppColors.darkTeal,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            title: Text(
                              context.tr(entry.value.$1),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.darkTeal,
                              ),
                            ),
                            iconColor: AppColors.teal,
                            collapsedIconColor: AppColors.darkTeal,
                            children: [
                              Text(
                                context.tr(entry.value.$2),
                                style: TextStyle(
                                  color: Colors.blueGrey.shade700,
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _wideSupportChat(BuildContext context, _SupportChatScreenState state) {
  return Row(
    children: [
      Expanded(
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: const Color(0xFFF5F9FC),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            children: [
              Container(
                height: 96,
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/أفق مصر_ الأهرامات والمساجد والطائرة.webp',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppColors.teal,
                      child: Icon(Icons.support_agent, color: Colors.white),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Travel Support',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                          Text(
                            '● Online · Usually replies within a few minutes',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    for (final message in state._messages)
                      _chatBubble(message.text, message.sent),
                    _chatBubble(
                      'Hello Ahmed, how can we make your next trip special? ✨',
                      false,
                    ),
                    _chatBubble(
                      'ممتاز! يسعدني مساعدتك في حجز رحلتك القادمة.',
                      true,
                    ),
                    _chatBubble('هل تفضل السفر بالطائرة أم القطار؟', true),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: state._messageController,
                  onSubmitted: state._sendMessage,
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: IconButton(
                      onPressed: state._pickAttachment,
                      icon: const Icon(
                        Icons.attach_file,
                        color: AppColors.teal,
                      ),
                    ),
                    suffixIcon: IconButton(
                      onPressed: state._sendMessage,
                      icon: const Icon(Icons.send, color: AppColors.teal),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget _chatBubble(String text, bool sent) => Align(
  alignment: sent
      ? AlignmentDirectional.centerEnd
      : AlignmentDirectional.centerStart,
  child: Container(
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
    decoration: BoxDecoration(
      color: sent ? const Color(0xFF0A7D89) : Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: TextStyle(color: sent ? Colors.white : const Color(0xFF163D4B)),
    ),
  ),
);

class SupportChatScreen extends StatefulWidget {
  const SupportChatScreen({super.key});

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final _messageController = TextEditingController();
  final _imagePicker = ImagePicker();
  final List<({String text, bool sent})> _messages = [
    (text: 'Hello Ahmed, how can we make your next trip special?', sent: false),
    (text: 'ممتاز! يسعدني مساعدتك في حجز رحلتك القادمة.', sent: true),
  ];

  // Demo-only chat state: nothing here is persisted or sent to a server.
  void _addDummyMessage(String text) {
    if (text.trim().isEmpty || !mounted) return;
    setState(() => _messages.add((text: text.trim(), sent: true)));
  }

  void _sendMessage([String? value]) {
    final text = (value ?? _messageController.text).trim();
    if (text.isEmpty) return;
    _addDummyMessage(text);
    _messageController.clear();
  }

  Future<void> _pickAttachment() async {
    final file = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (file == null || !mounted) return;
    setState(() => _messages.add((text: '📎 ${file.name}', sent: true)));
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    appBar: MediaQuery.sizeOf(context).width < 900
        ? _supportAppBar(context, context.tr('Chat with Support'))
        : null,
    body: AppNavigationBody(
      selectedIndex: -1,
      child: _wideSupportChat(context, this),
      /*
          SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.teal.withValues(alpha: .10),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.teal.withValues(alpha: .22),
                        ),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.darkTeal,
                            child: Icon(
                              Icons.support_agent_rounded,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.tr('Travel Concierge'),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.darkTeal,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  context.tr(
                                    'Usually replies within a few minutes',
                                  ),
                                  style: TextStyle(
                                    color: Colors.blueGrey.shade700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.circle,
                            color: Colors.green,
                            size: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) => Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F7FB),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.tr(_messages[index].text),
                                style: const TextStyle(
                                  color: AppColors.darkTeal,
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                _formatMessageTime(_messages[index].time),
                                style: TextStyle(
                                  color: Colors.blueGrey.shade500,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: context.tr('Write your message...'),
                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            if (_messageController.text.trim().isEmpty) return;
                            setState(() {
                              _messages.add((
                                text: _messageController.text.trim(),
                                time: DateTime.now(),
                              ));
                              _messageController.clear();
                            });
                          },
                          icon: const Icon(
                            Icons.send_rounded,
                            color: AppColors.teal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      */
    ),
  );
}

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    appBar: MediaQuery.sizeOf(context).width < 900
        ? _supportAppBar(context, context.tr('Contact Us'))
        : null,
    body: AppNavigationBody(
      selectedIndex: -1,
      backgroundImage: 'assets/images/خلفية سفر عصرية بخريطة وطائرة.webp',
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (Theme.of(context).brightness != Brightness.dark)
            Image.asset(
              'assets/images/خلفية سفر عصرية بخريطة وطائرة.webp',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      context.tr('How can we help you?'),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.tr(
                      'PharaTrip helps travelers discover trusted stays, curated trips, and smooth transportation in one place. Our team is here to make every step of your journey easier.',
                    ),
                    style: TextStyle(
                      color: Colors.blueGrey.shade700,
                      height: 1.55,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      context.tr('Contact information'),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _LuxurySectionHeader(
                    eyebrow: context.tr('PERSONAL ASSISTANCE'),
                    title: context.tr('Let’s plan something unforgettable.'),
                  ),
                  const SizedBox(height: 22),
                  _ContactCard(
                    icon: Icons.phone_in_talk_outlined,
                    title: context.tr('Call our concierge'),
                    value: '+20 1023117751',
                  ),
                  _ContactCard(
                    icon: Icons.email_outlined,
                    title: context.tr('Send us an email'),
                    value: 'hello@pharatrip.com',
                  ),
                  _ContactCard(
                    icon: Icons.location_on_outlined,
                    title: context.tr('Visit our office'),
                    value: 'Cairo, Egypt · Open daily 9 AM – 9 PM',
                  ),
                  const SizedBox(height: 12),
                  Text(
                    context.tr('We usually reply within a few minutes.'),
                    style: const TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

PreferredSizeWidget _supportAppBar(BuildContext context, String title) =>
    AppBar(
      title: Text(context.tr(title)),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () => context.go(AppRoutes.home),
        icon: const Icon(Icons.arrow_back_rounded),
      ),
    );

class _SupportHero extends StatelessWidget {
  const _SupportHero({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
  final String title, subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF0D493D), Color(0xFF177E70)],
      ),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .16),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 31),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr(title),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                context.tr(subtitle),
                style: const TextStyle(color: Colors.white70, height: 1.35),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _SupportTile extends StatelessWidget {
  const _SupportTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    child: Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: Color(0xFFE4EBF0)),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE4F4FB),
          child: Icon(icon, color: AppColors.teal),
        ),
        title: Text(
          context.tr(title),
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.darkTeal,
          ),
        ),
        subtitle: Text(
          context.tr(subtitle),
          style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 15,
          color: AppColors.darkTeal,
        ),
      ),
    ),
  );
}

class _LuxurySectionHeader extends StatelessWidget {
  const _LuxurySectionHeader({required this.eyebrow, required this.title});
  final String eyebrow, title;

  @override
  Widget build(BuildContext context) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr(eyebrow),
          style: const TextStyle(
            color: AppColors.teal,
            fontSize: 11,
            letterSpacing: 1.4,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          context.tr(title),
          style: const TextStyle(
            color: AppColors.darkTeal,
            fontSize: 21,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.icon,
    required this.title,
    required this.value,
  });
  final IconData icon;
  final String title, value;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFE4EBF0)),
    ),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xFFE4F4FB),
          child: Icon(icon, color: AppColors.teal),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr(title),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkTeal,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                context.tr(value),
                style: const TextStyle(color: Colors.blueGrey, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
