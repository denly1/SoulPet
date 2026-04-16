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
    _Message(text: 'Hey! How are you?', isUser: true, time: '10:24'),
    _Message(text: 'Hi! 😊 Doing great, just resting!', isUser: false, time: '10:25'),
    _Message(text: 'Want to play together?', isUser: true, time: '10:26'),
    _Message(text: 'Yay! 🐾 Fetch or commands?', isUser: false, time: '10:27'),
    _Message(text: 'Fetch first, then commands!', isUser: true, time: '10:28'),
    _Message(text: 'Perfect! 🎾 Running for the ball!', isUser: false, time: '10:28'),
    _Message(text: 'You are the best! 🥰', isUser: true, time: '10:29'),
    _Message(text: 'Woof! 🐶 Love you so much! ♡', isUser: false, time: '10:29'),
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
                    final msg  = _messages[i];
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
    final screenW = MediaQuery.of(context).size.width;
    // Аватар 30 + зазор 16 + выступ хвостика 11 с каждой стороны
    final maxW = screenW * 0.72;
    final isUser = msg.isUser;

    final outerPadding = EdgeInsets.only(
      left:   isUser ? 8 : 0,
      right:  isUser ? 0 : 8,
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
            // Зазор 3px воздух (хвостик уже компенсирован padding в _IMessageBubble)
            const SizedBox(width: 3),
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

const double _kTailOutset = 14.0;

Path _buildBubblePath(Size size, {required bool isMe, required bool showTail}) {
  final w = size.width;
  final h = size.height;
  const double r = 20.0;
  final t = _kTailOutset;
  final p = Path();

  if (!showTail) {
    p.addRRect(RRect.fromLTRBR(0, 0, w, h, const Radius.circular(r)));
    return p;
  }

  if (isMe) {
    p.moveTo(r, 0);
    p.lineTo(w - r, 0);
    p.arcToPoint(Offset(w, r), radius: const Radius.circular(r));
    // Правый бок вниз до стыка хвоста (~40%)
    p.lineTo(w, h * 0.40);
    // Длинная вогнутая кривая → кончик
    p.cubicTo(w, h * 0.85, w + t * 0.7, h * 0.96, w + t, h);
    // Плавный возврат к низу тела
    p.cubicTo(w + t * 0.15, h, w + 1, h, w - 3, h);
    // Низ
    p.lineTo(r, h);
    p.arcToPoint(Offset(0, h - r), radius: const Radius.circular(r));
    p.lineTo(0, r);
    p.arcToPoint(Offset(r, 0), radius: const Radius.circular(r));
    p.close();
  } else {
    p.moveTo(r, 0);
    p.lineTo(w - r, 0);
    p.arcToPoint(Offset(w, r), radius: const Radius.circular(r));
    p.lineTo(w, h - r);
    p.arcToPoint(Offset(w - r, h), radius: const Radius.circular(r));
    // Низ влево до стыка хвоста
    p.lineTo(3, h);
    // Плавный переход к кончику
    p.cubicTo(-1, h, -t * 0.15, h, -t, h);
    // Длинная вогнутая кривая вверх по левому боку
    p.cubicTo(-t * 0.7, h * 0.96, 0, h * 0.85, 0, h * 0.40);
    // Левый бок вверх
    p.lineTo(0, r);
    p.arcToPoint(Offset(r, 0), radius: const Radius.circular(r));
    p.close();
  }

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
    final painter = _GlassBubblePainter(isUser: isUser, showTail: showTail);
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: _BubbleContent(msg: msg, isUser: isUser),
    );

    if (showTail) {
      return Padding(
        padding: EdgeInsets.only(
          right: isUser ? _kTailOutset : 0,
          left:  isUser ? 0 : _kTailOutset,
        ),
        child: CustomPaint(painter: painter, child: content),
      );
    }
    return CustomPaint(painter: painter, child: content);
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
    final rect  = Rect.fromLTWH(0, 0, size.width, size.height);

    // Тень
    canvas.drawShadow(path, const Color(0x1A000000), 4, false);

    // Стеклянный залив
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

    // Обводка
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.70)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
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
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 15.0,
        height: 1.3,
        letterSpacing: -0.1,
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
