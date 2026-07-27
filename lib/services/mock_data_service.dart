import '../models/product.dart';

class MockDataService {
  static const List<String> categories = [
    'All',
    'New In',
    'Trending',
    'Flash Sale',
    'Dresses',
    'Tops',
    'Bottoms',
    'Shoes',
    'Accessories'
  ];

  static const List<String> sizes = ['XS', 'S', 'M', 'L', 'XL'];

  static const List<Map<String, String>> colors = [
    {'name': 'Off-White', 'hex': '0xFFF5F5F0'},
    {'name': 'Ebony Black', 'hex': '0xFF1A1A1A'},
    {'name': 'Sage Green', 'hex': '0xFF9CAF88'},
    {'name': 'Terracotta Red', 'hex': '0xFFC35243'},
    {'name': 'Lavender Blue', 'hex': '0xFF969AD6'},
    {'name': 'Champagne Gold', 'hex': '0xFFE6CF8B'},
  ];

  static const List<String> _fashionImageBases = [
    'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f',
    'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6',
    'https://images.unsplash.com/photo-1496747611176-843222e1e57c',
    'https://images.unsplash.com/photo-1509631179647-0177331693ae',
    'https://images.unsplash.com/photo-1554412933-514a83d2f3c8',
    'https://images.unsplash.com/photo-1529139574466-a303027c1d8b',
    'https://images.unsplash.com/photo-1485968579580-b6d095142e6e',
    'https://images.unsplash.com/photo-1583391733956-3750e0ff4e8b',
    'https://images.unsplash.com/photo-1576185056114-4a67e1536b72',
    'https://images.unsplash.com/photo-1483985988355-763728e1935b',
    'https://images.unsplash.com/photo-1609505848912-b7c3b8b4beda',
    'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633',
    'https://images.unsplash.com/photo-1585487000160-6ebcfceb0d03',
    'https://images.unsplash.com/photo-1595777457583-95e059d581b8',
    'https://images.unsplash.com/photo-1479064555552-3ef4979f8908',
    'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908',
    'https://images.unsplash.com/photo-1549298916-b41d501d3772',
    'https://images.unsplash.com/photo-1618220179428-22790b461013',
    'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80',
    'https://images.unsplash.com/photo-1512436991641-6745cdb1723f',
  ];

  static const List<String> _titles = [
    'Satin Cowl Neck Midi Dress',
    'Bouclé Knit Oversized Sweater',
    'Sequin Fringe Wrap Skirt',
    'Utility High-Waist Cargo Pants',
    'Linen Wide-Leg Trousers',
    'Platform Double-Strap Sandals',
    'Ribbed Cropped Tank Top',
    'Structured Classic Blazer',
    'Crochet Fringe Kimono Sleeve',
    'Velvet Puff Sleeve Bodysuit',
    'Suede Ankle Chelsea Boots',
    'Shearling Denim Casual Jacket',
    'Ribbed Wrap Crop Cardigan',
    'Embroidered Mesh Corset Top',
    'Lettuce-Edge Fit Cardigan',
    'Asymmetric Ribbed Swimwear',
    'Sleek Vegan Leather Trench',
    'Lace Trim Silk Camisole',
    'High-Impact Comfort Bra',
    'Linen Blend Drawstring Shorts'
  ];

  static const List<String> _adjectives = [
    'Classic', 'Elegant', 'Minimalist', 'Bohemian', 'Modern', 'Vintage',
    'Streetwear', 'Athletic', 'Romantic', 'Sophisticated', 'Vogue', 'Urban'
  ];

