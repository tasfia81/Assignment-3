import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../models/order.dart';
import '../services/storage_service.dart';

class CartProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  final List<CartItem> _items = [];
  final List<Order> _orders = [];
  
  // Promo code system
  String _appliedPromoCode = '';
  double _promoDiscountPercentage = 0.0; // e.g. 0.1 for 10% off

  List<CartItem> get items => List.unmodifiable(_items);
  List<Order> get orders => List.unmodifiable(_orders);
  String get appliedPromoCode => _appliedPromoCode;

  CartProvider() {
    _loadFromStorage();
  }

  // Load cart and orders from SharedPreferences
  Future<void> _loadFromStorage() async {
    final cart = await _storageService.loadCart();
    _items.clear();
    _items.addAll(cart);

    final history = await _storageService.loadOrders();
    _orders.clear();
    _orders.addAll(history);

    notifyListeners();
  }

  // Helper to count total units in cart
  int get totalItemsCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  // Calculations
  double get subtotal {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get discountAmount {
    return subtotal * _promoDiscountPercentage;
  }

  double get shippingFee {
    if (subtotal == 0.0) return 0.0;
    // Free shipping over $49.00
    return subtotal >= 49.00 ? 0.0 : 5.99;
  }

  double get total {
    final calculated = subtotal - discountAmount + shippingFee;
    return calculated < 0.0 ? 0.0 : double.parse(calculated.toStringAsFixed(2));
  }

  // Add Item to Cart (checks variant stock)
  String? addToCart(Product product, String size, String colorName, int qty) {
    final String cartItemId = '${product.id}_${size}_$colorName';
    final variant = product.getVariant(size, colorName);
    final maxStock = variant?.stock ?? 0;

    if (maxStock <= 0) {
      return 'Sorry, this variant is out of stock!';
    }

    final int existingIndex = _items.indexWhere((item) => item.id == cartItemId);

    if (existingIndex != -1) {
      final currentQty = _items[existingIndex].quantity;
      if (currentQty + qty > maxStock) {
        _items[existingIndex].quantity = maxStock;
        _saveCart();
        return 'Stock limit reached! Added maximum available ($maxStock).';
      } else {
        _items[existingIndex].quantity += qty;
        _saveCart();
        return null;
      }
    } else {
      if (qty > maxStock) {
        _items.add(CartItem(
          id: cartItemId,
          product: product,
          selectedSize: size,
          selectedColor: colorName,
          quantity: maxStock,
        ));
        _saveCart();
        return 'Added maximum available stock ($maxStock).';
      } else {
        _items.add(CartItem(
          id: cartItemId,
          product: product,
          selectedSize: size,
          selectedColor: colorName,
          quantity: qty,
        ));
        _saveCart();
        return null;
      }
    }
  }

  // Update Cart Item Quantity
  bool updateQuantity(String cartItemId, int newQty) {
    final index = _items.indexWhere((item) => item.id == cartItemId);
    if (index == -1) return false;

    final item = _items[index];
    final variant = item.product.getVariant(item.selectedSize, item.selectedColor);
    final maxStock = variant?.stock ?? 0;

    if (newQty <= 0) {
      _items.removeAt(index);
      _saveCart();
      return true;
    }

    if (newQty > maxStock) {
      item.quantity = maxStock;
      _saveCart();
      return false; // Indicates stock limit hit
    }

    item.quantity = newQty;
    _saveCart();
    return true;
  }

  // Remove Item
  void removeItem(String cartItemId) {
    _items.removeWhere((item) => item.id == cartItemId);
    _saveCart();
  }

  // Clear Cart
  void clearCart() {
    _items.clear();
    _appliedPromoCode = '';
    _promoDiscountPercentage = 0.0;
    _saveCart();
  }

  // Apply Coupon Code
  bool applyPromoCode(String code) {
    final sanitizedCode = code.trim().toUpperCase();
    if (sanitizedCode == 'VOGUEX20') {
      _appliedPromoCode = sanitizedCode;
      _promoDiscountPercentage = 0.20; // 20% off
      notifyListeners();
      return true;
    } else if (sanitizedCode == 'FLASH50') {
      _appliedPromoCode = sanitizedCode;
      _promoDiscountPercentage = 0.50; // 50% off
      notifyListeners();
      return true;
    }
    return false;
  }

  void removePromoCode() {
    _appliedPromoCode = '';
    _promoDiscountPercentage = 0.0;
    notifyListeners();
  }

  // Complete Simulated Checkout
  Future<Order> completeCheckout({
    required String name,
    required String phone,
    required String address,
    required String city,
    required String zip,
    required String paymentMethod,
  }) async {
    final order = Order(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      items: List.from(_items),
      shippingName: name,
      shippingPhone: phone,
      shippingAddress: address,
      shippingCity: city,
      shippingZip: zip,
      paymentMethod: paymentMethod,
      subtotal: subtotal,
      shippingFee: shippingFee,
      discount: discountAmount,
      total: total,
      dateTime: DateTime.now(),
    );

    _orders.insert(0, order); // Add to history
    await _storageService.saveOrders(_orders);
    
    clearCart(); // Empties cart and clears codes
    return order;
  }

  Future<void> _saveCart() async {
    notifyListeners();
    await _storageService.saveCart(_items);
  }
}
