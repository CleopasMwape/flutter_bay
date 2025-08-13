part of 'products_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {
  const LoadProducts({this.forceRefresh = false});
  final bool forceRefresh;

  @override
  List<Object?> get props => [forceRefresh];
}

class RefreshProducts extends ProductEvent {}

class SearchProducts extends ProductEvent {
  const SearchProducts(this.query);
  final String query;

  @override
  List<Object?> get props => [query];
}

class FilterByCategory extends ProductEvent {
  const FilterByCategory(this.category);
  final String category;

  @override
  List<Object?> get props => [category];
}

class FilterByPriceRange extends ProductEvent {
  const FilterByPriceRange({required this.minPrice, required this.maxPrice});
  final double minPrice;
  final double maxPrice;

  @override
  List<Object?> get props => [minPrice, maxPrice];
}

class ClearFilters extends ProductEvent {}

class LoadMoreProducts extends ProductEvent {}
