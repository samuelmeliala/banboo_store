// lib/views/page/product/product_details.dart
import 'package:flutter/material.dart';
import 'package:banboo_store/models/banboo_model.dart';
import 'package:banboo_store/models/cart_item_model.dart';
import 'package:banboo_store/controller/services/cart_services.dart';

class ProductDetailPage extends StatefulWidget {
  final Banboo banboo;

  const ProductDetailPage({super.key, required this.banboo});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.banboo.name),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Container(
              height: 300,
              width: double.infinity,
              color: const Color(0xFFF7F8F9),
              child: widget.banboo.imageUrl != null
                  ? Image.network(
                      widget.banboo.imageUrl!,
                      fit: BoxFit.cover,
                    )
                  : const Icon(
                      Icons.image,
                      size: 100,
                      color: Colors.grey,
                    ),
            ),

            // Product details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.banboo.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${widget.banboo.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.banboo.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),

                  // Quantity selector
                  Row(
                    children: [
                      const Text(
                        'Quantity:',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: _decrementQuantity,
                            ),
                            Text(
                              quantity.toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: _incrementQuantity,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () async {
            try {
              await CartService.addToCart(
                CartItem(
                  banboo: widget.banboo,
                  quantity: quantity,
                ),
              );

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Added to cart successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error adding to cart: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
          child: const Text(
            'Add to Cart',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
