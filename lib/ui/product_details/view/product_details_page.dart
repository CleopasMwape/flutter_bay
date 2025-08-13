import 'package:flutter/material.dart';
import 'package:flutter_bay/core/utils/extensions.dart';
import 'package:flutter_bay/ui/product_details/product_details.dart';
import 'package:flutter_bay/ui/product_details/view/rating_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({required this.productId, super.key});
  final int productId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductDetailsBloc(repository: context.read()),
      child: ProductDetailsView(
        productId: productId,
      ),
    );
  }
}

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({super.key, required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
      builder: (context, state) {
        if (state is ProductDetailInitial) {
          context.read<ProductDetailsBloc>().add(LoadProductDetail(productId));
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductDetailLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductDetailLoaded) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        state.product.title,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      state.product.price.formatPrice,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Category and Rating
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        state.product.category,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    RatingWidget(
                      rating: state.product.rating.rate,
                      count: state.product.rating.count,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Description
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.product.description,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),

                // Cart Status
                if (state.isAddedToCart) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Added to cart',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                        if (state.cartQuantity > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$state.cartQuantity',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100), // Space for FAB
                ],
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
