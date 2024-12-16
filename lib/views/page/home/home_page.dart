import 'package:banboo_store/controller/services/api.dart';
import 'package:banboo_store/controller/services/cart_services.dart';
import 'package:banboo_store/controller/utils/session_manager.dart';
import 'package:banboo_store/models/banboo_model.dart';
import 'package:banboo_store/views/page/cart/cart_page.dart';
import 'package:banboo_store/views/page/product/product_details.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int cartItemCount = 0;
  String username = 'User';
  List<Banboo> banboos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadBanboos(),
      _loadCartItemCount(),
    ]);
  }

  Future<void> _onRefresh() async {
    // Show loading indicator
    setState(() {
      isLoading = true;
    });

    try {
      await _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error refreshing: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _loadCartItemCount() async {
    final cart = await CartService.getCart();
    setState(() {
      cartItemCount = cart.length;
    });
  }

  Future<void> _loadBanboos() async {
    try {
      final fetchedBanboos = await fetchBanboos();
      setState(() {
        banboos = fetchedBanboos;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading banboos: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadUsername() async {
    String? savedUsername = await SessionManager.getUsername();
    if (savedUsername != null) {
      setState(() {
        username = savedUsername;
      });
    }
  }

  final TextEditingController _searchController = TextEditingController();

  // // Dummy data for products
  // final List<Map<String, dynamic>> products = [
  //   {
  //     'id': 1,
  //     'name': 'Fire Banboo',
  //     'price': 29.99,
  //     'description':
  //         'A powerful fire element banboo that helps in emergency fire situations.',
  //     'isFavorite': false,
  //     'image': 'assets/fire_banboo.png',
  //   },
  //   // Add more products as needed
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Hello, $username',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_cart,
                  color: Colors.black,
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartPage()),
                  );
                  //Refresh cart count when returning from cart page
                  _loadCartItemCount();
                },
              ),
              if (cartItemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$cartItemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search Banboo...',
                  prefixIcon: const Icon(Icons.search),
                  fillColor: const Color(0xFFF7F8F9),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Carousel for featured products
            CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                autoPlay: true,
                enlargeCenterPage: true,
              ),
              items: [1, 2, 3].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF686D76),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Featured Banboo $i',
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),

            // Products Grid
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : banboos.isEmpty
                      ? const Center(child: Text('No banboos available'))
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: banboos.length,
                          itemBuilder: (context, index) {
                            final banboo = banboos[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductDetailPage(banboo: banboo),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Product Image
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF7F8F9),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: banboo.imageUrl != null
                                              ? Image.network(
                                                  banboo.imageUrl!,
                                                  fit: BoxFit.cover,
                                                )
                                              : Icon(
                                                  Icons.image,
                                                  size: 50,
                                                  color: Colors.grey[400],
                                                ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  banboo.name,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  banboo.isFavorite
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: banboo.isFavorite
                                                      ? Colors.red
                                                      : Colors.grey,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    banboo.isFavorite =
                                                        !banboo.isFavorite;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '\$${banboo.price.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
