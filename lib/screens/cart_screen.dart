import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/cart_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final currencyFormat = NumberFormat.simpleCurrency(name: 'USD');

    return Scaffold(
      appBar: AppBar(
        title: const Text('S H O P P I N G  B A G'),
        actions: [
          if (cart.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined, color: Colors.black),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    title: Text(
                      'CLEAR BAG',
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w900),
                    ),
                    content: Text(
                      'Are you sure you want to empty your shopping bag?',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    actions: [
                      TextButton(
                        child: Text('CANCEL', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11.sp)),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: Text('CLEAR', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 11.sp)),
                        onPressed: () {
                          cart.clearCart();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 54.r, color: Colors.grey[300]),
                  SizedBox(height: 16.h),
                  Text(
                    'YOUR BAG IS EMPTY',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.black54,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Explore our catalog and add items to your shopping bag.',
                    style: TextStyle(color: Colors.grey[500], fontSize: 11.sp),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      final variant = item.product.getVariant(item.selectedSize, item.selectedColor);
                      final variantImg = variant?.imageUrl ?? item.product.images.first;

                      return Card(
                        elevation: 0,
                        margin: EdgeInsets.only(bottom: 10.h),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey[200]!, width: 1.w),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(8.0.r),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image (downsized)
                              SizedBox(
                                width: 80.w,
                                height: 100.h,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4.r),
                                  child: CachedNetworkImage(
                                    imageUrl: variantImg,
                                    fit: BoxFit.cover,
                                    memCacheWidth: 200, // Downsized image resolution
                                    placeholder: (context, url) => Container(color: Colors.grey[50]),
                                    errorWidget: (context, url, error) => const Icon(Icons.broken_image),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              // Details Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        height: 1.25,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      'SIZE: ${item.selectedSize}  |  COLOR: ${item.selectedColor}',
                                      style: TextStyle(fontSize: 10.sp, color: Colors.grey[600], fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      currencyFormat.format(item.unitPrice),
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    // Quantity Select and Delete
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey[300]!),
                                            borderRadius: BorderRadius.circular(4.r),
                                          ),
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  cart.updateQuantity(item.id, item.quantity - 1);
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                                  child: Icon(Icons.remove, size: 14.r),
                                                ),
                                              ),
                                              Text(
                                                '${item.quantity}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  final success = cart.updateQuantity(item.id, item.quantity + 1);
                                                  if (!success) {
                                                    ScaffoldMessenger.of(context).clearSnackBars();
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          'Stock limit reached for this variant!',
                                                          style: TextStyle(fontWeight: FontWeight.bold),
                                                        ),
                                                        backgroundColor: Colors.black,
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                                  child: Icon(Icons.add, size: 14.r),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete_outline, color: Colors.grey, size: 18.r),
                                          onPressed: () {
                                            cart.removeItem(item.id);
                                          },
                                        ),
                                      ],
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
                ),

                // Coupon / Promo Code entry and Pricing breakdown
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10.r,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Promo Input Bar
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 40.h,
                                child: TextField(
                                  controller: _promoController,
                                  decoration: InputDecoration(
                                    hintText: 'PROMO CODE (VOGUEX20, FLASH50)',
                                    hintStyle: TextStyle(fontSize: 10.sp, letterSpacing: 0.5, fontWeight: FontWeight.bold),
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                    suffixIcon: cart.appliedPromoCode.isNotEmpty
                                        ? IconButton(
                                            icon: Icon(Icons.clear, size: 16.r),
                                            onPressed: () {
                                              cart.removePromoCode();
                                              _promoController.clear();
                                            },
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              height: 40.h,
                              child: ElevatedButton(
                                onPressed: () {
                                  final code = _promoController.text;
                                  if (code.isEmpty) return;
                                  final success = cart.applyPromoCode(code);
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        success
                                            ? 'Promo code "$code" applied successfully!'
                                            : 'Invalid promo code.',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      backgroundColor: success ? Colors.black : Colors.red[700],
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                ),
                                child: Text(
                                  'APPLY',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.sp, letterSpacing: 0.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (cart.appliedPromoCode.isNotEmpty) ...[
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green, size: 14.r),
                              SizedBox(width: 4.w),
                              Text(
                                'PROMO CODE "${cart.appliedPromoCode}" APPLIED!',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                        SizedBox(height: 16.h),

                        // Pricing Summaries
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Subtotal', style: TextStyle(fontSize: 12.sp, color: Colors.grey, fontWeight: FontWeight.w500)),
                            Text(currencyFormat.format(cart.subtotal), style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        if (cart.discountAmount > 0.0) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Discounts', style: TextStyle(fontSize: 12.sp, color: Colors.red, fontWeight: FontWeight.w500)),
                              Text('-${currencyFormat.format(cart.discountAmount)}', style: TextStyle(fontSize: 12.sp, color: Colors.red, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(height: 6.h),
                        ],
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Estimated Shipping', style: TextStyle(fontSize: 12.sp, color: Colors.grey, fontWeight: FontWeight.w500)),
                            Text(
                              cart.shippingFee == 0.0 ? 'FREE' : currencyFormat.format(cart.shippingFee),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: cart.shippingFee == 0.0 ? Colors.green : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Divider(height: 20.h, thickness: 0.5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'TOTAL DUE',
                              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                            ),
                            Text(
                              currencyFormat.format(cart.total),
                              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        // Proceed to Checkout CTA
                        SizedBox(
                          height: 48.h,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CheckoutScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                            ),
                            child: Text(
                              'PROCEED TO CHECKOUT',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.sp,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
