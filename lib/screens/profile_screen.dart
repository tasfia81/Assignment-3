import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/cart_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final currencyFormat = NumberFormat.simpleCurrency(name: 'USD');
    final dateFormat = DateFormat('MMM dd, yyyy - hh:mm a');

    return Scaffold(
      appBar: AppBar(
        title: const Text('M Y  P R O F I L E'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Mock Intern Profile Header
            Container(
              color: Colors.grey[50],
              padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
              width: double.infinity,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36.r,
                    backgroundColor: Colors.black,
                    child: Text(
                      'VX',
                      style: TextStyle(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'VogueX Engineering Intern',
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w900, letterSpacing: 0.2),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'intern.voguex@khizex.com',
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey[600], fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

            // Order History List
            Padding(
              padding: EdgeInsets.all(16.0.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.history_outlined, size: 18.r),
                      SizedBox(width: 8.w),
                      Text(
                        'ORDER HISTORY',
                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                      ),
                    ],
                  ),
                  Divider(height: 24.h, thickness: 0.5),

                  if (cart.orders.isEmpty)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 48.0.h),
                        child: Column(
                          children: [
                            Icon(Icons.receipt_long_outlined, size: 44.r, color: Colors.grey[300]),
                            SizedBox(height: 12.h),
                            Text(
                              'NO ORDERS RECORDED',
                              style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w900, color: Colors.black54, letterSpacing: 0.5),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Purchased items will generate order logs here.',
                              style: TextStyle(fontSize: 10.sp, color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cart.orders.length,
                      itemBuilder: (context, index) {
                        final order = cart.orders[index];
                        return Card(
                          elevation: 0,
                          margin: EdgeInsets.only(bottom: 12.h),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey[200]!, width: 1.w),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(12.0.r),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      order.id,
                                      style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold, letterSpacing: 0.2),
                                    ),
                                    Text(
                                      currencyFormat.format(order.total),
                                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w900),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  dateFormat.format(order.dateTime),
                                  style: TextStyle(fontSize: 9.sp, color: Colors.grey[500], fontWeight: FontWeight.w500),
                                ),
                                Divider(height: 16.h),
                                Text(
                                  'SHIPPING ADDRESS:\n'
                                  '${order.shippingName}\n'
                                  '${order.shippingAddress}, ${order.shippingCity}, ${order.shippingZip}\n'
                                  'Phone: ${order.shippingPhone}',
                                  style: TextStyle(fontSize: 10.sp, color: Colors.black54, height: 1.35),
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  'ITEMS ORDERED:',
                                  style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w900, color: Colors.black87, letterSpacing: 0.5),
                                ),
                                SizedBox(height: 6.h),
                                Column(
                                  children: order.items.map((item) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(vertical: 2.0.h),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '• ${item.product.title} (${item.selectedSize} / ${item.selectedColor})',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 10.sp, color: Colors.grey[750], fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          Text(
                                            'QTY: ${item.quantity}',
                                            style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w900),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
