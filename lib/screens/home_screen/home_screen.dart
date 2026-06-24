// import 'dart:developer' as myLog;
// import 'package:alert_info/alert_info.dart';
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:jara_market/screens/address_google/address_google.dart';
// import 'package:jara_market/screens/address_google/controller/address_google.dart';
// // import 'package:jara_market/screens/address_google/models/lga_model.dart' as lga;
// import 'package:jara_market/screens/cart_screen/models/models.dart';
// import 'package:jara_market/screens/cart_screen/controller/cart_controller.dart';
// import 'package:jara_market/screens/checkout_address_change/models/lga_model.dart'
//     as lga;
// import 'package:jara_market/screens/checkout_address_change/models/state_model.dart';
// import 'package:jara_market/screens/egusi_soup_detail_screen/egusi_soup_detail_screen.dart';
// import 'package:jara_market/screens/grains_screen/grains_screen.dart';
// import 'package:jara_market/screens/home_screen/controller/home_controller.dart';
// import 'package:jara_market/screens/main_screen/main_screen.dart';
// import 'package:jara_market/screens/wallet_screen/wallet_screen.dart';
// import 'package:jara_market/screens/wallet_screen/controller/wallet_controller.dart';
// import 'package:jara_market/screens/wallet_screen/withdraw_screen.dart';
// import 'package:jara_market/widgets/custom_button.dart';
// import 'package:lucide_icons_flutter/lucide_icons.dart';
// import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
// import '../soup_list_screen/soup_list_screen.dart';

// HomeController controller = Get.put(HomeController());
// AddressGoogleChangeController controller1 =
//     Get.put(AddressGoogleChangeController());
// WalletController walletController = Get.put(WalletController());

// var cartController = Get.put(CartController());

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   // ApiService _apiService = ApiService(Duration(seconds: 60 * 5));
//   // List<dynamic> _foodCategories = [];
//   // List<dynamic> _ingredients = [];
//   // List<dynamic> _foods = [];
//   // bool _isLoading = true;
//   late Map<String, dynamic> userData;
//   bool isSet = false;
//   int _currentIndex = 0;
//   int _quantity = 1;
//   String state = '';

//   final RefreshController _refreshController =
//       RefreshController(initialRefresh: false);

//   void _onRefresh() async {
//     var stateId = await dataBase.getStateAddressId();
//     var lgaId = await dataBase.getLGAAddressId();
//     if (stateId.isNotEmpty) {
//       controller.fetchFoodCategories(lgaId.toString(), stateId);
//     } else {
//       Navigator.push(
//           Get.context!,
//           MaterialPageRoute(
//             builder: (context) => AddressGoogleChangeScreen(),
//           ));
//     }
//   }

//   // Controller for the carousel
//   late CarouselSliderController carouselController;
//   // Timer? _autoSlideTimer;
//   // int _currentPage = 0;
//   // final int _totalItems = 5; // Update this with your actual number of items

//   String? name;

//   // Add search controller and filtered lists
//   final TextEditingController _searchController = TextEditingController();
//   // List<dynamic> _filteredFoodCategories = [];
//   // List<dynamic> _filteredIngredients = [];
//   // List<dynamic> _filteredFoods = [];

//   void getUserName() async {
//     var name1 = await dataBase.getFirstName() ?? 'N/A';
//     if (mounted) {
//       // Added mounted check
//       setState(() {
//         name = name1;
//       });
//     }
//   }

//   void getState() async {
//     var state = await dataBase.getState() ?? 'N/A';
//     if (mounted) {
//       // Added mounted check
//       setState(() {
//         this.state = state;
//       });
//     }
//   }

//   Widget dotIndicator(int index, int lenght) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         SizedBox(
//           height: 20,
//           child: ListView.builder(
//               itemCount: lenght,
//               itemBuilder: (BuildContext, index) {
//                 return AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   curve: Curves.easeInOut,
//                   width: _currentIndex == index ? 18.0 : 10.0,
//                   height: _currentIndex == index ? 10.0 : 10.0,
//                   margin: const EdgeInsets.symmetric(horizontal: 4.0),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5.0),
//                     color: _currentIndex == index
//                         ? Colors.blue
//                         : Colors.grey.withValues(alpha: 0.5),
//                   ),
//                 );
//               }),
//         )
//       ],
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     getUserName();
//     controller.fetchFoodCategoriesByCondition();
//     // Uncomment this when you implement filtering
//     // _searchController.addListener(_filterItems);
//     controller1.fetchStates();
//     getState();
//     walletController.fetchWallet();
//     carouselController = CarouselSliderController();
//     //_startAutoSlide();
//   }

//   // void _startAutoSlide() {
//   //   // Create a timer that updates the carousel every 3 seconds
//   //   _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
//   //     // Move to next slide (with wrap-around)
//   //     _currentPage = (_currentPage + 1) % _totalItems;
//   //     // Update carousel position
//   //     carouselController.animateTo(_currentPage,
//   //         duration: const Duration(seconds: 3), curve: Curves.decelerate);
//   //     // Rebuild the widget to reflect current state
//   //     setState(() {});
//   //   });
//   // }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     try {
//       return Scaffold(
//         body: SafeArea(
//           child: Obx(() {
//             return controller.isLoading.value
//                 ? const Center(
//                     child: CircularProgressIndicator(
//                     color: Color(0xFFFBBC05),
//                   ))
//                 : Column(
//                     children: [
//                       // ElevatedButton(onPressed: (){dataBase.logOut();}, child: Text('clear local db')),
//                       // Header
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(16),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'Hello ${name ?? "User"},',
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           // Wallet Balance Display
//                           // Obx(() {

