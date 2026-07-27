import 'cart_item.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final String shippingName;
  final String shippingPhone;
  final String shippingAddress;
  final String shippingCity;
  final String shippingZip;
  final String paymentMethod;
  final double subtotal;
  final double shippingFee;
  final double discount;
  final double total;
  final DateTime dateTime;

  Order({
    required this.id,
    required this.items,
    required this.shippingName,
    required this.shippingPhone,
    required this.shippingAddress,
    required this.shippingCity,
    required this.shippingZip,
    required this.paymentMethod,
    required this.subtotal,
    required this.shippingFee,
    required this.discount,
    required this.total,
    required this.dateTime,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      items: (json['items'] as List)
          .map((i) => CartItem.fromJson(i as Map<String, dynamic>))
          .toList(),
      shippingName: json['shippingName'] as String,
      shippingPhone: json['shippingPhone'] as String,
      shippingAddress: json['shippingAddress'] as String,
      shippingCity: json['shippingCity'] as String,
      shippingZip: json['shippingZip'] as String,
      paymentMethod: json['paymentMethod'] as String,
      subtotal: (json['subtotal'] as num).toDouble(),
      shippingFee: (json['shippingFee'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      dateTime: DateTime.parse(json['dateTime'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((i) => i.toJson()).toList(),
      'shippingName': shippingName,
      'shippingPhone': shippingPhone,
      'shippingAddress': shippingAddress,
      'shippingCity': shippingCity,
      'shippingZip': shippingZip,
      'paymentMethod': paymentMethod,
      'subtotal': subtotal,
      'shippingFee': shippingFee,
      'discount': discount,
      'total': total,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}
