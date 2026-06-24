import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/contact_screen/controller/contact_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/contact_form_model.dart';
import '../../widgets/custom_back_header.dart';
import '../../widgets/contact_method_card.dart';
import '../../services/api_service.dart';
import '../../services/whatsapp_service.dart';

ContactController controller = Get.put(ContactController());

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final ContactFormData _formData = ContactFormData();
  ApiService _apiService = ApiService(Duration(seconds: 60 * 5));
  bool _isSubmitting = false;
  String? _errorMessage;
  bool _formSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomBackHeader(title: 'Get in Touch'),
            Expanded(
              child: _formSubmitted
                  ? _buildSuccessMessage()
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'We\'re here to help',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Choose a contact method below or fill out the form. Our team typically responds within 24 hours.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildContactMethods(),
                          const SizedBox(height: 32),
                          const Text(
                            'Send us a message',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildContactForm(),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactMethods() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ContactMethodCard(
                icon: Icons.email_outlined,
                title: 'Email',
                subtitle: 'support@jaramarket.com',
                onTap: () {
                  _launchEmail('support@jaramarket.com');
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ContactMethodCard(
                icon: Icons.phone_outlined,
                title: 'Phone',
                subtitle: '+234 800 123 4567',
                onTap: () {
                  _launchPhone('+2348001234567');
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ContactMethodCard(
          icon: FontAwesomeIcons.whatsapp,
          title: 'WhatsApp Support',
          subtitle: 'Chat with us directly',
          color: const Color(0xFF25D366),
          onTap: () {
            _openWhatsApp(context);
          },
        ),
      ],
    );
  }

  // Add these methods to launch email and phone
  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': 'Support Request from JaraMarket App',
      },
    );
    
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      // Show error if unable to launch email app
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not launch email app'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      // Show error if unable to launch phone app
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not launch phone app'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Widget _buildContactForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'I am a:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          _buildUserTypeSelector(),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
            onSaved: (value) {
              _formData.name = value ?? '';
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Email Address',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
            onSaved: (value) {
              _formData.email = value ?? '';
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Subject',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a subject';
              }
              return null;
            },
            onSaved: (value) {
              _formData.subject = value ?? '';
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Message',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 5,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your message';
              }
              return null;
            },
            onSaved: (value) {
              _formData.message = value ?? '';
            },
          ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                _errorMessage!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 14,
                ),
              ),
            ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Send Message',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildUserTypeOption(UserType.customer, 'Customer'),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildUserTypeOption(UserType.vendor, 'Vendor'),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildUserTypeOption(UserType.other, 'Other'),
        ),
      ],
    );
  }

  Widget _buildUserTypeOption(UserType type, String label) {
    final isSelected = _formData.userType == type;
    
    return InkWell(
      onTap: () {
        setState(() {
          _formData.userType = type;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      setState(() {
        _isSubmitting = true;
        _errorMessage = null;
      });
      
      try {
        // In a real app, this would call an API endpoint
        // For now, we'll simulate a successful submission
        await Future.delayed(const Duration(seconds: 2));
        
        // Simulate API call
        // final response = await _apiService.submitContactForm(_formData.toJson());
        
        setState(() {
          _isSubmitting = false;
          _formSubmitted = true;
        });
      } catch (e) {
        setState(() {
          _isSubmitting = false;
          _errorMessage = 'Failed to submit form. Please try again.';
        });
      }
    }
  }

  Widget _buildSuccessMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.green[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 64,
                color: Colors.green[600],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Message Sent!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Thank you for contacting us. We\'ve received your message and will get back to you within 24 hours.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Back to Home',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Update the _openWhatsApp method in the ContactScreen class
  void _openWhatsApp(BuildContext context) {
    WhatsAppService.openWhatsApp(
      context,
      userContext: _formData.userType == UserType.customer 
          ? UserContext.customer 
          : _formData.userType == UserType.vendor 
              ? UserContext.vendor 
              : UserContext.general,
    );
  }
}