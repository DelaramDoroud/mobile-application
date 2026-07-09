import 'dart:async';

import 'package:flutter/material.dart';

class ImageSlideshow extends StatefulWidget {
  const ImageSlideshow({
    super.key,
    required this.imagePaths,
    required this.fallbackImagePath,
    this.height = 220,
    this.borderRadius = 22,
    this.fit = BoxFit.cover,
  });

  final List<dynamic> imagePaths;
  final String fallbackImagePath;
  final double height;
  final double borderRadius;
  final BoxFit fit;

  @override
  State<ImageSlideshow> createState() => _ImageSlideshowState();
}

class _ImageSlideshowState extends State<ImageSlideshow> {
  late final PageController _controller;
  Timer? _timer;
  int _index = 0;

  List<String> get _images {
    final paths =
        widget.imagePaths
            .map((path) => path.toString())
            .where((path) => path.trim().isNotEmpty)
            .toList();
    return paths.isEmpty ? [widget.fallbackImagePath] : paths;
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant ImageSlideshow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imagePaths != widget.imagePaths ||
        oldWidget.fallbackImagePath != widget.fallbackImagePath) {
      _timer?.cancel();
      _index = 0;
      if (_controller.hasClients) {
        _controller.jumpToPage(0);
      }
      _startTimer();
    }
  }

  void _startTimer() {
    if (_images.length <= 1) return;

    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_controller.hasClients) return;

      final next = (_index + 1) % _images.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = _images;

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: _controller,
              physics:
                  images.length > 1
                      ? const PageScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
              itemCount: images.length,
              onPageChanged: (value) => setState(() => _index = value),
              itemBuilder: (context, index) {
                return Image.asset(
                  images[index],
                  fit: widget.fit,
                  errorBuilder:
                      (_, __, ___) => Image.asset(
                        widget.fallbackImagePath,
                        fit: widget.fit,
                      ),
                );
              },
            ),
            if (images.length > 1) ...[
              Positioned(
                left: 0,
                right: 0,
                bottom: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(images.length, (index) {
                    final selected = index == _index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: selected ? 18 : 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color:
                            selected
                                ? Colors.white
                                : Colors.white.withOpacity(0.62),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    );
                  }),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.48),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${_index + 1}/${images.length}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