//                           //   return
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => const WalletScreen(),
//                                 ),
//                               );
//                             },
//                             child: Container(
//                               margin: const EdgeInsets.only(right: 8),
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 12, vertical: 8),
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.rectangle,
//                                 borderRadius: BorderRadius.circular(20),
//                                 color: Color(0xFFFF9800).withOpacity(0.1),
//                               ),
//                               child: Row(
//                                 children: [
//                                   const Icon(
//                                     Icons.wallet,
//                                     size: 18,
//                                     color: Color(0xFFFF9800),
//                                   ),
//                                   const SizedBox(width: 6),
//                                   Text(
//                                     walletController.walletModel.data!.balance
//                                                 .toString()
//                                                 .length >
//                                             3
//                                         ? '₦${walletController.walletModel.data!.balance.toString().substring(0, 3)}K'
//                                         : '₦${walletController.walletModel.data!.balance}',
//                                     style: const TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.bold,
//                                       color: Color(0xFFFF9800),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           //  }),
//                           GestureDetector(
//                             onTap: () {
//                               showModalBottomSheet(
//                                   isDismissible: true,
//                                   enableDrag: true,
//                                   isScrollControlled: true,
//                                   shape: const RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(20),
//                                       topRight: Radius.circular(20),
//                                     ),
//                                   ),
//                                   context: context,
//                                   builder: (context) {
//                                     return Container(
//                                       color: Colors.white,
//                                       height: double.infinity,
//                                       padding: EdgeInsets.all(16),
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Text(
//                                                 'Delivery Address',
//                                                 style: TextStyle(
//                                                     fontSize: 18,
//                                                     fontFamily: 'Poppins'),
//                                               ),
//                                               Container(
//                                                 margin: const EdgeInsets.only(
//                                                     left: 8),
//                                                 padding:
//                                                     const EdgeInsets.all(3),
//                                                 decoration: BoxDecoration(
//                                                   shape: BoxShape.circle,
//                                                   color: Colors.grey[100],
//                                                   //borderRadius:
//                                                   //  BorderRadius.circular(4),
//                                                 ),
//                                                 child: Container(
//                                                   padding:
//                                                       const EdgeInsets.all(2),
//                                                   // margin:
//                                                   //     const EdgeInsets.all(2),
//                                                   // height: 30,
//                                                   // width: 30,
//                                                   child: IconButton(
//                                                     icon: Icon(Icons.close,
//                                                         size: 16),
//                                                     onPressed: () {
//                                                       print('object');
//                                                       Navigator.pop(context);
//                                                     },
//                                                   ),
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                           SizedBox(height: 10),
//                                           // Text('137 Nwanniba Rd,Uyo,Akwa Ibom'),
//                                           // SizedBox(height: 20),
//                                           // CustomButton(
//                                           //     text: 'Change Address',
//                                           //     onPressed: () {
//                                           //       Get.to(() =>
//                                           //           AddressGoogleChangeScreen());
//                                           //     })
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 vertical: 10, horizontal: 0.0),
//                                             child: DropdownSearch<StateData>(
//                                               onChanged: (value) async {
//                                                 setState(() {
//                                                   controller1.selectedState1 =
//                                                       value!.name;
//                                                   controller1.selectedStateId =
//                                                       value.id;
//                                                 });
//                                                 print(
//                                                     'selected item is: ${controller1.selectedState1}');
//                                                 await controller1.fetchLgas(
//                                                     controller1
//                                                         .selectedState1!);
//                                                 myLog.log(
//                                                     'Selected state: ${controller1.selectedState1}');
//                                                 myLog.log(
//                                                     'Selected state ID: ${controller1.selectedStateId}');
//                                                 await dataBase.saveSateAddress(
//                                                     controller1.selectedStateId
//                                                         .toString());
//                                                 await dataBase.saveState(
//                                                     controller1
//                                                         .selectedState1!);
//                                                 setState(() {
//                                                   state = controller1
//                                                       .selectedState1!;
//                                                 });
//                                                 // controller.fetchFoodCategories(
//                                                 //     controller1.selectedStateId
//                                                 //         .toString());
//                                                 // Navigator.pop(context);
//                                               },
//                                               selectedItem:
//                                                   controller1.selectedState,
//                                               suffixProps:
//                                                   DropdownSuffixProps(),
//                                               compareFn: (item1, item2) {
//                                                 return item1 == item2;
//                                               },
//                                               decoratorProps: DropDownDecoratorProps(
//                                                   baseStyle: TextStyle(
//                                                       color: Colors.white),
//                                                   decoration: InputDecoration(
//                                                       filled: true,
//                                                       fillColor:
//                                                           Color(0xffF5F5F5),
//                                                       alignLabelWithHint: true,
//                                                       suffixIconColor:
//                                                           Color(0xFFFF9800),
//                                                       focusedBorder: OutlineInputBorder(
//                                                           borderSide: BorderSide(
//                                                               style: BorderStyle
//                                                                   .solid,
//                                                               color: Color(
//                                                                   0xFFFF9800),
//                                                               width: 1),
//                                                           borderRadius:
//                                                               BorderRadius.all(
//                                                                   Radius.circular(
//                                                                       8))),
//                                                       enabledBorder: OutlineInputBorder(
//                                                           borderSide: BorderSide(
//                                                               style: BorderStyle
//                                                                   .solid,
//                                                               color: Color(0xffD9D9D9),
//                                                               width: 1),
//                                                           borderRadius: BorderRadius.all(Radius.circular(12))),
//                                                       border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, color: Color(0xffD9D9D9), width: 1), borderRadius: BorderRadius.all(Radius.circular(12))))),
//                                               dropdownBuilder:
//                                                   (context, selectedItem) {
//                                                 if (selectedItem != null) {
//                                                   return Text(
//                                                       selectedItem.name!);
//                                                 } else {
//                                                   return Text(
//                                                     'Enter Your State',
//                                                     style: TextStyle(
//                                                       color: Colors.grey[300],
//                                                       fontSize: 16,
//                                                     ),
//                                                   );
//                                                 }
//                                               },
//                                               items: (f, cs) => controller1
//                                                       .isStateLoading.value
//                                                   ? []
//                                                   : controller1.stateDataList,
//                                               itemAsString: (item) {
//                                                 return item.name ?? '';
//                                               },
//                                               popupProps: PopupProps.menu(
//                                                   showSelectedItems: true,
//                                                   searchDelay:
//                                                       Duration(seconds: 0),
//                                                   emptyBuilder:
//                                                       (context, searchEntry) {
//                                                     return controller1
//                                                             .isStateLoading
//                                                             .value
//                                                         ? const Center(
//                                                             child:
//                                                                 CircularProgressIndicator(
//                                                             color: Color(
//                                                                 0xFFFF9800),
//                                                           ))
//                                                         : Center(
//                                                             child: Text(
//                                                               'No states found',
//                                                               style: TextStyle(
//                                                                   color: Colors
//                                                                       .grey,
//                                                                   fontFamily:
//                                                                       'Poppins',
//                                                                   fontSize: 12),
//                                                             ),
//                                                           );
//                                                   },
//                                                   title: Padding(
//                                                     padding:
//                                                         const EdgeInsets.all(
//                                                             8.0),
//                                                     child: Text('Search State',
//                                                         style: TextStyle(
//                                                             fontFamily:
//                                                                 'Poppins',
//                                                             fontSize: 12,
//                                                             color:
//                                                                 Colors.black)),
//                                                   ),
//                                                   onDismissed: () {
//                                                     ScaffoldMessenger.of(
//                                                             context)
//                                                         .showSnackBar(
//                                                       SnackBar(
//                                                           content: Text(
//                                                               "move to the next item")),
//                                                     );
//                                                     myLog.log(
//                                                         'Next items found.');
//                                                   },
//                                                   onItemsLoaded: (value) {
//                                                     myLog.log(
//                                                         'Items loaded: ${value.length} items found.');
//                                                   },
//                                                   scrollbarProps:
//                                                       ScrollbarProps(),
//                                                   showSearchBox: true,
//                                                   searchFieldProps:
//                                                       TextFieldProps(),
//                                                   disabledItemFn: (item) =>
//                                                       item == 'Item 3',
//                                                   fit: FlexFit.loose),
//                                             ),
//                                           ),
// //TODO: LGA starts here
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 vertical: 10, horizontal: 0.0),
//                                             child: DropdownSearch<lga.LgaData>(
//                                               onChanged: (value) async {
//                                                 setState(() {
//                                                   controller1.selectedLGA1 =
//                                                       value!.name;
//                                                   controller1.selectedLGAId =
//                                                       value.id;
//                                                 });
//                                                 print(
//                                                     'selected item is: ${controller1.selectedLGA1}');
//                                                 await controller1.fetchLgas(
//                                                     controller1
//                                                         .selectedState1!);
//                                                 myLog.log(
//                                                     'Selected LGA: ${controller1.selectedLGA1}');
//                                                 myLog.log(
//                                                     'Selected lga ID: ${controller1.selectedLGAId}');
//                                                 await dataBase.saveLGAAddressID(
//                                                     controller1.selectedLGAId!);
//                                                 await dataBase.saveLGAAddress(
//                                                     controller1.selectedLGA1!);
//                                                 setState(() {
//                                                   state =
//                                                       controller1.selectedLGA1!;
//                                                 });
//                                                 controller.fetchFoodCategories(
//                                                     controller1.selectedLGAId
//                                                         .toString(),
//                                                     controller1.selectedStateId
//                                                         .toString());
//                                                 Navigator.pop(context);
//                                               },
//                                               selectedItem:
//                                                   controller1.selectedLGA,
//                                               suffixProps:
//                                                   DropdownSuffixProps(),
//                                               compareFn: (item1, item2) {
//                                                 return item1 == item2;
//                                               },
//                                               decoratorProps: DropDownDecoratorProps(
//                                                   baseStyle: TextStyle(
//                                                       color: Colors.white),
//                                                   decoration: InputDecoration(
//                                                       filled: true,
//                                                       fillColor:
//                                                           Color(0xffF5F5F5),
//                                                       alignLabelWithHint: true,
//                                                       suffixIconColor:
//                                                           Color(0xFFFF9800),
//                                                       focusedBorder: OutlineInputBorder(
//                                                           borderSide: BorderSide(
//                                                               style: BorderStyle
//                                                                   .solid,
//                                                               color: Color(
//                                                                   0xFFFF9800),
//                                                               width: 1),
//                                                           borderRadius:
//                                                               BorderRadius.all(
//                                                                   Radius.circular(
//                                                                       8))),
//                                                       enabledBorder: OutlineInputBorder(
//                                                           borderSide: BorderSide(
//                                                               style: BorderStyle
//                                                                   .solid,
//                                                               color: Color(0xffD9D9D9),
//                                                               width: 1),
//                                                           borderRadius: BorderRadius.all(Radius.circular(12))),
//                                                       border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, color: Color(0xffD9D9D9), width: 1), borderRadius: BorderRadius.all(Radius.circular(12))))),
//                                               dropdownBuilder:
//                                                   (context, selectedItem) {
//                                                 if (selectedItem != null) {
//                                                   return Text(
//                                                       selectedItem.name!);
//                                                 } else {
//                                                   return Text(
//                                                     'Enter Your LGA',
//                                                     style: TextStyle(
//                                                       color: Colors.grey[300],
//                                                       fontSize: 16,
//                                                     ),
//                                                   );
//                                                 }
//                                               },
//                                               items: (f, cs) =>
//                                                   controller1.isLgaLoading.value
//                                                       ? []
//                                                       : controller1.lgaDataList,
//                                               itemAsString: (item) {
//                                                 return item.name ?? '';
//                                               },
//                                               popupProps: PopupProps.menu(
//                                                   showSelectedItems: true,
//                                                   searchDelay:
//                                                       Duration(seconds: 0),
//                                                   emptyBuilder:
//                                                       (context, searchEntry) {
//                                                     return controller1
//                                                             .isLgaLoading.value
//                                                         ? const Center(
//                                                             child:
//                                                                 CircularProgressIndicator(
//                                                             color: Color(
//                                                                 0xFFFF9800),
//                                                           ))
//                                                         : Center(
//                                                             child: Text(
//                                                               'No LGA found',
//                                                               style: TextStyle(
//                                                                   color: Colors
//                                                                       .grey,
//                                                                   fontFamily:
//                                                                       'Poppins',
//                                                                   fontSize: 12),
//                                                             ),
//                                                           );
//                                                   },
//                                                   title: Padding(
//                                                     padding:
//                                                         const EdgeInsets.all(
//                                                             8.0),
//                                                     child: Text('Search LGA',
//                                                         style: TextStyle(
//                                                             fontFamily:
//                                                                 'Poppins',
//                                                             fontSize: 12,
//                                                             color:
//                                                                 Colors.black)),
//                                                   ),
//                                                   onDismissed: () {
//                                                     ScaffoldMessenger.of(
//                                                             context)
//                                                         .showSnackBar(
//                                                       SnackBar(
//                                                           content: Text(
//                                                               "move to the next item")),
//                                                     );
//                                                     myLog.log(
//                                                         'Next items found.');
//                                                   },
//                                                   onItemsLoaded: (value) {
//                                                     myLog.log(
//                                                         'Items loaded: ${value.length} items found.');
//                                                   },
//                                                   scrollbarProps:
//                                                       ScrollbarProps(),
//                                                   showSearchBox: true,
//                                                   searchFieldProps:
//                                                       TextFieldProps(),
//                                                   disabledItemFn: (item) =>
//                                                       item == 'Item 3',
//                                                   fit: FlexFit.loose),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   });
//                             },
//                             child: Container(
//                               margin: const EdgeInsets.only(right: 16),
//                               padding: const EdgeInsets.all(8),
//                               // width: 40,
//                               // height: 40,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.rectangle,
//                                 borderRadius: BorderRadius.circular(30),
//                                 color: Colors.grey[100],
//                               ),
//                               child: Row(
//                                 children: [
//                                   const Icon(LucideIcons.chevronDown, size: 20),
//                                   Text(
//                                     state.length > 15
//                                         ? '${state.substring(0, 15)}...'
//                                         : state,
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       fontFamily: 'Poppins',
//                                       fontWeight: FontWeight.w400,
//                                       color: Colors.grey[800],
//                                     ),
//                                   ),
//                                   const Icon(
//                                     LucideIcons.mapPinCheckInside500,
//                                     size: 20,
//                                     color: Color(0xFFFF9800),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),

