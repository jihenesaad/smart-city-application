enum Category {
  ROAD,
  LIGHT,
  WASTE,
  WATER,
  OTHER;

  factory Category.fromString(String value) {
    return Category.values.firstWhere(
      (e) => e.name == value,
      orElse: () => Category.OTHER,
    );
  }
}