  // Return a single product by generating it deterministically from an integer index
  static Product getProductByIndex(int index) {
    final imageBaseIndex = index % _fashionImageBases.length;
    final titleIndex = index % _titles.length;
    final adjIndex = (index ~/ _titles.length) % _adjectives.length;

    final String id = 'prod_${index + 1}';
    final String baseTitle = _titles[titleIndex];
    final String adjective = _adjectives[adjIndex];
    final String title = '$adjective $baseTitle';

    // Base price between $14.99 and $99.99
    final double basePrice = double.parse((14.99 + (index * 4.79) % 85.0).toStringAsFixed(2));
    
    // Rating between 4.2 and 4.9
    final double rating = double.parse((4.2 + (index * 0.07) % 0.79).toStringAsFixed(2));
    
    // Review count between 24 and 2500
    final int reviewsCount = 24 + (index * 43) % 2476;

    // Flash sale: make every 4th item a Flash Sale
    final bool isFlashSale = index % 4 == 0;
    final List<double> discounts = [0.15, 0.20, 0.30, 0.40];
    final double flashSaleDiscount = isFlashSale ? discounts[(index ~/ 4) % discounts.length] : 0.0;

    // General tag selection
    final List<String> tags = ['New In', 'Trending', 'Best Seller', 'Hot Items'];
    final String tag = tags[index % tags.length];

    // Image gallery (3 images per product, cycled)
    final List<String> images = [];
    for (int i = 0; i < 3; i++) {
      final imgIdx = (imageBaseIndex + i) % _fashionImageBases.length;
      images.add(_fashionImageBases[imgIdx]);
    }

    // Limit to 3 colors for this item
    final List<Map<String, String>> selectedColors = [];
    for (int i = 0; i < 3; i++) {
      selectedColors.add(colors[(index + i) % colors.length]);
    }

    // Limit to 3-4 sizes
    final List<String> selectedSizes = [];
    final int sizesCount = 3 + (index % 2); // 3 or 4 sizes
    for (int i = 0; i < sizesCount; i++) {
      selectedSizes.add(sizes[(index + i) % sizes.length]);
    }
    // Sort sizes chronologically
    selectedSizes.sort((a, b) => sizes.indexOf(a).compareTo(sizes.indexOf(b)));

    // Create variants
    final List<ProductVariant> variants = [];
    for (var size in selectedSizes) {
      for (var color in selectedColors) {
        // XL costs $2.00 extra, L costs $1.00 extra
        final sizeExtra = size == 'XL' ? 2.0 : (size == 'L' ? 1.0 : 0.0);
        final priceOverride = basePrice + sizeExtra;
        
        // Stock between 0 and 50 (simulate out of stock at 0, rare)
        final int stock = (index + size.hashCode + color['name'].hashCode) % 49;

        // Custom gallery image based on color index (so changing color changes displayed image)
        final colorIndex = selectedColors.indexOf(color);
        final imageUrl = images[colorIndex % images.length];

        variants.add(ProductVariant(
          size: size,
          colorName: color['name']!,
          colorHex: color['hex']!,
          priceOverride: priceOverride,
          stock: stock,
          imageUrl: imageUrl,
        ));
      }
    }

    final String description = 'The $title represents contemporary styling. '
        'Cut from premium lightweight fabrics, it features an elegant design, providing '
        'both dynamic flexibility and long-lasting comfort. Detailed craftsmanship makes '
        'it perfect for both casual streetwear or chic night outs. An essential addition '
        'to your fast-fashion collection, curated exclusively by VogueX.';

    return Product(
      id: id,
      title: title,
      description: description,
      images: images,
      basePrice: basePrice,
      rating: rating,
      reviewsCount: reviewsCount,
      isFlashSale: isFlashSale,
      flashSaleDiscount: flashSaleDiscount,
      tag: tag,
      sizes: selectedSizes,
      colors: selectedColors,
      variants: variants,
    );
  }

  // Paginated query supporting search tags and infinite scroll. 
  // Offset represents the starting number of matching items.
  static Future<List<Product>> getProductsPage({
    required int offset,
    required int limit,
    required String category,
    String searchQuery = '',
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 700));

    final List<Product> result = [];
    int matchCount = 0;
    int currentIndex = 0;

    // Scan up to 5000 mock products
    while (result.length < limit && currentIndex < 5000) {
      final Product p = getProductByIndex(currentIndex);
      bool isMatch = false;

      if (category == 'All') {
        isMatch = true;
      } else if (category == 'Flash Sale') {
        isMatch = p.isFlashSale;
      } else if (category == 'New In' || category == 'Trending') {
        isMatch = p.tag == category;
      } else {
        // Matches product type based on category name
        final titleLower = p.title.toLowerCase();
        if (category == 'Dresses') {
          isMatch = titleLower.contains('dress');
        } else if (category == 'Tops') {
          isMatch = titleLower.contains('top') || titleLower.contains('sweater') || titleLower.contains('blazer') || titleLower.contains('jacket') || titleLower.contains('bra') || titleLower.contains('cardigan') || titleLower.contains('camisole') || titleLower.contains('bodysuit');
        } else if (category == 'Bottoms') {
          isMatch = titleLower.contains('pant') || titleLower.contains('skirt') || titleLower.contains('trousers') || titleLower.contains('shorts');
        } else if (category == 'Shoes') {
          isMatch = titleLower.contains('sandals') || titleLower.contains('boots') || titleLower.contains('shoes');
        } else if (category == 'Accessories') {
          isMatch = titleLower.contains('kimono') || titleLower.contains('bag');
        }
      }

      // Apply search query filter if populated
      if (isMatch && searchQuery.trim().isNotEmpty) {
        final query = searchQuery.trim().toLowerCase();
        final matchesTitle = p.title.toLowerCase().contains(query);
        final matchesDesc = p.description.toLowerCase().contains(query);
        final matchesTag = p.tag.toLowerCase().contains(query);
        isMatch = matchesTitle || matchesDesc || matchesTag;
      }

      if (isMatch) {
        if (matchCount >= offset) {
          result.add(p);
        }
        matchCount++;
      }
      currentIndex++;
    }

    return result;
  }

  // Lookup single product by ID
  static Product getProductById(String id) {
    try {
      final int index = int.parse(id.replaceAll('prod_', '')) - 1;
      return getProductByIndex(index);
    } catch (_) {
      return getProductByIndex(0);
    }
  }
}
