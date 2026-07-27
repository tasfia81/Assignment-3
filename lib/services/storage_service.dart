import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/cart_item.dart';
import '../models/order.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static const String _keyCart = 'voguex_cart';
  static const String _keyWishlist = 'voguex_wishlist';
  static const String _keyOrders = 'voguex_orders';

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Save Cart Items
  Future<void> saveCart(List<CartItem> items) async {
    await init();
    final List<String> encoded = items.map((item) => json.encode(item.toJson())).toList();
    await _prefs!.setStringList(_keyCart, encoded);
  }

  // Load Cart Items
  Future<List<CartItem>> loadCart() async {
    await init();
    final List<String>? encoded = _prefs!.getStringList(_keyCart);
    if (encoded == null) return [];
    try {
      return encoded.map((item) => CartItem.fromJson(json.decode(item) as Map<String, dynamic>)).toList();
    } catch (e) {
      // Clear storage if corrupted
      await _prefs!.remove(_keyCart);
      return [];
    }
  }

  // Save Wishlist Product IDs
  Future<void> saveWishlist(List<String> productIds) async {
    await init();
    await _prefs!.setStringList(_keyWishlist, productIds);
  }

  // Load Wishlist Product IDs
  Future<List<String>> loadWishlist() async {
    await init();
    return _prefs!.getStringList(_keyWishlist) ?? [];
  }

  // Save Confirmed Orders
  Future<void> saveOrders(List<Order> orders) async {
    await init();
    final List<String> encoded = orders.map((order) => json.encode(order.toJson())).toList();
    await _prefs!.setStringList(_keyOrders, encoded);
  }

  // Load Confirmed Orders
  Future<List<Order>> loadOrders() async {
    await init();
    final List<String>? encoded = _prefs!.getStringList(_keyOrders);
    if (encoded == null) return [];
    try {
      return encoded.map((order) => Order.fromJson(json.decode(order) as Map<String, dynamic>)).toList();
    } catch (e) {
      await _prefs!.remove(_keyOrders);
      return [];
    }
  }
}
