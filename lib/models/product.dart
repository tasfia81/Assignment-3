class ProductVariant {
  final String size;
  final String colorName;
  final String colorHex;
  final double priceOverride; // Price for this variant
  final int stock;
  final String? imageUrl; // Custom image for this variant, if any

  ProductVariant({
    required this.size,
    required this.colorName,
    required this.colorHex,
    required this.priceOverride,
    required this.stock,
    this.imageUrl,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      size: json['size'] as String,
      colorName: json['colorName'] as String,
      colorHex: json['colorHex'] as String,
      priceOverride: (json['priceOverride'] as num).toDouble(),
      stock: json['stock'] as int,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'size': size,
      'colorName': colorName,
      'colorHex': colorHex,
      'priceOverride': priceOverride,
      'stock': stock,
      'imageUrl': imageUrl,
    };
  }
}

class Product {
  final String id;
  final String title;
  final String description;
  final List<String> images;
  final double basePrice;
  final double rating;
  final int reviewsCount;
  final bool isFlashSale;
  final double flashSaleDiscount; // Decimal representing percentage, e.g. 0.3 for 30% off
  final String tag; // e.g. "Trending", "New In", "Best Seller"
  final List<String> sizes;
  final List<Map<String, String>> colors; // List of {'name': 'Black', 'hex': '0xFF000000'}
  final List<ProductVariant> variants;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.basePrice,
    required this.rating,
    required this.reviewsCount,
    required this.isFlashSale,
    required this.flashSaleDiscount,
    required this.tag,
    required this.sizes,
    required this.colors,
    required this.variants,
  });

  // Calculate price taking flash sale and variant override into account
  double getPriceForVariant(String size, String colorName) {
    final variant = getVariant(size, colorName);
    double price = variant != null ? variant.priceOverride : basePrice;
    if (isFlashSale) {
      price = price * (1.0 - flashSaleDiscount);
    }
    return price;
  }

  ProductVariant? getVariant(String size, String colorName) {
    try {
      return variants.firstWhere(
        (v) => v.size == size && v.colorName == colorName,
      );
    } catch (_) {
      return null;
    }
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      images: List<String>.from(json['images'] as List),
      basePrice: (json['basePrice'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      reviewsCount: json['reviewsCount'] as int,
      isFlashSale: json['isFlashSale'] as bool,
      flashSaleDiscount: (json['flashSaleDiscount'] as num).toDouble(),
      tag: json['tag'] as String,
      sizes: List<String>.from(json['sizes'] as List),
      colors: (json['colors'] as List)
          .map((c) => Map<String, String>.from(c as Map))
          .toList(),
      variants: (json['variants'] as List)
          .map((v) => ProductVariant.fromJson(v as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'images': images,
      'basePrice': basePrice,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'isFlashSale': isFlashSale,
      'flashSaleDiscount': flashSaleDiscount,
      'tag': tag,
      'sizes': sizes,
      'colors': colors,
      'variants': variants.map((v) => v.toJson()).toList(),
    };
  }
}
