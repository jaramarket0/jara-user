import 'package:flutter/material.dart';
import '../../widgets/back_header.dart';
import '../../widgets/custom_button.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BackHeader(title: 'Privacy Policy'),
                  const Text(
                    'Last updated on 5/12/2022',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Divider(height: 32),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildClause(
                      'Welcome to JaraMarket!',
                      'We value your privacy. This Privacy Policy outlines how we gather, utilize, disclose, and safeguard your personal information when you engage with our platform and services. By using JaraMarket, you consent to the terms of this policy.',
                    ),
                    const SizedBox(height: 24),
                    _buildClause(
                      '1. Information We Collect',
                      'We gather various types of information to enhance our services, including:',
                    ),
                    const SizedBox(height: 16),
                    _buildClause(
                      'a. Personal Information',
                      'When you register, place an order, or interact with our services, we may collect:\n\n- Name\n- Email address\n- Phone number\n- Delivery address\n- Payment details (processed securely through third-party providers)',
                    ),
                    const SizedBox(height: 16),
                    _buildClause(
                      'b. Usage and Device Information',
                      'We may collect:\n\n- IP address\n- Browser type\n- Device information\n- Location data (with your permission)\n- Usage patterns and interactions with our platform',
                    ),
                    const SizedBox(height: 16),
                    _buildClause(
                      'c. Transactional Information',
                      '- Order details\n- Payment history\n- Communication records with customer support',
                    ),
                    const SizedBox(height: 24),
                    _buildClause(
                      '2. How We Use Your Information',
                      'We utilize the information collected to:\n\n- Process orders and deliver food ingredients to you\n- Provide customer support and respond to inquiries\n- Enhance our services and user experience\n- Send promotional offers, updates, and notifications (you can opt-out anytime)\n- Prevent fraud and ensure the security of our platform\n- Comply with legal obligations',
                    ),
                    const SizedBox(height: 24),
                    _buildClause(
                      '3. How We Share Your Information',
                      'We do not sell or rent your personal information. However, we may share your data with:\n\n- Delivery Partners: To facilitate order deliveries via Ryda dispatch.\n- Payment Providers: To process secure transactions.\n- Service Providers: For analytics, marketing, and customer support.\n- Legal Authorities: If required by law or to protect our rights and users.',
                    ),
                    const SizedBox(height: 24),
                    _buildClause(
                      '4. Data Security',
                      'We take reasonable steps to protect your personal information from unauthorized access, loss, or misuse. However, no system is completely secure, so we encourage you to use strong passwords and be cautious when sharing your account details.',
                    ),
                    const SizedBox(height: 24),
                    _buildClause(
                      '5. Your Rights and Choices',
                      'You have the right to:\n\n- Access, update, or delete your personal information.\n- Opt out of marketing communications.\n- Disable location tracking through your device settings.\n- Request a copy of your data by reaching out to us.',
                    ),
                    const SizedBox(height: 24),
                    _buildClause(
                      '6. Cookies and Tracking Technologies',
                      'JaraMarket utilizes cookies and similar tracking technologies to improve your experience. You can adjust your cookie preferences through your browser settings.',
                    ),
                    const SizedBox(height: 24),
                    _buildClause(
                      '7. Third-Party Links',
                      'Our platform may include links to external websites. We are not responsible for their privacy practices, so we recommend reviewing their policies before engaging with them.',
                    ),
                    const SizedBox(height: 24),
                    _buildClause(
                      '8. Updates to This Policy',
                      'We may revise this Privacy Policy periodically. Any changes will be posted on this page, and we may inform you via email or app notifications. Your continued use of JaraMarket indicates your acceptance of the updated policy.',
                    ),
                    const SizedBox(height: 24),
                    _buildClause(
                      '9. Contact Us',
                      'If you have any questions or concerns regarding this Privacy Policy, please reach out to us at:\n\nJaraMarket Customer Support\n[Your Contact Email]\n[Your Business Address]\n[Your Phone Number]',
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomButton(
                text: 'Accept',
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClause(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}