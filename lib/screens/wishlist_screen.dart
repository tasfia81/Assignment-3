import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/wishlist_provider.dart';
import '../services/mock_data_service.dart';
import 'detail_screen.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = Provider.of<WishlistProvider>(context);
    final currencyFormat = NumberFormat.simpleCurrency(name: 'USD');

    return Scaffold(
      appBar: AppBar(
        title: const Text('W I S H L I S T'),
      ),
      body: wishlist.wishlistIds.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 54.r, color: Colors.grey[300]),
                  SizedBox(height: 16.h),
                  Text(
                    'YOUR WISHLIST IS EMPTY',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.black54,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Tap the heart icon on any product to save it here.',
                    style: TextStyle(color: Colors.grey[500], fontSize: 11.sp),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: EdgeInsets.all(10.r),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.w,
                mainAxisSpacing: 8.h,
                childAspectRatio: 0.59,
              ),
              itemCount: wishlist.wishlistIds.length,
              itemBuilder: (context, index) {
                final productId = wishlist.wishlistIds[index];
                // Lookup item details from repository
                final product = MockDataService.getProductById(productId);

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
                    elevation: 0,
                    clipBehavior: Clip.antiAlias,
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
                              aspectRatio: 0.85,
                              child: CachedNetworkImage(
                                imageUrl: product.images.first,
                                fit: BoxFit.cover,
                                memCacheWidth: 300, // Downscale in memory
                                placeholder: (context, url) => Container(color: Colors.grey[50]),
                                errorWidget: (context, url, error) => const Icon(Icons.broken_image),
                              ),
                            ),
                            Positioned(
                              top: 6.h,
                              right: 6.w,
                              child: GestureDetector(
                                onTap: () {
                                  wishlist.remove(product.id);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(4.r),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: 14.r,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Details
                        Padding(
                          padding: EdgeInsets.all(8.0.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                  height: 1.2,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                currencyFormat.format(product.basePrice),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
