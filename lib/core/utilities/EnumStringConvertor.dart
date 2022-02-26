/// `values` should be `Enum.values`.
/// `value` should be string which needs to be converted to enum
T convertStringToEnum<T>(Iterable<T> values, String value) => values.firstWhere(
      (type) => enumValueToString(type) == value,
      orElse: () =>
          throw Exception('$value not part of ${values.first.runtimeType}'),
    );

String enumValueToString(Object? enumValue) =>
    enumValue.toString().split('.').last;
