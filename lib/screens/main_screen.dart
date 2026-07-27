import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import 'feed_screen.dart';
import 'wishlist_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const FeedScreen(),
    const WishlistScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final wishlist = Provider.of<WishlistProvider>(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey[200]!,
              width: 1.0.h,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey[450],
          selectedFontSize: 10.sp,
          unselectedFontSize: 10.sp,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.2, fontSize: 10.sp),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, letterSpacing: 0.2, fontSize: 10.sp),
          elevation: 0,
          backgroundColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 22.r),
              activeIcon: Icon(Icons.home_filled, size: 22.r),
              label: 'SHOP',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                label: Text(
                  '${wishlist.wishlistIds.length}',
                  style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.bold),
                ),
                isLabelVisible: wishlist.wishlistIds.isNotEmpty,
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Icon(Icons.favorite_border, size: 22.r),
              ),
              activeIcon: Badge(
                label: Text(
                  '${wishlist.wishlistIds.length}',
                  style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.bold),
                ),
                isLabelVisible: wishlist.wishlistIds.isNotEmpty,
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Icon(Icons.favorite, size: 22.r),
              ),
              label: 'WISHLIST',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                label: Text(
                  '${cart.totalItemsCount}',
                  style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.bold),
                ),
                isLabelVisible: cart.totalItemsCount > 0,
                backgroundColor: Colors.red[700],
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Icon(Icons.shopping_bag_outlined, size: 22.r),
              ),
              activeIcon: Badge(
                label: Text(
                  '${cart.totalItemsCount}',
                  style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.bold),
                ),
                isLabelVisible: cart.totalItemsCount > 0,
                backgroundColor: Colors.red[700],
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Icon(Icons.shopping_bag, size: 22.r),
              ),
              label: 'BAG',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 22.r),
              activeIcon: Icon(Icons.person, size: 22.r),
              label: 'PROFILE',
            ),
          ],
        ),
      ),
    );
  }
}
