import 'package:banboo_store/controller/services/api.dart';
import 'package:banboo_store/controller/utils/session_manager.dart';
import 'package:banboo_store/models/banboo_model.dart';
import 'package:banboo_store/views/page/product/product_details.dart';
import 'package:banboo_store/views/widgets/image_carousel.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int cartItemCount = 0;
  String username = 'User';
  List<Banboo> banboos = [];
  List<Banboo> searchBanboo = [];
  bool isLoading = true;
  String _error = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _loadAllBanboos();
    _loadData();
  }

  Future<void> _loadAllBanboos() async {
    setState(() {
      isLoading = true;
      _error = '';
    });

    try {
      var banboos = await fetchBanboos();
      setState(() {
        banboos = banboos;
        searchBanboo = banboos; // Initially show all banboos
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load banboos: $e';
        isLoading = false;
      });
    }
  }

  void _filterBanboos(String query) {
    setState(() {
      if (query.isEmpty) {
        searchBanboo = banboos;
      } else {
        searchBanboo = banboos
            .where((banboo) =>
                banboo.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadBanboos(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Hello, $username!',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterBanboos,
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
            ),

            // Carousel (when not searching)
            if (_searchController.text.isEmpty)
              const SliverToBoxAdapter(
                child: CarouselImage(),
              ),

            // Error Message
            if (_error.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _error,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),

            // Loading Indicator
            if (isLoading)
              const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),

            // Products Grid
            if (!isLoading)
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: searchBanboo.isEmpty
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: Text(
                            _searchController.text.isEmpty
                                ? 'No banboos available'
                                : 'No banboos found for "${_searchController.text}"',
                          ),
                        ),
                      )
                    : SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final banboo = searchBanboo[index];
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
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF7F8F9),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: banboo.imageUrl != null
                                              ? Image.network(banboo.imageUrl!)
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
                          childCount: searchBanboo.length,
                        ),
                      ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
