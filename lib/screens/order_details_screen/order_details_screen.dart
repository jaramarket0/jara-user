import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/order_details_screen/controller/order_details_controller.dart';
import 'dart:convert';
import 'package:jara_market/services/api_service.dart';
import '../order_tracking_screen/order_tracking_screen.dart';

OrderDetailsController controller = Get.put(OrderDetailsController());

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailsScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  ApiService _apiService = ApiService(Duration(seconds: 60 * 5));
  late Future<Map<String, dynamic>> _orderDetails;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _orderDetails = fetchOrderDetails(widget.orderId);
  }

  Future<Map<String, dynamic>> fetchOrderDetails(String orderId) async {
    try {
      final response = await _apiService.getOrder(orderId);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load order details: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack Trace: $stackTrace');
      throw Exception('Error: $e');
    }
  }

  Future<void> _cancelOrder() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiService.cancelOrder(widget.orderId);

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order cancelled successfully')),
        );
        // Refresh order details
        setState(() {
          _orderDetails = fetchOrderDetails(widget.orderId);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to cancel order: ${response.body}')),
        );
      }
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack Trace: $stackTrace');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _viewReceipt() async {
    try {
      final response = await _apiService.getOrderReceipt(widget.orderId);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final receiptData = jsonDecode(response.body);
        // Navigate to receipt screen or show receipt dialog
        _showReceiptDialog(receiptData);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load receipt: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showReceiptDialog(Map<String, dynamic> receiptData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Order Receipt'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Order ID: ${receiptData['orderId']}'),
              Text('Date: ${receiptData['date']}'),
              Text('Total: ${receiptData['total']}'),
              const Divider(),
              const Text('Items:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...List.generate(
                receiptData['items']?.length ?? 0,
                (index) => Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(receiptData['items'][index]['name']),
                      Text(
                          '${receiptData['items'][index]['quantity']} x ${receiptData['items'][index]['price']}'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              // Implement print functionality
              Navigator.pop(context);
            },
            child: const Text('Print'),
          ),
        ],
      ),
    );
  }

  Future<void> _trackOrder() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderTrackingScreen(orderId: widget.orderId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<Map<String, dynamic>>(
              future: _orderDetails,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('No data found'));
                } else {
                  final order = snapshot.data!;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${order['id']}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Status: ${order['status']}'),
                        Text('Date: ${order['date']}'),
                        Text('Total Amount: ${order['amount']}'),
                        const SizedBox(height: 24),
                        const Text(
                          'Items',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: order['items']?.length ?? 0,
                          itemBuilder: (context, index) {
                            final item = order['items'][index];
                            return ListTile(
                              title: Text(item['name']),
                              subtitle: Text('Quantity: ${item['quantity']}'),
                              trailing: Text('${item['price']}'),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: order['status'] == 'pending'
                                  ? _cancelOrder
                                  : null,
                              child: const Text('Cancel Order'),
                            ),
                            ElevatedButton(
                              onPressed: _viewReceipt,
                              child: const Text('View Receipt'),
                            ),
                            ElevatedButton(
                              onPressed: _trackOrder,
                              child: const Text('Track Order'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
    );
  }
}
