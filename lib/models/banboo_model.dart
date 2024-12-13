class Banboo {
  final int? id;
  final String? name;
  final double? price;
  final String? description;
  final String? elementId;
  final int? level;
  bool isFavorite;

  Banboo({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.elementId,
    required this.level,
    this.isFavorite = false,
  });

  factory Banboo.fromJson(Map<String, dynamic> json) {
    return Banboo(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      description: json['description'],
      elementId: json['elementId'],
      level: json['level'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}
