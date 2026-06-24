import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/whatsapp_service.dart';

class FloatingWhatsAppButton extends StatelessWidget {
  final UserContext userContext;
  final String? customMessage;

  const FloatingWhatsAppButton({
    Key? key,
    this.userContext = UserContext.general,
    this.customMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: FloatingActionButton(
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
      ),
    );
  }
}