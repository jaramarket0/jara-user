// import 'dart:convert';
// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:jara_market/models/support_ticket.dart';
// import 'package:jara_market/widgets/custom_text_field.dart';
// import 'package:jara_market/services/api_service.dart';

// class HelpAndSupport extends StatefulWidget {
//   const HelpAndSupport({super.key});

//   @override
//   State<HelpAndSupport> createState() => _HelpAndSupportState();
// }

// class _HelpAndSupportState extends State<HelpAndSupport> {
//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _subjectController = TextEditingController();
//   final _messageController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   final ApiService _apiService = ApiService(Duration(seconds: 60 * 5));
//   final ImagePicker _imagePicker = ImagePicker();

//   bool _isSubmitting = false;
//   bool _isLoadingTickets = true;

//   File? _attachmentFile;
//   List<SupportTicket> _tickets = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchTickets();
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _phoneController.dispose();
//     _emailController.dispose();
//     _subjectController.dispose();
//     _messageController.dispose();
//     super.dispose();
//   }

//   Future<void> _submitSupportTicket() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       _isSubmitting = true;
//     });

//     try {
//       final response = await _apiService.createSupportTicket(
//         subject: _subjectController.text.trim(),
//         message: _messageController.text.trim(),
//         name: _nameController.text.trim(),
//         email: _emailController.text.trim(),
//         phone: _phoneController.text.trim(),
//         attachment: _attachmentFile,
//       );

//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//             content: Text('Support ticket submitted successfully.'),
//             duration: Duration(seconds: 2),
//           ));
//         }
//         _formKey.currentState!.reset();
//         _nameController.clear();
//         _phoneController.clear();
//         _emailController.clear();
//         _subjectController.clear();
//         _messageController.clear();
//       } else {
//         final errorMessage = response.body.isNotEmpty
//             ? response.body
//             : 'Unable to submit support ticket.';
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Text(errorMessage),
//             duration: Duration(seconds: 2),
//           ));
//         }
//       }
//     } catch (error) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text('Network error. Please try again.'),
//           duration: Duration(seconds: 2),
//         ));
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isSubmitting = false;
//         });
//       }
//     }
//   }

//   Future<void> _fetchTickets() async {
//     setState(() {
//       _isLoadingTickets = true;
//     });

//     try {
//       final response = await _apiService.fetchSupportTickets();
//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         final jsonData = jsonDecode(response.body);
//         List<dynamic> itemsRaw = [];

//         if (jsonData is List) {
//           itemsRaw = jsonData;
//         } else if (jsonData is Map<String, dynamic>) {
//           if (jsonData.containsKey('data')) {
//             itemsRaw = jsonData['data'];
//           } else if (jsonData.containsKey('tickets')) {
//             itemsRaw = jsonData['tickets'];
//           }
//         }

//         _tickets = itemsRaw
//             .whereType<Map<String, dynamic>>()
//             .map((e) => SupportTicket.fromJson(e))
//             .toList();
//       } else {
//         _tickets = [];
//       }
//     } catch (e) {
//       _tickets = [];
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoadingTickets = false;
//         });
//       }
//     }
//   }

//   Future<void> _pickAttachment() async {
//     final XFile? result = await _imagePicker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 80,
//     );

//     if (result != null) {
//       setState(() {
//         _attachmentFile = File(result.path);
//       });
//     }
//   }

