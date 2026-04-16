import 'package:flutter/material.dart';

/// iMessage-style chat bubble with smooth tail.
/// 
/// Usage:
/// ```dart
/// IMessageBubble(
///   text: 'Hello!',
///   isMe: true,
///   time: '10:30',
/// )
/// ```
class IMessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String? time;
  final Color? color;
  final Color? textColor;

  const IMessageBubble({
    super.key,
    required this.text,
    required this.isMe,
    this.time,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final bubbleColor = color ?? (isMe ? const Color(0xFF007AFF) : const Color(0xFFE9E9EB));
    final contentColor = textColor ?? (isMe ? Colors.white : Colors.black);
    final timeColor = isMe ? Colors.white.withValues(alpha: 0.7) : Colors.black54;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        child: CustomPaint(
          painter: _BubblePainter(
            color: bubbleColor,
            isMe: isMe,
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              isMe ? 14 : 18,  // left: extra space for tail on left
              10,
              isMe ? 18 : 14,  // right: extra space for tail on right
              time != null ? 24 : 10,
            ),
            child: Stack(
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: contentColor,
                    fontSize: 16,
                    height: 1.35,
                  ),
                ),
                if (time != null)
                  Positioned(
                    right: 0,
                    bottom: -14,
                    child: Text(
                      time!,
                      style: TextStyle(
                        color: timeColor,
                        fontSize: 11,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BubblePainter extends CustomPainter {
  final Color color;
  final bool isMe;

  const _BubblePainter({
    required this.color,
    required this.isMe,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = _buildBubblePath(size, isMe);
    
    // Optional subtle shadow
    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.15), 4, false);
    canvas.drawPath(path, paint);
  }

  Path _buildBubblePath(Size size, bool tailRight) {
    const double r = 18.0;      // corner radius
    const double tailW = 8.0;   // tail width at base
    const double tailH = 6.0;   // how far tail extends horizontally
    
    final double w = size.width;
    final double h = size.height;
    
    final path = Path();

    if (tailRight) {
      // ═══════════════════════════════════════════════════════════════
      // Sender bubble (tail on bottom-right, pointing right)
      // ═══════════════════════════════════════════════════════════════
      
      // Start: top-left corner
      path.moveTo(r, 0);
      
      // Top edge
      path.lineTo(w - r, 0);
      
      // Top-right corner
      path.arcToPoint(
        Offset(w, r),
        radius: const Radius.circular(r),
      );
      
      // Right edge (stop before tail)
      path.lineTo(w, h - r - tailW);
      
      // Tail: smooth curve going right then back
      // Control point 1: start curving outward
      path.quadraticBezierTo(
        w, h - tailW * 0.5,           // control: right edge, moving down
        w + tailH, h,                  // end: tip of tail (extends right)
      );
      
      // Tail: curve back into bubble
      path.quadraticBezierTo(
        w - 2, h,                      // control: back toward bubble
        w - r, h,                      // end: bottom edge
      );
      
      // Bottom edge
      path.lineTo(r, h);
      
      // Bottom-left corner
      path.arcToPoint(
        Offset(0, h - r),
        radius: const Radius.circular(r),
      );
      
      // Left edge
      path.lineTo(0, r);
      
      // Top-left corner
      path.arcToPoint(
        Offset(r, 0),
        radius: const Radius.circular(r),
      );
      
    } else {
      // ═══════════════════════════════════════════════════════════════
      // Receiver bubble (tail on bottom-left, pointing left)
      // ═══════════════════════════════════════════════════════════════
      
      // Start: top-left corner (after radius)
      path.moveTo(r, 0);
      
      // Top edge
      path.lineTo(w - r, 0);
      
      // Top-right corner
      path.arcToPoint(
        Offset(w, r),
        radius: const Radius.circular(r),
      );
      
      // Right edge
      path.lineTo(w, h - r);
      
      // Bottom-right corner
      path.arcToPoint(
        Offset(w - r, h),
        radius: const Radius.circular(r),
      );
      
      // Bottom edge (stop before tail)
      path.lineTo(r, h);
      
      // Tail: curve going left then back up
      path.quadraticBezierTo(
        2, h,                          // control: toward left edge
        -tailH, h,                     // end: tip of tail (extends left)
      );
      
      // Tail: curve back into bubble
      path.quadraticBezierTo(
        0, h - tailW * 0.5,            // control: curving back up
        0, h - r - tailW,              // end: left edge
      );
      
      // Left edge (rest of it)
      path.lineTo(0, r);
      
      // Top-left corner
      path.arcToPoint(
        Offset(r, 0),
        radius: const Radius.circular(r),
      );
    }

    path.close();
    return path;
  }

  @override
  bool shouldRepaint(_BubblePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.isMe != isMe;
}

// ═══════════════════════════════════════════════════════════════════════════
// Example usage in a chat screen
// ═══════════════════════════════════════════════════════════════════════════

class IMessageChatExample extends StatelessWidget {
  const IMessageChatExample({super.key});

  @override
  Widget build(BuildContext context) {
    final messages = [
      (text: 'Hey! How are you?', isMe: true, time: '10:24'),
      (text: 'I\'m good, thanks! Just finished work 😊', isMe: false, time: '10:25'),
      (text: 'Nice! Want to grab dinner tonight?', isMe: true, time: '10:26'),
      (text: 'Sure! Where do you want to go?', isMe: false, time: '10:27'),
      (text: 'How about that new Italian place downtown?', isMe: true, time: '10:28'),
      (text: 'Perfect! I\'ve been wanting to try it. See you at 7?', isMe: false, time: '10:29'),
      (text: '👍', isMe: true, time: '10:29'),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: const Color(0xFFF8F8F8),
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final msg = messages[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: IMessageBubble(
              text: msg.text,
              isMe: msg.isMe,
              time: msg.time,
            ),
          );
        },
      ),
    );
  }
}
