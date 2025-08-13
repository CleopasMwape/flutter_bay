import 'package:equatable/equatable.dart';
import 'package:flutter_bay/data/models/rating.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@HiveType(typeId: 0) // Unique typeId for Product
@JsonSerializable()
class Product extends Equatable {
  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> data) =>
      _$ProductFromJson(data);

  @HiveField(0)
  @JsonKey(name: 'id')
  final num id;

  @HiveField(1)
  @JsonKey(name: 'title')
  final String title;

  @HiveField(2)
  @JsonKey(name: 'price')
  final num price;

  @HiveField(3)
  @JsonKey(name: 'description')
  final String description;

  @HiveField(4)
  @JsonKey(name: 'category')
  final String category;

  @HiveField(5)
  @JsonKey(name: 'image')
  final String image;

  @HiveField(6)
  @JsonKey(name: 'rating')
  final Rating rating;

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

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  @override
  String toString() =>
      'Product(id: $id, title: $title, price: $price, description: $description, category: $category, image: $image, rating: $rating)';
}
