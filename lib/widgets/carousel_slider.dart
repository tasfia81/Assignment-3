import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarouselSlider extends StatefulWidget {
  final List<String> imageUrls;
  final double height;
  final BoxFit fit;
  final bool showIndicators;
  final double memCacheWidth; // Cache resizing support for memory stability

  const CarouselSlider({
    super.key,
    required this.imageUrls,
    this.height = 350.0,
    this.fit = BoxFit.cover,
    this.showIndicators = true,
    this.memCacheWidth = 600.0, // Default for details view
  });

  @override
  State<CarouselSlider> createState() => _CarouselSliderState();
}

class _CarouselSliderState extends State<CarouselSlider> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) {
      return Container(
        height: widget.height.h,
        color: Colors.grey[200],
        child: Icon(Icons.image, size: 50.r, color: Colors.grey),
      );
    }

    return Stack(
      children: [
        SizedBox(
          height: widget.height.h,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: widget.imageUrls[index],
                fit: widget.fit,
                memCacheWidth: widget.memCacheWidth.toInt(), // Downsampling in memory
                placeholder: (context, url) => Container(
                  color: Colors.grey[100],
                  child: Center(
                    child: SizedBox(
                      width: 24.w,
                      height: 24.h,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.broken_image, size: 24.r, color: Colors.grey),
                ),
              );
            },
          ),
        ),
        if (widget.showIndicators && widget.imageUrls.length > 1)
          Positioned(
            bottom: 16.0.h,
            left: 0.0,
            right: 0.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.imageUrls.length,
                (index) => GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: _currentIndex == index ? 16.0.w : 6.0.w,
                    height: 6.0.h,
                    margin: EdgeInsets.symmetric(horizontal: 3.0.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0.r),
                      color: _currentIndex == index
                          ? Colors.black
                          : Colors.black.withValues(alpha: 0.2),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
