class Banboo {
  final int banbooId;
  final String name;
  final double price;
  final String description;
  final int elementId;
  final int level;
  final String? imageUrl;
  bool isFavorite;

  Banboo({
    required this.banbooId,
    required this.name,
    required this.price,
    required this.description,
    required this.elementId,
    required this.level,
    this.imageUrl,
    this.isFavorite = false,
  });

  factory Banboo.fromJson(Map<String, dynamic> json) {
    return Banboo(
      banbooId: json['banbooId'],
      name: json['name'],
      price: json['price'].toDouble(),
      description: json['description'],
      elementId: json['elementId'],
      level: json['level'],
      imageUrl: json['imageUrl'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'banbooId': banbooId,
      'name': name,
      'price': price,
      'description': description,
      'elementId': elementId,
      'level': level,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
    };
  }
}

// Element types enum for better type safety
enum BanbooElement {
  fire,
  water,
  earth,
  air,
  // Add more elements as needed
}
