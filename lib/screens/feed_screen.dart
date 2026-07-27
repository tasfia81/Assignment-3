import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/feed_provider.dart';
import '../services/mock_data_service.dart';
import '../widgets/product_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Detect scroll offset to trigger paginated loading before reaching the absolute end
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 400) {
      Provider.of<FeedProvider>(context, listen: false).fetchMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final feedProvider = Provider.of<FeedProvider>(context);

    return Scaffold(
      appBar: _isSearching
          ? AppBar(
              title: TextField(
                controller: _searchController,
                autofocus: true,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: 'Search items (e.g. dress, wrap, comfortable)...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 12.sp),
                ),
                onChanged: (val) {
                  feedProvider.updateSearchQuery(val);
                },
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _isSearching = false;
                    _searchController.clear();
                  });
                  feedProvider.updateSearchQuery('');
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    feedProvider.updateSearchQuery('');
                  },
                ),
              ],
            )
          : AppBar(
              title: const Text('V O G U E X'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_none_outlined, color: Colors.black),
                  onPressed: () => _showNotificationsBottomSheet(context),
                ),
              ],
            ),
      body: RefreshIndicator(
        onRefresh: feedProvider.refresh,
        color: Colors.black,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Category Slider Row
            SliverToBoxAdapter(
              child: SizedBox(
                height: 50.0.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: MockDataService.categories.length,
                  padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 8.0.h),
                  itemBuilder: (context, index) {
                    final catName = MockDataService.categories[index];
                    final isSelected = catName == feedProvider.selectedCategory;
                    return Padding(
                      padding: EdgeInsets.only(right: 8.0.w),
                      child: ChoiceChip(
                        label: Text(
                          catName.toUpperCase(),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                            fontSize: 10.sp,
                            letterSpacing: 0.5,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            feedProvider.changeCategory(catName);
                          }
                        },
                        selectedColor: Colors.black,
                        backgroundColor: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: isSelected ? Colors.black : Colors.grey[200]!,
                            width: 1.w,
                          ),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        showCheckmark: false,
                      ),
                    );
                  },
                ),
              ),
            ),

            // Main Content Area
            if (feedProvider.isLoading && feedProvider.products.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: Colors.black),
                ),
              )
            else if (feedProvider.products.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: Text(
                    'No products found in this category.',
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            else ...[
              // The staggered grid using Masonry rendering for virtualization
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                sliver: SliverMasonryGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.h,
                  crossAxisSpacing: 8.w,
                  itemBuilder: (context, index) {
                    return ProductCard(product: feedProvider.products[index]);
                  },
                  childCount: feedProvider.products.length,
                ),
              ),

              // Paginated Spinner Footer
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(24.0.r),
                  child: Center(
                    child: feedProvider.hasMore
                        ? SizedBox(
                            width: 24.w,
                            height: 24.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                            ),
                          )
                        : Text(
                            '— YOU HAVE REACHED THE END —',
                            style: TextStyle(
                              fontSize: 9.sp,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0,
                            ),
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

  void _showNotificationsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: Colors.white,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'NOTIFICATIONS & ALERTS',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12.sp, letterSpacing: 0.5),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, size: 16.r),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Divider(height: 16.h),
                _notificationItem(
                  icon: Icons.bolt,
                  title: 'FLASH SALE LIVE NOW!',
                  desc: 'Save up to 50% on select premium clothing. Real-time timer active on items.',
                  time: 'Just now',
                ),
                _notificationItem(
                  icon: Icons.card_giftcard,
                  title: 'WELCOME 20% DISCOUNT AVAILABLE',
                  desc: 'Apply coupon code VOGUEX20 in your shopping bag to redeem 20% off your purchase.',
                  time: '1 hour ago',
                ),
                _notificationItem(
                  icon: Icons.local_shipping_outlined,
                  title: 'FREE SHIPPING OFFER',
                  desc: 'Enjoy free standard shipping automatically applied on orders over \$49.00.',
                  time: '2 days ago',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _notificationItem({
    required IconData icon,
    required String title,
    required String desc,
    required String time,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[100],
            foregroundColor: Colors.black,
            radius: 15.r,
            child: Icon(icon, size: 14.r),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp, letterSpacing: 0.2),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: TextStyle(fontSize: 10.sp, color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(fontSize: 8.sp, color: Colors.grey[400], fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
