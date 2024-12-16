import 'package:flutter/material.dart';
import 'package:banboo_store/models/cart_item_model.dart';
import 'package:banboo_store/controller/services/cart_services.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    try {
      final items = await CartService.getCart();
      setState(() {
        cartItems = items;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading cart: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  double get totalPrice {
    return cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                await CartService.clearCart();
                _loadCart();
              },
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? const Center(
                  child: Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Dismissible(
                      key: Key(item.banboo.banbooId.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (direction) async {
                        await CartService.updateQuantity(
                            item.banboo.banbooId, 0);
                        _loadCart();
                      },
                      child: Card(
                        color: Colors.grey.shade300,
                        margin: const EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              // Product image
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7F8F9),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: item.banboo.imageUrl != null
                                    ? Image.network(
                                        item.banboo.imageUrl!,
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(
                                        Icons.image,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                              ),
                              const SizedBox(width: 16),
                              // Product details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.banboo.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${item.banboo.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Quantity controls
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () async {
                                      if (item.quantity > 1) {
                                        await CartService.updateQuantity(
                                          item.banboo.banbooId,
                                          item.quantity - 1,
                                        );
                                        _loadCart();
                                      }
                                    },
                                  ),
                                  Text(
                                    item.quantity.toString(),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () async {
                                      await CartService.updateQuantity(
                                        item.banboo.banbooId,
                                        item.quantity + 1,
                                      );
                                      _loadCart();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      bottomNavigationBar: cartItems.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '\$${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    onPressed: () {
                      //TODO: Implement Checkout
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Proceeding to checkout...'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Text(
                      'Checkout',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
