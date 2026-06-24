import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/faq_screen/controller/faq_controller.dart';
import '../../models/faq_model.dart';
import '../../widgets/custom_back_header.dart';
import '../../widgets/faq_category_section.dart';
import '../../widgets/search_bar.dart' as custom_search;  // Use alias to avoid ambiguity
import '../../widgets/contact_button.dart';
import '../../services/whatsapp_service.dart';


FaqController controller = Get.put(FaqController());

class FaqScreen extends StatefulWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<FaqCategory> _allCategories = [];
  List<FaqCategory> _filteredCategories = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadFaqData();
  }

  void _loadFaqData() {
    // In a real app, this would come from an API or database
    _allCategories = [
      FaqCategory(
        title: 'For Customers',
        items: [
          FaqItem(
            question: 'How do I place an order?',
            answer: 'Browse through available products, add items to your cart, and proceed to checkout. Follow the payment instructions to complete your order.',
          ),
          FaqItem(
            question: 'What payment methods are accepted?',
            answer: 'We accept credit/debit cards, bank transfers, and wallet payments. All payments are processed securely within 2 hours.',
          ),
          FaqItem(
            question: 'How does the countdown timer work?',
            answer: 'Once you place an order, vendors have a specific timeframe to fulfill it. The countdown timer shows the remaining time for order preparation and delivery.',
          ),
        ],
      ),
      FaqCategory(
        title: 'For Vendors',
        items: [
          FaqItem(
            question: 'How do I become a vendor?',
            answer: 'Register an account, complete your profile, submit required documentation, and wait for approval from our team.',
          ),
          FaqItem(
            question: 'What is the service fee?',
            answer: 'JaraMarket charges a 5% service fee on each successful transaction. This fee covers platform maintenance, customer support, and payment processing.',
          ),
          FaqItem(
            question: 'What are my responsibilities for order fulfillment?',
            answer: 'Vendors must prepare and deliver orders within the specified timeframe shown by the countdown timer. Failure to meet deadlines may affect your vendor rating.',
          ),
        ],
      ),
      FaqCategory(
        title: 'Orders & Delivery',
        items: [
          FaqItem(
            question: 'How can I track my order?',
            answer: 'You can track your order status in real-time from the Orders section in your account dashboard.',
          ),
          FaqItem(
            question: 'What if my order is late?',
            answer: 'If your order exceeds the countdown timer, you will receive a notification and may be eligible for compensation as per our late delivery policy.',
          ),
        ],
      ),
      FaqCategory(
        title: 'Payments',
        items: [
          FaqItem(
            question: 'How long does payment processing take?',
            answer: 'Payments are typically processed within 2 hours. You will receive a confirmation once the payment is complete.',
          ),
          FaqItem(
            question: 'Can I get a refund?',
            answer: 'Yes, refunds are available for orders that do not meet our quality standards or were not delivered. Contact customer support to initiate a refund.',
          ),
        ],
      ),
    ];
    
    _filteredCategories = List.from(_allCategories);
  }

  void _filterFaqs(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredCategories = List.from(_allCategories);
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _filteredCategories = _allCategories.map((category) {
        final filteredItems = category.items.where((item) {
          return item.question.toLowerCase().contains(query.toLowerCase()) ||
              item.answer.toLowerCase().contains(query.toLowerCase());
        }).toList();
        
        return FaqCategory(
          title: category.title,
          items: filteredItems,
        );
      }).where((category) => category.items.isNotEmpty).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomBackHeader(title: 'FAQs'),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text('Haven\'t seen you the answer you\'re looking for?', 
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey[700])),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: custom_search.SearchBar(  // Use the alias to reference your custom SearchBar
                controller: _searchController,
                hintText: 'Search FAQs...',
                onChanged: _filterFaqs,
              ),
            ),
            Expanded(
              child: _isSearching && _filteredCategories.isEmpty
                ? _buildNoResultsFound()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredCategories.length + 1, // +1 for the contact section
                    itemBuilder: (context, index) {
                      if (index == _filteredCategories.length) {
                        return _buildStillHaveQuestionsSection();
                      }
                      return FaqCategorySection(
                        category: _filteredCategories[index],
                        onExpand: (itemIndex, isExpanded) {
                          setState(() {
                            _filteredCategories[index].items[itemIndex].isExpanded = isExpanded;
                          });
                        },
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try different keywords or browse all FAQs',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () {
              _searchController.clear();
              _filterFaqs('');
            },
            child: const Text('Clear Search'),
          ),
        ],
      ),
    );
  }

  Widget _buildStillHaveQuestionsSection() {
    return Container(
      margin: const EdgeInsets.only(top: 32, bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'Still have questions?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Our support team is here to help you with any questions or concerns.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ContactButton(
                icon: Icons.email_outlined,
                label: 'Email Us',
                onTap: () {
                  Navigator.pushNamed(context, '/contact');
                },
              ),
              ContactButton(
                icon: FontAwesomeIcons.whatsapp,
                label: 'WhatsApp',
                color: const Color(0xFF25D366),
                onTap: () {
                  _openWhatsApp(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Update the _openWhatsApp method in the FaqScreen class
  void _openWhatsApp(BuildContext context) {
    WhatsAppService.openWhatsApp(
      context,
      userContext: UserContext.general,
      customMessage: 'Hello JaraMarket Support, I have a question that wasn\'t answered in the FAQ: ',
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}