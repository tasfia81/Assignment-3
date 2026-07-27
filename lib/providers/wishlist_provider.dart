import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

class WishlistProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  final List<String> _wishlistIds = [];

  List<String> get wishlistIds => List.unmodifiable(_wishlistIds);

  WishlistProvider() {
    _loadFromStorage();
  }

  //------------------------- Load wishlist from SharedPreferences -------------------------
  Future<void> _loadFromStorage() async {
    final ids = await _storageService.loadWishlist();
    _wishlistIds.clear();
    _wishlistIds.addAll(ids);
    notifyListeners();
  }

  //------------------------- Check if a product is favorited -------------------------
  bool contains(String productId) {
    return _wishlistIds.contains(productId);
  }

  //------------------------- Toggle favorite state -------------------------
  Future<void> toggleWishlist(String productId) async {
    if (_wishlistIds.contains(productId)) {
      _wishlistIds.remove(productId);
    } else {
      _wishlistIds.add(productId);
    }
    notifyListeners();
    await _storageService.saveWishlist(_wishlistIds);
  }

  //------------------------- Explicitly remove from favorites -------------------------
  Future<void> remove(String productId) async {
    if (_wishlistIds.remove(productId)) {
      notifyListeners();
      await _storageService.saveWishlist(_wishlistIds);
    }
  }
}
