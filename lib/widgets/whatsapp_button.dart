import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/whatsapp_service.dart';

class WhatsAppButton extends StatelessWidget {
  final UserContext userContext;
  final String? customMessage;
  final bool isFloating;
  final String? label;

  const WhatsAppButton({
    Key? key,
    this.userContext = UserContext.general,
    this.customMessage,
    this.isFloating = false,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isFloating) {
      return FloatingActionButton(
        onPressed: () => WhatsAppService.openWhatsApp(
          context,
          userContext: userContext,
          customMessage: customMessage,
        ),
        backgroundColor: const Color(0xFF25D366),
        child: const FaIcon(
          FontAwesomeIcons.whatsapp,
          color: Colors.white,
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: () => WhatsAppService.openWhatsApp(
        context,
        userContext: userContext,
        customMessage: customMessage,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF25D366),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      icon: const FaIcon(FontAwesomeIcons.whatsapp),
      label: Text(
        label ?? 'WhatsApp Support',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}