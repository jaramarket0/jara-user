import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/wallet_screen/controller/wallet_controller.dart';
import 'package:jara_market/widgets/custom_button.dart';
import 'package:jara_market/widgets/custom_back_header.dart';

// class WithdrawScreen extends StatefulWidget {
//   const WithdrawScreen({Key? key}) : super(key: key);

//   @override
//   State<WithdrawScreen> createState() => _WithdrawScreenState();
// }

// class _WithdrawScreenState extends State<WithdrawScreen> {
//   final TextEditingController _amountController = TextEditingController();
//   final TextEditingController _remarkController = TextEditingController();
//   int? selectedBankId;
//   late WalletController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = Get.find<WalletController>();
//     controller.fetchBanks();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             const CustomBackHeader(title: 'Withdraw'),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Withdraw to Bank',
//                       style:
//                           TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 24),
//                     TextField(
//                       controller: _amountController,
//                       keyboardType: TextInputType.number,
//                       decoration: const InputDecoration(
//                         labelText: 'Amount',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Obx(() {
//                       return DropdownButtonFormField<int>(
//                         value: selectedBankId,
//                         items: controller.banks.map((bank) {
//                           return DropdownMenuItem<int>(
//                             value: bank['id'],
//                             child: Text(bank['name'] ?? ''),
//                           );
//                         }).toList(),
//                         onChanged: (value) {
//                           setState(() {
//                             selectedBankId = value;
//                           });
//                         },
//                         decoration: const InputDecoration(
//                           labelText: 'Select Bank',
//                           border: OutlineInputBorder(),
//                         ),
//                       );
//                     }),
//                     const SizedBox(height: 16),
//                     TextField(
//                       controller: _remarkController,
//                       decoration: const InputDecoration(
//                         labelText: 'Remark (optional)',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     CustomButton(
//                       text: 'Withdraw',
//                       onPressed: () {
//                         if (_amountController.text.isNotEmpty &&
//                             selectedBankId != null) {
//                           int amount = int.parse(_amountController.text);
//                           controller.withdrawToBank(
//                             amount,
//                             selectedBankId!,
//                             'NGN',
//                             _remarkController.text.isEmpty
//                                 ? 'Withdraw to bank'
//                                 : _remarkController.text,
//                           );
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                                 content: Text('Please fill all fields')),
//                           );
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//TODO: STARTE HERE

import 'dart:developer' as myLog;
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/profile_screen/pinScreen.dart';
import 'package:jara_market/services/api_service.dart';
//import 'package:jara_market/screens/pin_screen/pin_screen.dart';

// ─── Model ───────────────────────────────────────────────────────────────────

class BankOption {
  final int id;
  final String name;
  final String code;

  BankOption({required this.id, required this.name, required this.code});

  factory BankOption.fromJson(Map<String, dynamic> json) {
    return BankOption(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
    );
  }
}

// ─── Controller ──────────────────────────────────────────────────────────────

class WithdrawController extends GetxController {
  final ApiService _api = ApiService(const Duration(seconds: 60));

  RxList<BankOption> banks = <BankOption>[].obs;
  Rx<BankOption?> selectedBank = Rx<BankOption?>(null);
  RxBool isLoadingBanks = false.obs;
  RxBool isSubmitting = false.obs;
  RxString bankSearchQuery = ''.obs;

  final amountCtrl = TextEditingController();
  final accountNumberCtrl = TextEditingController();
  final accountNameCtrl = TextEditingController();
  final narrationCtrl = TextEditingController();

  List<BankOption> get filteredBanks {
    if (bankSearchQuery.value.isEmpty) return banks;
    return banks
        .where((b) =>
            b.name.toLowerCase().contains(bankSearchQuery.value.toLowerCase()))
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchBanks();
  }

  @override
  void onClose() {
    amountCtrl.dispose();
    accountNumberCtrl.dispose();
    accountNameCtrl.dispose();
    narrationCtrl.dispose();
    super.onClose();
  }

