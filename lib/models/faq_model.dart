class FaqCategory {
  final String title;
  final List<FaqItem> items;

  FaqCategory({
    required this.title,
    required this.items,
  });
}

class FaqItem {
  final String question;
  final String answer;
  bool isExpanded;

  FaqItem({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });
}