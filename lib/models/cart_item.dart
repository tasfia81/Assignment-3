import 'product.dart';

class CartItem {
  final String id; // Unique ID for this specific cart item configuration
  final Product product;
  final String selectedSize;
  final String selectedColor;
  int quantity;

  CartItem({
    required this.id,
    required this.product,
    required this.selectedSize,
    required this.selectedColor,
    required this.quantity,
  });

  // Dynamically calculate unit price based on variant and any sales
  double get unitPrice => product.getPriceForVariant(selectedSize, selectedColor);

  // Dynamically calculate total price
  double get totalPrice => unitPrice * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String,
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      selectedSize: json['selectedSize'] as String,
      selectedColor: json['selectedColor'] as String,
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'selectedSize': selectedSize,
      'selectedColor': selectedColor,
      'quantity': quantity,
    };
  }
}
