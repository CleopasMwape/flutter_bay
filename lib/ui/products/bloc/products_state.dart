part of 'products_bloc.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  const ProductsLoaded({
    required this.products,
    required this.filteredProducts,
    required this.categories,
    this.selectedCategory = 'All',
    this.searchQuery = '',
    this.minPrice = 0,
    this.maxPrice = 1000,
    this.hasReachedMax = false,
  });
  final List<Product> products;
  final List<Product> filteredProducts;
  final List<String> categories;
  final String selectedCategory;
  final String searchQuery;
  final double minPrice;
  final double maxPrice;
  final bool hasReachedMax;

  ProductsLoaded copyWith({
    List<Product>? products,
    List<Product>? filteredProducts,
    List<String>? categories,
    String? selectedCategory,
    String? searchQuery,
    double? minPrice,
    double? maxPrice,
    bool? hasReachedMax,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
    products,
    filteredProducts,
    categories,
    selectedCategory,
    searchQuery,
    minPrice,
    maxPrice,
    hasReachedMax,
  ];
}

class ProductsError extends ProductsState {
  const ProductsError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class ProductsEmpty extends ProductsState {
  const ProductsEmpty({this.message = 'No products found'});
  final String message;

  @override
  List<Object?> get props => [message];
}

class ProductsLoadingMore extends ProductsState {
  const ProductsLoadingMore({
    required this.products,
    required this.filteredProducts,
  });
  final List<Product> products;
  final List<Product> filteredProducts;

  @override
  List<Object?> get props => [products, filteredProducts];
}
