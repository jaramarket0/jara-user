import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:jara_market/screens/user_orders_screen/controller/user_orders_controller.dart';

UserOrdersController controller = Get.put(UserOrdersController());

class UserOrdersScreen extends StatefulWidget {
  final String userId;

  const UserOrdersScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<UserOrdersScreen> createState() => _UserOrdersScreenState();
}

class _UserOrdersScreenState extends State<UserOrdersScreen> {
  List<dynamic>? _orders;

  @override
  void initState() {
    super.initState();
    _fetchUserOrders();
  }

  Future<void> _fetchUserOrders() async {
    final response = await http.get(Uri.parse(
        'https://ryda.com.ng/api/users/${widget.userId}/orders'));

    if (response.statusCode == 200) {
      setState(() {
        _orders = jsonDecode(response.body);
      });
    } else {
      print('Failed to load user orders');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Orders'),
      ),
      body: _orders == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _orders!.length,
              itemBuilder: (context, index) {
                final order = _orders![index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order ID: ${order['_id']}'),
                        const SizedBox(height: 8),
                        Text('Total: ${order['total']}'),
                        const SizedBox(height: 8),
                        Text('Date: ${order['date']}'),
                        const SizedBox(height: 8),
                        Text('Status: ${order['status']}'),
                        const SizedBox(height: 16),
                        const Text('Items:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        ...order['items'].map<Widget>((item) {
                          return ListTile(
                            title: Text('Product ID: ${item['productId']}'),
                            subtitle: Text(
                                'Quantity: ${item['quantity']} - Price: ${item['price']}'),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
