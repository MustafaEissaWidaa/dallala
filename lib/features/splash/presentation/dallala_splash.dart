// dallala_splash.dart
// شاشة السبلاش المتحركة لتطبيق «دلّالة» — مرسومة بالكود (بدون فيديو).
// تشتغل تلقائياً عند فتح التطبيق، وبعد ما تخلص تنتقل وحدها للشاشة التالية.
//
// المتطلبات في pubspec.yaml:
//   dependencies:
//     path_drawing: ^1.0.1
//
// الاستخدام:
//   home: DallalaSplash(nextScreen: (_) => const OnboardingScreen()),

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

class DallalaColors {
  static const terracotta = Color(0xFFB8431A);
  static const terracottaDune1 = Color(0xFFA63B15);
  static const terracottaDune2 = Color(0xFF8F3211);
  static const acaciaTree = Color(0xFF7A2A0E);
  static const sand = Color(0xFFFBF6EE);
  static const sandSoft = Color(0xFFFDEDE4);
  static const gum = Color(0xFFE9A23B);
}

class DallalaSplash extends StatefulWidget {
  const DallalaSplash({
    super.key,
    required this.nextScreen,
    this.holdAfterAnimation = const Duration(milliseconds: 700),
  });

  /// الشاشة اللي ننتقل ليها بعد السبلاش (التعريف أو الرئيسية).
  final WidgetBuilder nextScreen;

  /// كم يفضل الشعار ظاهر بعد ما تكتمل الحركة.
  final Duration holdAfterAnimation;

  @override
  State<DallalaSplash> createState() => _DallalaSplashState();
}

