import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../cubit/shops_cubit.dart';
import '../../../../core/enums/shop_enums.dart';

class FilterDialog extends StatefulWidget {
  final ShopsCubit cubit;
  final SortOption currentSort;
  final FilterOption currentFilter;

  const FilterDialog({
    super.key,
    required this.cubit,
    required this.currentSort,
    required this.currentFilter,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late SortOption _selectedSort;
  late FilterOption _selectedFilter;

  @override
  void initState() {
    super.initState();
    _selectedSort = widget.currentSort;
    _selectedFilter = widget.currentFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  AppStrings.filter,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Sort Section
            Text(
              AppStrings.sortBy,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ...SortOption.values.map((option) {
              return RadioListTile<SortOption>(
                title: Text(_getSortOptionLabel(option)),
                value: option,
                groupValue: _selectedSort,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedSort = value;
                    });
                  }
                },
                contentPadding: EdgeInsets.zero,
              );
            }),
            const SizedBox(height: 24),
            // Filter Section
            Text(
              'Availability',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ...FilterOption.values.map((option) {
              return RadioListTile<FilterOption>(
                title: Text(_getFilterOptionLabel(option)),
                value: option,
                groupValue: _selectedFilter,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedFilter = value;
                    });
                  }
                },
                contentPadding: EdgeInsets.zero,
              );
            }),
            const SizedBox(height: 24),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // Reset to current values
                    setState(() {
                      _selectedSort = widget.currentSort;
                      _selectedFilter = widget.currentFilter;
                    });
                  },
                  child: const Text(AppStrings.clear),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    // Apply filters
                    widget.cubit.sortShops(_selectedSort);
                    widget.cubit.filterShops(_selectedFilter);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Apply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getSortOptionLabel(SortOption option) {
    switch (option) {
      case SortOption.none:
        return 'None';
      case SortOption.etaAscending:
        return AppStrings.sortByEta;
      case SortOption.minOrderAscending:
        return AppStrings.sortByMinOrder;
    }
  }

  String _getFilterOptionLabel(FilterOption option) {
    switch (option) {
      case FilterOption.all:
        return AppStrings.all;
      case FilterOption.openOnly:
        return AppStrings.openOnly;
    }
  }
}
