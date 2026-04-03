import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soulpet/core/constants/app_colors.dart';
import 'package:soulpet/shared/widgets/liquid_glass.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  final List<_Message> _messages = [
    _Message(text: 'Hey Buddy! How are you doing? What are you up to?', isUser: true, time: '10:24'),
    _Message(text: 'Hi! 😊 I\'m doing great!\nI was resting after playing and napping a little.\nWaiting for you to write!', isUser: false, time: '10:25'),
    _Message(text: 'How cute! Maybe we can play together?\nWhat would you like to do?', isUser: true, time: '10:26'),
    _Message(text: 'Yay! I love playing with you! 🐾\nLet\'s play fetch — it\'s my favourite game!\nOr we can practice commands like "give paw"?', isUser: false, time: '10:27'),
    _Message(text: 'Let\'s play fetch first, then practise commands. Deal?', isUser: true, time: '10:28'),
    _Message(text: 'Perfect! I\'m already running for my ball! 🎾\nThank you so much for playing with me, I\'m having so much fun!', isUser: false, time: '10:28'),
    _Message(text: 'You\'re the best, Buddy! 🥰', isUser: true, time: '10:29'),
    _Message(text: 'Woof! 🐶 You\'re my absolute favourite too!\nI love you so much! ♡', isUser: false, time: '10:29'),
  ];

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_Message(
        text: text,
        isUser: true,
        time: _currentTime(),
      ));
      _controller.clear();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  String _currentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.warmGradient),
        child: SafeArea(
          child: Column(
            children: [
              // ── Top bar ──
              _ChatTopBar(),
              // ── Messages ──
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                  itemCount: _messages.length,
                  itemBuilder: (context, i) => _MessageBubble(msg: _messages[i]),
                ),
              ),
              // ── Input bar ──
              _InputBar(
                controller: _controller,
                onSend: _sendMessage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Top bar ───────────────────────────────────────────────────────────────────

class _ChatTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => context.pop(),
            child: LiquidGlassCircle(
              size: 40,
              child: Icon(Icons.arrow_back_ios_new_rounded,
                  size: 18, color: AppColors.deepMoss),
            ),
          ),
          const Spacer(),
          // Title
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.pets_rounded, size: 18, color: AppColors.deepMoss),
              const SizedBox(width: 8),
              Text(
                'soul pet',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const Spacer(),
          // History button
          LiquidGlassCircle(
            size: 40,
            child: Icon(Icons.history_rounded,
                size: 20, color: AppColors.deepMoss),
          ),
          const SizedBox(width: 8),
          // More button
          LiquidGlassCircle(
            size: 40,
            child: Icon(Icons.more_horiz_rounded,
                size: 20, color: AppColors.deepMoss),
          ),
        ],
      ),
    );
  }
}

// ── Message bubble ────────────────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  final _Message msg;
  const _MessageBubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    if (msg.isUser) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Time
            Text(msg.time,
                style: TextStyle(
                    color: AppColors.textHint,
                    fontSize: 10,
                    fontWeight: FontWeight.w500)),
            const SizedBox(width: 6),
            // Bubble
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.65),
              child: LiquidGlassCard(
                borderRadius: 22,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                  msg.text,
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      height: 1.4),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Pet avatar
            LiquidGlassCircle(
              size: 38,
              child: Icon(Icons.pets_rounded, size: 18, color: AppColors.deepMoss),
            ),
            const SizedBox(width: 8),
            // Bubble + time
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.65),
                  child: LiquidGlassCard(
                    borderRadius: 22,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Text(
                      msg.text,
                      style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          height: 1.4),
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(msg.time,
                    style: TextStyle(
                        color: AppColors.textHint,
                        fontSize: 10,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      );
    }
  }
}

// ── Input bar ─────────────────────────────────────────────────────────────────

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _InputBar({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      child: LiquidGlassCard(
        borderRadius: 50,
        padding: const EdgeInsets.fromLTRB(16, 6, 6, 6),
        child: Row(
          children: [
            // Text field
            Expanded(
              child: TextField(
                controller: controller,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15),
                onSubmitted: (_) => onSend(),
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                  hintText: 'Write a message...',
                  hintStyle: TextStyle(
                      color: AppColors.textHint, fontSize: 15),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Send button
            GestureDetector(
              onTap: onSend,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.deepMoss.withValues(alpha: 0.90),
                      AppColors.liquidGreen.withValues(alpha: 0.80),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deepMoss.withValues(alpha: 0.28),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_upward_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Data model ────────────────────────────────────────────────────────────────

class _Message {
  final String text;
  final bool isUser;
  final String time;
  const _Message({required this.text, required this.isUser, required this.time});
}
