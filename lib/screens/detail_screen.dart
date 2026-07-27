import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../providers/feed_provider.dart';
import '../widgets/carousel_slider.dart';
import '../widgets/countdown_timer.dart';
import '../widgets/variant_selector.dart';

class DetailScreen extends StatefulWidget {
  final Product product;

  const DetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late String _selectedSize;
  late String _selectedColor;

  @override
  void initState() {
    super.initState();
    // Default select first size and first color
    _selectedSize = widget.product.sizes.isNotEmpty ? widget.product.sizes.first : 'M';
    _selectedColor = widget.product.colors.isNotEmpty ? widget.product.colors.first['name']! : '';
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final wishlist = Provider.of<WishlistProvider>(context);
    final feedProvider = Provider.of<FeedProvider>(context, listen: false);

    final isWishlisted = wishlist.contains(widget.product.id);
    final variant = widget.product.getVariant(_selectedSize, _selectedColor);
    
    // Determine dynamic price and stock
    final double displayPrice = widget.product.getPriceForVariant(_selectedSize, _selectedColor);
    final double originalPrice = variant != null ? variant.priceOverride : widget.product.basePrice;
    final int availableStock = variant?.stock ?? 0;

    // Dynamically re-order images so that the selected color variant's image is shown first
    final List<String> displayImages = List.from(widget.product.images);
    if (variant != null && variant.imageUrl != null) {
      final vImg = variant.imageUrl!;
      displayImages.remove(vImg);
      displayImages.insert(0, vImg);
    }

    final currencyFormat = NumberFormat.simpleCurrency(name: 'USD');

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.0.r),
          child: CircleAvatar(
            backgroundColor: Colors.white.withValues(alpha: 0.9),
            foregroundColor: Colors.black,
            child: IconButton(
              icon: Icon(Icons.arrow_back, size: 20.r),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0.r),
            child: CircleAvatar(
              backgroundColor: Colors.white.withValues(alpha: 0.9),
              foregroundColor: Colors.black,
              child: IconButton(
                icon: Icon(
                  isWishlisted ? Icons.favorite : Icons.favorite_border,
                  color: isWishlisted ? Colors.red : Colors.black,
                  size: 20.r,
                ),
                onPressed: () {
                  wishlist.toggleWishlist(widget.product.id);
                },
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Swipeable Image Carousel
            CarouselSlider(
              imageUrls: displayImages,
              height: 480,
              memCacheWidth: 800, // Detail view uses higher resolution downsampling
            ),

            // Flash Sale expanded banner
            if (widget.product.isFlashSale)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                color: Colors.red[700],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.bolt, color: Colors.white, size: 20.r),
                        SizedBox(width: 4.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'FLASH SALE',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 13.sp,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              'GET ${(widget.product.flashSaleDiscount * 100).toInt()}% OFF',
                              style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'ENDS IN  ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CountdownTimer(
                          targetDateTime: feedProvider.flashSaleTarget,
                          isExpanded: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            // Product Information
            Padding(
              padding: EdgeInsets.all(16.0.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Tag
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.title,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            height: 1.25,
                          ),
                        ),
                      ),
                      if (widget.product.tag.isNotEmpty) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          color: Colors.black,
                          child: Text(
                            widget.product.tag.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 8.h),

                  // Rating & Reviews Count
                  Row(
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < widget.product.rating.floor()
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 16.r,
                          );
                        }),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '${widget.product.rating}',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '(${widget.product.reviewsCount} reviews)',
                        style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),

                  // Prices
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        currencyFormat.format(displayPrice),
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w900,
                          color: widget.product.isFlashSale ? Colors.red[700] : Colors.black,
                        ),
                      ),
                      if (widget.product.isFlashSale) ...[
                        SizedBox(width: 8.w),
                        Text(
                          currencyFormat.format(originalPrice),
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                          color: Colors.red[50],
                          child: Text(
                            '-${(widget.product.flashSaleDiscount * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.red[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Divider(height: 32.h, thickness: 0.5),

                  // Variant Selection (Sizes, Colors)
                  VariantSelector(
                    sizes: widget.product.sizes,
                    selectedSize: _selectedSize,
                    onSizeSelected: (size) {
                      setState(() {
                        _selectedSize = size;
                      });
                    },
                    colors: widget.product.colors,
                    selectedColor: _selectedColor,
                    onColorSelected: (colorName) {
                      setState(() {
                        _selectedColor = colorName;
                      });
                    },
                  ),
                  SizedBox(height: 18.h),

                  // Stock Status Indicator
                  Row(
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: availableStock == 0
                              ? Colors.red
                              : (availableStock <= 5 ? Colors.orange : Colors.green),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        availableStock == 0
                            ? 'Out of Stock'
                            : (availableStock <= 5
                                ? 'Only $availableStock left in stock!'
                                : 'In Stock ($availableStock available)'),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: availableStock == 0
                              ? Colors.red[700]
                              : (availableStock <= 5 ? Colors.orange[800] : Colors.green[800]),
                        ),
                      ),
                    ],
                  ),

                  Divider(height: 36.h, thickness: 0.5),

                  // Description
                  Text(
                    'DETAILS & DESCRIPTION',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    widget.product.description,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 100.h), // Spacing for bottom bar
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey[200]!, width: 1.w),
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Price Preview
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOTAL PRICE',
                    style: TextStyle(fontSize: 9.sp, color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    currencyFormat.format(displayPrice),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 24.w),
              // Add to Bag Button
              Expanded(
                child: SizedBox(
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: availableStock == 0
                        ? null
                        : () {
                            final error = cart.addToCart(
                              widget.product,
                              _selectedSize,
                              _selectedColor,
                              1,
                            );

                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  error ?? 'Added to bag successfully!',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: error != null ? Colors.red[700] : Colors.black,
                                action: error == null
                                    ? SnackBarAction(
                                        label: 'VIEW BAG',
                                        textColor: Colors.white,
                                        onPressed: () {
                                          // Navigate back to Shop shell, but wait we need main navigation.
                                          // For simplicity, just dismiss or pop.
                                        },
                                      )
                                    : null,
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[300],
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Text(
                      availableStock == 0 ? 'OUT OF STOCK' : 'ADD TO BAG',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
