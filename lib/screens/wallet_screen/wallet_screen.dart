import 'dart:developer' as myLog;
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/add_money_screen/add_money_screen.dart';
import 'package:jara_market/screens/wallet_screen/controller/wallet_controller.dart';
import 'package:jara_market/screens/wallet_screen/withdraw_screen.dart';
import '../../widgets/custom_back_header.dart';
import '../../widgets/balance_card.dart';

WalletController controller = Get.put(WalletController());

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _isBalanceVisible = true;

  @override
  void initState() {
    super.initState();
    controller.fetchWallet();
    controller.fetchTransactions();
  }

  RefreshController refreshController =
      RefreshController(initialRefresh: false);
// RefreshController
  void onRefresh() {
    controller.fetchWallet();
    controller.fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        controller: refreshController,
        onRefresh: onRefresh,
        child: SafeArea(child: Obx(() {
          return controller.isLoading.value ||
                  controller.isTransactionLoading.value
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Colors.amber,
                ))
              : Column(
                  children: [
                    const CustomBackHeader(title: 'Wallet'),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ElevatedButton(onPressed: (){controller.fetchTransaction();}, child: Text('transaction')),
                            Obx(() {
                              return BalanceCard(
                                balance: controller.isLoading.value
                                    ? 'Loading...'
                                    : (controller.walletModel.data?.balance
                                            ?.toString() ??
                                        '0.00'),
                                subtitle: 'JaraWallet - Seamless Pay',
                                isBalanceVisible: _isBalanceVisible,
                                onToggleVisibility: () {
                                  setState(() {
                                    _isBalanceVisible = !_isBalanceVisible;
                                  });
                                },
                              );
                            }),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildActionButton(
                                  icon: 'assets/images/add.svg',
                                  label: 'Add Money',
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AddMoneyScreen(),
                                      ),
                                    );
                                  },
                                ),
                                _buildActionButton(
                                  icon: 'assets/images/withdraw.svg',
                                  label: 'Withdraw',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const WithdrawScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            const Text(
                              'Wallet History',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Obx(() {
                              if (controller.isTransactionLoading.value) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.amber),
                                );
                              }
                              if (controller.transactions.isEmpty) {
                                return _buildEmptyState();
                              }
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.transactions.length,
                                itemBuilder: (context, index) {
                                  final transaction =
                                      controller.transactions[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: ListTile(
                                      onTap: () {
                                        controller
                                            .fetchTransaction(transaction.id);
                                      },
                                      tileColor: Colors.grey[100],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          side: BorderSide(
                                              width: 1,
                                              color:
                                                  const Color(0xff1919190D))),
                                      leading: Icon(
                                        transaction.status == 'success'
                                            ? Icons.arrow_upward
                                            : Icons.arrow_downward,
                                        color: transaction.status == 'success'
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                      title: Text(transaction.gatewayResponse),
                                      subtitle: Text(transaction.createdAt),
                                      trailing: Text(
                                        '${transaction.status == 'success' ? '+' : '-'}${transaction.amount}',
                                        style: TextStyle(
                                          color: transaction.status == 'success'
                                              ? Colors.green
                                              : Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            })
                          ],
                        ),
                      ),
                    ),
                  ],
                );
        })),
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
              height: 40,
              width: 40,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[100],
                shape: BoxShape.rectangle,
              ),
              child: SvgPicture.asset(
                icon,
                fit: BoxFit.cover,
                // height: 14,
                // width: 24,
              )),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 362,
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Color(0xff1919190D)),
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon(
          //   Icons.block,
          //   size: 48,
          //   color: Colors.grey[400],
          // ),
          SvgPicture.asset('assets/images/block.svg'),
          const SizedBox(height: 16),
          // Text(
          //   'No transactions found',
          //   style: TextStyle(
          //     fontSize: 16,
          //     color: Colors.grey[600],
          //     fontWeight: FontWeight.w500,
          //   ),
          // ),
          //  const SizedBox(height: 256), // Increase the height here
        ],
      ),
    );
  }
}


