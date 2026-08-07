enum Status {
  PENDING,
  IN_PROGRESS,
  RESOLVED,
  REJECTED;

  factory Status.fromString(String value) {
    return Status.values.firstWhere(
      (e) => e.name == value,
      orElse: () => Status.PENDING,
    );
  }
}