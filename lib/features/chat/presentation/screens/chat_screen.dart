import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soulpet/core/constants/app_colors.dart';
import 'package:soulpet/shared/widgets/liquid_glass.dart';

class _Message {
  final String text;
  final bool isUser;
  final String time;
  const _Message({required this.text, required this.isUser, required this.time});
}

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
      _messages.add(_Message(text: text, isUser: true, time: _currentTime()));
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
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                  itemCount: _messages.length,
                  itemBuilder: (context, i) {
                    final msg = _messages[i];
                    final next = i < _messages.length - 1 ? _messages[i + 1] : null;
                    final showTail = next == null || next.isUser != msg.isUser;
                    return _MessageRow(msg: msg, showTail: showTail);
                  },
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

// ── Top bar ──────────────────────────────────────────────────────────────────

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

// ── Message row ──────────────────────────────────────────────────────────────

class _MessageRow extends StatelessWidget {
  final _Message msg;
  final bool showTail;

  const _MessageRow({required this.msg, required this.showTail});

  @override
  Widget build(BuildContext context) {
    final maxW = MediaQuery.of(context).size.width * 0.72;
    final isUser = msg.isUser;

    return Padding(
      padding: EdgeInsets.only(bottom: showTail ? 10 : 2),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            if (showTail)
              LiquidGlassCircle(
                size: 30,
                child: const Icon(Icons.pets_rounded, size: 14, color: AppColors.deepMoss),
              )
            else
              const SizedBox(width: 30),
            const SizedBox(width: 4),
          ],
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxW),
            child: _IMessageBubble(
              msg: msg,
              isUser: isUser,
              showTail: showTail,
            ),
          ),
        ],
      ),
    );
  }
}

// ── iMessage bubble ──────────────────────────────────────────────────────────

const double _kRadius = 18.0;

/// Строит путь пузыря iMessage с хвостиком.
/// [isMe]=true → хвостик справа внизу (зелёный, пользователь)
/// [isMe]=false → хвостик слева внизу (серый, питомец)
Path _buildBubblePath(Size size, {required bool isMe, required bool showTail}) {
  final double r = _kRadius;
  final double w = size.width;
  final double h = size.height;
  final p = Path();

  if (isMe) {
    // ═══════════════════════════════════════════════════════════════════════
    // ПРАВЫЙ пузырь (пользователь): хвостик справа внизу
    // ═══════════════════════════════════════════════════════════════════════
    p.moveTo(r, 0);
    p.lineTo(w - r, 0);
    p.arcToPoint(Offset(w, r), radius: Radius.circular(r));
    
    if (showTail) {
      // Правая сторона до хвостика
      p.lineTo(w, h - 6);
      // Хвостик: кривая Безье вправо-вниз
      p.cubicTo(
        w, h - 2,        // control point 1
        w + 4, h + 2,    // control point 2
        w + 10, h + 2,   // end point (кончик хвоста)
      );
      // Возврат к нижней части пузыря
      p.cubicTo(
        w + 2, h + 2,    // control point 1
        w - 4, h,        // control point 2
        w - r, h,        // end point
      );
    } else {
      p.lineTo(w, h - r);
      p.arcToPoint(Offset(w - r, h), radius: Radius.circular(r));
    }
    
    // Нижняя и левая стороны
    p.lineTo(r, h);
    p.arcToPoint(Offset(0, h - r), radius: Radius.circular(r));
    p.lineTo(0, r);
    p.arcToPoint(Offset(r, 0), radius: Radius.circular(r));
    
  } else {
    // ═══════════════════════════════════════════════════════════════════════
    // ЛЕВЫЙ пузырь (питомец): хвостик слева внизу
    // ═══════════════════════════════════════════════════════════════════════
    p.moveTo(r, 0);
    p.lineTo(w - r, 0);
    p.arcToPoint(Offset(w, r), radius: Radius.circular(r));
    p.lineTo(w, h - r);
    p.arcToPoint(Offset(w - r, h), radius: Radius.circular(r));
    
    if (showTail) {
      // Нижняя сторона до хвостика
      p.lineTo(r, h);
      // Хвостик: кривая Безье влево-вниз
      p.cubicTo(
        4, h,            // control point 1
        -2, h + 2,       // control point 2
        -10, h + 2,      // end point (кончик хвоста)
      );
      // Возврат к левой стороне пузыря
      p.cubicTo(
        -2, h + 2,       // control point 1
        0, h - 2,        // control point 2
        0, h - 6,        // end point
      );
    } else {
      p.lineTo(r, h);
      p.arcToPoint(Offset(0, h - r), radius: Radius.circular(r));
    }
    
    // Левая сторона
    p.lineTo(0, r);
    p.arcToPoint(Offset(r, 0), radius: Radius.circular(r));
  }

  p.close();
  return p;
}