//                       // Search Bar
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         child: TextField(
//                           controller: _searchController,
//                           decoration: InputDecoration(
//                             hintText: 'Search foods, ingredients...',
//                             prefixIcon: const Icon(Icons.search),
//                             suffixIcon: _searchController.text.isNotEmpty
//                                 ? IconButton(
//                                     icon: const Icon(Icons.clear),
//                                     onPressed: () {
//                                       _searchController.clear();
//                                       controller.clearSearch();
//                                     },
//                                   )
//                                 : null,
//                             filled: true,
//                             fillColor: Colors.grey[100],
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: BorderSide.none,
//                             ),
//                           ),
//                           onSubmitted: (value) async {
//                             if (value.isNotEmpty) {
//                               var stateId = await dataBase.getStateAddressId();
//                               if (stateId.isNotEmpty) {
//                                 controller.searchProducts(value, stateId);
//                               }
//                             } else {
//                               controller.clearSearch();
//                             }
//                           },
//                         ),
//                       ),
//                       //  CustomButton(text: 'Shop Ingredient', onPressed: () {}),
//                       // Category sections inside ListView
//                       Expanded(
//                         child: Obx(() {
//                           if (controller.isSearching.value) {
//                             return controller.isLoading.value
//                                 ? const Center(
//                                     child: CircularProgressIndicator(
//                                       color: Color(0xFFFBBC05),
//                                     ),
//                                   )
//                                 : ListView.builder(
//                                     itemCount: controller.searchResults.length,
//                                     itemBuilder: (context, index) {
//                                       var product =
//                                           controller.searchResults[index];
//                                       return ListTile(
//                                         title: Text(product.name ?? ''),
//                                         subtitle:
//                                             Text('₦${product.price ?? ''}'),
//                                         leading: product.imageUrl != null &&
//                                                 product.imageUrl!.isNotEmpty
//                                             ? CachedNetworkImage(
//                                                 imageUrl: product.imageUrl!,
//                                                 width: 50,
//                                                 height: 50,
//                                                 fit: BoxFit.cover,
//                                                 placeholder: (context, url) =>
//                                                     CircularProgressIndicator(),
//                                                 errorWidget:
//                                                     (context, url, error) =>
//                                                         Icon(Icons.error),
//                                               )
//                                             : Icon(Icons.image),
//                                         onTap: () {
//                                           // Navigate to product detail if needed
//                                         },
//                                       );
//                                     },
//                                   );
//                           } else {
//                             return SmartRefresher(
//                               controller: _refreshController,
//                               onRefresh: _onRefresh,
//                               child: ListView.separated(
//                                 physics: BouncingScrollPhysics(),
//                                 itemCount: controller.category.length + 2,
//                                 separatorBuilder: (context, index) {
//                                   if (index == 0) {
//                                     return SizedBox(height: 24);
//                                   }
//                                   return Divider(
//                                     height: 24,
//                                     thickness: 0.5,
//                                     color: Colors.grey[400],
//                                   );
//                                 },
//                                 itemBuilder: (context, sectionIndex) {
//                                   // Section 0: Shop for Ingredient Button
//                                   if (sectionIndex == 0) {
//                                     return Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 16),
//                                       child: SizedBox(
//                                         height: 94,
//                                         child: Column(
//                                           children: [
//                                             Text(
//                                               'Shop for fresh ingredients, we deliver in minutes, You can\'t go wrong with Jara.',
//                                               style: TextStyle(
//                                                 fontFamily: 'Monts',
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.w400,
//                                               ),
//                                             ),
//                                             SizedBox(height: 10),
//                                             SizedBox(
//                                               height: 50,
//                                               child: CustomButton(
//                                                 text: 'Shop For Ingredient',
//                                                 onPressed: () async {
//                                                   var token =
//                                                       await dataBase.getToken();
//                                                   print(token);
//                                                   Navigator.push(
//                                                     context,
//                                                     CupertinoPageRoute(
//                                                       builder: (context) =>
//                                                           const GrainsScreen(
//                                                         forProduct: false,
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   }
//                                   // Section 1: First Category
//                                   if (sectionIndex == 1) {
//                                     if (controller.category.isEmpty) {
//                                       return SizedBox.shrink();
//                                     }
//                                     return _buildCategorySection(0);
//                                   }
//                                   // Section 2: Second Category
//                                   if (sectionIndex == 2) {
//                                     if (controller.category.length < 2) {
//                                       return SizedBox.shrink();
//                                     }
//                                     return _buildCategorySection(1);
//                                   }
//                                   // Section 3: Carousel
//                                   if (sectionIndex == 3) {
//                                     return Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       children: [
//                                         SizedBox(
//                                           height: 154,
//                                           child: CarouselSlider(
//                                             carouselController:
//                                                 carouselController,
//                                             options: CarouselOptions(
//                                               height: 200.0,
//                                               viewportFraction: 0.8,
//                                               initialPage: 0,
//                                               enableInfiniteScroll: true,
//                                               reverse: false,
//                                               autoPlay: true,
//                                               autoPlayInterval:
//                                                   const Duration(seconds: 3),
//                                               autoPlayAnimationDuration:
//                                                   const Duration(
//                                                       milliseconds: 800),
//                                               autoPlayCurve:
//                                                   Curves.fastOutSlowIn,
//                                               enlargeCenterPage: true,
//                                               scrollDirection: Axis.horizontal,
//                                               onPageChanged: (index, reason) {
//                                                 setState(() {
//                                                   _currentIndex = index;
//                                                 });
//                                               },
//                                             ),
//                                             items: [
//                                               _buildCarouselItem(
//                                                   '14%', context),
//                                               _buildCarouselItem(
//                                                   '15%', context),
//                                               _buildCarouselItem(
//                                                   '16%', context),
//                                               _buildCarouselItem(
//                                                   '17%', context),
//                                               _buildCarouselItem(
//                                                   '18%', context),
//                                             ],
//                                           ),
//                                         ),
//                                         SizedBox(height: 10),
//                                         // Dot Indicators
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: List.generate(
//                                             5,
//                                             (index) => GestureDetector(
//                                               onTap: () {
//                                                 carouselController
//                                                     .animateToPage(index);
//                                               },
//                                               child: AnimatedContainer(
//                                                 duration: const Duration(
//                                                     milliseconds: 300),
//                                                 curve: Curves.easeInOut,
//                                                 width: _currentIndex == index
//                                                     ? 12.0
//                                                     : 7.0,
//                                                 height: 7.0,
//                                                 margin:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 4.0),
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           5.0),
//                                                   color: _currentIndex == index
//                                                       ? Colors.blue
//                                                       : Colors.grey.withValues(
//                                                           alpha: 0.5),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     );
//                                   }
//                                   // Sections 4+: Remaining Categories
//                                   int categoryIndex;
//                                   if (sectionIndex >= 4) {
//                                     categoryIndex = sectionIndex - 2;
//                                   } else {
//                                     return SizedBox.shrink();
//                                   }
//                                   if (categoryIndex < 0 ||
//                                       categoryIndex >=
//                                           controller.category.length) {
//                                     return SizedBox.shrink();
//                                   }
//                                   return _buildCategorySection(categoryIndex);
//                                 },
//                               ),
//                             );
//                           }
//                         }),
//                       ),
//                     ],
//                   );
//           }),
//         ),
//       );
//     } catch (e, stackTrace) {
//       print('Error building home screen: $e');
//       print('Stack Trace: $stackTrace');
//       return Scaffold(
//         body: Center(
//           child: Text('Error loading screen: $e'),
//         ),
//       );
//     }
//   }