  Future<void> fetchBanks({String? search}) async {
    isLoadingBanks.value = true;
    try {
      final res = await _api.fetchBanks(search: search);
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final list = body['data'] as List? ?? body as List? ?? [];
        banks.value = list.map((e) => BankOption.fromJson(e)).toList();
      }
    } catch (_) {
    } finally {
      isLoadingBanks.value = false;
    }
  }

  Future<bool> transfer(String pinToken) async {
    isSubmitting.value = true;
    myLog.log(
        'Initiating transfer with amount: ${amountCtrl.text}, bank: ${selectedBank.value?.name}, account number: ${accountNumberCtrl.text}, account name: ${accountNameCtrl.text}, narration: ${narrationCtrl.text}, bank id: ${selectedBank.value?.id}, bank code: ${selectedBank.value?.code}');
    try {
      final res = await _api.transferToBank({
        'amount': double.tryParse(amountCtrl.text) ?? 0,
        'bank_id': 1, //selectedBank.value?.id,
        'bank_code': selectedBank.value?.code,
        'account_number': accountNumberCtrl.text.trim(),
        'account_name': accountNameCtrl.text.trim(),
        'narration': narrationCtrl.text.trim(),
        'pin_token': pinToken,
      });
      final body = jsonDecode(res.body);
      myLog.log('Transfer response: ${res.body}');
      if (res.statusCode == 200 || res.statusCode == 201) {
        Get.snackbar(
          'Transfer Initiated',
          body['message'] ?? 'Your transfer has been initiated successfully.',
          backgroundColor: const Color(0xFF22C55E),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.defaultDialog(
            title: 'Transfer Initated',
            content: Text(
              body['message'] ??
                  'Your transfer has been initiated successfully.',
            ),
            confirm: TextButton(
                onPressed: () {
                  Navigator.pop(Get.context!);
                },
                child: Text('OK')));
        return true;
      } else {
        // Get.snackbar(
        //   'Transfer Failed',
        //   body['message'] ?? 'Could not complete transfer. Please try again.',
        //   backgroundColor: Colors.red,
        //   colorText: Colors.white,
        //   snackPosition: SnackPosition.BOTTOM,
        // );
        //Dialog();
        // AlertDialog(
        //   title: Text('Transfer Failed'),
        //   content: Text(body['message'] ??
        //       'Could not complete transfer. Please try again.'),
        //   actions: [
        //     TextButton(
        //       onPressed: () => Navigator.pop(Get.context!),
        //       child: Text('OK'),
        //     ),
        //   ],
        // );
        Get.defaultDialog(
            title: 'Transfer Failed',
            content: Text(body['message'] ??
                'Could not complete transfer. Please try again.'));
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error. Please try again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
}

// ─── Screen ──────────────────────────────────────────────────────────────────

class WithdrawScreen extends StatelessWidget {
  const WithdrawScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(WithdrawController());
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('Withdraw / Transfer',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Amount ──
              _SectionLabel('Amount (₦)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: ctrl.amountCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: _inputDec(hint: 'Enter amount to withdraw'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter an amount';
                  if ((double.tryParse(v) ?? 0) < 100) return 'Minimum is ₦100';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // ── Bank ──
              _SectionLabel('Bank'),
              const SizedBox(height: 8),
              Obx(() => GestureDetector(
                    onTap: () => _showBankPicker(context, ctrl),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              ctrl.selectedBank.value?.name ??
                                  'Select your bank',
                              style: TextStyle(
                                color: ctrl.selectedBank.value == null
                                    ? Colors.grey.shade500
                                    : Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down_rounded,
                              color: Colors.grey),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 20),

              // ── Account Number ──
              _SectionLabel('Account Number'),
              const SizedBox(height: 8),
              TextFormField(
                controller: ctrl.accountNumberCtrl,
                keyboardType: TextInputType.number,
                maxLength: 10,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: _inputDec(hint: '10-digit account number'),
                validator: (v) {
                  if (v == null || v.length != 10)
                    return 'Enter a valid 10-digit account number';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // ── Account Name ──
              _SectionLabel('Account Name'),
              const SizedBox(height: 8),
              TextFormField(
                controller: ctrl.accountNameCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: _inputDec(hint: 'Account holder name'),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Enter account name'
                    : null,
              ),
              const SizedBox(height: 20),

              // ── Narration ──
              _SectionLabel('Narration (optional)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: ctrl.narrationCtrl,
                decoration: _inputDec(hint: 'What is this transfer for?'),
              ),
              const SizedBox(height: 12),

              // ── Warning ──
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Colors.amber.shade700, size: 18),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Transfers are processed within 24 hours. Your PIN will be required.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── Submit ──
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: ctrl.isSubmitting.value
                          ? null
                          : () async {
                              if (!formKey.currentState!.validate()) return;
                              if (ctrl.selectedBank.value == null) {
                                Get.snackbar('Error', 'Please select a bank',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                    snackPosition: SnackPosition.BOTTOM);
                                return;
                              }
                              // PIN verification
                              final pinToken =
                                  await showPinVerificationDialog(context);
                              if (pinToken.isEmpty) return;

                              final success = await ctrl.transfer(pinToken);
                              if (success && context.mounted) Get.back();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFAA00),
                        disabledBackgroundColor:
                            const Color(0xFFFFAA00).withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: ctrl.isSubmitting.value
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2.5))
                          : const Text('Transfer Now',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                    ),
                  )),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _showBankPicker(BuildContext context, WithdrawController ctrl) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (_, scrollCtrl) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2)),
                ),
                const SizedBox(height: 16),
                const Text('Select Bank',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 12),
                TextField(
                  onChanged: (v) => ctrl.bankSearchQuery.value = v,
                  decoration: _inputDec(hint: 'Search bank...').copyWith(
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Obx(() => ctrl.isLoadingBanks.value
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFFFFAA00)))
                      : ListView.builder(
                          controller: scrollCtrl,
                          itemCount: ctrl.filteredBanks.length,
                          itemBuilder: (_, i) {
                            final bank = ctrl.filteredBanks[i];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xFFFFF8EC),
                                child: Text(
                                  bank.name.isNotEmpty
                                      ? bank.name[0].toUpperCase()
                                      : 'B',
                                  style: const TextStyle(
                                      color: Color(0xFFFFAA00),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              title: Text(bank.name),
                              onTap: () {
                                ctrl.selectedBank.value = bank;
                                ctrl.bankSearchQuery.value = '';
                                Navigator.pop(context);
                              },
                            );
                          },
                        )),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  InputDecoration _inputDec({String hint = ''}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFFFAA00), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14));
  }
}

