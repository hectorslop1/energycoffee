class HomeInfo {
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final String? actionUrl;

  const HomeInfo({
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.actionUrl,
  });
}

class Promotion {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double? discountPercent;
  final DateTime? validUntil;

  const Promotion({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.discountPercent,
    this.validUntil,
  });
}
