import 'package:flutter/material.dart';

/// How the user is shopping for a food.
///
/// Carried from here into the CartItem and sent as `shopping_type` on each
/// product line at checkout. The backend prices a corporate line from the
/// customer's own per-ingredient prices (floored at `corporate_min_price`)
/// instead of the recipe, so this choice changes what they pay.
enum ShoppingType { individual, corporate }

extension ShoppingTypeLabel on ShoppingType {
  String get label =>
      this == ShoppingType.individual ? 'Individual' : 'Corporate';

  String get description => this == ShoppingType.individual
      ? 'Everyday shopping for yourself, your home or a small gathering.'
      : 'Bulk buying for restaurants, hotels, caterers and offices.';

  /// The one-line difference that actually decides the choice.
  String get priceNote => this == ShoppingType.individual
      ? 'Our standard prices'
      : 'Set your own price per ingredient';

  IconData get icon => this == ShoppingType.individual
      ? Icons.person_outline_rounded
      : Icons.business_rounded;

  Color get color => this == ShoppingType.individual
      ? const Color(0xFFFF9800)
      : const Color(0xFF2D4A66);
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
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'How are you shopping?',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                  color: Color(0xff111827),
                ),
              ),
              const SizedBox(height: 6),
              // The food name carries the weight -- it's the thing they just
              // tapped, so it anchors the question.
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontFamily: 'Inter',
                    height: 1.4,
                    color: Color(0xff6B7280),
                  ),
                  children: [
                    const TextSpan(text: 'This changes how '),
                    TextSpan(
                      text: foodName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, color: Color(0xff374151)),
                    ),
                    const TextSpan(text: ' is priced.'),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              for (int i = 0; i < ShoppingType.values.length; i++) ...[
                _ShoppingTypeOption(
                  type: ShoppingType.values[i],
                  onTap: () =>
                      Navigator.of(sheetContext).pop(ShoppingType.values[i]),
                ),
                if (i < ShoppingType.values.length - 1)
                  const SizedBox(height: 12),
              ],
              const SizedBox(height: 18),
              Center(
                child: Text(
                  'You can change this later in your cart.',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Inter',
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
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
    // Cards stay neutral: tinting the whole card in two different hues made
    // the sheet look like two unrelated brands. Colour is carried only by
    // the icon chip and the price note, so the eye reads the words first.
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: type.color.withValues(alpha: 0.08),
        highlightColor: type.color.withValues(alpha: 0.04),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: type.color.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(type.icon, color: type.color, size: 23),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type.label,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                          color: Color(0xff111827),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        type.description,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontFamily: 'Inter',
                          height: 1.4,
                          color: Color(0xff6B7280),
                        ),
                      ),
                      const SizedBox(height: 9),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: type.color.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          type.priceNote,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            color: type.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: Icon(Icons.chevron_right_rounded,
                      size: 22, color: Colors.grey.shade400),
                ),
              ],
            ),
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
