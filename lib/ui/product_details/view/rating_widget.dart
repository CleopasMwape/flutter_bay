import 'package:flutter/material.dart';
import 'package:flutter_bay/core/utils/extensions.dart';

class RatingWidget extends StatelessWidget {
  const RatingWidget({
    required this.rating,
    required this.count,
    super.key,
    this.size = 16,
  });
  final double rating;
  final int count;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          if (index < rating.floor()) {
            return Icon(Icons.star, color: Colors.amber, size: size);
          } else if (index < rating) {
            return Icon(Icons.star_half, color: Colors.amber, size: size);
          } else {
            return Icon(Icons.star_border, color: Colors.grey, size: size);
          }
        }),
        const SizedBox(width: 8),
        Text(
          '${rating.formatRating} ($count)',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
