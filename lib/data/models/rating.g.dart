part of 'rating.dart';

Rating _$RatingFromJson(Map<String, dynamic> json) => Rating(
      rate: json['rate'] as double,
      count: json['count'] as int,
    );

Map<String, dynamic> _$RatingToJson(Rating instance) => <String, dynamic>{ 
      'rate': instance.rate,
      'count': instance.count,
    };