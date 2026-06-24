import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:jara_market/screens/order_summary_screen/controller/order_summary_controller.dart';

OrderSummaryController controller = Get.put(OrderSummaryController());

class OrderSummaryScreen extends StatefulWidget {
  final String orderId;

  const OrderSummaryScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  Map<String, dynamic>? _order;

  @override
  void initState() {
    super.initState();
    _fetchOrderSummary();
  }

  Future<void> _fetchOrderSummary() async {
    final response = await http.get(Uri.parse(
        'https://ryda.com.ng/api/orders/${widget.orderId}'));

    if (response.statusCode == 200) {
      setState(() {
        _order = jsonDecode(response.body);
      });
    } else {
      print('Failed to load order summary');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary'),
      ),
      body: _order == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order ID: ${_order!['_id']}'),
                  const SizedBox(height: 8),
                  Text('User ID: ${_order!['userId']}'),
                  const SizedBox(height: 8),
                  Text('Total: ${_order!['total']}'),
                  const SizedBox(height: 8),
                  Text('Date: ${_order!['date']}'),
                  const SizedBox(height: 8),
                  Text('Status: ${_order!['status']}'),
                  const SizedBox(height: 16),
                  const Text('Items:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ..._order!['items'].map<Widget>((item) {
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
  }
}
