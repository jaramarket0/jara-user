import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/order_tracking_screen/controller/order_tracking_controller.dart';
import 'dart:convert';
import 'package:jara_market/services/api_service.dart';

OrderTrackingController controller = Get.put(OrderTrackingController());

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;

  const OrderTrackingScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  ApiService _apiService = ApiService(Duration(seconds: 60 * 5));
  Map<String, dynamic>? _trackingInfo;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchTrackingInfo();
  }

  Future<void> _fetchTrackingInfo() async {
    try {
      final response = await _apiService.trackOrder(widget.orderId);

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        setState(() {
          _trackingInfo = jsonDecode(response.body);
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load tracking info: ${response.statusCode}';
        });
        print(_errorMessage);
      }
    } catch (e) {
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
        title: const Text('Order Tracking'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _trackingInfo == null
                  ? const Center(child: Text('No tracking information available'))
                  : Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Carrier: ${_trackingInfo!['carrier']}'),
                          const SizedBox(height: 8),
                          Text('Tracking Number: ${_trackingInfo!['trackingNumber']}'),
                          const SizedBox(height: 8),
                          Text('Estimated Delivery: ${_trackingInfo!['estimatedDelivery']}'),
                          const SizedBox(height: 24),
                          if (_trackingInfo!.containsKey('timeline') && _trackingInfo!['timeline'] is List) ...[
                            const Text(
                              'Tracking Timeline',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: ListView.builder(
                                itemCount: (_trackingInfo!['timeline'] as List).length,
                                itemBuilder: (context, index) {
                                  final event = _trackingInfo!['timeline'][index];
                                  return ListTile(
                                    leading: Icon(
                                      event['completed'] ? Icons.check_circle : Icons.circle_outlined,
                                      color: event['completed'] ? Colors.green : Colors.grey,
                                    ),
                                    title: Text(event['status']),
                                    subtitle: Text(event['timestamp']),
                                  );
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
    );
  }
}