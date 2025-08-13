import 'package:flutter/material.dart';
import 'package:flutter_bay/data/models/product.dart';
import 'package:flutter_bay/data/models/rating.dart';
import 'package:flutter_bay/ui/products/view/product_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductLoadingWidget extends StatelessWidget {
  const ProductLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return const ProductCard(
            product: Product(
              id: 1,
              title: 'title',
              price: 0,
              description: 'description',
              category: 'category',
              image: 'image',
              rating: Rating(rate: 0, count: 0),
            ),
          );
        },
      ),
    );
  }
}