// // Add this method to your _HomeScreenState class
//   Widget _buildCategorySection(int categoryIndex) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Category Header
//           Padding(
//             padding: EdgeInsets.symmetric(vertical: 8.0),
//             child: Row(
//               children: [
//                 Text(
//                   controller.category[categoryIndex].name.toString(),
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontFamily: 'Roboto',
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 Spacer(),
//                 if (controller.category[categoryIndex].products!.length > 3)
//                   InkWell(
//                     onTap: () {
//                       print(
//                           'Tapped on See All for category: ${controller.category[categoryIndex].name}');
//                       Get.to(() => SoupListScreen(
//                           item: controller.category[categoryIndex]));
//                     },
//                     child: Row(
//                       children: [
//                         Text(
//                           'See All',
//                           style: TextStyle(
//                             fontSize: 10,
//                             fontFamily: 'Roboto',
//                             fontWeight: FontWeight.w400,
//                             color: Color(0xffCC6522),
//                           ),
//                         ),
//                         Icon(
//                           Icons.arrow_forward_ios,
//                           size: 10,
//                           color: Color(0xffCC6522),
//                         )
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           ),
//           SizedBox(height: 10),

//           // Products Grid
//           controller.category[categoryIndex].products!.isEmpty
//               ? Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       'Food Not Available for this Category!!!',
//                       style: TextStyle(
//                         color: Colors.grey[400],
//                         fontFamily: 'Roboto',
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   ),
//                 )
//               : SizedBox(
//                   height:
//                       (controller.category[categoryIndex].products!.length / 4)
//                               .ceil() *
//                           70.0,
//                   child: GridView.builder(
//                     physics: NeverScrollableScrollPhysics(),
//                     itemCount:
//                         controller.category[categoryIndex].products!.length > 8
//                             ? 8
//                             : controller
//                                 .category[categoryIndex].products!.length,
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 4,
//                       crossAxisSpacing: 4.0,
//                       mainAxisSpacing: 7.0,
//                       childAspectRatio: 1.2,
//                     ),
//                     itemBuilder: (context, index) {
//                       final category =
//                           controller.category[categoryIndex].products;

//                       return GestureDetector(
//                         onTap: () {
//                           _showProductDialog(context, category!, index);
//                         },
//                         child: Column(
//                           children: [
//                             Container(
//                               padding: EdgeInsets.all(
//                                 category![index].imageUrl != null ? 0 : 5,
//                               ),
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.grey[200],
//                               ),
//                               child: Center(
//                                 child: category[index].imageUrl != null
//                                     ? ClipRRect(
//                                         borderRadius: BorderRadius.circular(20),
//                                         child: CachedNetworkImage(
//                                           imageUrl: category[index]
//                                               .imageUrl
//                                               .toString(),
//                                           placeholder: (context, url) =>
//                                               const Padding(
//                                             padding: EdgeInsets.all(8.0),
//                                             child: Center(
//                                               child: SpinKitPulse(
//                                                 color: Color(0xFFFF9800),
//                                                 size: 24.0,
//                                               ),
//                                             ),
//                                           ),
//                                           errorWidget: (context, url, error) =>
//                                               const Icon(Icons.error),
//                                           width: 40,
//                                           height: 40,
//                                           fit: BoxFit.cover,
//                                         ),
//                                       )
//                                     : SvgPicture.asset(
//                                         'assets/images/product_image.svg'),
//                               ),
//                             ),
//                             SizedBox(height: 5),
//                             Text(
//                               category[index].name.toString().length > 10
//                                   ? '${category[index].name!.substring(0, 7)}...'
//                                   : category[index].name.toString(),
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w400,
//                                 fontFamily: 'Roboto',
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//         ],
//       ),
//     );
//   }

