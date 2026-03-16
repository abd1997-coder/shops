import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../cubit/shops_cubit.dart';
import '../widgets/shop_card.dart';
import '../widgets/shop_card_shimmer.dart';
import '../widgets/search_bar.dart';
import '../widgets/filter_dialog.dart';

class ShopsPage extends StatefulWidget {
  const ShopsPage({super.key});

  @override
  State<ShopsPage> createState() => _ShopsPageState();
}

class _ShopsPageState extends State<ShopsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ShopsCubit>().loadShops();
  }

  void _handleSearchChanged(String query) {
    context.read<ShopsCubit>().searchShops(query);
  }

  void _showFilterDialog(BuildContext context) {
    final cubit = context.read<ShopsCubit>();
    showDialog(
      context: context,
      builder:
          (context) => FilterDialog(
            cubit: cubit,
            currentSort: cubit.currentSort,
            currentFilter: cubit.currentFilter,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        elevation: 0,
        actions: [
          BlocBuilder<ShopsCubit, ShopsState>(
            builder: (context, state) {
              final cubit = context.read<ShopsCubit>();
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    tooltip: AppStrings.filter,
                    onPressed: () => _showFilterDialog(context),
                  ),
                  if (cubit.hasActiveFilters)
                    Positioned(
                      right: 8,
                      top: 8,
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
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<ShopsCubit, ShopsState>(
        listener: (context, state) {
          // The cubit maintains the sort and filter state internally
        },
        builder: (context, state) {
          return Column(
            children: [
              // Search Bar
              BlocBuilder<ShopsCubit, ShopsState>(
                builder: (context, state) {
                  final cubit = context.read<ShopsCubit>();
                  return SearchBarWidget(
                    onSearchChanged: _handleSearchChanged,
                    onClear: () {
                      cubit.searchShops('');
                    },
                  );
                },
              ),
              // Content
              Expanded(child: _buildContent(state)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(ShopsState state) {
    if (state is ShopsLoading) {
      return RefreshIndicator(
        onRefresh: () async {
          context.read<ShopsCubit>().loadShops();
        },
        child: ListView.builder(
          itemCount: 5, // Show 5 shimmer cards
          itemBuilder: (context, index) {
            return const ShopCardShimmer();
          },
        ),
      );
    }

    if (state is ShopsError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              AppStrings.errorOccurred,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.read<ShopsCubit>().loadShops(),
              icon: const Icon(Icons.refresh),
              label: const Text(AppStrings.retry),
            ),
          ],
        ),
      );
    }

    if (state is ShopsLoaded) {
      if (state.shops.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                AppStrings.noResults,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.noResultsDescription,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          context.read<ShopsCubit>().loadShops();
        },
        child: ListView.builder(
          itemCount: state.shops.length,
          itemBuilder: (context, index) {
            return ShopCard(shop: state.shops[index]);
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
