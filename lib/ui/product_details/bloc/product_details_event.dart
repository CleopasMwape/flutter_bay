part of 'product_details_bloc.dart';

sealed class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductDetail extends ProductDetailEvent {
  const LoadProductDetail(this.productId);
  final int productId;

  @override
  List<Object?> get props => [productId];
}

class AddToCart extends ProductDetailEvent {}

class RemoveFromCart extends ProductDetailEvent {}
