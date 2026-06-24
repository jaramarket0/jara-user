import 'package:flutter/material.dart';
import 'package:jara_market/screens/wallet_screen/models/single_transaction_model.dart';

class Receipt extends StatelessWidget {
  const Receipt({super.key, required this.singleTransactionData});
  final SingleTransactionData singleTransactionData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.pop(context),icon: Icon(Icons.chevron_left_rounded)),
        actions: [],
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          SizedBox(
              width: 80,
              height: 80,
              child: Image.asset('assets/images/logo.png')),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 362,
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Color(0xff1919190D)),
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Transaction Receipt', style: TextStyle(
                              fontFamily: 'Mont',
                              fontWeight: FontWeight.w600,
                              fontSize: 18)),
                              SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Status:',
                        style: TextStyle(
                            fontFamily: 'Mont',
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ),
                      Text(singleTransactionData.status!,
                          style: TextStyle(
                              fontFamily: 'Mont',
                              fontWeight: FontWeight.w400,
                              fontSize: 14))
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tranx Ref:',
                        style: TextStyle(
                            fontFamily: 'Mont',
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ),
                      Text(singleTransactionData.txnRef!,
                          style: TextStyle(
                              fontFamily: 'Mont',
                              fontWeight: FontWeight.w400,
                              fontSize: 14))
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Amount',
                        style: TextStyle(
                            fontFamily: 'Mont',
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ),
                      Text("₦${singleTransactionData.amount!}",
                          style: TextStyle(
                              fontFamily: 'Mont',
                              fontWeight: FontWeight.w400,
                              fontSize: 14))
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'User Name',
                        style: TextStyle(
                            fontFamily: 'Mont',
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ),
                      Text(singleTransactionData.userName!,
                          style: TextStyle(
                              fontFamily: 'Mont',
                              fontWeight: FontWeight.w400,
                              fontSize: 14))
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transaction Mode',
                        style: TextStyle(
                            fontFamily: 'Mont',
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ),
                      Text(singleTransactionData.transactionMode!,
                          style: TextStyle(
                              fontFamily: 'Mont',
                              fontWeight: FontWeight.w400,
                              fontSize: 14))
                    ],
                  ),
SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Provider',
                        style: TextStyle(
                            fontFamily: 'Mont',
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ),
                      Text(singleTransactionData.provider!,
                          style: TextStyle(
                              fontFamily: 'Mont',
                              fontWeight: FontWeight.w400,
                              fontSize: 14))
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Date',
                        style: TextStyle(
                            fontFamily: 'Mont',
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ),
                      Text(singleTransactionData.createdAt!,
                          style: TextStyle(
                              fontFamily: 'Mont',
                              fontWeight: FontWeight.w400,
                              fontSize: 14))
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       'Transaction Mode',
                  //       style: TextStyle(
                  //           fontFamily: 'Mont',
                  //           fontWeight: FontWeight.w400,
                  //           fontSize: 14),
                  //     ),
                  //     Text(singleTransactionData.transactionMode!,
                  //         style: TextStyle(
                  //             fontFamily: 'Mont',
                  //             fontWeight: FontWeight.w400,
                  //             fontSize: 14))
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
