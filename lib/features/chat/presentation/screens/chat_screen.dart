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

    // Отступ снаружи: 10 со стороны хвостика (для его выступа), 6 с другой
    final outerPadding = EdgeInsets.only(
      left: isUser ? 6 : 10,
      right: isUser ? 10 : 6,
      bottom: showTail ? 8 : 2,
    );

    return Padding(
      padding: outerPadding,
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

const double _kR = 18.0;

/// Строит путь пузыря iMessage 1-в-1.
/// Хвостик: плавный переход стенки → острый кончик → вогнутый возврат.
Path _buildBubblePath(Size size, {required bool isMe, required bool showTail}) {
  final double r = _kR;
  final double w = size.width;
  final double h = size.height;
  final p = Path();

  if (isMe) {
    // ── Правый пузырь (пользователь) ──
    p.moveTo(r, 0);
    p.lineTo(w - r, 0);
    p.arcToPoint(Offset(w, r), radius: Radius.circular(r));

    if (showTail) {
      // Правая стенка до хвостика
      p.lineTo(w, h - r);
      // Плавный переход стенки в хвостик
      p.cubicTo(
        w, h - 4,           // cp1: продолжение стенки
        w, h + 0.5,         // cp2: чуть ниже дна
        w + 8, h + 2,       // кончик хвоста
      );
      // Вогнутый возврат от кончика к дну пузыря
      p.cubicTo(
        w + 3, h + 1,       // cp1: рядом с кончиком
        w - 4, h + 0.5,     // cp2: к дну с вогнутостью
        w - r, h,           // точка на дне
      );
    } else {
      p.lineTo(w, h - r);
      p.arcToPoint(Offset(w - r, h), radius: Radius.circular(r));
    }

    // Дно и левая сторона
    p.lineTo(r, h);
    p.arcToPoint(Offset(0, h - r), radius: Radius.circular(r));
    p.lineTo(0, r);
    p.arcToPoint(Offset(r, 0), radius: Radius.circular(r));

  } else {
    // ── Левый пузырь (питомец) ──
    p.moveTo(r, 0);
    p.lineTo(w - r, 0);
    p.arcToPoint(Offset(w, r), radius: Radius.circular(r));
    p.lineTo(w, h - r);
    p.arcToPoint(Offset(w - r, h), radius: Radius.circular(r));

    if (showTail) {
      // Дно до хвостика
      p.lineTo(r, h);
      // Плавный переход дна в хвостик
      p.cubicTo(
        4, h + 0.5,         // cp1: к краю дна
        0, h + 0.5,         // cp2: чуть ниже дна
        -8, h + 2,          // кончик хвоста
      );
      // Вогнутый возврат от кончика к стенке
      p.cubicTo(
        -3, h + 1,          // cp1: рядом с кончиком
        0, h - 4,           // cp2: к стенке с вогнутостью
        0, h - r,           // точка на стенке
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

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      child: _BubbleContent(msg: msg, isUser: isUser),
    );

    // Без BackdropFilter на каждом пузыре — только paint
    return CustomPaint(
      painter: _GlassBubblePainter(
        isUser: isUser,
        showTail: showTail,
      ),
      child: content,
    );
  }
}

class _GlassBubblePainter extends CustomPainter {
  final bool isUser;
  final bool showTail;

  const _GlassBubblePainter({
    required this.isUser,
    required this.showTail,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = _buildBubblePath(size, isMe: isUser, showTail: showTail);
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Лёгкая тень для глубины
    canvas.drawShadow(
      path,
      const Color(0x1A000000),
      6,
      false,
    );

    // Оба пузыря — чистый прозрачный white glass
    final gradient = LinearGradient(
      colors: [
        Colors.white.withValues(alpha: 0.55),
        Colors.white.withValues(alpha: 0.35),
        Colors.white.withValues(alpha: 0.20),
      ],
      stops: const [0.0, 0.55, 1.0],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    canvas.drawPath(
      path,
      Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.fill,
    );

    // Белая обводка для обоих
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.70)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  @override
  bool shouldRepaint(_GlassBubblePainter o) =>
      o.isUser != isUser || o.showTail != showTail;
}


class _BubbleContent extends StatelessWidget {
  final _Message msg;
  final bool isUser;
  const _BubbleContent({required this.msg, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Text(
      msg.text,
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 16.5,
        height: 1.25,
        letterSpacing: -0.2,
        fontWeight: FontWeight.w500,
      ),
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
