import 'package:get/get.dart';
import 'package:jara_market/screens/wallet_screen/controller/wallet_controller.dart';
import 'package:jara_market/screens/wallet_screen/wallet_screen.dart';

class WalletBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=> WalletController());
  }
}