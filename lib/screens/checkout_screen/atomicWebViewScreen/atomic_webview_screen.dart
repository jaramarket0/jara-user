import 'package:atomic_webview/atomic_webview.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/config/routes.dart';
import 'package:jara_market/screens/wallet_screen/controller/wallet_controller.dart';
//import 'package:jara_market/screens/wallet_screen/controller/wallet_controller.dart';

WalletController walletController = Get.put(WalletController());

class AtomicWebViewScreen extends StatefulWidget {
  AtomicWebViewScreen({super.key, this.url = ''});

  final String? url;

  @override
  State<AtomicWebViewScreen> createState() => _AtomicWebViewScreenState();
}

class _AtomicWebViewScreenState extends State<AtomicWebViewScreen> {
  WebViewController webViewController = WebViewController();
  InAppWebViewController? webViewController1;
  final String callback_url = "http://127.0.0.1:8000";

  /// The callback URL can settle more than once; without this the success
  /// dialog stacks on itself.
  bool _handledSuccess = false;

  void _showFundingSuccess() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 24),
            SizedBox(width: 8),
            Text('Wallet funded', style: TextStyle(fontSize: 18)),
          ],
        ),
        content: const Text(
          'Your wallet has been topped up successfully. You can carry on '
          'shopping right away.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.offAllNamed(AppRoutes.walletScreen);
            },
            child: const Text('View wallet'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // offAll, not until: nothing in the funding stack is worth
              // going back to.
              Get.offAllNamed(AppRoutes.mainScreen);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFAA00),
              foregroundColor: Colors.white,
            ),
            child: const Text('Continue shopping'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   var url = widget.url ?? '';

    //   Loggerr.log("Paystack URL in webview page: $url");

    //   webViewController.init(
    //     context: context,
    //     setState: setState,
    //     uri: Uri.parse(url),
    //   );
    // });
  }

  final GlobalKey webViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).canPop()
                    ? Navigator.pop(context)
                    : Navigator.of(context).pushNamed(AppRoutes.mainScreen);
              },
              icon: Icon(Icons.chevron_left_rounded)),
          title: Text("Pay with Paystack",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 14))),
      body: InAppWebView(
        key: webViewKey,
        initialUrlRequest: URLRequest(url: WebUri(widget.url ?? '')),
        onWebViewCreated: (controller) {
          webViewController1 = controller;
        },
        onLoadStop: (controller, url) {
          print("Loaded URL: $url");
          if (url.toString().startsWith(callback_url)) {
            // Funded. Popping back up the stack lands the customer in the
            // funding flow they just finished, which reads as "it didn't
            // work" -- so offer an explicit way onward instead.
            if (_handledSuccess) return;   // onLoadStop can fire more than once
            _handledSuccess = true;
            walletController.fetchWallet();
            walletController.fetchTransactions();
            _showFundingSuccess();
          }
        },
      ),
    );

    // return WebView(
    //   controller: webViewController,
    // );
  }
}