class _IMessageBubble extends StatelessWidget {
  final _Message msg;
  final bool isUser;
  final bool showTail;

  const _IMessageBubble({
    required this.msg,
    required this.isUser,
    required this.showTail,
  });

  // Точные цвета iMessage
  static const Color _userBubbleColor = Color(0xFF34C759); // Зелёный iMessage
  static const Color _petBubbleColor = Color(0xFFE9E9EB);  // Светло-серый iMessage

  @override
  Widget build(BuildContext context) {
    // Отступы внутри пузыря
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: _BubbleContent(msg: msg, isUser: isUser),
    );

    // Добавляем margin для хвостика
    final margin = EdgeInsets.only(
      left: isUser ? 0 : (showTail ? 10 : 0),
      right: isUser ? (showTail ? 10 : 0) : 0,
    );

    if (isUser) {
      return Padding(
        padding: margin,
        child: CustomPaint(
          painter: _BubblePainter(
            isUser: true,
            showTail: showTail,
            color: _userBubbleColor,
          ),
          child: content,
        ),
      );
    } else {
      // Питомец: светло-серый пузырь
      return Padding(
        padding: margin,
        child: CustomPaint(
          painter: _BubblePainter(
            isUser: false,
            showTail: showTail,
            color: _petBubbleColor,
          ),
          child: content,
        ),
      );
    }
  }
}

class _BubblePainter extends CustomPainter {
  final bool isUser;
  final bool showTail;
  final Color color;

  const _BubblePainter({
    required this.isUser,
    required this.showTail,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = _buildBubblePath(size, isMe: isUser, showTail: showTail);
    // Заливка без тени (как в iMessage)
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_BubblePainter o) =>
      o.isUser != isUser || o.showTail != showTail || o.color != color;
}

class _BubbleClipper extends CustomClipper<Path> {
  final bool isMe;
  final bool showTail;
  const _BubbleClipper({required this.isMe, required this.showTail});

  @override
  Path getClip(Size size) =>
      _buildBubblePath(size, isMe: isMe, showTail: showTail);

  @override
  bool shouldReclip(_BubbleClipper o) =>
      o.showTail != showTail || o.isMe != isMe;
}

class _BubbleContent extends StatelessWidget {
  final _Message msg;
  final bool isUser;
  const _BubbleContent({required this.msg, required this.isUser});

  @override
  Widget build(BuildContext context) {
    // Цвета текста как в iMessage
    final textColor = isUser ? Colors.white : Colors.black;
    final timeColor = isUser ? Colors.white70 : Colors.black54;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          msg.text,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            height: 1.3,
          ),
        ),
      ],
    );
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
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: LiquidGlassCard(
              borderRadius: 50,
              padding: EdgeInsets.zero,
              child: TextField(
                controller: controller,
                onSubmitted: (_) => onSend(),
                textInputAction: TextInputAction.send,
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Write a message...',
                  hintStyle:
                      TextStyle(color: AppColors.textHint, fontSize: 15),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(Icons.pets_rounded,
                        color: AppColors.deepMoss, size: 20),
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 16),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 50,
              height: 50,
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
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.45),
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.deepMoss.withValues(alpha: 0.30),
                    blurRadius: 16,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_upward_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
