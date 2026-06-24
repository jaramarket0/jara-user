import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../models/faq_model.dart';

class FaqCategorySection extends StatelessWidget {
  final FaqCategory category;
  final Function(int, bool) onExpand;

  const FaqCategorySection({
    Key? key,
    required this.category,
    required this.onExpand,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            category.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...List.generate(category.items.length, (index) {
          final item = category.items[index];
          return Card(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            elevation: 1,
            child: ExpansionTile(
              trailing: item.isExpanded ? SvgPicture.asset('assets/images/trailing1.svg') : SvgPicture.asset('assets/images/trailing.svg'),
              title: Text(
                item.question,
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Roboto',
                  fontSize: 14,
                ),
              ),
              initiallyExpanded: item.isExpanded,
              onExpansionChanged: (expanded) {
                onExpand(index, expanded);
              },
              childrenPadding: const EdgeInsets.all(16),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.answer,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w300,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}