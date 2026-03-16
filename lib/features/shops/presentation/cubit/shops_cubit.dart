import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/shop.dart';
import '../../domain/usecases/get_shops.dart';
import '../../../../core/enums/shop_enums.dart';

part 'shops_state.dart';

class ShopsCubit extends Cubit<ShopsState> {
  final GetShops getShops;

  ShopsCubit({required this.getShops}) : super(ShopsInitial());

  List<Shop> _allShops = [];
  String _searchQuery = '';
  SortOption _sortOption = SortOption.none;
  FilterOption _filterOption = FilterOption.all;

  Future<void> loadShops() async {
    emit(ShopsLoading());

    final result = await getShops(NoParams());

    result.fold((failure) => emit(ShopsError(failure.message)), (shops) {
      _allShops = shops;
      _applyFiltersAndSort();
    });
  }

  void searchShops(String query) {
    _searchQuery = query.toLowerCase();
    _applyFiltersAndSort();
  }

  void sortShops(SortOption option) {
    _sortOption = option;
    _applyFiltersAndSort();
  }

  void filterShops(FilterOption option) {
    _filterOption = option;
    _applyFiltersAndSort();
  }

  void clearFilters() {
    _searchQuery = '';
    _sortOption = SortOption.none;
    _filterOption = FilterOption.all;
    _applyFiltersAndSort();
  }

  void _applyFiltersAndSort() {
    List<Shop> filteredShops = List.from(_allShops);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filteredShops =
          filteredShops.where((shop) {
            return shop.name.toLowerCase().contains(_searchQuery) ||
                shop.description.toLowerCase().contains(_searchQuery);
          }).toList();
    }

    // Apply availability filter
    if (_filterOption == FilterOption.openOnly) {
      filteredShops = filteredShops.where((shop) => shop.isOpen).toList();
    }

    // Apply sorting
    if (_sortOption == SortOption.etaAscending) {
      filteredShops.sort(
        (a, b) => a.estimatedDeliveryTime.compareTo(b.estimatedDeliveryTime),
      );
    } else if (_sortOption == SortOption.minOrderAscending) {
      filteredShops.sort((a, b) => a.minimumOrder.compareTo(b.minimumOrder));
    }

    // Always emit the loaded state (even if currently loading, we have data now)
    emit(ShopsLoaded(filteredShops));
  }

  bool get hasActiveFilters =>
      _searchQuery.isNotEmpty ||
      _sortOption != SortOption.none ||
      _filterOption != FilterOption.all;

  SortOption get currentSort => _sortOption;
  FilterOption get currentFilter => _filterOption;
  String get currentSearchQuery => _searchQuery;
}
