import 'package:flutter/material.dart';
import '../../domain/enums/record_category.dart';
import 'category_chip.dart';

class CategoryFilterBar extends StatelessWidget {
  final RecordCategory? selectedCategory;
  final Function(RecordCategory?) onCategorySelected;

  const CategoryFilterBar({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // All categories option
            CategoryChip(
              category: RecordCategory.all,
              isSelected: selectedCategory == null,
              onTap: () => onCategorySelected(null),
            ),
            const SizedBox(width: 8),
            // Other category options
            ...RecordCategory.values
                .where((category) => category != RecordCategory.all)
                .map((category) {
              return Row(
                children: [
                  CategoryChip(
                    category: category,
                    isSelected: selectedCategory == category,
                    onTap: () => onCategorySelected(category),
                  ),
                  const SizedBox(width: 8),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
