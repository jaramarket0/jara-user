import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:jara_market/screens/grains_detailed_screen/controller/grains_detailed_controller.dart';

GrainsDetailedController controller = Get.put(GrainsDetailedController());

class GrainsDetailedScreen extends StatefulWidget {
  const GrainsDetailedScreen({super.key});

  @override
  State<GrainsDetailedScreen> createState() => _GrainsDetailedScreenState();
}

class _GrainsDetailedScreenState extends State<GrainsDetailedScreen> {
  String _selectedMeasurement = 'Half Bag';
  final List<String> _measurementsRow1 = ['Cup', 'Quarter Bag'];
  final List<String> _measurementsRow2 = ['Half Bag', 'One Bag'];
  int _quantity = 1;
  bool _shopWithYourPrice = false;
  final TextEditingController _priceController = TextEditingController();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 4) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Rice',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
            onPressed: () {
              // TODO: Implement cart navigation
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              child: PageView.builder(
                controller: _pageController,
                itemCount: 5,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return Image.asset(
                    'assets/images/image${index + 1}.jpg',
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Container(
                  margin: const EdgeInsets.all(4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _currentPage == index ? Colors.blue : Colors.grey[300],
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            const Text(
              'Rice',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Premium quality rice, perfect for your daily meals.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Row(
              children: _measurementsRow1.map((measurement) {
                final isSelected = measurement == _selectedMeasurement;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ElevatedButton(
                    onPressed: _shopWithYourPrice
                        ? null
                        : () {
                            setState(() {
                              _selectedMeasurement = measurement;
                            });
                          },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: isSelected ? Colors.white : Colors.black,
                      backgroundColor:
                          isSelected ? Colors.orange : Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(measurement),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            Row(
              children: _measurementsRow2.map((measurement) {
                final isSelected = measurement == _selectedMeasurement;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ElevatedButton(
                    onPressed: _shopWithYourPrice
                        ? null
                        : () {
                            setState(() {
                              _selectedMeasurement = measurement;
                            });
                          },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: isSelected ? Colors.white : Colors.black,
                      backgroundColor:
                          isSelected ? Colors.orange : Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(measurement),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: _shopWithYourPrice
                      ? null
                      : () {
                          setState(() {
                            _quantity = (_quantity - 1).clamp(1, 99);
                          });
                        },
                  color: _shopWithYourPrice ? Colors.grey : Colors.black,
                ),
                Text(
                  _quantity.toString(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: _shopWithYourPrice
                      ? null
                      : () {
                          setState(() {
                            _quantity = (_quantity + 1).clamp(1, 99);
                          });
                        },
                  color: _shopWithYourPrice ? Colors.grey : Colors.black,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _shopWithYourPrice,
                  onChanged: (value) {
                    setState(() {
                      _shopWithYourPrice = value ?? false;
                    });
                  },
                  activeColor: Colors.orange,
                ),
                const Text(
                  'Shop with your price',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              enabled: _shopWithYourPrice,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter your price',
                filled: true,
                fillColor: _shopWithYourPrice ? Colors.white : Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement add to cart functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Add to Cart',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Service Cost',
                  style: TextStyle(color: Colors.grey),
                ),
                Text('N18.00'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'N85,000',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement checkout functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Checkout',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
