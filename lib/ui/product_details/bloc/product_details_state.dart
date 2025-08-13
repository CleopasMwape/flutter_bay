part of 'product_details_bloc.dart';

abstract class ProductDetailsState extends Equatable {
  const ProductDetailsState();

  @override
  List<Object?> get props => [];
}

class ProductDetailInitial extends ProductDetailsState {}

class ProductDetailLoading extends ProductDetailsState {}

class ProductDetailLoaded extends ProductDetailsState {
  const ProductDetailLoaded({
    required this.product,
    this.isAddedToCart = false,
    this.cartQuantity = 0,
  });
  final Product product;
  final bool isAddedToCart;
  final int cartQuantity;

  ProductDetailLoaded copyWith({
    Product? product,
    bool? isAddedToCart,
    int? cartQuantity,
  }) {
    return ProductDetailLoaded(
      product: product ?? this.product,
      isAddedToCart: isAddedToCart ?? this.isAddedToCart,
      cartQuantity: cartQuantity ?? this.cartQuantity,
    );
  }

  @override
  List<Object?> get props => [product, isAddedToCart, cartQuantity];
}

class ProductDetailError extends ProductDetailsState {
  const ProductDetailError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
