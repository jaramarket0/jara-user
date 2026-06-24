import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum UserContext {
  customer,
  vendor,
  general,
}

class WhatsAppService {
  static const String _phoneNumber = '2348001234567'; // Replace with actual number
  
  static String _getMessageTemplate(UserContext context) {
    switch (context) {
      case UserContext.customer:
        return 'Hello JaraMarket Support, I am a customer and I need help with: ';
      case UserContext.vendor:
        return 'Hello JaraMarket Support, I am a vendor and I need help with: ';
      case UserContext.general:
      default:
        return 'Hello JaraMarket Support, I need help with: ';
    }
  }

  static Future<void> openWhatsApp(BuildContext context, {
    UserContext userContext = UserContext.general,
    String? customMessage,
  }) async {
    final message = customMessage ?? _getMessageTemplate(userContext);
    final encodedMessage = Uri.encodeComponent(message);
    final whatsappUrl = 'https://wa.me/$_phoneNumber?text=$encodedMessage';
    
    final uri = Uri.parse(whatsappUrl);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Show error dialog if WhatsApp can't be launched
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('WhatsApp is not installed on your device or could not be opened.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }
}