//   void _showTicketDetails(SupportTicket ticket) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Ticket #${ticket.id}'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Subject: ${ticket.subject}'),
//               SizedBox(height: 8),
//               Text('Status: ${ticket.status}'),
//               SizedBox(height: 8),
//               Text('Message: ${ticket.message}'),
//               if (ticket.attachmentUrl != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   child: Text('Attachment: ${ticket.attachmentUrl}'),
//                 ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           leading: GestureDetector(
//               onTap: () {
//                 Get.back();
//               },
//               child: Icon(Icons.chevron_left_rounded)),
//           title: Text('Help and Support'),
//           centerTitle: false,
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(
//                 height: 10,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 16),
//                 child: Align(
//                   alignment: Alignment.topLeft,
//                   child: Text(
//                     'Call or Chat with us and we will answer your questions',
//                     style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 30,
//               ),
//               Row(
//                 spacing: 10,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Column(
//                     spacing: 10,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         spacing: 5,
//                         children: [
//                           SvgPicture.asset('assets/images/phone.svg'),
//                           Text(
//                             'www.jaramarket.com.ng',
//                             style: TextStyle(
//                                 fontSize: 12, fontWeight: FontWeight.w400),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         spacing: 5,
//                         children: [
//                           SvgPicture.asset('assets/images/phone.svg'),
//                           Text(
//                             '+2347123456789',
//                             style: TextStyle(
//                                 fontSize: 12, fontWeight: FontWeight.w400),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         spacing: 5,
//                         children: [
//                           SvgPicture.asset('assets/images/help_support.svg'),
//                           Text(
//                             'hello@jaramarket.com',
//                             style: TextStyle(
//                                 fontSize: 12, fontWeight: FontWeight.w400),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         spacing: 5,
//                         children: [
//                           SvgPicture.asset('assets/images/office.svg'),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('Corporate Office',
//                                   style: TextStyle(
//                                       color: Color(0xff3D3D3D),
//                                       fontFamily: 'Roboto',
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w600)),
//                               Text('#12 Your address, LGA\nState, Nigeria',
//                                   style: TextStyle(
//                                       color: Color(0xff3D3D3D),
//                                       fontFamily: 'Roboto',
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.w400)),
//                             ],
//                           ),
//                           // RichText(
//                           //   text: TextSpan(
//                           //     children: [
//                           //       TextSpan(
//                           //         text: '#12 Your address, LGA\nState, Nigeria',

