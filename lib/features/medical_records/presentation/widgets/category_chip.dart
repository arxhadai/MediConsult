import 'package:flutter/material.dart';
import '../../domain/enums/record_category.dart';

class CategoryChip extends StatelessWidget {
  final RecordCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(category.displayName),
      selected: isSelected,
      onSelected: (selected) => onTap(),
      selectedColor: Theme.of(context).primaryColor,
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey[700],
      ),
    );
  }
}
