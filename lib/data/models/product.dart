import 'package:equatable/equatable.dart';
import 'package:flutter_bay/data/models/rating.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

/// {@template product}
/// Product description
/// {@endtemplate}
@JsonSerializable()
class Product extends Equatable {
  /// {@macro product}
  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  /// Creates a Product from Json map
  factory Product.fromJson(Map<String, dynamic> data) =>
      _$ProductFromJson(data);

  /// A description for id
  @JsonKey(name: 'id')
  final int id;

  /// A description for title
  @JsonKey(name: 'title')
  final String title;

  /// A description for price
  @JsonKey(name: 'price')
  final double price;

  /// A description for description
  @JsonKey(name: 'description')
  final String description;

  /// A description for category
  @JsonKey(name: 'category')
  final String category;

  /// A description for image
  @JsonKey(name: 'image')
  final String image;

  /// A description for rating
  @JsonKey(name: 'rating')
  final Rating rating;

  /// Creates a copy of the current Product with property changes
  Product copyWith({
    int? id,
    String? title,
    double? price,
    String? description,
    String? category,
    String? image,
    Rating? rating,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      image: image ?? this.image,
      rating: rating ?? this.rating,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    price,
    description,
    category,
    image,
    rating,
  ];

  /// Creates a Json map from a Product
  Map<String, dynamic> toJson() => _$ProductToJson(this);

  /// Creates a toString() override for Product
  @override
  String toString() =>
      'Product(id: $id, title: $title, price: $price, description: $description, category: $category, image: $image, rating: $rating)';
}
