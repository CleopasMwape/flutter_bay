import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rating.g.dart';

@HiveType(typeId: 1) // Unique typeId for Rating
@JsonSerializable()
class Rating extends Equatable {
  const Rating({
    required this.rate,
    required this.count,
  });

  factory Rating.fromJson(Map<String, dynamic> data) => _$RatingFromJson(data);

  @HiveField(0)
  @JsonKey(name: 'rate')
  final double rate;

  @HiveField(1)
  @JsonKey(name: 'count')
  final int count;

  @override
  List<Object?> get props => [rate, count];

  Map<String, dynamic> toJson() => _$RatingToJson(this);
}
