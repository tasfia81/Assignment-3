import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/product.dart';
import '../providers/wishlist_provider.dart';
import '../providers/feed_provider.dart';
import '../screens/detail_screen.dart';
import 'countdown_timer.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final wishlist = Provider.of<WishlistProvider>(context);
    final feedProvider = Provider.of<FeedProvider>(context, listen: false);
    final isWishlisted = wishlist.contains(product.id);

    final double price = product.isFlashSale
        ? product.basePrice * (1.0 - product.flashSaleDiscount)
        : product.basePrice;

    final currencyFormat = NumberFormat.simpleCurrency(name: 'USD');

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(product: product),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey[200]!, width: 1.w),
          borderRadius: BorderRadius.circular(6.r),
        ),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack
            Stack(
              children: [
                AspectRatio(
                  // Alternating aspect ratios based on product ID to simulate a natural staggered masonry layout
                  aspectRatio: (product.id.hashCode % 2 == 0) ? 0.75 : 0.88,
                  child: CachedNetworkImage(
                    imageUrl: product.images.first,
                    fit: BoxFit.cover,
                    memCacheWidth: 300, // Downscale in memory for feed thumbnails to maintain a flat memory footprint (Core Requirement)
                    placeholder: (context, url) => Container(
                      color: Colors.grey[50],
                      child: Center(
                        child: SizedBox(
                          width: 20.w,
                          height: 20.h,
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
                  ),
                ),
                
                // Tag Overlay (Top Left)
                if (product.tag.isNotEmpty)
                  Positioned(
                    top: 6.h,
                    left: 6.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                      ),
                      child: Text(
                        product.tag.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                // Wishlist Heart Toggle (Top Right) - updates global wishlist provider
                Positioned(
                  top: 4.h,
                  right: 4.w,
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20.r),
                      onTap: () {
                        wishlist.toggleWishlist(product.id);
                      },
                      child: Container(
                        padding: EdgeInsets.all(5.r),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withValues(alpha: 0.25),
                        ),
                        child: Icon(
                          isWishlisted ? Icons.favorite : Icons.favorite_border,
                          color: isWishlisted ? Colors.red[600] : Colors.white,
                          size: 18.r,
                        ),
                      ),
                    ),
                  ),
                ),

                // Flash Sale Timer Overlay (Bottom Left)
                if (product.isFlashSale)
                  Positioned(
                    bottom: 6.h,
                    left: 6.w,
                    child: CountdownTimer(
                      targetDateTime: feedProvider.flashSaleTarget,
                      isExpanded: false,
                    ),
                  ),
              ],
            ),
            
            // Text Details
            Padding(
              padding: EdgeInsets.all(8.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      height: 1.25,
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // Rating/Reviews
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 10.r),
                      SizedBox(width: 2.w),
                      Text(
                        '${product.rating}',
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '(${product.reviewsCount})',
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),

                  // Pricing
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        currencyFormat.format(price),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: product.isFlashSale ? Colors.red[700] : Colors.black,
                        ),
                      ),
                      if (product.isFlashSale) ...[
                        SizedBox(width: 4.w),
                        Text(
                          currencyFormat.format(product.basePrice),
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.grey[400],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '-${(product.flashSaleDiscount * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 9.sp,
                            color: Colors.red[700],
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ],
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
