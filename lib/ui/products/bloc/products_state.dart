part of 'products_bloc.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductsState {}

class ProductLoading extends ProductsState {}

class ProductLoaded extends ProductsState {
  const ProductLoaded({
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

  ProductLoaded copyWith({
    List<Product>? products,
    List<Product>? filteredProducts,
    List<String>? categories,
    String? selectedCategory,
    String? searchQuery,
    double? minPrice,
    double? maxPrice,
    bool? hasReachedMax,
  }) {
    return ProductLoaded(
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

class ProductError extends ProductsState {
  const ProductError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class ProductEmpty extends ProductsState {
  const ProductEmpty({this.message = 'No products found'});
  final String message;

  @override
  List<Object?> get props => [message];
}

class ProductLoadingMore extends ProductsState {
  const ProductLoadingMore({
    required this.products,
    required this.filteredProducts,
  });
  final List<Product> products;
  final List<Product> filteredProducts;

  @override
  List<Object?> get props => [products, filteredProducts];
}