class _DallalaSplashState extends State<DallalaSplash>
    with TickerProviderStateMixin {
  // مدة الحركة الأساسية بالملّي ثانية — كل التوقيتات أدناه محسوبة منها.
  static const double _totalMs = 2400;

  late final AnimationController _main = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );
  late final AnimationController _dots = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..repeat();

  bool _navigated = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_main.isAnimating || _main.isCompleted) return;
    // لو المستخدم مفعّل «تقليل الحركة» في الجوال: نعرض الشعار ثابت.
    if (MediaQuery.of(context).disableAnimations) {
      _main.value = 1;
      _finish();
    } else {
      _main.forward().whenComplete(_finish);
    }
  }

  Future<void> _finish() async {
    await Future<void>.delayed(widget.holdAfterAnimation);
    if (!mounted || _navigated) return;
    _navigated = true;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (ctx, _, __) => widget.nextScreen(ctx),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _main.dispose();
    _dots.dispose();
    super.dispose();
  }

  /// تقدّم مرحلة معيّنة (0→1) بين start و end بالملّي ثانية.
  double _p(double startMs, double endMs, [Curve curve = Curves.linear]) {
    final t = ((_main.value * _totalMs - startMs) / (endMs - startMs))
        .clamp(0.0, 1.0);
    return curve.transform(t);
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DallalaColors.terracotta,
      body: LayoutBuilder(
        builder: (context, box) {
          final w = box.maxWidth;
          final h = box.maxHeight;
          final s = w / 390; // مقياس التصميم (عرض التصميم الأصلي 390)
          final markSize = 140 * s;
          final markLeft = (w - markSize) / 2;
          final markTop = h * 0.332;

          return AnimatedBuilder(
            animation: Listenable.merge([_main, _dots]),
            builder: (context, _) {
              // ── التوقيتات (ms) ──
              final dune1 = _p(0, 880, Curves.easeOutCubic);
              final dune2 = _p(200, 1120, Curves.easeOutCubic);
              final sun = _p(320, 1440, Curves.easeOutCubic);
              final tree = _p(800, 1280, Curves.easeOut);
              final tag = _p(0, 960, Curves.easeOutBack);
              final tagFade = _p(0, 400);
              final glyph = _p(600, 1080, Curves.easeOut);
              final dropFall = _p(880, 1240, Curves.easeIn);
              final dropBounce = _p(1240, 1560);
              final ring = _p(1240, 2080, Curves.easeOut);
              final word = _p(1200, 1760, Curves.easeOut);
              final latin = _p(1520, 2080, Curves.easeOut);
              final tagline = _p(1840, 2320, Curves.easeOut);
              final dots = _p(2080, 2400);

              // قطرة الصمغ: تسقط ثم ترتد ارتداد خفيف
              final dropY = dropBounce > 0
                  ? -7 * math.sin(math.pi * dropBounce)
                  : _lerp(-160, 0, dropFall);
              final squash = dropBounce > 0 && dropBounce < 0.35
                  ? 1 - (dropBounce / 0.35)
                  : 0.0;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  // الشمس
                  Positioned(
                    left: 266 * s,
                    top: h * 0.178 + _lerp(90, 0, sun) * s,
                    child: Opacity(
                      opacity: sun,
                      child: _circle(64 * s, DallalaColors.gum),
                    ),
                  ),

                  // الكثيب الخلفي
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: -_lerp(160, 0, dune1) * s,
                    height: 300 * s,
                    child: CustomPaint(
                      painter: _DunePainter(
                        'M0 120 Q100 80 200 108 T390 96 V300 H0Z',
                        const Size(390, 300),
                        DallalaColors.terracottaDune1,
                      ),
                    ),
                  ),

                  // شجرة الهشاب
                  Positioned(
                    left: 24 * s,
                    bottom: 170 * s,
                    width: 90 * s,
                    height: 60 * s,
                    child: Opacity(
                      opacity: tree,
                      child: Transform(
                        alignment: Alignment.bottomCenter,
                        transform: Matrix4.diagonal3Values(1, tree, 1),
                        child: CustomPaint(painter: _TreePainter()),
                      ),
                    ),
                  ),

                  // الكثيب الأمامي
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: -_lerp(200, 0, dune2) * s,
                    height: 220 * s,
                    child: CustomPaint(
                      painter: _DunePainter(
                        'M0 80 Q120 40 240 72 T390 60 V220 H0Z',
                        const Size(390, 220),
                        DallalaColors.terracottaDune2,
                      ),
                    ),
                  ),

                  // الموجة حول الشعار
                  Positioned(
                    left: (w - 160 * s) / 2,
                    top: markTop - 10 * s,
                    child: Opacity(
                      opacity: ring > 0 ? (0.45 * (1 - ring)) : 0,
                      child: Transform.scale(
                        scale: _lerp(0.7, 1.7, ring),
                        child: Container(
                          width: 160 * s,
                          height: 160 * s,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(48 * s),
                            border: Border.all(
                                color: DallalaColors.sand, width: 3 * s),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // الشعار: البطاقة + حرف «د» + قطرة الصمغ
                  Positioned(
                    left: markLeft,
                    top: markTop,
                    width: markSize,
                    height: markSize,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Opacity(
                          opacity: tagFade,
                          child: Transform.rotate(
                            angle: _lerp(-16, 0, tag) * math.pi / 180,
                            child: Transform.scale(
                              scale: _lerp(0.2, 1, tag),
                              child: CustomPaint(
                                size: Size.square(markSize),
                                painter: _SvgPathPainter(
                                    _Paths.tag, _Paths.markBox, DallalaColors.sand),
                              ),
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: glyph,
                          child: Transform.translate(
                            offset: Offset(_lerp(10, 0, glyph) * s, 0),
                            child: CustomPaint(
                              size: Size.square(markSize),
                              painter: _SvgPathPainter(_Paths.glyph,
                                  _Paths.markBox, DallalaColors.terracotta),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 23 * s,
                          top: 60 * s + dropY * s,
                          child: Opacity(
                            opacity: dropFall > 0 ? 1 : 0,
                            child: Transform(
                              alignment: Alignment.bottomCenter,
                              transform: Matrix4.diagonal3Values(
                                  1 + 0.18 * squash, 1 - 0.18 * squash, 1),
                              child: _circle(20 * s, DallalaColors.gum),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // اسم «دلّالة»
                  Positioned(
                    left: 0,
                    right: 0,
                    top: h * 0.531 + _lerp(16, 0, word) * s,
                    child: Opacity(
                      opacity: word,
                      child: Center(
                        child: CustomPaint(
                          size: Size(146 * s, 96 * s),
                          painter: _SvgPathPainter(
                              _Paths.wordmark, _Paths.wordBox, DallalaColors.sand),
                        ),
                      ),
                    ),
                  ),

                  // DALLALA
                  Positioned(
                    left: 0,
                    right: 0,
                    top: h * 0.649,
                    child: Opacity(
                      opacity: 0.75 * latin,
                      child: Text(
                        'DALLALA',
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          color: DallalaColors.sandSoft,
                          fontSize: 13 * s,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 4.2 * s,
                        ),
                      ),
                    ),
                  ),

                  // الشعار النصي
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 118 * s - _lerp(10, 0, tagline) * s,
                    child: Opacity(
                      opacity: tagline,
                      child: Text(
                        'سوق كردفان في جيبك',
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: DallalaColors.sandSoft,
                          fontSize: 15 * s,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  // نقاط التحميل
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 80 * s,
                    child: Opacity(
                      opacity: dots,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (i) {
                          final phase =
                              (_dots.value - i * 0.15) % 1.0; // تأخير لكل نقطة
                          final bounce = math.sin(phase * math.pi);
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4 * s),
                            child: Transform.translate(
                              offset: Offset(0, -5 * s * bounce),
                              child: Opacity(
                                opacity: 0.45 + 0.55 * bounce,
                                child: _circle(
                                  8 * s,
                                  i == 2 ? DallalaColors.gum : DallalaColors.sand,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _circle(double d, Color c) => Container(
        width: d,
        height: d,
        decoration: BoxDecoration(color: c, shape: BoxShape.circle),
      );
}

// ───────────────────────── الرسم ─────────────────────────

class _Paths {
  static const markBox = Rect.fromLTWH(0, 0, 120, 120);
  static const wordBox = Rect.fromLTWH(-2, -64, 122, 80);

  static const tag =
      'M44 8H104Q120 8 120 24V96Q120 112 104 112H44Q36 112 30 106L6 70Q2 60 6 50L30 14Q36 8 44 8Z';

  static const glyph =
      'M63.328 92 60.64 76.928H87.424Q86.464 74.72 84.352 71.696Q82.24 68.672 79.072 65.024Q75.904 61.376 71.584 57.632L83.488 42.272Q90.88 50.624 95.296 58.352Q99.712 66.08 101.008 74.192Q102.304 82.304 100.096 92Z';

  static const wordmark = 'M14.952 -0.84Q10.864 -0.84 7.728 -2.016Q4.592 -3.192 2.828 -5.432Q1.064 -7.672 1.064 -10.808Q1.064 -13.72 2.604 -16.072Q4.144 -18.424 6.916 -20.356Q9.688 -22.288 13.468 -23.996Q17.248 -25.704 21.672 -27.328L23.016 -18.48Q19.264 -17.584 16.772 -16.604Q14.280 -15.624 12.824 -14.644Q11.368 -13.664 10.724 -12.796Q10.08 -11.928 10.08 -11.312Q10.08 -10.584 11.032 -10.108Q11.984 -9.632 14.616 -9.632Q15.176 -9.632 16.240 -9.687Q17.304 -9.744 18.704 -9.940Q20.104 -10.136 21.672 -10.528L23.744 -3.136Q21.504 -2.072 19.516 -1.456Q17.528 -0.84 14.952 -0.84ZM28.616 0.0Q25.032 0.0 22.875 -0.98Q20.72 -1.96 19.628 -3.5Q18.536 -5.04 18.172 -6.832Q17.808 -8.624 17.808 -10.192V-29.904H26.824V-12.712Q26.824 -10.528 27.972 -9.66Q29.12 -8.792 31.696 -8.792H33.544V0.0ZM10.752 -33.04 4.872 -38.976 10.416 -44.968 16.296 -38.976ZM20.608 -33.04 14.728 -38.976 20.328 -44.968 26.208 -38.976ZM33.544 0.0V-8.792H38.976V-41.44H47.992V0.0ZM33.544 -8.792H34.104V0.0H33.544Q31.864 0.0 31.864 -4.368Q31.864 -8.792 33.544 -8.792ZM66.472 0.0Q63.672 0.0 61.656 -0.56Q59.64 -1.12 58.324 -2.324Q57.008 -3.528 56.364 -5.432Q55.72 -7.336 55.72 -10.024V-41.44H64.736V-13.272Q64.736 -12.040 64.904 -11.172Q65.072 -10.304 65.520 -9.772Q65.968 -9.24 66.78 -9.016Q67.592 -8.792 68.936 -8.792H71.12V0.0ZM84.616 -44.855Q82.039 -44.855 80.556 -46.48Q79.072 -48.104 79.072 -50.736V-52.808H82.936V-50.736Q82.936 -48.664 84.616 -48.664Q85.4 -48.664 85.904 -49.28Q86.408 -49.896 86.408 -51.016V-54.208H90.271V-51.016Q90.271 -48.048 88.844 -46.452Q87.416 -44.855 84.616 -44.855ZM77.336 -44.855Q74.648 -44.855 73.192 -46.396Q71.736 -47.936 71.736 -51.016V-54.208H75.6V-51.016Q75.6 -49.952 76.076 -49.308Q76.551 -48.664 77.336 -48.664Q79.072 -48.664 79.072 -50.736V-52.808H82.936V-50.736Q82.936 -48.104 81.424 -46.48Q79.912 -44.855 77.336 -44.855ZM71.12 0.0V-8.792H76.552V-41.44H85.568V0.0ZM71.12 -8.792H71.68V0.0H71.12Q69.44 0.0 69.44 -4.368Q69.44 -8.792 71.12 -8.792ZM92.624 0.0 91.056 -8.792H106.68Q106.12 -10.08 104.888 -11.844Q103.656 -13.608 101.808 -15.736Q99.960 -17.864 97.44 -20.048L104.384 -29.008Q108.696 -24.136 111.271 -19.628Q113.848 -15.120 114.604 -10.388Q115.36 -5.656 114.072 0.0Z';

  static final Map<String, Path> _cache = {};
  static Path parse(String d) => _cache.putIfAbsent(d, () => parseSvgPathData(d));
}

class _SvgPathPainter extends CustomPainter {
  _SvgPathPainter(this.d, this.viewBox, this.color);
  final String d;
  final Rect viewBox;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / viewBox.width, size.height / viewBox.height);
    canvas.translate(-viewBox.left, -viewBox.top);
    canvas.drawPath(_Paths.parse(d), Paint()..color = color);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_SvgPathPainter old) =>
      old.color != color || old.d != d;
}

class _DunePainter extends CustomPainter {
  _DunePainter(this.d, this.design, this.color);
  final String d;
  final Size design;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / design.width, size.height / design.height);
    canvas.drawPath(_Paths.parse(d), Paint()..color = color);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_DunePainter old) => false;
}

class _TreePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 90, sy = size.height / 60;
    final p = Paint()..color = DallalaColors.acaciaTree;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(43 * sx, 16 * sy, 4 * sx, 44 * sy), Radius.circular(2 * sx)),
      p,
    );
    canvas.drawOval(
        Rect.fromCenter(center: Offset(45 * sx, 15 * sy), width: 68 * sx, height: 20 * sy),
        p);
  }

  @override
  bool shouldRepaint(_TreePainter old) => false;
}
