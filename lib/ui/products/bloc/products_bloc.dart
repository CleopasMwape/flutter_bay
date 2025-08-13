import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bay/data/models/product.dart';
import 'package:flutter_bay/data/repositories/product_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductEvent, ProductsState> {
  ProductsBloc({required this.repository}) : super(ProductsInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<RefreshProducts>(_onRefreshProducts);
    on<SearchProducts>(
      _onSearchProducts,
      transformer: debounce(const Duration(milliseconds: 300)),
    );
    on<FilterByCategory>(_onFilterByCategory);
    on<FilterByPriceRange>(_onFilterByPriceRange);
    on<ClearFilters>(_onClearFilters);
    on<LoadMoreProducts>(_onLoadMoreProducts);
  }
  final ProductRepository repository;

  List<Product> _allProducts = [];
  List<String> _categories = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  double _minPrice = 0;
  double _maxPrice = 1000;

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductsState> emit,
  ) async {
    if (_allProducts.isEmpty || event.forceRefresh) {
      emit(ProductsLoading());
    }

    try {
      _allProducts = await repository.getProducts(
        forceRefresh: event.forceRefresh,
      );
      _categories = await repository.getCategories();

      if (_allProducts.isEmpty) {
        emit(const ProductsEmpty());
      } else {
        final filteredProducts = _applyFilters();
        emit(
          ProductsLoaded(
            products: _allProducts,
            filteredProducts: filteredProducts,
            categories: _categories,
            selectedCategory: _selectedCategory,
            searchQuery: _searchQuery,
            minPrice: _minPrice,
            maxPrice: _maxPrice,
          ),
        );
      }
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }

  Future<void> _onRefreshProducts(
    RefreshProducts event,
    Emitter<ProductsState> emit,
  ) async {
    add(const LoadProducts(forceRefresh: true));
  }

  void _onSearchProducts(
    SearchProducts event,
    Emitter<ProductsState> emit,
  ) {
    _searchQuery = event.query;
    final filteredProducts = _applyFilters();

    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;
      emit(
        currentState.copyWith(
          filteredProducts: filteredProducts,
          searchQuery: _searchQuery,
        ),
      );
    }
  }

  void _onFilterByCategory(
    FilterByCategory event,
    Emitter<ProductsState> emit,
  ) {
    _selectedCategory = event.category;
    final filteredProducts = _applyFilters();

    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;
      emit(
        currentState.copyWith(
          filteredProducts: filteredProducts,
          selectedCategory: _selectedCategory,
        ),
      );
    }
  }

  void _onFilterByPriceRange(
    FilterByPriceRange event,
    Emitter<ProductsState> emit,
  ) {
    _minPrice = event.minPrice;
    _maxPrice = event.maxPrice;
    final filteredProducts = _applyFilters();

    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;
      emit(
        currentState.copyWith(
          filteredProducts: filteredProducts,
          minPrice: _minPrice,
          maxPrice: _maxPrice,
        ),
      );
    }
  }

  void _onClearFilters(
    ClearFilters event,
    Emitter<ProductsState> emit,
  ) {
    _selectedCategory = 'All';
    _searchQuery = '';
    _minPrice = 0;
    _maxPrice = 1000;
    final filteredProducts = _applyFilters();

    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;
      emit(
        currentState.copyWith(
          filteredProducts: filteredProducts,
          selectedCategory: _selectedCategory,
          searchQuery: _searchQuery,
          minPrice: _minPrice,
          maxPrice: _maxPrice,
        ),
      );
    }
  }

  Future<void> _onLoadMoreProducts(
    LoadMoreProducts event,
    Emitter<ProductsState> emit,
  ) async {
    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;
      emit(
        ProductsLoadingMore(
          products: currentState.products,
          filteredProducts: currentState.filteredProducts,
        ),
      );

      // Simulate loading more products (implement pagination here)
      await Future.delayed(const Duration(seconds: 1));

      emit(currentState.copyWith(hasReachedMax: true));
    }
  }

  List<Product> _applyFilters() {
    return _allProducts.where((product) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          product.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.category.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory =
          _selectedCategory == 'All' || product.category == _selectedCategory;

      final matchesPrice =
          product.price >= _minPrice && product.price <= _maxPrice;

      return matchesSearch && matchesCategory && matchesPrice;
    }).toList();
  }
}