//TODO: END HERER

// import 'dart:developer' as myLog;
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:jara_market/screens/wallet_screen/wallet_screen.dart';
// import 'package:jara_market/services/api_service.dart';

// // ─── Model ───────────────────────────────────────────────────────────────────

// class WalletData {
//   final double balance;
//   final String currency;
//   final String? accountNumber;
//   final String? bankName;

//   WalletData({
//     required this.balance,
//     this.currency = 'NGN',
//     this.accountNumber,
//     this.bankName,
//   });

//   factory WalletData.fromJson(Map<String, dynamic> json) {
//     final data = json['data'] ?? json;
//     return WalletData(
//       balance: double.tryParse(data['balance']?.toString() ?? '0') ?? 0.0,
//       currency: data['currency']?.toString() ?? 'NGN',
//       accountNumber: data['account_number']?.toString(),
//       bankName: data['bank_name']?.toString(),
//     );
//   }
// }

// class WalletTransaction {
//   final int id;
//   final String type;
//   final double amount;
//   final String status;
//   final String description;
//   final DateTime createdAt;

//   WalletTransaction({
//     required this.id,
//     required this.type,
//     required this.amount,
//     required this.status,
//     required this.description,
//     required this.createdAt,
//   });

//   factory WalletTransaction.fromJson(Map<String, dynamic> json) {
//     return WalletTransaction(
//       id: json['id'] is int
//           ? json['id']
//           : int.tryParse(json['id'].toString()) ?? 0,
//       type: json['type']?.toString() ?? 'debit',
//       amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
//       status: json['status']?.toString() ?? 'completed',
//       description: json['description']?.toString() ??
//           json['narration']?.toString() ??
//           '',
//       createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
//           DateTime.now(),
//     );
//   }
// }

// // ─── Controller ──────────────────────────────────────────────────────────────

// class WalletController extends GetxController {
//   final ApiService _api = ApiService(const Duration(seconds: 30));

