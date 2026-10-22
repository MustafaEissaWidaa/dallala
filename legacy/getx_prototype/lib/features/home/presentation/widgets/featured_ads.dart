import 'package:flutter/material.dart';

class FeaturedAdCard extends StatelessWidget {
  const FeaturedAdCard({super.key});

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.all(Radius.circular(20));
    return Container(
      width: 220,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: radius,
        boxShadow: [
          BoxShadow(color: Color(0x0F231A12), offset: Offset(0, 1), blurRadius: 2),
          BoxShadow(color: Color(0x0F231A12), offset: Offset(0, 4), blurRadius: 16),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // الصورة
            SizedBox(
              height: 128,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const ColoredBox(color: Color(0xFFF0DCCB)),
                  CustomPaint(painter: _DunePainter()),
                  const Center(
                    child: ImageIcon(AssetImage("assets/03-Icons/png-terracotta/car.png")),
                  ),
                  // شارة مميّز
                  PositionedDirectional(
                    top: 10,
                    start: 10,
                    child: Container(
                      height: 24,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9A23B),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'مميّز',
                        style: TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF231A12),
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                  // زر المفضلة
                  PositionedDirectional(
                    top: 10,
                    end: 10,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.favorite_border_rounded,
                          size: 18, color: Color(0xFF231A12)),
                    ),
                  ),
                ],
              ),
            ),
            // النصوص
            const Padding(
              padding: EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '٤٥٬٠٠٠٬٠٠٠ ج.س',
                    style: TextStyle(
                      fontFamily: 'Readex Pro',
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFB8431A),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'تويوتا هايلكس ٢٠١٨',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF231A12),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'الأبيض · حي القبة',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6E5F50),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// الكثيب في أسفل الصورة
class _DunePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 220, sy = size.height / 128;
    final path = Path()
      ..moveTo(0, 104 * sy)
      ..quadraticBezierTo(70 * sx, 88 * sy, 130 * sx, 100 * sy)
      ..quadraticBezierTo(190 * sx, 112 * sy, 220 * sx, 94 * sy)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = const Color(0xFFE7C9B1));
  }

  @override
  bool shouldRepaint(_DunePainter oldDelegate) => false;
}