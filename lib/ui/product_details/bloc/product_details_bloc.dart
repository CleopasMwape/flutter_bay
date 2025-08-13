import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bay/data/models/product.dart';
import 'package:flutter_bay/data/repositories/product_repository.dart';

part 'product_details_event.dart';
part 'product_details_state.dart';

class ProductDetailsBloc extends Bloc<ProductDetailEvent, ProductDetailsState> {
  ProductDetailsBloc({required this.repository})
    : super(ProductDetailInitial()) {
    on<LoadProductDetail>(_onLoadProductDetail);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
  }
  final ProductRepository repository;

  Future<void> _onLoadProductDetail(
    LoadProductDetail event,
    Emitter<ProductDetailsState> emit,
  ) async {
    emit(ProductDetailLoading());

    try {
      final product = await repository.getProduct(event.productId);
      emit(ProductDetailLoaded(product: product));
    } catch (e) {
      emit(ProductDetailError(e.toString()));
    }
  }

  void _onAddToCart(
    AddToCart event,
    Emitter<ProductDetailsState> emit,
  ) {
    if (state is ProductDetailLoaded) {
      final currentState = state as ProductDetailLoaded;
      emit(
        currentState.copyWith(
          isAddedToCart: true,
          cartQuantity: currentState.cartQuantity + 1,
        ),
      );
    }
  }

  void _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<ProductDetailsState> emit,
  ) {
    if (state is ProductDetailLoaded) {
      final currentState = state as ProductDetailLoaded;
      final newQuantity = currentState.cartQuantity - 1;
      emit(
        currentState.copyWith(
          isAddedToCart: newQuantity > 0,
          cartQuantity: newQuantity,
        ),
      );
    }
  }
}
