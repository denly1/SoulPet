import 'dart:math' as math;

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
    _Message(text: 'Hi! Doing great, just resting.', isUser: false, time: '10:25'),
    _Message(text: 'Want to play together?', isUser: true, time: '10:26'),
    _Message(text: 'Sure! Fetch or commands?', isUser: false, time: '10:27'),
    _Message(text: 'Fetch first, then commands!', isUser: true, time: '10:28'),
    _Message(text: 'Perfect, running for the ball!', isUser: false, time: '10:28'),
    _Message(text: 'You are the best.', isUser: true, time: '10:29'),
    _Message(text: 'Love you so much.', isUser: false, time: '10:29'),
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
    final double maxW = screenW * 0.72;
    final isUser = msg.isUser;

    final double tailGap = showTail ? 0.0 : _kTailOutset;

    final outerPadding = EdgeInsets.only(
      left:   isUser ? 8 : tailGap,
      right:  isUser ? tailGap : 8,
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

// ГИБКИЕ параметры хвостика - МЕНЯЙ ЭТИ ЗНАЧЕНИЯ
const double _kBubbleUserRadiusTL = 20.0; // Радиус верхнего-левого угла пузыря (user)
const double _kBubbleUserRadiusTR = 20.0; // Радиус верхнего-правого угла пузыря (user)
const double _kBubbleUserRadiusBR = 20.0; // Радиус нижнего-правого угла пузыря (user)
const double _kBubbleUserRadiusBL = 20.0; // Радиус нижнего-левого угла пузыря (user)

const double _kBubblePetRadiusTL = 20.0; // Радиус верхнего-левого угла пузыря (pet)
const double _kBubblePetRadiusTR = 20.0; // Радиус верхнего-правого угла пузыря (pet)
const double _kBubblePetRadiusBR = 20.0; // Радиус нижнего-правого угла пузыря (pet)
const double _kBubblePetRadiusBL = 20.0; // Радиус нижнего-левого угла пузыря (pet)

const double _kTailOutset = 20.0; // Длина хвоста в px (меньше = короче)
const double _kTailStartHeight = 1; // Где хвост выходит из облака по высоте (0..1), меньше = выше
const double _kTailBottomHeight = 1; // Нижняя линия хвоста по высоте (0..1), меньше = поднять низ
const double _kTailCurveControl1 = 0; // Плавность/изгиб верхней линии (0.75..0.95)
const double _kTailCurveControl2 = 0; // Плавность/изгиб ближе к кончику (0.85..0.99)
const double _kTailBottomCurve = 0 ; // Острота низа: меньше = острее клин, больше = круглее

const double _kTailJoinOverlap = 6.0; // Склейка хвоста с облаком (px): больше = меньше шов
const double _kTailJoinFeather = 0.0; // Сглаживание стыка (px): 0 = выкл, 2..8 = мягче переход у основания
const double _kTailJoinAnchorFactor = 1.0; // Где по основанию (0..1) применять сглаживание: 0 = у верхней точки, 1 = у нижней
const double _kTailJoinSpanFactor = 0.0; // Насколько вниз (0..1 от tailOutset) тянуть сглаживание от верхнего основания
const double _kTailJoinShoulder = 4.0; // S-стык сверху (px): 0 = выкл, 2..10 = плавный выход хвоста от грани bubble
const double _kTailJoinShoulderBottom = 1; // S-стык снизу (px): 0 = выкл, 2..10 = плавный вход хвоста в bubble снизу
const double _kTailJoinPatchDx = 6.0;
const double _kTailJoinPatchDy = 6.0;
const double _kTailJoinPatchRotationDeg = 0.0;

const double _kTailTipXFactor = 0.9; // Положение кончика по X (0..1): 1 = на краю, 0.5 = ближе к облаку
const double _kTailTipYFactor = 1.0; // Положение кончика по Y (0..1): 0 = у верхней точки, 1 = у нижней
const double _kTailTopArc = 0.0; // Дуга верхней стороны клина (0..1): 0 = прямая, 0.2..0.5 = заметная дуга
const double _kTailBottomArc = 0.1; // Дуга нижней стороны клина (0..1): 0 = прямая, 0.2..0.5 = заметная дуга

Path _buildBubblePath(Size size, {required bool isMe, required bool showTail}) {
  final w = size.width; // Ширина области рисования (bubble) в px
  final h = size.height; // Высота области рисования (bubble) в px
  const double r = 20.0; // Радиус скругления углов пузыря
  final t = _kTailOutset; // Длина хвостика (вылет) в px
  final p = Path(); // Контур пузыря (Path)

  if (!showTail) {
    // Если хвост не нужен — рисуем обычный скруглённый прямоугольник.
    p.addRRect(RRect.fromLTRBR(0, 0, w, h, const Radius.circular(r)));
    return p;
  }

  if (isMe) {
    // Пузырь пользователя (хвост справа).
    p.moveTo(r, 0); // Стартуем на верхней стороне, после левого скругления
    p.lineTo(w - r, 0); // Идём по верхней стороне до правого скругления (x = w - r)
    p.arcToPoint(Offset(w, r), radius: const Radius.circular(r)); // Правый верхний угол (дуга)
    p.lineTo(w, h * 0.40); // Спускаемся по правой стороне до места хвоста
    p.cubicTo(w, h * 0.85, w + t * 0.7, h * 0.96, w + t, h); // Верхняя линия хвоста к кончику
    p.cubicTo(w + t * 0.05, h, w - 1, h, w - 3, h); // Возврат от кончика хвоста в нижнюю грань пузыря
    p.lineTo(r, h); // Низ пузыря влево до левого скругления
    p.arcToPoint(Offset(0, h - r), radius: const Radius.circular(r)); // Левый нижний угол (дуга)
    p.lineTo(0, r); // Левая сторона вверх до верхнего скругления
    p.arcToPoint(Offset(r, 0), radius: const Radius.circular(r)); // Левый верхний угол (дуга)
    p.close();
  } else {
    // Пузырь питомца (хвост слева).
    // ВЫЧИСЛЯЕМЫЕ параметры хвоста из констант (привязка к высоте пузыря).
    final tailBottom = h * _kTailBottomHeight; // y-низ хвоста
    final tailStart = h * _kTailStartHeight; // y-верх хвоста (точка выхода)
    
    p.moveTo(r, 0); // Старт на верхней стороне после левого скругления
    p.lineTo(w - r, 0); // Верхняя грань до правого скругления
    p.arcToPoint(Offset(w, r), radius: const Radius.circular(r)); // Правый верхний угол
    p.lineTo(w, h - r); // Правая сторона вниз до нижнего скругления
    p.arcToPoint(Offset(w - r, h), radius: const Radius.circular(r)); // Правый нижний угол
    p.lineTo(0, h); // Низ пузыря до самого левого края (x = 0)
    p.lineTo(0, tailStart); // Поднимаемся по левому краю до точки старта хвоста
    
    // Верхняя кривая хвоста к кончику (уходит влево на -t)
    p.cubicTo(
      -t * 0.7, h * _kTailCurveControl2,
      0, h * _kTailCurveControl1,
      -t, tailBottom,
    );
    
    // Нижняя линия хвоста обратно к левому краю пузыря
    p.cubicTo(
      -t * _kTailBottomCurve, tailBottom,
      -1, tailBottom,
      0, tailStart,
    );
    
    p.lineTo(0, r); // Левая сторона вверх до верхнего скругления
    p.arcToPoint(Offset(r, 0), radius: const Radius.circular(r)); // Левый верхний угол
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
      return CustomPaint(
        painter: painter,
        child: Padding(
          padding: EdgeInsets.only(
            right: isUser ? _kTailOutset : 0,
            left: isUser ? 0 : _kTailOutset,
          ),
          child: content,
        ),
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
    final double radTL = isUser ? _kBubbleUserRadiusTL : _kBubblePetRadiusTL;
    final double radTR = isUser ? _kBubbleUserRadiusTR : _kBubblePetRadiusTR;
    final double radBR = isUser ? _kBubbleUserRadiusBR : _kBubblePetRadiusBR;
    final double radBL = isUser ? _kBubbleUserRadiusBL : _kBubblePetRadiusBL;

    final double r = math.max(math.max(radTL, radTR), math.max(radBL, radBR));
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

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

    final fillPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.70)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..strokeMiterLimit = 2.0;

    final double tailW = showTail ? _kTailOutset : 0.0;
    final Rect cloudRect = showTail
        ? (isUser
            ? Rect.fromLTWH(0, 0, size.width - tailW, size.height)
            : Rect.fromLTWH(tailW, 0, size.width - tailW, size.height))
        : rect;

    final cloudPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          cloudRect,
          topLeft: Radius.circular(radTL),
          topRight: Radius.circular(radTR),
          bottomRight: Radius.circular(radBR),
          bottomLeft: Radius.circular(radBL),
        ),
      );

    Path shapePath = cloudPath;
    Path? tailPathForStroke;
    if (showTail) {
      double clampD(double v, double min, double max) {
        if (v < min) return min;
        if (v > max) return max;
        return v;
      }

      final double overlap = _kTailJoinOverlap;
      final double baseX = isUser ? (cloudRect.right - overlap) : (cloudRect.left + overlap);
      final double cloudEdgeX = isUser ? cloudRect.right : cloudRect.left;
      final double tipX = clampD(
        isUser
            ? (cloudEdgeX + tailW * _kTailTipXFactor)
            : (cloudEdgeX - tailW * _kTailTipXFactor),
        0.0,
        size.width,
      );

      final double tailStartY = clampD(
        size.height * _kTailStartHeight,
        r + 2,
        size.height - r - 2,
      );
      final double maxBottomY = (tailStartY + tailW * 0.85)
          .clamp(0.0, size.height - 2)
          .toDouble();
      final double tailBottomY = clampD(
        size.height * _kTailBottomHeight,
        tailStartY + tailW * 0.25,
        maxBottomY,
      );
      final double tipFactor = clampD(_kTailTipYFactor, 0.0, 1.0);
      final double tipY = tailStartY + (tailBottomY - tailStartY) * tipFactor;

      final double topArc = clampD(_kTailTopArc, 0.0, 1.0);
      final double bottomArc = clampD(_kTailBottomArc, 0.0, 1.0);
      final double shoulder = clampD(_kTailJoinShoulder, 0.0, tailW);
      final double shoulderBottom = clampD(_kTailJoinShoulderBottom, 0.0, tailW);

      Offset outwardControlPoint(Offset a, Offset b, double bulge) {
        final mid = Offset((a.dx + b.dx) * 0.5, (a.dy + b.dy) * 0.5);
        final v = Offset(b.dx - a.dx, b.dy - a.dy);
        var n = Offset(-v.dy, v.dx);
        final len = n.distance;
        if (len == 0) return mid;
        n = Offset(n.dx / len, n.dy / len);
        final bulgePx = _kTailOutset * bulge;
        final toInside = Offset(cloudRect.center.dx - mid.dx, cloudRect.center.dy - mid.dy);
        final dot = n.dx * toInside.dx + n.dy * toInside.dy;
        if (dot < 0) {
          n = Offset(-n.dx, -n.dy);
        }
        return Offset(mid.dx + n.dx * bulgePx, mid.dy + n.dy * bulgePx);
      }

      final a = Offset(baseX, tailStartY);
      final b = Offset(tipX, tipY);
      final c = Offset(baseX, tailBottomY);
      final cpTop = outwardControlPoint(a, b, topArc);
      final cpBottom = outwardControlPoint(b, c, bottomArc);

      final tailPath = Path()..moveTo(a.dx, a.dy);
      if (topArc == 0.0) {
        if (shoulder == 0.0) {
          tailPath.lineTo(b.dx, b.dy);
        } else {
          tailPath.lineTo(cloudEdgeX, a.dy);
          tailPath.cubicTo(
            cloudEdgeX,
            a.dy + shoulder,
            b.dx,
            b.dy,
            b.dx,
            b.dy,
          );
        }
      } else {
        if (shoulder == 0.0) {
          tailPath.quadraticBezierTo(cpTop.dx, cpTop.dy, b.dx, b.dy);
        } else {
          tailPath.lineTo(cloudEdgeX, a.dy);
          tailPath.cubicTo(
            cloudEdgeX,
            a.dy + shoulder,
            cpTop.dx,
            cpTop.dy,
            b.dx,
            b.dy,
          );
        }
      }

      if (bottomArc == 0.0) {
        if (shoulderBottom == 0.0) {
          tailPath.lineTo(c.dx, c.dy);
        } else {
          final double tSplit = clampD(1.0 - (shoulderBottom / (tailW * 2.0)), 0.7, 0.97);
          final Offset d = Offset(
            b.dx + (c.dx - b.dx) * tSplit,
            b.dy + (c.dy - b.dy) * tSplit,
          );
          tailPath.lineTo(d.dx, d.dy);

          final Offset v = Offset(c.dx - b.dx, c.dy - b.dy);
          final double vLen = v.distance;
          final Offset dir = vLen == 0.0 ? const Offset(0, 1) : Offset(v.dx / vLen, v.dy / vLen);
          final double handle = clampD(shoulderBottom * 0.8, 0.0, tailW);
          final Offset cp1 = Offset(
            clampD(d.dx + dir.dx * handle, math.min(d.dx, cloudEdgeX), math.max(d.dx, cloudEdgeX)),
            clampD(d.dy + dir.dy * handle, 0.0, size.height),
          );
          final double y2 = clampD(c.dy - shoulderBottom, 0.0, size.height);
          tailPath.cubicTo(cp1.dx, cp1.dy, cloudEdgeX, y2, c.dx, c.dy);
        }
      } else {
        if (shoulderBottom == 0.0) {
          tailPath.quadraticBezierTo(cpBottom.dx, cpBottom.dy, c.dx, c.dy);
        } else {
          final double tSplit = clampD(1.0 - (shoulderBottom / (tailW * 2.0)), 0.7, 0.97);
          Offset lerpO(Offset p, Offset q, double t) => Offset(
                p.dx + (q.dx - p.dx) * t,
                p.dy + (q.dy - p.dy) * t,
              );

          final Offset p1 = lerpO(b, cpBottom, tSplit);
          final Offset p2 = lerpO(cpBottom, c, tSplit);
          final Offset d = lerpO(p1, p2, tSplit);
          tailPath.quadraticBezierTo(p1.dx, p1.dy, d.dx, d.dy);

          final Offset deriv = Offset(
            2.0 * ((1.0 - tSplit) * (cpBottom.dx - b.dx) + tSplit * (c.dx - cpBottom.dx)),
            2.0 * ((1.0 - tSplit) * (cpBottom.dy - b.dy) + tSplit * (c.dy - cpBottom.dy)),
          );
          final double dLen = deriv.distance;
          final Offset dir = dLen == 0.0 ? const Offset(0, 1) : Offset(deriv.dx / dLen, deriv.dy / dLen);
          final double handle = clampD(shoulderBottom * 0.8, 0.0, tailW);
          final Offset cp1 = Offset(
            clampD(d.dx + dir.dx * handle, math.min(d.dx, cloudEdgeX), math.max(d.dx, cloudEdgeX)),
            clampD(d.dy + dir.dy * handle, 0.0, size.height),
          );
          final double y2 = clampD(c.dy - shoulderBottom, 0.0, size.height);
          tailPath.cubicTo(cp1.dx, cp1.dy, cloudEdgeX, y2, c.dx, c.dy);
        }
      }
      tailPath.close();

      tailPathForStroke = tailPath;
      shapePath = Path.combine(PathOperation.union, cloudPath, tailPath);

      final double feather = clampD(_kTailJoinFeather, 0.0, math.min(tailW * 0.6, r));
      if (feather > 0.0) {
        final double span = clampD(_kTailJoinSpanFactor, 0.0, 1.0) * tailW;
        final double anchorFactor = clampD(_kTailJoinAnchorFactor, 0.0, 1.0);
        final double anchorY = tailStartY + (tailBottomY - tailStartY) * anchorFactor;
        final double left = clampD(math.min(baseX, cloudEdgeX) - feather, 0.0, size.width);
        final double right = clampD(math.max(baseX, cloudEdgeX) + feather, 0.0, size.width);
        final joinPath = Path()
          ..addRRect(
            RRect.fromRectXY(
              Rect.fromLTRB(
                left,
                anchorY - feather,
                right,
                (anchorY + feather + span).clamp(0.0, size.height).toDouble(),
              ),
              feather,
              feather,
            ),
          );

        shapePath = Path.combine(PathOperation.union, shapePath, joinPath);
      }
    }

    Path strokeShapePath = shapePath;
    if (showTail && tailPathForStroke != null) {
      final Path extrasOuter = Path.combine(PathOperation.difference, tailPathForStroke, cloudPath);
      strokeShapePath = Path.combine(PathOperation.union, cloudPath, extrasOuter);
    }

    canvas.drawShadow(shapePath, const Color(0x1A000000), 4, false);
    canvas.drawPath(shapePath, fillPaint);
    canvas.drawPath(strokeShapePath, strokePaint);
  }

  @override
  bool shouldRepaint(_GlassBubblePainter o) => true;
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