// // Build carousel item
//   Widget _buildCarouselItem(String discount, BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: MediaQuery.of(context).size.height * 154,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         color: Color(0xFFFBBC05),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'MIN $discount\nOFF',
//               style: TextStyle(
//                 fontWeight: FontWeight.w700,
//                 fontSize: 24,
//                 color: Color(0xff3F1405),
//               ),
//             ),
//             SizedBox(height: 8),
//             SizedBox(
//               height: 28,
//               width: 90,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//                   backgroundColor: Color(0xffCC6522),
//                   foregroundColor: Color(0xffffffff),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ),
//                 onPressed: () {},
//                 child: Text(
//                   'SHOP NOW',
//                   style: TextStyle(color: Colors.white, fontSize: 8),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // // Build carousel item
//   // Widget _buildCarouselItem(String discount, BuildContext context) {
//   //   return Container(
//   //     width: double.infinity,
//   //     height: MediaQuery.of(context).size.height * 154,
//   //     decoration: BoxDecoration(
//   //       borderRadius: BorderRadius.circular(15),
//   //       color: Color(0xFFFBBC05),
//   //     ),
//   //     child: Padding(
//   //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
//   //       child: Column(
//   //         mainAxisAlignment: MainAxisAlignment.start,
//   //         crossAxisAlignment: CrossAxisAlignment.start,
//   //         children: [
//   //           Text(
//   //             'MIN $discount\nOFF',
//   //             style: TextStyle(
//   //               fontWeight: FontWeight.w700,
//   //               fontSize: 24,
//   //               color: Color(0xff3F1405),
//   //             ),
//   //           ),
//   //           SizedBox(height: 8),
//   //           SizedBox(
//   //             height: 28,
//   //             width: 90,
//   //             child: ElevatedButton(
//   //               style: ElevatedButton.styleFrom(
//   //                 padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//   //                 backgroundColor: Color(0xffCC6522),
//   //                 foregroundColor: Color(0xffffffff),
//   //                 shape: RoundedRectangleBorder(
//   //                   borderRadius: BorderRadius.circular(4),
//   //                 ),
//   //               ),
//   //               onPressed: () {},
//   //               child: Text(
//   //                 'SHOP NOW',
//   //                 style: TextStyle(color: Colors.white, fontSize: 8),
//   //               ),
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }

// // Show product dialog
//   void _showProductDialog(BuildContext context, List category, int index) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Dialog(
//               backgroundColor: Colors.transparent,
//               child: Container(
//                 width: double.infinity,
//                 height: 420,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     // Product Image
//                     Container(
//                       decoration: BoxDecoration(color: Colors.transparent),
//                       width: double.infinity,
//                       height: 150,
//                       child: Container(
//                         child: category[index].imageUrl != null
//                             ? ClipRRect(
//                                 borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(20),
//                                   topRight: Radius.circular(20),
//                                 ),
//                                 child: CachedNetworkImage(
//                                   imageUrl: category[index].imageUrl.toString(),
//                                   placeholder: (context, url) => const Padding(
//                                     padding: EdgeInsets.all(8.0),
//                                     child: Center(
//                                       child: SpinKitPulse(
//                                         color: Color(0xFFFF9800),
//                                         size: 24.0,
//                                       ),
//                                     ),
//                                   ),
//                                   errorWidget: (context, url, error) =>
//                                       const Icon(Icons.error),
//                                   width: context.width * 0.9,
//                                   height: 40,
//                                   fit: BoxFit.cover,
//                                 ),
//                               )
//                             : SvgPicture.asset(
//                                 'assets/images/product_image.svg'),
//                       ),
//                     ),

//                     // Product Details
//                     Container(
//                       padding: EdgeInsets.all(8),
//                       height: 256,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.only(
//                           bottomLeft: Radius.circular(20),
//                           bottomRight: Radius.circular(20),
//                         ),
//                         color: Colors.white,
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               SizedBox(
//                                 width: context.width * 0.5,
//                                 child: Text(
//                                   maxLines: 2,
//                                   '${category[index].name}',
//                                   style: TextStyle(
//                                     color: Color(0xff1F2937),
//                                     fontFamily: 'Inter',
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                               ),
//                               Spacer(),
//                               Text('2.5k orders'),
//                             ],
//                           ),
//                           SizedBox(height: 10),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Text(
//                                         '${category[index].ingredients!.length} ingredients',
//                                         style: TextStyle(
//                                           color: Color(0xff1F2937),
//                                           fontFamily: 'Inter',
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w400,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(height: 10),
//                                   Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Text(
//                                             '\u20A6${category[index].price} Per Portion',
//                                             style: TextStyle(
//                                               color: Color(0xff1F2937),
//                                               fontFamily: 'Roboto',
//                                               fontSize: 12,
//                                               fontWeight: FontWeight.w400,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             '\u20A6${double.parse(category[index].price) * _quantity} Total Price',
//                                             style: TextStyle(
//                                               color: Color(0xff1F2937),
//                                               fontFamily: 'Roboto',
//                                               fontSize: 12,
//                                               fontWeight: FontWeight.w400,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                               Column(
//                                 children: [
//                                   Text(
//                                     'Quantity',
//                                     style: TextStyle(
//                                       color: Color(0xff1F2937),
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w400,
//                                       fontFamily: 'Inter',
//                                     ),
//                                   ),
//                                   Row(
//                                     children: [
//                                       IconButton(
//                                         icon: SvgPicture.asset(
//                                             'assets/images/removepreview.svg'),
//                                         onPressed: () {
//                                           setState(() {
//                                             _quantity =
//                                                 (_quantity - 1).clamp(1, 99);
//                                           });
//                                         },
//                                         color: Colors.black,
//                                       ),
//                                       Container(
//                                         padding: EdgeInsets.symmetric(
//                                             vertical: 5, horizontal: 10),
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                           border: Border.all(
//                                               width: 0.5,
//                                               color: Color(0xffF9F9F9)),
//                                         ),
//                                         child: Text(
//                                           _quantity.toString(),
//                                           style: const TextStyle(
//                                             color: Color(0xff262626),
//                                             fontSize: 12,
//                                             fontFamily: 'Inter',
//                                             fontWeight: FontWeight.w400,
//                                           ),
//                                         ),
//                                       ),
//                                       IconButton(
//                                         icon: SvgPicture.asset(
//                                             'assets/images/addpreview.svg'),
//                                         onPressed: () {
//                                           setState(() {
//                                             _quantity =
//                                                 (_quantity + 1).clamp(1, 99);
//                                           });
//                                         },
//                                         color: Colors.black,
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(height: 15),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           Spacer(),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Expanded(
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     cartController.addToCart(CartItem(
//                                       id: category[index].id!,
//                                       name: category[index].name!,
//                                       description:
//                                           category[index].description ?? 'N/A',
//                                       price: double.tryParse(category[index]
//                                               .price!
//                                               .toString()) ??
//                                           0.0,
//                                       originalPrice: double.tryParse(
//                                               category[index]
//                                                   .price!
//                                                   .toString()) ??
//                                           0.0,
//                                       ingredients: (category[index].ingredients
//                                               as List<dynamic>)
//                                           .map((ingredient) => Ingredients(
//                                                 basePrice: double.tryParse(
//                                                         ingredient.price
//                                                             .toString()) ??
//                                                     0.0,
//                                                 id: ingredient.id!,
//                                                 name: ingredient.name,
//                                                 description:
//                                                     ingredient.description,
//                                                 price: double.tryParse(
//                                                         ingredient.price
//                                                             .toString()) ??
//                                                     0.0,
//                                               ))
//                                           .toList(),
//                                     ));
//                                     // Get.snackbar(
//                                     //     'Success', 'Item added to cart',
//                                     //     colorText: Colors.white,
//                                     //     backgroundColor: Colors.green);
//                                     AlertInfo.show(
//                                         context: context,
//                                         text: 'Item added to cart',
//                                         //  backgroundColor: Colors.green,
//                                         textColor: Colors.white);
//                                     Navigator.pop(context);
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.orange,
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 16),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                   ),
//                                   child: const Text(
//                                     'Add to Cart',
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       fontFamily: 'Inter',
//                                       color: Color(0xff090909),
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 10),
//                               Expanded(
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                     Navigator.of(context).push(
//                                         CupertinoPageRoute(
//                                             builder: (context) =>
//                                                 FoodDetailScreen(
//                                                   item: category[index],
//                                                 )));
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.orange,
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 16),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                   ),
//                                   child: const Text(
//                                     'GET INGREDIENT',
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       fontFamily: 'Inter',
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 40),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }

