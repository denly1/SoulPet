import 'dart:ui';
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
    _Message(text: 'Yay! I love playing with you! 🐾\nLet\'s play fetch - it\'s my favourite game!\nOr we can practice commands like "give paw"?', isUser: false, time: '10:27'),
    _Message(text: 'Let\'s play fetch first, then practise commands. Deal?', isUser: true, time: '10:28'),
    _Message(text: 'Perfect! I\'m already running for my ball! 🎾\nThank you so much for playing with me - I\'m having so much fun!', isUser: false, time: '10:28'),
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
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
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
              _ChatTopBar(),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
                  itemCount: _messages.length,
                  itemBuilder: (context, i) => _MessageBubble(msg: _messages[i]),
                ),
              ),
              _InputBar(controller: _controller, onSend: _sendMessage),
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
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: LiquidGlassCircle(
              size: 40,
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 18, color: AppColors.deepMoss),
            ),
          ),
          const Spacer(),
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.pets_rounded, size: 18, color: AppColors.deepMoss),
              SizedBox(width: 8),
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
          LiquidGlassCircle(
            size: 40,
            child: const Icon(Icons.more_horiz_rounded,
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
    final maxW = MediaQuery.of(context).size.width * 0.68;

    if (msg.isUser) {
      // ── User bubble (right, no tail) ──
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(msg.time,
                style: TextStyle(
                    color: AppColors.textHint,
                    fontSize: 10,
                    fontWeight: FontWeight.w500)),
            const SizedBox(width: 6),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxW),
              child: LiquidGlassCard(
                borderRadius: 20,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Text(
                  msg.text,
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontSize: 15, height: 1.45),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // ── Pet bubble (left, with bottom-left tail) ──
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Avatar
            LiquidGlassCircle(
              size: 36,
              child: const Icon(Icons.pets_rounded, size: 17, color: AppColors.deepMoss),
            ),
            const SizedBox(width: 4),
            // Bubble + time column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxW),
                  child: _PetBubble(text: msg.text),
                ),
                const SizedBox(height: 3),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(msg.time,
                      style: TextStyle(
                          color: AppColors.textHint,
                          fontSize: 10,
                          fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}

// ── Pet bubble with tail ──────────────────────────────────────────────────────

class _PetBubble extends StatelessWidget {
  final String text;
  const _PetBubble({required this.text});

  static const double _tailW = 9.0;
  static const double _br = 18.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Tail drawn as a separate painted widget aligned at bottom
        CustomPaint(
          size: const Size(_tailW, 18),
          painter: _TailPainter(),
        ),
        // Bubble body
        Flexible(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(_br),
              topRight: Radius.circular(_br),
              bottomRight: Radius.circular(_br),
              bottomLeft: Radius.circular(4),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(_br),
                    topRight: Radius.circular(_br),
                    bottomRight: Radius.circular(_br),
                    bottomLeft: Radius.circular(4),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.55),
                      Colors.white.withValues(alpha: 0.30),
                      Colors.white.withValues(alpha: 0.18),
                    ],
                    stops: const [0.0, 0.55, 1.0],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.60),
                    width: 1.0,
                  ),
                ),
                child: Text(
                  text,
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontSize: 15, height: 1.45),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.48)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.62)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeJoin = StrokeJoin.round;

    // Smooth curved tail: starts at top-right (merges into bubble bottom-left),
    // curves down-left to the tip, curves back into bubble bottom edge
    final path = Path()
      ..moveTo(size.width, 0)                          // top-right — joins bubble
      ..quadraticBezierTo(
          size.width * 0.6, size.height * 0.5,        // control point
          0, size.height,                              // tip at bottom-left
      )
      ..quadraticBezierTo(
          size.width * 0.8, size.height * 0.7,        // control point
          size.width, size.height * 0.4,              // back up to bubble body
      )
      ..close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(_TailPainter old) => false;
}

// ── Input bar ─────────────────────────────────────────────────────────────────

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _InputBar({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    const double barH = 54.0;
    const double btnH = 42.0;
    const double r = 28.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Glass text field ──
          Expanded(
            child: Container(
              height: barH,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(r),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.60),
                          Colors.white.withValues(alpha: 0.34),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.65),
                        width: 1.0,
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: TextField(
                      controller: controller,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          height: 1.0),
                      onSubmitted: (_) => onSend(),
                      textInputAction: TextInputAction.send,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: 'Message...',
                        hintStyle: TextStyle(
                            color: AppColors.textHint, fontSize: 15),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        isCollapsed: true,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // ── Send button ──
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: btnH,
              height: btnH,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.deepMoss,
                    AppColors.liquidGreen,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.deepMoss.withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_upward_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
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