//   Rx<WalletData?> wallet1 = Rx<WalletData?>(null);
//   Rx<double?> wallet = Rx<double?>(null);
//   RxList<WalletTransaction> transactions = <WalletTransaction>[].obs;
//   RxBool isLoading = false.obs;
//   RxBool isBalanceHidden = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchWallet();
//     fetchTransactions();
//   }

//   Future<double> fetchWallet() async {
//     myLog.log('Fetching wallet data...');
//     isLoading.value = true;
//     try {
//       final res = await _api.fetchWallet();
//       myLog.log('Fetching wallet data response...${res.body}');
//       if (res.statusCode == 200 || res.statusCode == 201) {
//         wallet.value = double.parse(jsonDecode(res.body)['data']['balance']
//             .toString()
//             .replaceAll(',', ''));
//         myLog.log(
//             'Wallet data fetched successfully - Balance: ${wallet.value} ---- ${wallet.value} ==== $wallet');
//         return wallet.value ?? 0.0;
//       }
//     } catch (e) {
//       myLog.log('Error fetching wallet data $e');
//     } finally {
//       isLoading.value = false;
//     }
//     return 0.0;
//   }

//   Future<void> fetchTransactions() async {
//     try {
//       final res = await _api.fetchPayments();
//       if (res.statusCode == 200) {
//         final body = jsonDecode(res.body);
//         final list = body['data'] as List? ?? [];
//         transactions.value =
//             list.map((e) => WalletTransaction.fromJson(e)).toList();
//       }
//     } catch (_) {}
//   }

//   String get formattedBalance {
//     final bal = wallet.value ?? 0.0;
//     return '₦${bal.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
//   }
// }

// // ─── Wallet Screen ───────────────────────────────────────────────────────────

// class WalletScreen extends StatelessWidget {
//   const WalletScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final ctrl = Get.put(WalletController());

//     return Scaffold(
//       backgroundColor: const Color(0xFFF9FAFB),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: const BackButton(color: Colors.white),
//         title: const Text('My Wallet',
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFFFF8C00), Color(0xFFFFAA00)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//       body: Obx(() {
//         if (ctrl.isLoading.value && ctrl.wallet.value == null) {
//           return const Center(
//               child: CircularProgressIndicator(color: Color(0xFFFFAA00)));
//         }
//         return RefreshIndicator(
//           color: const Color(0xFFFFAA00),
//           onRefresh: () async {
//             await ctrl.fetchWallet();
//             await ctrl.fetchTransactions();
//           },
//           child: ListView(
//             children: [
//               _WalletCard(ctrl: ctrl),
//               _ActionButtons(),
//               const Padding(
//                 padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
//                 child: Text('Transaction History',
//                     style:
//                         TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
//               ),
//               if (ctrl.transactions.isEmpty)
//                 const Padding(
//                   padding: EdgeInsets.all(32),
//                   child: Center(
//                     child: Text('No transactions yet',
//                         style: TextStyle(color: Colors.grey)),
//                   ),
//                 )
//               else
//                 ...ctrl.transactions.map((t) => _TransactionTile(t: t)),
//               const SizedBox(height: 32),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }

// class _WalletCard extends StatelessWidget {
//   final WalletController ctrl;
//   const _WalletCard({required this.ctrl});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFFFF8C00), Color(0xFFFFAA00)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFFFFAA00).withOpacity(0.4),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text('Wallet Balance',
//                   style: TextStyle(color: Colors.white70, fontSize: 13)),
//               Obx(() => GestureDetector(
//                     onTap: () => ctrl.isBalanceHidden.value =
//                         !ctrl.isBalanceHidden.value,
//                     child: Icon(
//                       ctrl.isBalanceHidden.value
//                           ? Icons.visibility_off_rounded
//                           : Icons.visibility_rounded,
//                       color: Colors.white70,
//                       size: 20,
//                     ),
//                   )),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Obx(() => Text(
//                 ctrl.isBalanceHidden.value ? '₦ ••••••' : ctrl.formattedBalance,
//                 style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 32,
//                     fontWeight: FontWeight.w800,
//                     letterSpacing: -0.5),
//               )),
//           const SizedBox(height: 20),
//           Row(
//             children: [
//               const Icon(Icons.account_balance_wallet_rounded,
//                   color: Colors.white54, size: 16),
//               const SizedBox(width: 6),
//               Text(
//                 'NGN',
//                 style: const TextStyle(color: Colors.white70, fontSize: 13),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ActionButtons extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Row(
//         children: [
//           Expanded(
//             child: _WalletActionBtn(
//               icon: Icons.add_rounded,
//               label: 'Add Money',
//               color: const Color(0xFFFFAA00),
//               onTap: () => Get.toNamed('/add_money_screen'),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: _WalletActionBtn(
//               icon: Icons.send_rounded,
//               label: 'Withdraw',
//               color: const Color(0xFF3B82F6),
//               onTap: () => Get.to(() => const WithdrawScreen()),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: _WalletActionBtn(
//               icon: Icons.receipt_long_rounded,
//               label: 'History',
//               color: const Color(0xFF22C55E),
//               onTap: () {},
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _WalletActionBtn extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final Color color;
//   final VoidCallback onTap;

//   const _WalletActionBtn({
//     required this.icon,
//     required this.label,
//     required this.color,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 14),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: color.withOpacity(0.2)),
//         ),
//         child: Column(
//           children: [
//             Icon(icon, color: color, size: 22),
//             const SizedBox(height: 6),
//             Text(label,
//                 style: TextStyle(
//                     fontSize: 12, color: color, fontWeight: FontWeight.w600)),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _TransactionTile extends StatelessWidget {
//   final WalletTransaction t;
//   const _TransactionTile({required this.t});

//   @override
//   Widget build(BuildContext context) {
//     final isCredit = t.type.toLowerCase().contains('credit') ||
//         t.amount > 0 && t.type == 'credit';
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade100),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 42,
//             height: 42,
//             decoration: BoxDecoration(
//               color: isCredit
//                   ? const Color(0xFF22C55E).withOpacity(0.1)
//                   : Colors.red.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(
//               isCredit
//                   ? Icons.arrow_downward_rounded
//                   : Icons.arrow_upward_rounded,
//               color: isCredit ? const Color(0xFF22C55E) : Colors.red,
//               size: 20,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(t.description.isEmpty ? t.type.capitalize! : t.description,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.w600, fontSize: 13),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis),
//                 const SizedBox(height: 2),
//                 Text(
//                   '${t.createdAt.day}/${t.createdAt.month}/${t.createdAt.year}',
//                   style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
//                 ),
//               ],
//             ),
//           ),
//           Text(
//             '${isCredit ? '+' : '-'}₦${t.amount.toStringAsFixed(2)}',
//             style: TextStyle(
//               color: isCredit ? const Color(0xFF22C55E) : Colors.red,
//               fontWeight: FontWeight.w700,
//               fontSize: 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── Wallet Mini Card (for homepage) ─────────────────────────────────────────

// class WalletMiniCard extends StatelessWidget {
//   const WalletMiniCard({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Lazily init if not already created
//     final ctrl = Get.put(WalletController(), permanent: false);

//     return GestureDetector(
//       onTap: () => Get.toNamed('/wallet_screen'),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [Color(0xFFFF8C00), Color(0xFFFFAA00)],
//             begin: Alignment.centerLeft,
//             end: Alignment.centerRight,
//           ),
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFFFFAA00).withOpacity(0.3),
//               blurRadius: 12,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Obx(() => Row(
//               children: [
//                 const Icon(Icons.account_balance_wallet_rounded,
//                     color: Colors.white, size: 28),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text('Wallet Balance',
//                           style: TextStyle(
//                               color: Colors.white70,
//                               fontSize: 11,
//                               fontWeight: FontWeight.w500)),
//                       const SizedBox(height: 2),
//                       Text(
//                         ctrl.isLoading.value ? '...' : ctrl.formattedBalance,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.w800,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Column(
//                   children: [
//                     Icon(Icons.arrow_forward_ios_rounded,
//                         color: Colors.white70, size: 14),
//                   ],
//                 ),
//               ],
//             )),
//       ),
//     );
//   }
// }
