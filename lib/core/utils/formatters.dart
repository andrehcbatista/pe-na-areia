class Formatters {
  static String meters(int meters) {
    if (meters < 1000) {
      return '${meters}m';
    }
    return '${(meters / 1000).toStringAsFixed(1)}km';
  }

  static String currency(num value) {
    final fixed = value.toStringAsFixed(2).replaceAll('.', ',');
    return 'R\$ $fixed';
  }
}
