extension DoubleExtensions on double {
  String get formatPrice {
    return toStringAsFixed(2);
  }

  String get formatRating {
    return toStringAsFixed(1);
  }
}

extension ListExtensions<T> on List<T> {
  List<T> get removeDuplicates {
    return toSet().toList();
  }

  T? get firstOrNull {
    return isEmpty ? null : first;
  }

  T? get lastOrNull {
    return isEmpty ? null : last;
  }
}