import 'dart:developer' as myLog;
import 'package:alert_info/alert_info.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/address_google/address_google.dart';
import 'package:jara_market/screens/address_google/controller/address_google.dart';
import 'package:jara_market/screens/cart_screen/models/models.dart';
import 'package:jara_market/screens/cart_screen/controller/cart_controller.dart';
import 'package:jara_market/screens/checkout_address_change/models/lga_model.dart'
    as lga;
import 'package:jara_market/screens/checkout_address_change/models/state_model.dart';
import 'package:jara_market/screens/egusi_soup_detail_screen/egusi_soup_detail_screen.dart';
import 'package:jara_market/screens/grains_screen/grains_screen.dart';
import 'package:jara_market/screens/home_screen/confetti.dart';
import 'package:jara_market/screens/home_screen/controller/home_controller.dart';
import 'package:jara_market/screens/main_screen/main_screen.dart';
import 'package:jara_market/screens/wallet_screen/wallet_screen.dart';
import 'package:jara_market/screens/wallet_screen/controller/wallet_controller.dart';
import 'package:jara_market/screens/wallet_screen/withdraw_screen.dart';
import 'package:jara_market/widgets/custom_button.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../soup_list_screen/soup_list_screen.dart';

HomeController controller = Get.put(HomeController());
AddressGoogleChangeController controller1 =
    Get.put(AddressGoogleChangeController());
WalletController walletController = Get.put(WalletController());

