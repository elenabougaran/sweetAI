extension DoubleFormatting on double {
  String get clean {
    return toStringAsFixed(truncateToDouble() == this ? 0 : 1);
  }
}
