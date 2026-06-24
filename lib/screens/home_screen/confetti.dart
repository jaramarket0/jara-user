import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: GiftAnimationScreen(),
//     );
//   }
// }

class GiftAnimationScreen extends StatefulWidget {
  const GiftAnimationScreen({super.key});

  @override
  State<GiftAnimationScreen> createState() => _GiftAnimationScreenState();
}

class _GiftAnimationScreenState extends State<GiftAnimationScreen>
    with TickerProviderStateMixin {
  // ── Confetti ──────────────────────────────────────────────────────────────
  late ConfettiController _confettiLeft;
  late ConfettiController _confettiRight;

  // ── Gift pop-in ───────────────────────────────────────────────────────────
  late AnimationController _scaleController;
  late Animation<double> _scaleAnim;

  // ── Gift float ────────────────────────────────────────────────────────────
  late AnimationController _floatController;
  late Animation<double> _floatAnim;

  // ── Glow pulse ────────────────────────────────────────────────────────────
  late AnimationController _glowController;
  late Animation<double> _glowAnim;

  // ── Thank-you fade ────────────────────────────────────────────────────────
  late AnimationController _thankYouController;
  late Animation<double> _thankYouAnim;

  bool _showGiftAnimation = false;
  String _selectedGiftEmoji = '🌸';
  int _selectedIndex = 0;

  final List<Map<String, String>> _gifts = [
    {'name': 'Flower', 'price': 'Free', 'emoji': '🌸'},
    {'name': 'Like', 'price': '₦200', 'emoji': '❤️'},
    {'name': 'Ice pop', 'price': '₦2,000', 'emoji': '🍦'},
    {'name': 'Coffee', 'price': '₦5,000', 'emoji': '☕'},
    {'name': 'Champagne', 'price': '₦10,000', 'emoji': '🍾'},
    {'name': 'Luxury car', 'price': '₦30,000', 'emoji': '🚗'},
  ];

  @override
  void initState() {
    super.initState();

    _confettiLeft = ConfettiController(duration: const Duration(seconds: 3));
    _confettiRight = ConfettiController(duration: const Duration(seconds: 3));

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnim = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _thankYouController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _thankYouAnim = CurvedAnimation(
      parent: _thankYouController,
      curve: Curves.easeOut,
    );
  }

  void _sendGift(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedGiftEmoji = _gifts[index]['emoji']!;
      _showGiftAnimation = true;
    });

    _confettiLeft.play();
    _confettiRight.play();
    _scaleController.forward(from: 0);
    _thankYouController.forward(from: 0);

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() => _showGiftAnimation = false);
        _thankYouController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _confettiLeft.dispose();
    _confettiRight.dispose();
    _scaleController.dispose();
    _floatController.dispose();
    _glowController.dispose();
    _thankYouController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF120800),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // ── Main scrollable content ─────────────────────────────────────
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildAuthorCard(),
                  const SizedBox(height: 16),
                  _buildGiftGrid(),
                  const SizedBox(height: 16),
                  _buildRankingBanner(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // ── Confetti — left side ────────────────────────────────────────
          Align(
            alignment: Alignment.topLeft,
            child: ConfettiWidget(
              confettiController: _confettiLeft,
              blastDirection: -pi / 4, // down-right
              emissionFrequency: 0.06,
              numberOfParticles: 18,
              gravity: 0.25,
              colors: const [
                Colors.pink,
                Colors.yellow,
                Colors.cyan,
                Colors.purple,
                Colors.orange,
                Colors.red,
              ],
            ),
          ),

          // ── Confetti — right side ───────────────────────────────────────
          Align(
            alignment: Alignment.topRight,
            child: ConfettiWidget(
              confettiController: _confettiRight,
              blastDirection: pi + pi / 4, // down-left
              emissionFrequency: 0.06,
              numberOfParticles: 18,
              gravity: 0.25,
              colors: const [
                Colors.pink,
                Colors.yellow,
                Colors.cyan,
                Colors.purple,
                Colors.orange,
                Colors.red,
              ],
            ),
          ),

          // ── Gift overlay ────────────────────────────────────────────────
          if (_showGiftAnimation)
            Positioned(
              bottom: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 1. Radial glow
                  _buildGlowLight(),
                  // 2. Light rays
                  _buildLightRays(),
                  // 3. Gift emoji
                  ScaleTransition(
                    scale: _scaleAnim,
                    child: AnimatedBuilder(
                      animation: _floatAnim,
                      builder: (context, child) => Transform.translate(
                        offset: Offset(0, _floatAnim.value),
                        child: child,
                      ),
                      child: Text(
                        _selectedGiftEmoji,
                        style: const TextStyle(fontSize: 110),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // ── "Thank you!" ────────────────────────────────────────────────
          if (_showGiftAnimation)
            Positioned(
              bottom: 60,
              child: FadeTransition(
                opacity: _thankYouAnim,
                child: const Text(
                  'Thank you!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.orangeAccent,
                        blurRadius: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Glow blob ─────────────────────────────────────────────────────────────
  Widget _buildGlowLight() {
    return AnimatedBuilder(
      animation: _glowAnim,
      builder: (context, _) => Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Colors.orange.withOpacity(0.55 * _glowAnim.value),
              Colors.deepOrange.withOpacity(0.30 * _glowAnim.value),
              Colors.transparent,
            ],
            stops: const [0.0, 0.45, 1.0],
          ),
        ),
      ),
    );
  }

  // ── Light rays ────────────────────────────────────────────────────────────
  Widget _buildLightRays() {
    return AnimatedBuilder(
      animation: _glowAnim,
      builder: (context, _) => CustomPaint(
        size: const Size(300, 300),
        painter: LightRayPainter(opacity: _glowAnim.value),
      ),
    );
  }

  // ── Author card ───────────────────────────────────────────────────────────
  Widget _buildAuthorCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1500),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.brown.shade700,
            child: const Text(
              'F',
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Fake Rich Young La...',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    SizedBox(width: 8),
                    Chip(
                      label: Text('Author',
                          style: TextStyle(color: Colors.white, fontSize: 11)),
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  'Thanks for your support, it motivates me to keep writing.',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Gift grid ─────────────────────────────────────────────────────────────
  Widget _buildGiftGrid() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1500),
        borderRadius: BorderRadius.circular(16),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.9,
        ),
        itemCount: _gifts.length,
        itemBuilder: (context, index) {
          final gift = _gifts[index];
          final isSelected = _selectedIndex == index;
          return GestureDetector(
            onTap: () => _sendGift(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: const Color(0xFF3A2000),
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(color: Colors.amber, width: 2)
                    : Border.all(color: Colors.transparent, width: 2),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.4),
                          blurRadius: 12,
                          spreadRadius: 2,
                        )
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(gift['emoji']!,
                      style: const TextStyle(fontSize: 34)),
                  const SizedBox(height: 4),
                  Text(
                    gift['name']!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    gift['price']!,
                    style: const TextStyle(
                        color: Colors.white54, fontSize: 11),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Ranking banner ────────────────────────────────────────────────────────
  Widget _buildRankingBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1500),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'User gifts ranking',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          Icon(Icons.chevron_right, color: Colors.white54),
        ],
      ),
    );
  }
}

// ── Light ray CustomPainter ───────────────────────────────────────────────────
class LightRayPainter extends CustomPainter {
  final double opacity;
  LightRayPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    const rayCount = 14;
    const angleStep = (2 * pi) / rayCount;

    for (int i = 0; i < rayCount; i++) {
      final angle = i * angleStep;
      final innerRadius = 55.0;
      final outerRadius = 140.0 + (i % 2 == 0 ? 20 : 0); // alternating length

      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.orange.withOpacity(0.55 * opacity),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: outerRadius))
        ..strokeWidth = i % 2 == 0 ? 5 : 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final start = Offset(
        center.dx + innerRadius * cos(angle),
        center.dy + innerRadius * sin(angle),
      );
      final end = Offset(
        center.dx + outerRadius * cos(angle),
        center.dy + outerRadius * sin(angle),
      );

      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(LightRayPainter old) => old.opacity != opacity;
}