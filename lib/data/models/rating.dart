import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';


part 'rating.g.dart';

/// {@template rating}
/// Rating description
/// {@endtemplate}
@JsonSerializable()
class Rating extends Equatable {
  /// {@macro rating}
  const Rating({ 
  required this.rate,
  required this.count,
  });

    /// Creates a Rating from Json map
  factory Rating.fromJson(Map<String, dynamic> data) => _$RatingFromJson(data);

  /// A description for rate
  @JsonKey(name: 'rate')
  final double rate;

  /// A description for count
  @JsonKey(name: 'count')
  final int count;

    /// Creates a copy of the current Rating with property changes
  Rating copyWith({ 
    double? rate,
    int? count,
  }) {
    return Rating(
      rate: rate ?? this.rate,
      count: count ?? this.count,
    );
  }


    @override
  List<Object?> get props => [
        rate,
        count,
      ];

    /// Creates a Json map from a Rating
  Map<String, dynamic> toJson() => _$RatingToJson(this);

    /// Creates a toString() override for Rating
  @override
  String toString() => 'Rating(rate: $rate, count: $count)';
}
