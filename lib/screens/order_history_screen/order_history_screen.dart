import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/order_history_screen/controller/order_history_controller.dart';
import 'dart:convert';
import 'package:jara_market/services/api_service.dart';
// import 'package:jara_market/widgets/custom_bottom_nav.dart';
import '../order_details_screen/order_details_screen.dart';

OrderHistoryController controller = Get.put(OrderHistoryController());

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  ApiService _apiService = ApiService(Duration(seconds: 60 * 5));
  bool _isLoading = true;
  List<dynamic> _orders = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      final response = await _apiService.getOrders();

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _orders = jsonDecode(response.body);
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load orders: ${response.statusCode}';
        });
        print(_errorMessage);
      }
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack Trace: $stackTrace');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: $e';
      });
      print(_errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _orders.isEmpty
                  ? const Center(child: Text('No orders found'))
                  : ListView.builder(
                      itemCount: _orders.length,
                      itemBuilder: (context, index) {
                        final order = _orders[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: ListTile(
                            title: Text('Order #${order['id']}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Date: ${order['date']}'),
                                Text('Status: ${order['status']}'),
                              ],
                            ),
                            trailing: Text('${order['amount']}'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      OrderDetailsScreen(orderId: order['id']),
                                ),
                              ).then((_) =>
                                  _fetchOrders()); // Refresh after returning
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}
