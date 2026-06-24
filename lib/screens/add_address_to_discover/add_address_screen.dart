import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/address_google/address_google.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.mapPinHouse,
              size: 120,
              color: Colors.orange[400],
            ),
            SizedBox(
              width: 300,
              child: Text(
                textAlign: TextAlign.center,
                'Add your address to discover nearby stores and products!',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Get.to(() => AddressGoogleChangeScreen()),
              child: Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  'Choose delivery address',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.orange[400]),
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     Get.offAllNamed('/add_address_screen');
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.grey[200],
                //     padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //   ),
                //   child: Text(
                //     'Add Address',
                //     style: TextStyle(
                //       fontFamily: 'Poppins',
                //       fontSize: 16,
                //       fontWeight: FontWeight.w600,
                //       color: Colors.white,
                //     ),
                //   ),
                // ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
