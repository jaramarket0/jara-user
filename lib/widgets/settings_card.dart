import 'package:flutter/material.dart';

class SettingsCard extends StatelessWidget {
  const SettingsCard({Key? key}) : super(key: key);

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
            _buildSettingItem(
              Icons.notifications_none,
              'Notifications',
              'On',
              onTap: () {
                // TODO: Implement notifications settings
              },
            ),
            const Divider(),
            _buildSettingItem(
              Icons.language,
              'Language',
              'English',
              onTap: () {
                // TODO: Implement language settings
              },
            ),
            const Divider(),
            _buildSettingItem(
              Icons.brightness_6,
              'Theme',
              'Light Mode',
              onTap: () {
                // TODO: Implement theme settings
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
      IconData icon,
      String label,
      String value, {
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
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.orange,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
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