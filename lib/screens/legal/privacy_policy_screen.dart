import 'package:flutter/material.dart';
import '../../widgets/back_header.dart';
import '../../widgets/custom_button.dart';
import 'privacy_policy_content.dart';

/// Renders the privacy policy from [PrivacyPolicyContent].
///
/// The text is held as data rather than as a widget tree because the same
/// document is published on the website and in the vendor app. Generated into
/// all three from one source, so a legal document cannot end up saying
/// different things in different places.
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
                  Text(
                    'Effective ${PrivacyPolicyContent.effectiveDate} · '
                    'Updated ${PrivacyPolicyContent.lastUpdated}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    'Jurisdiction: ${PrivacyPolicyContent.jurisdiction}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
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
                    Text(
                      PrivacyPolicyContent.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    for (final section in PrivacyPolicyContent.sections) ...[
                      // Section 24 is the contact block. It is not in the
                      // generated list because its details come from
                      // configuration rather than from the document, so it is
                      // spliced in ahead of 25 to keep the numbering in order.
                      if (section.title.startsWith('25.')) ...[
                        _contactSection(),
                        const SizedBox(height: 20),
                      ],
                      _sectionTitle(section.title),
                      for (final block in section.blocks) _block(block),
                      const SizedBox(height: 20),
                    ],
                    const SizedBox(height: 8),
                    const Center(
                      child: Column(
                        children: [
                          Text('JARAMARKET',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                          SizedBox(height: 4),
                          Text('Market at Your Door.',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 12)),
                        ],
                      ),
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

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 10),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
            height: 1.3,
          ),
        ),
      );

  Widget _block(PolicyBlock block) {
    switch (block.kind) {
      case 'h3':
        return Padding(
          padding: const EdgeInsets.only(top: 14, bottom: 6),
          child: Text(
            block.text,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, height: 1.4),
          ),
        );
      case 'ul':
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final item in block.items) _bullet('•', item),
            ],
          ),
        );
      case 'ol':
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < block.items.length; i++)
                _bullet('${i + 1}.', block.items[i]),
            ],
          ),
        );
      default:
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            block.text,
            style: const TextStyle(fontSize: 14, height: 1.55),
          ),
        );
    }
  }

  /// Marker and text in a Row so wrapped lines align under the text rather
  /// than under the bullet.
  Widget _bullet(String marker, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 5, left: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 22,
              child: Text(marker,
                  style: const TextStyle(fontSize: 14, height: 1.55)),
            ),
            Expanded(
              child: Text(text,
                  style: const TextStyle(fontSize: 14, height: 1.55)),
            ),
          ],
        ),
      );

  /// Section 24. Rows with an empty value are skipped: an absent detail must
  /// disappear, never render as "[Insert support email]".
  Widget _contactSection() {
    final rows = PrivacyPolicyContent.contactRows
        .where((r) => r[1].trim().isNotEmpty)
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('24. CONTACT AND PRIVACY COMPLAINTS'),
        Text(PrivacyPolicyContent.contactIntro,
            style: const TextStyle(fontSize: 14, height: 1.55)),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final row in rows)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(row[0].toUpperCase(),
                          style: const TextStyle(
                              fontSize: 10,
                              letterSpacing: 0.6,
                              color: Colors.grey)),
                      const SizedBox(height: 2),
                      Text(row[1],
                          style: const TextStyle(fontSize: 13, height: 1.4)),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(PrivacyPolicyContent.contactOutro,
            style: const TextStyle(fontSize: 14, height: 1.55)),
      ],
    );
  }
}
