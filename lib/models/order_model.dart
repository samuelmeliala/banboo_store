class Order {
  final int orderId;
  final int userId;
  final int banbooId;
  final int quantity;
  final double totalPrice;
  final DateTime orderDate;
  final String status;
  final String banbooName;
  final String? banbooImage;

  Order({
    required this.orderId,
    required this.userId,
    required this.banbooId,
    required this.quantity,
    required this.totalPrice,
    required this.orderDate,
    this.status = 'success',
    required this.banbooName,
    this.banbooImage,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'],
      userId: json['userId'],
      banbooId: json['banbooId'],
      quantity: json['quantity'],
      totalPrice: double.parse(json['totalPrice'].toString()),
      orderDate: DateTime.parse(json['orderDate']),
      status: json['status'] ?? 'success',
      banbooName: json['name'],
      banbooImage: json['imageUrl'],
    );
  }
}
