import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/mock_data_service.dart';

class FeedProvider with ChangeNotifier {
  final List<Product> _products = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _offset = 0;
  static const int _limit = 10;

  List<Product> get products => List.unmodifiable(_products);
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;

  //------------------------- Real-time Flash sale target (fixed to 2 hours, 14 minutes, and 30 seconds from app boot) -------------------------
  late DateTime _flashSaleTarget;
  DateTime get flashSaleTarget => _flashSaleTarget;

  FeedProvider() {
    _flashSaleTarget = DateTime.now().add(const Duration(hours: 2, minutes: 14, seconds: 30));
    fetchInitialProducts();
  }

  //------------------------- Filter feed by category -------------------------
  void changeCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    fetchInitialProducts();
  }

  //------------------------- Update search query -------------------------
  void updateSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    fetchInitialProducts();
  }

  //------------------------- Fetch first page of products -------------------------
  Future<void> fetchInitialProducts() async {
    _isLoading = true;
    _hasMore = true;
    _offset = 0;
    _products.clear();
    notifyListeners();

    try {
      final newProducts = await MockDataService.getProductsPage(
        offset: _offset,
        limit: _limit,
        category: _selectedCategory,
        searchQuery: _searchQuery,
      );
      _products.addAll(newProducts);
      _offset += newProducts.length;
      if (newProducts.length < _limit) {
        _hasMore = false;
      }
    } catch (e) {
      _hasMore = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //------------------------- Load next page of products -------------------------
  Future<void> fetchMoreProducts() async {
    if (_isLoading || _isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final newProducts = await MockDataService.getProductsPage(
        offset: _offset,
        limit: _limit,
        category: _selectedCategory,
        searchQuery: _searchQuery,
      );
      
      _products.addAll(newProducts);
      _offset += newProducts.length;
      
      if (newProducts.length < _limit) {
        _hasMore = false;
      }
    } catch (e) {
      //------------------------- In case of error, stop loading more -------------------------
      _hasMore = false;
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  //------------------------- Pull to refresh handler -------------------------
  Future<void> refresh() async {
    //------------------------- Reset flash sale timer slightly for visual testing of the countdown -------------------------
    _flashSaleTarget = DateTime.now().add(const Duration(hours: 2, minutes: 14, seconds: 30));
    await fetchInitialProducts();
  }
}
