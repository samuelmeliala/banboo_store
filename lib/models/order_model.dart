class Order {
  final int orderId;
  final int userId;
  final int banbooId;
  final int quantity;
  final double totalPrice;
  final DateTime orderDate;
  final String status;
  final String banbooName; // Including banboo details
  final String? banbooImage;

  Order({
    required this.orderId,
    required this.userId,
    required this.banbooId,
    required this.quantity,
    required this.totalPrice,
    required this.orderDate,
    required this.status,
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
      status: json['status'],
      banbooName:
          json['name'], // Assuming this comes from the JOIN with banboo table
      banbooImage: json['imageUrl'],
    );
  }
}
