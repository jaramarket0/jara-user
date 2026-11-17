import 'package:flutter/material.dart';

/// How the user is shopping for a food. UI-only for now: it is carried to the
/// food detail screen as a tag but not yet sent to the backend.
enum ShoppingType { individual, corporate }

extension ShoppingTypeLabel on ShoppingType {
  String get label =>
      this == ShoppingType.individual ? 'Individual' : 'Corporate';

  String get description => this == ShoppingType.individual
      ? 'For personal or family shopping — cooking for yourself, your home or a small gathering.'
      : 'For businesses — restaurants, hotels, caterers, offices and other bulk buyers.';

  IconData get icon => this == ShoppingType.individual
      ? Icons.person_outline_rounded
      : Icons.business_rounded;

  Color get color => this == ShoppingType.individual
      ? const Color(0xFFFF9800)
      : const Color(0xFF3F51B5);
}

/// Asks the user whether they are shopping as an individual or a business.
/// Returns null if the sheet is dismissed without a choice.
Future<ShoppingType?> showShoppingTypeSheet(
    BuildContext context, String foodName) {
  return showModalBottomSheet<ShoppingType>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'How are you shopping?',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  color: Color(0xff1F2937),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Choose an option to continue with $foodName.',
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'Inter',
                  color: Color(0xff6B7280),
                ),
              ),
              const SizedBox(height: 20),
              for (final type in ShoppingType.values) ...[
                _ShoppingTypeOption(
                  type: type,
                  onTap: () => Navigator.of(sheetContext).pop(type),
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      );
    },
  );
}

class _ShoppingTypeOption extends StatelessWidget {
  final ShoppingType type;
  final VoidCallback onTap;

  const _ShoppingTypeOption({required this.type, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: type.color.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: type.color.withValues(alpha: 0.35)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: type.color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(type.icon, color: type.color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${type.label} Shopping',
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        color: Color(0xff1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      type.description,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'Inter',
                        height: 1.35,
                        color: Color(0xff6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios, size: 14, color: type.color),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small pill showing which shopping type the user picked.
class ShoppingTypeTag extends StatelessWidget {
  final ShoppingType type;

  const ShoppingTypeTag({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: type.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: type.color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(type.icon, size: 14, color: type.color),
          const SizedBox(width: 4),
          Text(
            type.label,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              color: type.color,
            ),
          ),
        ],
      ),
    );
  }
}
