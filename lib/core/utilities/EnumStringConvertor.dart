/// `values` should be `Enum.values`.
/// `value` should be string which needs to be converted to enum
T convertStringToEnum<T>(Iterable<T> values, String value) => values.firstWhere(
      (type) => enumValueToString(type) == value,
      orElse: () =>
          throw Exception('$value not part of ${values.first.runtimeType}'),
    );

String enumValueToString(Object? enumValue) =>
    enumValue.toString().split('.').last;

extension StringExtension on String {
  String get capitalize {
    String capitalizedString = '';
    final words = split(' ');
    words.forEach((word) {
      String capitalizedWord =
          word.substring(0, 1).toUpperCase() + word.substring(1).toLowerCase();
      capitalizedString += capitalizedWord;
      if (words.length > 1 && words.last != word) capitalizedString += ' ';
    });
    return capitalizedString;
  }

  String get capitalizeEnum {
    String capitalizedString = '';
    final words = split('_');
    words.forEach((word) {
      String capitalizedWord =
          word.substring(0, 1).toUpperCase() + word.substring(1).toLowerCase();
      capitalizedString += capitalizedWord;
      if (words.length > 1 && words.last != word) capitalizedString += ' ';
    });
    return capitalizedString;
  }
}
