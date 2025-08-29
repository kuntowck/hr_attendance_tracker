import 'dart:async';
import 'package:animated_item/animated_item.dart';
import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  const Carousel({
    super.key,
    this.height = 150,
    this.autoPlay = true,
    this.interval = const Duration(seconds: 3),
  });

  final double height;
  final bool autoPlay;
  final Duration interval;

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final _controller = PageController(viewportFraction: 0.92);
  int _current = 0;
  Timer? _timer;

  final _banners = <Widget>[
    _PromoBanner(
      bg: Colors.blue,
      title: "Request Time-off",
      subtitle: "Now you can request time-off directly from the app!",
      icon: Icons.flash_on,
    ),
    _PromoBanner(
      bg: Colors.indigo,
      title: "Performance Review",
      subtitle: "New: Performance review available on mobile!",
      icon: Icons.thumb_up,
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.autoPlay) _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.interval, (_) {
      if (!mounted) return;
      final next = (_current + 1) % _banners.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    });
  }

  void _stopAutoPlay() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _stopAutoPlay();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Listener(
        onPointerDown: (_) => _stopAutoPlay(),
        onPointerUp: (_) {
          if (widget.autoPlay) _startAutoPlay();
        },
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _banners.length,
                onPageChanged: (i) => setState(() => _current = i),
                itemBuilder: (context, index) {
                  return AnimatedPage(
                    controller: _controller,
                    effect: const TranslateEffect(),
                    index: index,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: _banners[index],
                    ),
                  );
                  // return AnimatedBuilder(
                  //   animation: _controller,
                  //   builder: (context, child) {
                  //     // sedikit efek scale biar manis
                  //     double scale = 1.0;
                  //     if (_controller.position.haveDimensions) {
                  //       final page =
                  //           _controller.page ??
                  //           _controller.initialPage.toDouble();
                  //       scale = (1 - (page - index).abs() * 0.06).clamp(
                  //         0.92,
                  //         1.0,
                  //       );
                  //     }
                  //     return Transform.scale(scale: scale, child: child);
                  //   },
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 6),
                  //     child: _banners[index],
                  //   ),
                  // );
                },
              ),
            ),
            const SizedBox(height: 10),
            _DotsIndicator(count: _banners.length, currentIndex: _current),
          ],
        ),
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner({
    required this.bg,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final Color bg;
  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: bg,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 36, color: Colors.white),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
          // isThreeLine: true,
        ),
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({required this.count, required this.currentIndex});

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: isActive ? 18 : 8,
          decoration: BoxDecoration(
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }
}
