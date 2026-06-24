import 'package:flutter/material.dart';

class AdditionalOptionsCard extends StatelessWidget {
  const AdditionalOptionsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildOptionItem(
              Icons.security,
              'Security',
              onTap: () {
                // TODO: Implement security settings
              },
            ),
            const Divider(),
            _buildOptionItem(
              Icons.help_outline,
              'Help & Support',
              onTap: () {
                // TODO: Implement help & support
              },
            ),
            const Divider(),
            _buildOptionItem(
              Icons.contact_support_outlined,
              'Contact Us',
              onTap: () {
                // TODO: Implement contact us
              },
            ),
            const Divider(),
            _buildOptionItem(
              Icons.privacy_tip_outlined,
              'Privacy Policy',
              onTap: () {
                // TODO: Implement privacy policy
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem(
      IconData icon,
      String label, {
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.black, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}