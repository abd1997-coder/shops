import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../cubit/shops_cubit.dart';
import '../../../../core/enums/shop_enums.dart';
import 'filter_dialog.dart';

class FilterSection extends StatelessWidget {
  final ShopsCubit cubit;
  final SortOption currentSort;
  final FilterOption currentFilter;
  final bool hasActiveFilters;

  const FilterSection({
    super.key,
    required this.cubit,
    required this.currentSort,
    required this.currentFilter,
    required this.hasActiveFilters,
  });

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => FilterDialog(
        cubit: cubit,
        currentSort: currentSort,
        currentFilter: currentFilter,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          // Filter Icon Button
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.filter_list),
                if (hasActiveFilters)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 8,
                        minHeight: 8,
                      ),
                    ),
                  ),
              ],
            ),
            tooltip: AppStrings.filter,
            onPressed: () => _showFilterDialog(context),
          ),
          const SizedBox(width: 8),
          // Show active filters indicator
          if (hasActiveFilters) ...[
            Expanded(
              child: Text(
                _getActiveFiltersText(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            // Clear Button
            TextButton.icon(
              onPressed: () => cubit.clearFilters(),
              icon: const Icon(Icons.clear, size: 18),
              label: const Text(AppStrings.clear),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ] else
            Expanded(
              child: Text(
                'Tap to filter and sort',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getActiveFiltersText() {
    final parts = <String>[];
    
    if (currentSort != SortOption.none) {
      switch (currentSort) {
        case SortOption.etaAscending:
          parts.add('Sorted by ETA');
          break;
        case SortOption.minOrderAscending:
          parts.add('Sorted by Min Order');
          break;
        case SortOption.none:
          break;
      }
    }
    
    if (currentFilter == FilterOption.openOnly) {
      parts.add('Open only');
    }
    
    return parts.isEmpty ? '' : parts.join(' • ');
  }
}
