import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:jara_market/screens/order_receipt_screen/controller/order_receipt_controller.dart';

OrderReceiptController controller = Get.put(OrderReceiptController());

class OrderReceiptScreen extends StatefulWidget {
  final String orderId;

  const OrderReceiptScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  State<OrderReceiptScreen> createState() => _OrderReceiptScreenState();
}

class _OrderReceiptScreenState extends State<OrderReceiptScreen> {
  Map<String, dynamic>? _order;

  @override
  void initState() {
    super.initState();
    _fetchOrderReceipt();
  }

  Future<void> _fetchOrderReceipt() async {
    final response = await http.get(Uri.parse(
        'https://ryda.com.ng/api/orders/${widget.orderId}/receipt'));

    if (response.statusCode == 200) {
      setState(() {
        _order = jsonDecode(response.body);
      });
    } else {
      print('Failed to load order receipt');
    }
  }

  Future<void> _cancelOrder() async {
    final response = await http.post(Uri.parse(
        'https://ryda.com.ng/api/orders/${widget.orderId}/cancel'));

    if (response.statusCode == 200) {
      setState(() {
        _order!['status'] = 'cancelled';
      });
      print('Order cancelled successfully');
    } else {
      print('Failed to cancel order');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Receipt'),
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
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        _order!['status'] == 'active' ? _cancelOrder : null,
                    child: const Text('Cancel Order'),
                  ),
                ],
              ),
            ),
    );
  }
}