//                           //         style: TextStyle(
//                           //           color: Color(0xff3D3D3D),
//                           //           fontFamily: 'Roboto',
//                           //           fontSize: 10,
//                           //           fontWeight: FontWeight.w600
//                           //           //decoration: TextDecoration.underline,
//                           //         ),
//                           //       ),
//                           //     ],
//                           //     text: '\nCorporate Office',
//                           //     //style: DefaultTextStyle.of(context).style,
//                           //     style: TextStyle(color: Color(0xff3D3D3D),
//                           //           fontFamily: 'Roboto',
//                           //           fontSize: 12,
//                           //           fontWeight: FontWeight.w600)
//                           //   ),
//                           // ),
//                         ],
//                       ),
//                       // Spacer(),
//                       SizedBox(
//                         width: 20,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             width: 25,
//                           ),
//                           SizedBox(
//                               width: 77.65,
//                               height: 20,
//                               child:
//                                   //CustomButton(text: 'Get Direcition', onPressed: (){})
//                                   ElevatedButton(
//                                 onPressed: () {},
//                                 child: Text(
//                                   'Get Direction',
//                                   style: TextStyle(
//                                       fontSize: 10, color: Colors.black),
//                                 ),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Color(0xffFECC2B),
//                                   padding: EdgeInsets.zero,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(4),
//                                   ),
//                                 ),
//                               )),
//                         ],
//                       ),
//                       // Spacer(),
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       Container(
//                         width: 120,
//                         height: 200,
//                         decoration: BoxDecoration(
//                           image: DecorationImage(
//                               image: AssetImage('assets/images/map.png'),
//                               fit: BoxFit.cover),
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.only(
//                             //topLeft: Radius.circular(12),
//                             topRight: Radius.circular(12),
//                             //bottomLeft: Radius.circular(12),
//                             bottomRight: Radius.circular(12),
//                           ),
//                         ),
//                       )
//                     ],
//                   )
//                 ],
//               ),
//               SizedBox(
//                 height: 50,
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 child: Container(
//                   width: double.infinity,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Get In Touch.',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             fontFamily: 'Roboto',
//                             fontSize: 12,
//                             color: Color(0xffF24A00)),
//                       ),
//                       Text('Chat with our customer care representative',
//                           style: TextStyle(
//                               fontWeight: FontWeight.w400,
//                               fontFamily: 'Roboto',
//                               fontSize: 10,
//                               color: Color(0xff3D3D3D))),
//                       const SizedBox(height: 20),
//                       Form(
//                         key: _formKey,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             CustomTextField(
//                               hint: 'Name',
//                               controller: _nameController,
//                               onChanged: (value) {},
//                             ),
//                             const SizedBox(height: 10),
//                             Row(
//                               spacing: 10,
//                               children: [
//                                 Expanded(
//                                   child: CustomTextField(
//                                     hint: 'Number',
//                                     controller: _phoneController,
//                                     keyboardType: TextInputType.phone,
//                                     onChanged: (value) {},
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: CustomTextField(
//                                     hint: 'Email',
//                                     controller: _emailController,
//                                     keyboardType: TextInputType.emailAddress,
//                                     onChanged: (value) {},
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 10),
//                             CustomTextField(
//                               hint: 'Subject',
//                               controller: _subjectController,
//                               onChanged: (value) {},
//                             ),
//                             const SizedBox(height: 10),
//                             TextFormField(
//                               controller: _messageController,
//                               maxLines: 5,
//                               validator: (value) {
//                                 if (value == null || value.trim().isEmpty) {
//                                   return 'Please enter your message';
//                                 }
//                                 return null;
//                               },
//                               decoration: InputDecoration(
//                                 hintText: 'Your Message',
//                                 hintStyle: TextStyle(color: Colors.black12),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: BorderSide(
//                                       width: 1, color: Colors.black12),
//                                 ),
//                                 fillColor: Colors.grey[100],
//                                 filled: true,
//                               ),
//                             ),
//                             const SizedBox(height: 18),
//                             Align(
//                               alignment: Alignment.center,
//                               child: SizedBox(
//                                 width: 120,
//                                 height: 40,
//                                 child: ElevatedButton(
//                                   onPressed: _isSubmitting
//                                       ? null
//                                       : _submitSupportTicket,
//                                   child: _isSubmitting
//                                       ? const SizedBox(
//                                           width: 24,
//                                           height: 24,
//                                           child: CircularProgressIndicator(
//                                             color: Colors.white,
//                                             strokeWidth: 2,
//                                           ),
//                                         )
//                                       : const Text(
//                                           'Send',
//                                           style: TextStyle(
//                                               fontSize: 12,
//                                               color: Colors.black),
//                                         ),
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Color(0xffFECC2B),
//                                     padding: EdgeInsets.zero,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(4),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 14),
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Expanded(
//                                   child: OutlinedButton.icon(
//                                     onPressed: _pickAttachment,
//                                     icon: const Icon(Icons.attach_file),
//                                     label: const Text('Add Attachment (optional)'),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             if (_attachmentFile != null) ...[
//                               const SizedBox(height: 8),
//                               Text('Attached: ${_attachmentFile!.path.split('/').last}'),
//                             ],
//                             const SizedBox(height: 20),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Text(
//                                   'My Support Tickets',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                                 IconButton(
//                                   onPressed: _fetchTickets,
//                                   icon: const Icon(Icons.refresh),
//                                 ),
//                               ],
//                             ),
//                             if (_isLoadingTickets)
//                               const Center(child: CircularProgressIndicator())
//                             else if (_tickets.isEmpty)
//                               const Padding(
//                                 padding: EdgeInsets.symmetric(vertical: 8.0),
//                                 child: Text('No support tickets yet.'),
//                               )
//                             else
//                               ListView.separated(
//                                 shrinkWrap: true,
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 itemCount: _tickets.length,
//                                 separatorBuilder: (_, __) => const Divider(),
//                                 itemBuilder: (context, index) {
//                                   final ticket = _tickets[index];
//                                   return ListTile(
//                                     title: Text(ticket.subject),
//                                     subtitle: Text('Status: ${ticket.status}'),
//                                     trailing: const Icon(Icons.open_in_new),
//                                     onTap: () => _showTicketDetails(ticket),
//                                   );
//                                 },
//                               ),
//                             const SizedBox(
//                               height: 30,
//                             ),
//                             Align(
//                               alignment: Alignment.center,
//                               child: Row(
//                                 spacing: 5,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   SvgPicture.asset('assets/images/faq.svg'),
//                                   const SizedBox(width: 8),
//                                   const Text('FAQ'),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 30,
//                             ),
//                             Row(
//                               spacing: 10,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 SvgPicture.asset('assets/images/facebook.svg'),
//                                 SvgPicture.asset('assets/images/instagram.svg'),
//                                 SvgPicture.asset('assets/images/x.svg'),
//                                 SvgPicture.asset('assets/images/telegram.svg'),
//                                 SvgPicture.asset('assets/images/linkedin.svg'),
//                                 SvgPicture.asset('assets/images/whatsApp.svg'),
//                               ],
//                             ),
//                             const SizedBox(
//                               height: 15,
//                             ),
//                           ],


//                         ),
//                       ),
                    
//                   ],
//                 ),
//               ),
           
          
//         ),
//             ]
//       );
//   }
// }
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jara_market/models/support_ticket.dart';
import 'package:jara_market/widgets/custom_text_field.dart';
import 'package:jara_market/services/api_service.dart';

class HelpAndSupport extends StatefulWidget {
  const HelpAndSupport({super.key});

  @override
  State<HelpAndSupport> createState() => _HelpAndSupportState();
}

class _HelpAndSupportState extends State<HelpAndSupport> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService(Duration(seconds: 60 * 5));
  final ImagePicker _imagePicker = ImagePicker();

  bool _isSubmitting = false;
  bool _isLoadingTickets = true;

  File? _attachmentFile;
  List<SupportTicket> _tickets = [];

  @override
  void initState() {
    super.initState();
    _fetchTickets();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitSupportTicket() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await _apiService.createSupportTicket(
        subject: _subjectController.text.trim(),
        message: _messageController.text.trim(),
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        attachment: _attachmentFile,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Support ticket submitted successfully.'),
            duration: Duration(seconds: 2),
          ));
        }
        _formKey.currentState!.reset();
        _nameController.clear();
        _phoneController.clear();
        _emailController.clear();
        _subjectController.clear();
        _messageController.clear();
        setState(() {
          _attachmentFile = null;
        });
        // Refresh ticket list after successful submission
        _fetchTickets();
      } else {
        final errorMessage = response.body.isNotEmpty
            ? response.body
            : 'Unable to submit support ticket.';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(errorMessage),
            duration: const Duration(seconds: 2),
          ));
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Network error. Please try again.'),
          duration: Duration(seconds: 2),
        ));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _fetchTickets() async {
    setState(() {
      _isLoadingTickets = true;
    });

    try {
      final response = await _apiService.fetchSupportTickets();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonData = jsonDecode(response.body);
        List<dynamic> itemsRaw = [];

        if (jsonData is List) {
          itemsRaw = jsonData;
        } else if (jsonData is Map<String, dynamic>) {
          if (jsonData.containsKey('data')) {
            itemsRaw = jsonData['data'];
          } else if (jsonData.containsKey('tickets')) {
            itemsRaw = jsonData['tickets'];
          }
        }

        _tickets = itemsRaw
            .whereType<Map<String, dynamic>>()
            .map((e) => SupportTicket.fromJson(e))
            .toList();
      } else {
        _tickets = [];
      }
    } catch (e) {
      _tickets = [];
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingTickets = false;
        });
      }
    }
  }

  Future<void> _pickAttachment() async {
    final XFile? result = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (result != null) {
      setState(() {
        _attachmentFile = File(result.path);
      });
    }
  }

  void _showTicketDetails(SupportTicket ticket) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ticket #${ticket.id}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Subject: ${ticket.subject}'),
              const SizedBox(height: 8),
              Text('Status: ${ticket.status}'),
              const SizedBox(height: 8),
              Text('Message: ${ticket.message}'),
              if (ticket.attachmentUrl != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('Attachment: ${ticket.attachmentUrl}'),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          //Get.back(),
          child: const Icon(Icons.chevron_left_rounded),
        ),
        title: const Text('Help and Support'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),

            // ── Subtitle ──
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Call or Chat with us and we will answer your questions',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ── Contact info + map ──
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 5,
                      children: [
                        SvgPicture.asset('assets/images/phone.svg'),
                        const Text(
                          'www.jaramarket.com.ng',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 5,
                      children: [
                        SvgPicture.asset('assets/images/phone.svg'),
                        const Text(
                          '+2347123456789',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 5,
                      children: [
                        SvgPicture.asset('assets/images/help_support.svg'),
                        const Text(
                          'hello@jaramarket.com',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 5,
                      children: [
                        SvgPicture.asset('assets/images/office.svg'),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Corporate Office',
                              style: TextStyle(
                                color: Color(0xff3D3D3D),
                                fontFamily: 'Roboto',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '#12 Your address, LGA\nState, Nigeria',
                              style: TextStyle(
                                color: Color(0xff3D3D3D),
                                fontFamily: 'Roboto',
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 25),
                        SizedBox(
                          width: 77.65,
                          height: 20,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffFECC2B),
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: const Text(
                              'Get Direction',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: 120,
                      height: 200,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/images/map.png'),
                          fit: BoxFit.cover,
                        ),
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 50),

            // ── Contact form ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Get In Touch.',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      color: Color(0xffF24A00),
                    ),
                  ),
                  const Text(
                    'Chat with our customer care representative',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Roboto',
                      fontSize: 10,
                      color: Color(0xff3D3D3D),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name
                        CustomTextField(
                          hint: 'Name',
                          controller: _nameController,
                          // validator: (value) {
                          //   if (value == null || value.trim().isEmpty) {
                          //     return 'Please enter your name';
                          //   }
                          //   return null;
                          // },
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 10),

                        // Phone + Email
                        Row(
                          spacing: 10,
                          children: [
                            Expanded(
                              child: CustomTextField(
                                hint: 'Number',
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                // validator: (value) {
                                //   if (value == null || value.trim().isEmpty) {
                                //     return 'Required';
                                //   }
                                //   return null;
                                // },
                                onChanged: (value) {},
                              ),
                            ),
                            Expanded(
                              child: CustomTextField(
                                hint: 'Email',
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                // validator: (value) {
                                //   if (value == null || value.trim().isEmpty) {
                                //     return 'Required';
                                //   }
                                //   if (!GetUtils.isEmail(value.trim())) {
                                //     return 'Invalid email';
                                //   }
                                //   return null;
                                // },
                                onChanged: (value) {},
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Subject
                        CustomTextField(
                          hint: 'Subject',
                          controller: _subjectController,
                          // validator: (value) {
                          //   if (value == null || value.trim().isEmpty) {
                          //     return 'Please enter a subject';
                          //   }
                          //   return null;
                          // },
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 10),

                        // Message
                        TextFormField(
                          controller: _messageController,
                          maxLines: 5,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your message';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Your Message',
                            hintStyle:
                                const TextStyle(color: Colors.black26),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.black12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  width: 1, color: Color(0xffFECC2B)),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.red),
                            ),
                            fillColor: Colors.grey[100],
                            filled: true,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Attachment picker (above Send button)
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _pickAttachment,
                                icon: const Icon(Icons.attach_file, size: 16),
                                label: const Text(
                                  'Add Attachment (optional)',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_attachmentFile != null) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.check_circle,
                                  size: 14, color: Colors.green),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  _attachmentFile!.path.split('/').last,
                                  style: const TextStyle(fontSize: 11),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    setState(() => _attachmentFile = null),
                                child: const Icon(Icons.close,
                                    size: 14, color: Colors.red),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 18),

                        // Send button
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 120,
                            height: 40,
                            child: ElevatedButton(
                              onPressed:
                                  _isSubmitting ? null : _submitSupportTicket,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffFECC2B),
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
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
                                      'Send',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ── My Support Tickets ──
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'My Support Tickets',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            IconButton(
                              onPressed: _fetchTickets,
                              icon: const Icon(Icons.refresh),
                            ),
                          ],
                        ),
                        if (_isLoadingTickets)
                          const Center(child: CircularProgressIndicator())
                        else if (_tickets.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('No support tickets yet.'),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _tickets.length,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (context, index) {
                              final ticket = _tickets[index];
                              return ListTile(
                                title: Text(ticket.subject),
                                subtitle: Text('Status: ${ticket.status}'),
                                trailing: const Icon(Icons.open_in_new),
                                onTap: () => _showTicketDetails(ticket),
                              );
                            },
                          ),
                        const SizedBox(height: 30),

                        // ── FAQ ──
                        Align(
                          alignment: Alignment.center,
                          child: Row(
                            spacing: 5,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/images/faq.svg'),
                              const SizedBox(width: 8),
                              const Text('FAQ'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // ── Social icons ──
                        Row(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/images/facebook.svg'),
                            SvgPicture.asset('assets/images/instagram.svg'),
                            SvgPicture.asset('assets/images/x.svg'),
                            SvgPicture.asset('assets/images/telegram.svg'),
                            SvgPicture.asset('assets/images/linkedin.svg'),
                            SvgPicture.asset('assets/images/whatsApp.svg'),
                          ],
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}