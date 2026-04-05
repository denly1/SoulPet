import 'dart:ui' as ui;
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
            // Bubble (no tail for user messages)
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
                // Bubble with integrated tail
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.65),
                  child: CustomPaint(
                    painter: _MessageBubbleWithTailPainter(),
                    child: Container(
                      margin: const EdgeInsets.only(left: 8),
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
                ),
                const SizedBox(height: 3),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
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

// ── Input bar ─────────────────────────────────────────────────────────────────

class _InputBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _InputBar({required this.controller, required this.onSend});

  @override
  State<_InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<_InputBar> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  void _showEmojiPicker() {
    // TODO: Implement emoji picker
    // For now, just show a placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Emoji picker coming soon! 😊'),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.deepMoss,
      ),
    );
  }

  void _startVoiceRecording() {
    // TODO: Implement voice recording
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Voice recording coming soon! 🎤'),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.deepMoss,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFFFFFF).withValues(alpha: 0.85),
                    const Color(0xFFFFFFFF).withValues(alpha: 0.75),
                    const Color(0xFFFFFFFF).withValues(alpha: 0.65),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: const Color(0xFFFFFFFF).withValues(alpha: 0.75),
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  // Paw icon (left)
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 38,
                      height: 38,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.pets_rounded,
                        size: 22,
                        color: AppColors.deepMoss.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Text field
                  Expanded(
                    child: TextField(
                      controller: widget.controller,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15),
                      onSubmitted: (_) => widget.onSend(),
                      textInputAction: TextInputAction.send,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Написать сообщение...',
                        hintStyle: TextStyle(
                            color: AppColors.textHint, fontSize: 15),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Emoji icon
                  GestureDetector(
                    onTap: _showEmojiPicker,
                    child: Container(
                      width: 38,
                      height: 38,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.emoji_emotions_outlined,
                        size: 22,
                        color: AppColors.deepMoss.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                  const SizedBox(width: 2),
                  // Voice/Send button
                  GestureDetector(
                    onTap: () {
                      if (_hasText) {
                        widget.onSend();
                      } else {
                        _startVoiceRecording();
                      }
                    },
                    child: Container(
                      width: 40,
                      height: 40,
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
                      child: Icon(
                        _hasText ? Icons.arrow_upward_rounded : Icons.mic_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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

// ── Message bubble with tail painter ─────────────────────────────────────────

class _MessageBubbleWithTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(size.width, size.height),
        [
          const Color(0xFFFFFFFF).withValues(alpha: 0.65),
          const Color(0xFFFFFFFF).withValues(alpha: 0.35),
        ],
      )
      ..style = PaintingStyle.fill;

    final path = Path();
    const radius = 22.0;
    const tailWidth = 8.0;
    const tailHeight = 10.0;
    
    // Start from top-left, after the tail area
    path.moveTo(tailWidth + radius, 0);
    
    // Top-right corner
    path.lineTo(size.width - radius, 0);
    path.arcToPoint(
      Offset(size.width, radius),
      radius: const Radius.circular(radius),
    );
    
    // Right side
    path.lineTo(size.width, size.height - radius);
    
    // Bottom-right corner
    path.arcToPoint(
      Offset(size.width - radius, size.height),
      radius: const Radius.circular(radius),
    );
    
    // Bottom side
    path.lineTo(tailWidth + radius, size.height);
    
    // Bottom-left corner (where tail connects)
    path.arcToPoint(
      Offset(tailWidth, size.height - radius),
      radius: const Radius.circular(radius),
    );
    
    // Left side down to tail connection point
    final tailConnectionY = size.height - radius - 4;
    path.lineTo(tailWidth, tailConnectionY + tailHeight);
    
    // Tail - smooth curve pointing left
    path.quadraticBezierTo(
      tailWidth * 0.3, tailConnectionY + tailHeight * 0.7,
      0, tailConnectionY + tailHeight * 0.5,
    );
    path.quadraticBezierTo(
      tailWidth * 0.3, tailConnectionY + tailHeight * 0.3,
      tailWidth, tailConnectionY,
    );
    
    // Continue left side up
    path.lineTo(tailWidth, radius);
    
    // Top-left corner
    path.arcToPoint(
      Offset(tailWidth + radius, 0),
      radius: const Radius.circular(radius),
    );
    
    path.close();

    // Draw shadow
    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.06), 16, false);
    
    // Draw fill
    canvas.drawPath(path, paint);

    // Draw border
    final borderPaint = Paint()
      ..color = const Color(0xFFFFFFFF).withValues(alpha: 0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(path, borderPaint);
    
    // Draw highlight on top and left
    final highlightPaint = Paint()
      ..color = const Color(0xFFFFFFFF).withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    
    final highlightPath = Path();
    highlightPath.moveTo(tailWidth + radius, 0.6);
    highlightPath.lineTo(size.width - radius, 0.6);
    canvas.drawPath(highlightPath, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
