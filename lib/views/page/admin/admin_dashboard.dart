import 'package:banboo_store/controller/services/api.dart';
import 'package:banboo_store/views/page/admin/add_banboo_page.dart';
import 'package:banboo_store/views/page/admin/edit_banboo_page.dart';
import 'package:flutter/material.dart';
import 'package:banboo_store/models/banboo_model.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<Banboo> banboos = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadBanboos();
  }

  Future<void> _loadBanboos() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final List<Banboo> loadedBanboos = await fetchBanboos();
      if (mounted) {
        setState(() {
          banboos = loadedBanboos;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading banboos: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Banboo Store Admin',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              // Wait for the result from AddBanbooPage
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddBanbooPage(),
                ),
              );

              // If result is true (success), reload the banboos
              if (result == true) {
                _loadBanboos();
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadBanboos,
              child: ListView.builder(
                itemCount: banboos.length,
                itemBuilder: (context, index) {
                  final banboo = banboos[index];
                  return ListTile(
                    title: Text(banboo.name),
                    subtitle: Text('\$${banboo.price.toStringAsFixed(2)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            // Wait for the result from EditBanbooPage
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditBanbooPage(banboo: banboo),
                              ),
                            );

                            // If result is true (success), reload the banboos
                            if (result == true) {
                              _loadBanboos();
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Banboo'),
                                content: Text(
                                    'Are you sure you want to delete ${banboo.name}?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      try {
                                        await deleteBanboo(banboo.banbooId);
                                        if (mounted) {
                                          Navigator.pop(context);
                                          _loadBanboos(); // Reload after deletion
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Banboo deleted successfully'),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        if (mounted) {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Error deleting banboo: ${e.toString()}'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
