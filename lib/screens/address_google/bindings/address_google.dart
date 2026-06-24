import 'package:get/get.dart';
import 'package:jara_market/screens/address_google/controller/address_google.dart';


class CheckoutAddressChangeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddressGoogleChangeController());
  }
}