var cartController = Get.put(CartController());

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Map<String, dynamic> userData;
  bool isSet = false;
  int _currentIndex = 0;
  int _quantity = 1;
  String state = '';

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    var stateId = await dataBase.getStateAddressId();
    var lgaId = await dataBase.getLGAAddressId();
    if (stateId.isNotEmpty) {
      controller.fetchFoodCategories(lgaId.toString(), stateId);
    } else {
      Navigator.push(
          Get.context!,
          MaterialPageRoute(
            builder: (context) => AddressGoogleChangeScreen(),
          ));
    }
  }

  late CarouselSliderController carouselController;

  String? name;
  String lgax = 'N/A';

  final TextEditingController _searchController = TextEditingController();

  void setLGA() async {
    var lga1 = await dataBase.getLGAAddress();
    setState(() {
      lgax = lga1;
    });
  }

  void getUserName() async {
    var name1 = await dataBase.getFirstName() ?? 'N/A';
    if (mounted) {
      setState(() {
        name = name1;
      });
    }
  }

  void getState() async {
    var state = await dataBase.getState() ?? 'N/A';
    if (mounted) {
      setState(() {
        this.state = state;
      });
    }
  }

  Widget dotIndicator(int index, int lenght) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 20,
          child: ListView.builder(
              itemCount: lenght,
              itemBuilder: (BuildContext, index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: _currentIndex == index ? 18.0 : 10.0,
                  height: _currentIndex == index ? 10.0 : 10.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: _currentIndex == index
                        ? Colors.blue
                        : Colors.grey.withValues(alpha: 0.5),
                  ),
                );
              }),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    getUserName();
    controller.fetchFoodCategoriesByCondition();
    _searchController.addListener(_onSearchChanged);
    controller1.fetchStates();
    getState();
    walletController.fetchWallet();
    setLGA();
    carouselController = CarouselSliderController();
  }

  void _onSearchChanged() {
    // Rebuild to show/hide the clear (X) icon reactively
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        body: SafeArea(
          child: Obx(() {
            return controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Color(0xFFFBBC05),
                  ))
                : Column(
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(() => GiftAnimationScreen());
                                },
                                child: Text(
                                  'Hello ${name ?? "User"},',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          // Wallet Balance
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const WalletScreen(),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xFFFF9800).withOpacity(0.1),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.wallet,
                                    size: 18,
                                    color: Color(0xFFFF9800),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    walletController.walletModel.data!.balance
                                                .toString()
                                                .length >
                                            3
                                        ? '₦${walletController.walletModel.data!.balance.toString().substring(0, 3)}K'
                                        : '₦${walletController.walletModel.data!.balance}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFF9800),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Location picker
                          GestureDetector(
                            onTap: () {
                              controller1.fetchCountries();
                              showModalBottomSheet(
                                  isDismissible: true,
                                  enableDrag: true,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      color: Colors.white,
                                      height: double.infinity,
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Delivery Address',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'Poppins'),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 8),
                                                padding:
                                                    const EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey[100],
                                                ),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  child: IconButton(
                                                    icon: Icon(Icons.close,
                                                        size: 16),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          // State dropdown
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 0.0),
                                            child: DropdownSearch<StateData>(
                                              onChanged: (value) async {
                                                setState(() {
                                                  controller1.selectedState1 =
                                                      value!.name;
                                                  controller1.selectedStateId =
                                                      value.id;
                                                });
                                                await controller1.fetchLgas(
                                                    controller1
                                                        .selectedState1!);
                                                myLog.log(
                                                    'Selected state: ${controller1.selectedState1}');
                                                myLog.log(
                                                    'Selected state ID: ${controller1.selectedStateId}');
                                                await dataBase.saveSateAddress(
                                                    controller1.selectedStateId
                                                        .toString());
                                                await dataBase.saveState(
                                                    controller1
                                                        .selectedState1!);
                                                setState(() {
                                                  state = controller1
                                                      .selectedState1!;
                                                });
                                              },
                                              selectedItem:
                                                  controller1.selectedState,
                                              suffixProps:
                                                  DropdownSuffixProps(),
                                              compareFn: (item1, item2) {
                                                return item1 == item2;
                                              },
                                              decoratorProps: DropDownDecoratorProps(
                                                  baseStyle: TextStyle(
                                                      color: Colors.white),
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor:
                                                          Color(0xffF5F5F5),
                                                      alignLabelWithHint: true,
                                                      suffixIconColor:
                                                          Color(0xFFFF9800),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              style: BorderStyle
                                                                  .solid,
                                                              color: Color(
                                                                  0xFFFF9800),
                                                              width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      8))),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              style: BorderStyle
                                                                  .solid,
                                                              color: Color(0xffD9D9D9),
                                                              width: 1),
                                                          borderRadius: BorderRadius.all(Radius.circular(12))),
                                                      border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, color: Color(0xffD9D9D9), width: 1), borderRadius: BorderRadius.all(Radius.circular(12))))),
                                              dropdownBuilder:
                                                  (context, selectedItem) {
                                                if (selectedItem != null) {
                                                  return Text(
                                                      selectedItem.name!);
                                                } else {
                                                  return Text(
                                                    'Enter Your State',
                                                    style: TextStyle(
                                                      color: Colors.grey[300],
                                                      fontSize: 16,
                                                    ),
                                                  );
                                                }
                                              },
                                              items: (f, cs) => controller1
                                                      .isStateLoading.value
                                                  ? []
                                                  : controller1.stateDataList,
                                              itemAsString: (item) {
                                                return item.name ?? '';
                                              },
                                              popupProps: PopupProps.menu(
                                                  showSelectedItems: true,
                                                  searchDelay:
                                                      Duration(seconds: 0),
                                                  emptyBuilder:
                                                      (context, searchEntry) {
                                                    return controller1
                                                            .isStateLoading
                                                            .value
                                                        ? const Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                            color: Color(
                                                                0xFFFF9800),
                                                          ))
                                                        : Center(
                                                            child: Text(
                                                              'No states found',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize: 12),
                                                            ),
                                                          );
                                                  },
                                                  title: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text('Search State',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                  onDismissed: () {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              "move to the next item")),
                                                    );
                                                    myLog.log(
                                                        'Next items found.');
                                                  },
                                                  onItemsLoaded: (value) {
                                                    myLog.log(
                                                        'Items loaded: ${value.length} items found.');
                                                  },
                                                  scrollbarProps:
                                                      ScrollbarProps(),
                                                  showSearchBox: true,
                                                  searchFieldProps:
                                                      TextFieldProps(),
                                                  disabledItemFn: (item) =>
                                                      item == 'Item 3',
                                                  fit: FlexFit.loose),
                                            ),
                                          ),
                                          // LGA dropdown
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 0.0),
                                            child: DropdownSearch<lga.LgaData>(
                                              onChanged: (value) async {
                                                setState(() {
                                                  controller1.selectedLGA1 =
                                                      value!.name;
                                                  controller1.selectedLGAId =
                                                      value.id;
                                                });
                                                await controller1.fetchLgas(
                                                    controller1
                                                        .selectedState1!);
                                                myLog.log(
                                                    'Selected LGA: ${controller1.selectedLGA1}');
                                                myLog.log(
                                                    'Selected lga ID: ${controller1.selectedLGAId}');
                                                await dataBase.saveLGAAddressID(
                                                    controller1.selectedLGAId!);
                                                await dataBase.saveLGAAddress(
                                                    controller1.selectedLGA1!);
                                                setState(() {
                                                  state =
                                                      controller1.selectedLGA1!;
                                                });
                                                controller.fetchFoodCategories(
                                                    controller1.selectedLGAId
                                                        .toString(),
                                                    controller1.selectedStateId
                                                        .toString());
                                                Navigator.pop(context);
                                              },
                                              selectedItem:
                                                  controller1.selectedLGA,
                                              suffixProps:
                                                  DropdownSuffixProps(),
                                              compareFn: (item1, item2) {
                                                return item1 == item2;
                                              },
                                              decoratorProps: DropDownDecoratorProps(
                                                  baseStyle: TextStyle(
                                                      color: Colors.white),
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor:
                                                          Color(0xffF5F5F5),
                                                      alignLabelWithHint: true,
                                                      suffixIconColor:
                                                          Color(0xFFFF9800),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              style: BorderStyle
                                                                  .solid,
                                                              color: Color(
                                                                  0xFFFF9800),
                                                              width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      8))),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              style: BorderStyle
                                                                  .solid,
                                                              color: Color(0xffD9D9D9),
                                                              width: 1),
                                                          borderRadius: BorderRadius.all(Radius.circular(12))),
                                                      border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, color: Color(0xffD9D9D9), width: 1), borderRadius: BorderRadius.all(Radius.circular(12))))),
                                              dropdownBuilder:
                                                  (context, selectedItem) {
                                                if (selectedItem != null) {
                                                  return Text(
                                                      selectedItem.name!);
                                                } else {
                                                  return Text(
                                                    'Enter Your LGA',
                                                    style: TextStyle(
                                                      color: Colors.grey[300],
                                                      fontSize: 16,
                                                    ),
                                                  );
                                                }
                                              },
                                              items: (f, cs) =>
                                                  controller1.isLgaLoading.value
                                                      ? []
                                                      : controller1.lgaDataList,
                                              itemAsString: (item) {
                                                return item.name ?? '';
                                              },
                                              popupProps: PopupProps.menu(
                                                  showSelectedItems: true,
                                                  searchDelay:
                                                      Duration(seconds: 0),
                                                  emptyBuilder:
                                                      (context, searchEntry) {
                                                    return controller1
                                                            .isLgaLoading.value
                                                        ? const Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                            color: Color(
                                                                0xFFFF9800),
                                                          ))
                                                        : Center(
                                                            child: Text(
                                                              'No LGA found',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize: 12),
                                                            ),
                                                          );
                                                  },
                                                  title: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text('Search LGA',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                  onDismissed: () {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              "move to the next item")),
                                                    );
                                                    myLog.log(
                                                        'Next items found.');
                                                  },
                                                  onItemsLoaded: (value) {
                                                    myLog.log(
                                                        'Items loaded: ${value.length} items found.');
                                                  },
                                                  scrollbarProps:
                                                      ScrollbarProps(),
                                                  showSearchBox: true,
                                                  searchFieldProps:
                                                      TextFieldProps(),
                                                  disabledItemFn: (item) =>
                                                      item == 'Item 3',
                                                  fit: FlexFit.loose),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 16),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.grey[100],
                              ),
                              child: Row(
                                children: [
                                  const Icon(LucideIcons.chevronDown, size: 20),
                                  Text(
                                    state.length > 15
                                        ? '${state.substring(0, 15)}...'
                                        : state,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  const Icon(
                                    LucideIcons.mapPinCheckInside500,
                                    size: 20,
                                    color: Color(0xFFFF9800),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Search Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search foods, ingredients...',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _searchController.clear();
                                      controller.clearSearch();
                                    },
                                  )
                                : null,
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) {
                            // Trigger search live as user types
                            if (value.isNotEmpty) {
                              _triggerSearch(value);
                            } else {
                              controller.clearSearch();
                            }
                          },
                          onSubmitted: (value) async {
                            if (value.isNotEmpty) {
                              _triggerSearch(value);
                            } else {
                              controller.clearSearch();
                            }
                          },
                        ),
                      ),

                      // Body
                      Expanded(
                        child: Obx(() {
                          if (controller.isSearching.value) {
                            return controller.isLoading.value
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFFFBBC05),
                                    ),
                                  )
                                : controller.searchResults.isEmpty
                                    ? Center(
                                        child: Text(
                                          'No results for "${_searchController.text}"',
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount:
                                            controller.searchResults.length,
                                        itemBuilder: (context, index) {
                                          var product =
                                              controller.searchResults[index];
                                          return ListTile(
                                            title: Text(product.name ?? ''),
                                            subtitle:
                                                Text('₦${product.price ?? ''}'),
                                            leading: product.imageUrl != null &&
                                                    product.imageUrl!.isNotEmpty
                                                ? CachedNetworkImage(
                                                    imageUrl: product.imageUrl!,
                                                    width: 50,
                                                    height: 50,
                                                    fit: BoxFit.cover,
                                                    placeholder: (context,
                                                            url) =>
                                                        CircularProgressIndicator(),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  )
                                                : Icon(Icons.image),
                                            onTap: () {
                                              // Navigate to product detail if needed
                                            },
                                          );
                                        },
                                      );
                          } else {
                            return SmartRefresher(
                              controller: _refreshController,
                              onRefresh: _onRefresh,
                              child: ListView.separated(
                                physics: BouncingScrollPhysics(),
                                itemCount: controller.category.length + 2,
                                separatorBuilder: (context, index) {
                                  if (index == 0) {
                                    return SizedBox(height: 24);
                                  }
                                  return Divider(
                                    height: 24,
                                    thickness: 0.5,
                                    color: Colors.grey[400],
                                  );
                                },
                                itemBuilder: (context, sectionIndex) {
                                  if (sectionIndex == 0) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: SizedBox(
                                        height: 94,
                                        child: Column(
                                          children: [
                                            // Text(
                                            //   'Shop for fresh ingredients, we deliver in minutes, You can\'t go wrong with Jara.',
                                            //   style: TextStyle(
                                            //     fontFamily: 'Monts',
                                            //     fontSize: 12,
                                            //     fontWeight: FontWeight.w400,
                                            //   ),
                                            // ),
                                            SizedBox(height: 10),
                                            Text(
                                              'Shoping From $lgax L.G.A',
                                              style: TextStyle(
                                                  fontFamily: 'Poppins'),
                                            ),
                                            SizedBox(height: 10),
                                            SizedBox(
                                              height: 50,
                                              child: CustomButton(
                                                text: 'Shop For Ingredient',
                                                onPressed: () async {
                                                  var token =
                                                      await dataBase.getToken();
                                                  print(token);
                                                  Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                      builder: (context) =>
                                                          const GrainsScreen(
                                                        forProduct: false,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  if (sectionIndex == 1) {
                                    if (controller.category.isEmpty) {
                                      return SizedBox.shrink();
                                    }
                                    return _buildCategorySection(0);
                                  }
                                  if (sectionIndex == 2) {
                                    if (controller.category.length < 2) {
                                      return SizedBox.shrink();
                                    }
                                    return _buildCategorySection(1);
                                  }
                                  if (sectionIndex == 3) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 154,
                                          child: CarouselSlider(
                                            carouselController:
                                                carouselController,
                                            options: CarouselOptions(
                                              height: 200.0,
                                              viewportFraction: 0.8,
                                              initialPage: 0,
                                              enableInfiniteScroll: true,
                                              reverse: false,
                                              autoPlay: true,
                                              autoPlayInterval:
                                                  const Duration(seconds: 3),
                                              autoPlayAnimationDuration:
                                                  const Duration(
                                                      milliseconds: 800),
                                              autoPlayCurve:
                                                  Curves.fastOutSlowIn,
                                              enlargeCenterPage: true,
                                              scrollDirection: Axis.horizontal,
                                              onPageChanged: (index, reason) {
                                                setState(() {
                                                  _currentIndex = index;
                                                });
                                              },
                                            ),
                                            items: [
                                              _buildCarouselItem(
                                                  '14%', context),
                                              _buildCarouselItem(
                                                  '15%', context),
                                              _buildCarouselItem(
                                                  '16%', context),
                                              _buildCarouselItem(
                                                  '17%', context),
                                              _buildCarouselItem(
                                                  '18%', context),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: List.generate(
                                            5,
                                            (index) => GestureDetector(
                                              onTap: () {
                                                carouselController
                                                    .animateToPage(index);
                                              },
                                              child: AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                curve: Curves.easeInOut,
                                                width: _currentIndex == index
                                                    ? 12.0
                                                    : 7.0,
                                                height: 7.0,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  color: _currentIndex == index
                                                      ? Colors.blue
                                                      : Colors.grey.withValues(
                                                          alpha: 0.5),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  int categoryIndex;
                                  if (sectionIndex >= 4) {
                                    categoryIndex = sectionIndex - 2;
                                  } else {
                                    return SizedBox.shrink();
                                  }
                                  if (categoryIndex < 0 ||
                                      categoryIndex >=
                                          controller.category.length) {
                                    return SizedBox.shrink();
                                  }
                                  return _buildCategorySection(categoryIndex);
                                },
                              ),
                            );
                          }
                        }),
                      ),
                    ],
                  );
          }),
        ),
      );
    } catch (e, stackTrace) {
      print('Error building home screen: $e');
      print('Stack Trace: $stackTrace');
      return Scaffold(
        body: Center(
          child: Text('Error loading screen: $e'),
        ),
      );
    }
  }

  /// Reads the current stateId and calls the controller's search method.
  Future<void> _triggerSearch(String value) async {
    var stateId = await dataBase.getStateAddressId();
    var lgaId = await dataBase.getLGAAddressId();
    if (stateId.isNotEmpty) {
      controller.searchProducts(value, lgaId.toString(), stateId);
    }
  }

  Widget _buildCategorySection(int categoryIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Text(
                  controller.category[categoryIndex].name.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                if (controller.category[categoryIndex].products!.length > 3)
                  InkWell(
                    onTap: () {
                      Get.to(() => SoupListScreen(
                          item: controller.category[categoryIndex]));
                    },
                    child: Row(
                      children: [
                        Text(
                          'See All',
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            color: Color(0xffCC6522),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                          color: Color(0xffCC6522),
                        )
                      ],
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 10),
          controller.category[categoryIndex].products!.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Food Not Available for this Category!!!',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                )
              : SizedBox(
                  height:
                      (controller.category[categoryIndex].products!.length / 4)
                              .ceil() *
                          70.0,
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount:
                        controller.category[categoryIndex].products!.length > 8
                            ? 8
                            : controller
                                .category[categoryIndex].products!.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 7.0,
                      childAspectRatio: 1.2,
                    ),
                    itemBuilder: (context, index) {
                      final category =
                          controller.category[categoryIndex].products;

                      return GestureDetector(
                        onTap: () {
                          _showProductDialog(context, category!, index);
                        },
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(
                                category![index].imageUrl != null ? 0 : 5,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[200],
                              ),
                              child: Center(
                                child: category[index].imageUrl != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: CachedNetworkImage(
                                          imageUrl: category[index]
                                              .imageUrl
                                              .toString(),
                                          placeholder: (context, url) =>
                                              const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Center(
                                              child: SpinKitPulse(
                                                color: Color(0xFFFF9800),
                                                size: 24.0,
                                              ),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : SvgPicture.asset(
                                        'assets/images/product_image.svg'),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              category[index].name.toString().length > 10
                                  ? '${category[index].name!.substring(0, 7)}...'
                                  : category[index].name.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(String discount, BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 154,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color(0xFFFBBC05),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MIN $discount\nOFF',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Color(0xff3F1405),
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 28,
              width: 90,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  backgroundColor: Color(0xffCC6522),
                  foregroundColor: Color(0xffffffff),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  'SHOP NOW',
                  style: TextStyle(color: Colors.white, fontSize: 8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProductDialog(BuildContext context, List category, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: double.infinity,
                height: 420,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(color: Colors.transparent),
                      width: double.infinity,
                      height: 150,
                      child: Container(
                        child: category[index].imageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: category[index].imageUrl.toString(),
                                  placeholder: (context, url) => const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(
                                      child: SpinKitPulse(
                                        color: Color(0xFFFF9800),
                                        size: 24.0,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  width: context.width * 0.9,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : SvgPicture.asset(
                                'assets/images/product_image.svg'),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      height: 256,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: context.width * 0.5,
                                child: Text(
                                  maxLines: 2,
                                  '${category[index].name}',
                                  style: TextStyle(
                                    color: Color(0xff1F2937),
                                    fontFamily: 'Inter',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Text('2.5k orders'),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${category[index].ingredients?.length ?? 0} ingredients',
                                        style: TextStyle(
                                          color: Color(0xff1F2937),
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '\u20A6${category[index].price} Per Portion',
                                            style: TextStyle(
                                              color: Color(0xff1F2937),
                                              fontFamily: 'Roboto',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '\u20A6${double.parse(category[index].price) * _quantity} Total Price',
                                            style: TextStyle(
                                              color: Color(0xff1F2937),
                                              fontFamily: 'Roboto',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Quantity',
                                    style: TextStyle(
                                      color: Color(0xff1F2937),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: SvgPicture.asset(
                                            'assets/images/removepreview.svg'),
                                        onPressed: () {
                                          setState(() {
                                            _quantity =
                                                (_quantity - 1).clamp(1, 99);
                                          });
                                        },
                                        color: Colors.black,
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              width: 0.5,
                                              color: Color(0xffF9F9F9)),
                                        ),
                                        child: Text(
                                          _quantity.toString(),
                                          style: const TextStyle(
                                            color: Color(0xff262626),
                                            fontSize: 12,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: SvgPicture.asset(
                                            'assets/images/addpreview.svg'),
                                        onPressed: () {
                                          setState(() {
                                            _quantity =
                                                (_quantity + 1).clamp(1, 99);
                                          });
                                        },
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                ],
                              ),
                            ],
                          ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    cartController.addToCart(CartItem(
                                      id: category[index].id!,
                                      name: category[index].name!,
                                      description:
                                          category[index].description ?? 'N/A',
                                      price: double.tryParse(category[index]
                                              .price!
                                              .toString()) ??
                                          0.0,
                                      originalPrice: double.tryParse(
                                              category[index]
                                                  .price!
                                                  .toString()) ??
                                          0.0,
                                      ingredients: (category[index].ingredients
                                              as List<dynamic>)
                                          .map((ingredient) => Ingredients(
                                                basePrice: double.tryParse(
                                                        ingredient.price
                                                            .toString()) ??
                                                    0.0,
                                                id: ingredient.id!,
                                                name: ingredient.name,
                                                description:
                                                    ingredient.description,
                                                price: double.tryParse(
                                                        ingredient.price
                                                            .toString()) ??
                                                    0.0,
                                              ))
                                          .toList(),
                                    ));
                                    AlertInfo.show(
                                        context: context,
                                        text: 'Item added to cart',
                                        textColor: Colors.white);
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Add to Cart',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      color: Color(0xff090909),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push(
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                FoodDetailScreen(
                                                  item: category[index],
                                                )));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'GET INGREDIENT',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
