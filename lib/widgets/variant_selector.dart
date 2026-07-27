import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VariantSelector extends StatelessWidget {
  final List<String> sizes;
  final String selectedSize;
  final ValueChanged<String> onSizeSelected;
  
  final List<Map<String, String>> colors;
  final String selectedColor;
  final ValueChanged<String> onColorSelected;

  const VariantSelector({
    super.key,
    required this.sizes,
    required this.selectedSize,
    required this.onSizeSelected,
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Size Selector
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'SIZE: $selectedSize',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              'Size Guide',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 11.sp,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.0.w,
          children: sizes.map((size) {
            final isSelected = size == selectedSize;
            return ChoiceChip(
              label: Text(
                size,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) onSizeSelected(size);
              },
              selectedColor: Colors.black,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: isSelected ? Colors.black : Colors.grey[300]!,
                  width: 1.w,
                ),
                borderRadius: BorderRadius.circular(4.r),
              ),
              showCheckmark: false,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            );
          }).toList(),
        ),
        
        SizedBox(height: 20.h),

        // Color Selector
        Text(
          'COLOR: $selectedColor',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 12.0.w,
          runSpacing: 8.0.h,
          children: colors.map((colorMap) {
            final colorName = colorMap['name']!;
            final colorHexStr = colorMap['hex']!;
            final isSelected = colorName == selectedColor;
            
            // Parse hexadecimal color format e.g. "0xFF000000"
            final colorValue = int.parse(colorHexStr);
            final color = Color(colorValue);

            return GestureDetector(
              onTap: () => onColorSelected(colorName),
              child: Container(
                padding: EdgeInsets.all(2.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.transparent,
                    width: 1.5.w,
                  ),
                ),
                child: Container(
                  width: 26.w,
                  height: 26.h,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey[350]!,
                      width: 0.5.w,
                    ),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4.r,
                          spreadRadius: 0.5.r,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
