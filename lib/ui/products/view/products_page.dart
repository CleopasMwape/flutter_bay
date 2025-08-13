import 'package:flutter/material.dart';
import 'package:flutter_bay/ui/products/bloc/products_bloc.dart';
import 'package:flutter_bay/ui/products/view/product_card.dart';
import 'package:flutter_bay/ui/theme/theme.dart';
import 'package:flutter_bay/ui/widgets/product_skeleton_loader.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ProductsBloc>().add(const LoadProducts());
    // return BlocProvider(
    //   create: (_) => ProductsBloc(),
    //   child: const ProductsView(),
    // );
    return const ProductsView();
  }
}

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView>
    with TickerProviderStateMixin {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  late AnimationController _fabAnimationController;
  bool _showFab = false;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scrollController.addListener(_onScroll);

    // Load products on init
    context.read<ProductsBloc>().add(LoadProducts());
  }

  void _onScroll() {
    if (_scrollController.offset >= 400 && !_showFab) {
      setState(() => _showFab = true);
      _fabAnimationController.forward();
    } else if (_scrollController.offset < 400 && _showFab) {
      setState(() => _showFab = false);
      _fabAnimationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('FBay'),
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () {},
                // => _showFilterBottomSheet(context),
                icon: const Icon(Icons.tune),
              ),
              const ThemePage(),
              // IconButton(
              //   onPressed: () => context.read<ProductsBloc>().add(ToggleTheme()),
              //   icon: Icon(
              //     state is ProductsLoaded && state.isDarkMode
              //         ? Icons.light_mode
              //         : Icons.dark_mode,
              //   ),
              // ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              context.read<ProductsBloc>().add(
                                const SearchProducts(''),
                              );
                            },
                            icon: const Icon(Icons.clear),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                  ),
                  onChanged: (query) {
                    context.read<ProductsBloc>().add(SearchProducts(query));
                  },
                ),
              ),
            ),
          ),
          body: _buildBody(state),
          floatingActionButton: ScaleTransition(
            scale: _fabAnimationController,
            child: FloatingActionButton(
              onPressed: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: const Icon(Icons.keyboard_arrow_up),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(ProductsState state) {
    if (state is ProductsLoading) {
      return const ProductLoadingWidget();
    } else if (state is ProductsError) {
      return _buildErrorWidget(state.message);
    } else if (state is ProductsLoaded) {
      if (state.filteredProducts.isEmpty) {
        return _buildEmptyWidget();
      }
      return _buildProductGrid(state);
    }
    return const SizedBox.shrink();
  }

  Widget _buildProductGrid(ProductsLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProductsBloc>().add(
          const LoadProducts(forceRefresh: true),
        );
      },
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
        ),
        itemCount: state.filteredProducts.length,
        itemBuilder: (context, index) {
          final product = state.filteredProducts[index];
          return AnimatedContainer(
            duration: Duration(milliseconds: 300 + (index * 50)),
            curve: Curves.easeOutBack,
            child: ProductCard(
              product: product,
              // onFavoritePressed: () {
              //   // Handle favorite toggle
              //   final updatedProduct = product.copyWith(
              //     isFavorite: !product.isFavorite,
              //   );
              //   // You would dispatch a toggle favorite event here
              // },
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Oops! Something went wrong',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<ProductsBloc>().add(
                LoadProducts(forceRefresh: true),
              );
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_bag_outlined,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // void _showFilterBottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) => const FilterBottomSheet(),
  //   );
  // }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }
}
