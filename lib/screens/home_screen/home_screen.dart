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
import 'package:jara_market/utils/app_feedback.dart';
import 'package:jara_market/services/osm_geocoding_service.dart';
import 'package:jara_market/services/location_resolver.dart';
import 'package:jara_market/screens/address_map_picker/address_map_picker_screen.dart';
// import 'package:jara_market/screens/main_screen/main_screen.dart';
// import 'package:jara_market/screens/add_money_screen/add_money_screen.dart';
import 'package:jara_market/screens/add_money_screen/add_money_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jara_market/screens/wallet_screen/wallet_screen.dart';
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

import 'dart:async';
import 'dart:developer' as myLog;
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
import 'package:jara_market/screens/cart_screen/controller/cart_controller.dart';
import 'package:jara_market/screens/checkout_address_change/models/lga_model.dart'
    as lga;
import 'package:jara_market/screens/checkout_address_change/models/state_model.dart';
import 'package:jara_market/screens/egusi_soup_detail_screen/egusi_soup_detail_screen.dart';
import 'package:jara_market/screens/grains_screen/grains_screen.dart';
import 'package:jara_market/screens/home_screen/confetti.dart';
import 'package:jara_market/screens/home_screen/controller/home_controller.dart';
import 'package:jara_market/screens/home_screen/widgets/shopping_type_sheet.dart';
import 'package:jara_market/screens/main_screen/main_screen.dart';
import 'package:jara_market/screens/profile_screen/pinScreen.dart';
import 'package:jara_market/screens/wallet_screen/wallet_screen.dart';
import 'package:jara_market/screens/wallet_screen/controller/wallet_controller.dart';
import 'package:jara_market/screens/home_screen/models/advertisement_model.dart';
import 'package:jara_market/widgets/custom_button.dart';
import 'package:jara_market/widgets/custom_image_view.dart';
import 'package:jara_market/utils/guest_guard.dart';
import 'package:jara_market/utils/app_tour.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../soup_list_screen/soup_list_screen.dart';

HomeController controller = Get.put(HomeController());
AddressGoogleChangeController controller1 =
    Get.put(AddressGoogleChangeController());
WalletController walletController = Get.put(WalletController());

var cartController = Get.find<CartController>();

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Map<String, dynamic> userData;
  bool isSet = false;
  int _currentIndex = 0;
  String state = '';

  /// Coordinates from the map, kept even when the state/LGA couldn't be
  /// matched automatically. The dropdowns supply the ids the API needs; this
  /// supplies the exact point the server measures market distance from, so a
  /// manual pick after a failed match is still precise.
  double? _pinnedLat;
  double? _pinnedLng;
  bool _resolvingPin = false;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    var stateId = await controller.getActiveStateId();
    var lgaId = await controller.getActiveLgaId();
    if (stateId.isNotEmpty) {
      controller.fetchFoodCategories(lgaId, stateId);
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
  Timer? _searchDebounce;

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

  Future<void> _openLocationPicker(BuildContext context,
      {required bool forSomeoneElse}) async {
    controller1.fetchCountries();
    final picked = await showModalBottomSheet<bool>(
        isDismissible: true,
        enableDrag: true,
        isScrollControlled: true,
        // isScrollControlled lets the sheet grow to
        // the full screen, which put it behind the
        // status bar. useSafeArea keeps it clear of
        // the notch and system bars.
        useSafeArea: true,
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
            // Sized to its contents instead of
            // double.infinity, which forced the
            // sheet full-height whether it needed
            // the room or not. Capped so it still
            // reads as a sheet over the page rather
            // than a new screen.
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.78,
            ),
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              // Lift the content clear of the
              // keyboard: the dropdowns have search
              // fields inside them.
              bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Delivery Address',
                        style: TextStyle(fontSize: 18, fontFamily: 'Poppins'),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[100],
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          child: IconButton(
                            icon: Icon(Icons.close, size: 16),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),

                  // Geolocation shortcut. The
                  // dropdowns below stay the source
                  // of the state/LGA ids the API
                  // needs -- this just fills them in
                  // from a real point on the map,
                  // and supplies the coordinates the
                  // server measures market distance
                  // from.
                  _DeliveryPinRow(
                    busy: _resolvingPin,
                    latitude: _pinnedLat,
                    longitude: _pinnedLng,
                    onTap: () => _pickDeliveryPin(
                        sheetContext: context, forSomeoneElse: forSomeoneElse),
                  ),

                  const Divider(height: 24),

                  // State dropdown
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 0.0),
                    child: DropdownSearch<StateData>(
                      onChanged: (value) async {
                        setState(() {
                          controller1.selectedState1 = value!.name;
                          controller1.selectedStateId = value.id;
                        });
                        await controller1
                            .fetchLgas(controller1.selectedState1!);
                        myLog.log(
                            'Selected state: ${controller1.selectedState1}');
                        myLog.log(
                            'Selected state ID: ${controller1.selectedStateId}');
                        if (!forSomeoneElse) {
                          await dataBase.saveSateAddress(
                              controller1.selectedStateId.toString());
                          await dataBase.saveState(controller1.selectedState1!);
                        }
                        setState(() {
                          state = controller1.selectedState1!;
                        });
                      },
                      selectedItem: controller1.selectedState,
                      suffixProps: DropdownSuffixProps(),
                      compareFn: (item1, item2) {
                        return item1 == item2;
                      },
                      decoratorProps: DropDownDecoratorProps(
                          baseStyle: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xffF5F5F5),
                              alignLabelWithHint: true,
                              suffixIconColor: Color(0xFFFF9800),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      style: BorderStyle.solid,
                                      color: Color(0xFFFF9800),
                                      width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      style: BorderStyle.solid,
                                      color: Color(0xffD9D9D9),
                                      width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      style: BorderStyle.solid,
                                      color: Color(0xffD9D9D9),
                                      width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))))),
                      dropdownBuilder: (context, selectedItem) {
                        if (selectedItem != null) {
                          return Text(selectedItem.name!);
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
                      items: (f, cs) => controller1.isStateLoading.value
                          ? []
                          : controller1.stateDataList,
                      itemAsString: (item) {
                        return item.name ?? '';
                      },
                      popupProps: PopupProps.menu(
                          showSelectedItems: true,
                          searchDelay: Duration(seconds: 0),
                          emptyBuilder: (context, searchEntry) {
                            return controller1.isStateLoading.value
                                ? const Center(
                                    child: CircularProgressIndicator(
                                    color: Color(0xFFFF9800),
                                  ))
                                : Center(
                                    child: Text(
                                      'No states found',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Poppins',
                                          fontSize: 12),
                                    ),
                                  );
                          },
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Search State',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    color: Colors.black)),
                          ),
                          onDismissed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("move to the next item")),
                            );
                            myLog.log('Next items found.');
                          },
                          onItemsLoaded: (value) {
                            myLog.log(
                                'Items loaded: ${value.length} items found.');
                          },
                          scrollbarProps: ScrollbarProps(),
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(),
                          disabledItemFn: (item) => item == 'Item 3',
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
                          controller1.selectedLGA1 = value!.name;
                          controller1.selectedLGAId = value.id;
                        });
                        await controller1
                            .fetchLgas(controller1.selectedState1!);
                        myLog.log('Selected LGA: ${controller1.selectedLGA1}');
                        myLog.log(
                            'Selected lga ID: ${controller1.selectedLGAId}');
                        if (forSomeoneElse) {
                          controller.setOtherLocation(
                            stateId: controller1.selectedStateId!,
                            stateName: controller1.selectedState1!,
                            lgaId: value!.id!,
                            lgaName: value.name!,
                            // Null unless they also
                            // dropped a pin; the
                            // server then falls back
                            // to state/LGA alone.
                            latitude: _pinnedLat,
                            longitude: _pinnedLng,
                          );
                        } else {
                          await dataBase
                              .saveLGAAddressID(controller1.selectedLGAId!);
                          await dataBase
                              .saveLGAAddress(controller1.selectedLGA1!);
                        }
                        setState(() {
                          state = controller1.selectedLGA1!;
                          lgax = controller1.selectedLGA1!;
                        });
                        controller.fetchFoodCategories(
                            controller1.selectedLGAId.toString(),
                            controller1.selectedStateId.toString());
                        Navigator.pop(context, true);
                      },
                      selectedItem: controller1.selectedLGA,
                      suffixProps: DropdownSuffixProps(),
                      compareFn: (item1, item2) {
                        return item1 == item2;
                      },
                      decoratorProps: DropDownDecoratorProps(
                          baseStyle: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xffF5F5F5),
                              alignLabelWithHint: true,
                              suffixIconColor: Color(0xFFFF9800),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      style: BorderStyle.solid,
                                      color: Color(0xFFFF9800),
                                      width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      style: BorderStyle.solid,
                                      color: Color(0xffD9D9D9),
                                      width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      style: BorderStyle.solid,
                                      color: Color(0xffD9D9D9),
                                      width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))))),
                      dropdownBuilder: (context, selectedItem) {
                        if (selectedItem != null) {
                          return Text(selectedItem.name!);
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
                      items: (f, cs) => controller1.isLgaLoading.value
                          ? []
                          : controller1.lgaDataList,
                      itemAsString: (item) {
                        return item.name ?? '';
                      },
                      popupProps: PopupProps.menu(
                          showSelectedItems: true,
                          searchDelay: Duration(seconds: 0),
                          emptyBuilder: (context, searchEntry) {
                            return controller1.isLgaLoading.value
                                ? const Center(
                                    child: CircularProgressIndicator(
                                    color: Color(0xFFFF9800),
                                  ))
                                : Center(
                                    child: Text(
                                      'No LGA found',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Poppins',
                                          fontSize: 12),
                                    ),
                                  );
                          },
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Search LGA',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    color: Colors.black)),
                          ),
                          onDismissed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("move to the next item")),
                            );
                            myLog.log('Next items found.');
                          },
                          onItemsLoaded: (value) {
                            myLog.log(
                                'Items loaded: ${value.length} items found.');
                          },
                          scrollbarProps: ScrollbarProps(),
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(),
                          disabledItemFn: (item) => item == 'Item 3',
                          fit: FlexFit.loose),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
    if (forSomeoneElse &&
        picked != true &&
        controller.otherLgaId.value == null) {
      // Sheet dismissed without ever picking a location this session —
      // avoid leaving the app in "Someone Else" mode with no valid location.
      controller.isShoppingForSomeoneElse.value = false;
    }
  }

  /// Opens the map, then matches the dropped pin to one of our state/LGA
  /// rows so the rest of the app keeps working off ids.
  ///
  /// A failed match is NOT treated as a dead end: the coordinates are kept
  /// and the sheet stays open so the dropdowns can finish the job. OSM's
  /// spelling of Nigerian LGAs is inconsistent enough that insisting on an
  /// automatic match would strand people who had pinned the right spot.
  Future<void> _pickDeliveryPin({
    required BuildContext sheetContext,
    required bool forSomeoneElse,
  }) async {
    final result = await Get.to(() => const AddressMapPickerScreen(),
        arguments: {'latitude': _pinnedLat, 'longitude': _pinnedLng});
    if (result is! OsmPlace) return;

    setState(() {
      _pinnedLat = result.latitude;
      _pinnedLng = result.longitude;
      _resolvingPin = true;
    });

    final area = await LocationResolver.resolve(result);

    if (!mounted) return;
    setState(() => _resolvingPin = false);

    if (area == null) {
      // Coordinates are already kept above, so finishing by hand stays exact.
      AppFeedback.showError(null,
          fallback: LocationResolver.lastFailure.isEmpty
              ? 'We couldn\'t match that spot to a delivery area. Please '
                  'choose the state and LGA below.'
              : LocationResolver.lastFailure);
      return;
    }

    if (forSomeoneElse) {
      controller.setOtherLocation(
        stateId: area.stateId,
        stateName: area.stateName,
        lgaId: area.lgaId,
        lgaName: area.lgaName,
        latitude: area.latitude,
        longitude: area.longitude,
      );
    } else {
      await dataBase.saveLGAAddressID(area.lgaId);
      await dataBase.saveLGAAddress(area.lgaName);
      // Named saveSateAddress in local_storage.dart (typo is pre-existing).
      await dataBase.saveSateAddress(area.stateId.toString());
      // Own-location coordinates are persisted; see ApiService._shopCoords.
      await dataBase.saveShopCoords(area.latitude, area.longitude);
    }

    if (!mounted) return;
    setState(() {
      state = area.lgaName;
      lgax = area.lgaName;
    });
    controller.fetchFoodCategories(
        area.lgaId.toString(), area.stateId.toString());
    AppFeedback.showSuccess(
        'Delivering to ${area.lgaName}, ${area.stateName}.');
    if (Navigator.canPop(sheetContext)) Navigator.pop(sheetContext, true);
  }

  Future<void> _switchToSomeoneElse() async {
    if (controller.isShoppingForSomeoneElse.value) return;
    controller.isShoppingForSomeoneElse.value = true;
    await _openLocationPicker(context, forSomeoneElse: true);
  }

  Future<void> _switchToMyself() async {
    if (!controller.isShoppingForSomeoneElse.value) return;
    controller.isShoppingForSomeoneElse.value = false;
    controller.clearOtherLocation();
    final stateId = await dataBase.getStateAddressId();
    final lgaId = await dataBase.getLGAAddressId();
    final lgaName = await dataBase.getLGAAddress();
    if (!mounted) return;
    setState(() {
      state = lgaName;
      lgax = lgaName;
    });
    controller.fetchFoodCategories(lgaId.toString(), stateId);
  }

  Widget _modeSegment({
    required String label,
    required IconData icon,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 6),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFFF9800) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF9800).withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: active ? Colors.white : const Color(0xFF616161),
            ),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: active ? Colors.white : const Color(0xFF616161),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shown when the catalogue is withheld. Two very different causes share
  /// this slot -- we can't see where you are, versus we don't serve where you
  /// are -- and they need different headings and different buttons, because
  /// the fix is different. The body copy comes from the server so the rule
  /// and its wording stay in one place.
  Widget _buildComingSoon() {
    final needsLocation = controller.needsLocation.value;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 40),
      child: Column(
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              shape: BoxShape.circle,
            ),
            child: Icon(
                needsLocation
                    ? Icons.my_location_outlined
                    : Icons.location_off_outlined,
                size: 38,
                color: const Color(0xFFFF9800)),
          ),
          const SizedBox(height: 20),
          Text(
            needsLocation ? 'Share your location' : 'Not in your area yet',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF212429),
            ),
          ),
          const SizedBox(height: 10),
          Obx(() => Text(
                controller.coverageMessage.value.isNotEmpty
                    ? controller.coverageMessage.value
                    : "Jaramarket isn't available in your area just yet. "
                        "We've taken note of your location and we'll be there soon.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 13.5, height: 1.55, color: Color(0xFF666666)),
              )),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: needsLocation
                  ? _enableLocationAndRetry
                  : () => _openLocationPicker(context,
                      forSomeoneElse:
                          controller.isShoppingForSomeoneElse.value),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9800),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              icon: Icon(
                  needsLocation
                      ? Icons.location_searching
                      : Icons.edit_location_alt_outlined,
                  size: 19),
              label: Text(
                  needsLocation ? 'Enable location' : 'Change my location',
                  style: const TextStyle(
                      fontSize: 14.5, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  /// Ask for location, cache it, and reload. A permanently denied permission
  /// can only be fixed in the OS settings, so send them there rather than
  /// looping on a request the system will never show again.
  Future<void> _enableLocationAndRetry() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      await Geolocator.openLocationSettings();
      return;
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return;
    }
    if (permission == LocationPermission.denied) return;

    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.low, distanceFilter: 0),
      ).timeout(const Duration(seconds: 10));
      await dataBase.saveShopCoords(pos.latitude, pos.longitude);
      await controller.fetchFoodCategories(null, null, reset: true);
    } catch (_) {
      Get.snackbar(
          'Location', 'We could not read your location. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Widget _buildShopModeToggle() {
    return Obx(() {
      final forOther = controller.isShoppingForSomeoneElse.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              "Who are you shopping for?",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF616161),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                Expanded(
                  child: _modeSegment(
                    label: 'Myself',
                    icon: Icons.person_outline,
                    active: !forOther,
                    onTap: _switchToMyself,
                  ),
                ),
                Expanded(
                  child: _modeSegment(
                    label: 'Someone Else',
                    icon: Icons.people_outline,
                    active: forOther,
                    onTap: _switchToSomeoneElse,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
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
    AppTour.register(AppTour.home);
    // Wallet and the PIN/wallet welcome tips only apply to signed-in users.
    // The feature tour waits for the welcome dialog to close.
    if (!Session.isGuest.value) {
      walletController.fetchWallet();
      _maybeShowWelcomeDialog().then((_) => _startTour());
    } else {
      _startTour();
    }
    setLGA();
    carouselController = CarouselSliderController();
  }

  /// First food in the grid, highlighted by the feature tour.
  final GlobalKey _foodTourKey = GlobalKey();

  void _startTour() =>
      AppTour.startIfUnseen(this, AppTour.home, [_foodTourKey]);

  /// Completes once the welcome dialog is closed (or straight away when it
  /// was already shown before).
  Future<void> _maybeShowWelcomeDialog() async {
    final alreadyShown = await dataBase.getWelcomeShown();
    if (alreadyShown || !mounted) return;
    await dataBase.saveWelcomeShown();

    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF3E0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.celebration_rounded,
                    size: 32, color: Color(0xFFFFAA00)),
              ),
              const SizedBox(height: 16),
              Text(
                'Welcome to JaraMarket${name != null && name!.isNotEmpty ? ', $name' : ''}! 🎉',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              const Text(
                'Here\'s how to get started:',
                style: TextStyle(fontSize: 13, color: Color(0xFF888888)),
              ),
              const SizedBox(height: 16),
              const _WelcomeStep(
                number: '1',
                title: 'Fund your wallet',
                subtitle:
                    'Go to Wallet → Add Money, enter an amount and pay securely with Paystack.',
              ),
              const SizedBox(height: 12),
              const _WelcomeStep(
                number: '2',
                title: 'Set your transaction PIN',
                subtitle:
                    'Your 4-digit PIN keeps every payment and withdrawal secure.',
              ),
              const SizedBox(height: 12),
              const _WelcomeStep(
                number: '3',
                title: 'Shop & checkout',
                subtitle:
                    'Add items to your cart and pay straight from your wallet.',
              ),
              const SizedBox(height: 12),
              const _WelcomeStep(
                number: '4',
                title: 'Track your Order',
                subtitle: 'You can track your order status at any time.',
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SetPinScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFAA00),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Set Transaction PIN',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WalletScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFFFAA00)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Fund My Wallet',
                    style: TextStyle(
                        color: Color(0xFFFFAA00),
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Maybe later',
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSearchChanged() {
    // Rebuild to show/hide the clear (X) icon reactively
    setState(() {});
  }

  @override
  void dispose() {
    AppTour.unregister(AppTour.home);
    _searchDebounce?.cancel();
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
                              child:
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     Get.to(() => GiftAnimationScreen());
                                  //   },
                                  //   child:
                                  Text(
                                Session.isGuest.value
                                    ? 'Hello Guest,'
                                    : 'Hello ${name ?? "User"},',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              // ),
                            ),
                          ),
                          // Wallet Balance
                          // ITEM 7 — a 10%-tint chip reads as decoration, not
                          // an action. Solid brand fill plus a "+" so funding
                          // is one obvious tap from the landing screen.
                          if (!Session.isGuest.value)
                            GestureDetector(
                              onTap: () => Get.to(() => const AddMoneyScreen()),
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 9),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(22),
                                  color: const Color(0xFFFF9800),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFF9800)
                                          .withValues(alpha: 0.35),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.account_balance_wallet,
                                      size: 17,
                                      color: Colors.white,
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
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.add,
                                          size: 11, color: Color(0xFFFF9800)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          // Location picker
                          GestureDetector(
                            onTap: () => _openLocationPicker(context,
                                forSomeoneElse:
                                    controller.isShoppingForSomeoneElse.value),
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

                      // Shopping-for mode toggle
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: _buildShopModeToggle(),
                      ),

                      // Search Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
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
                                  _searchDebounce?.cancel();
                                  if (value.isNotEmpty) {
                                    // Wait for the user to pause typing before
                                    // firing the request, so we don't send one
                                    // request per keystroke (which was racing —
                                    // a stale response for an earlier partial
                                    // word could arrive after the final one and
                                    // overwrite it, showing "no results" even
                                    // though the full word does match).
                                    _searchDebounce = Timer(
                                        const Duration(milliseconds: 450), () {
                                      _triggerSearch(value);
                                    });
                                  } else {
                                    controller.clearSearch();
                                  }
                                },
                                onSubmitted: (value) async {
                                  _searchDebounce?.cancel();
                                  if (value.isNotEmpty) {
                                    _triggerSearch(value);
                                  } else {
                                    controller.clearSearch();
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: (controller.minPrice != null ||
                                        controller.maxPrice != null)
                                    ? Colors.orange
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.tune,
                                    color: (controller.minPrice != null ||
                                            controller.maxPrice != null)
                                        ? Colors.white
                                        : Colors.black87),
                                onPressed: _openPriceFilter,
                              ),
                            ),
                          ],
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
                                // +1 for the load-more footer
                                itemCount: controller.category.length + 3,
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
                                              'Shopping From $lgax L.G.A',
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
                                    // Out of coverage isn't an empty shop --
                                    // say so, or it looks broken.
                                    if (controller.outOfCoverage.value) {
                                      return _buildComingSoon();
                                    }
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
                                    return Obx(() {
                                      final ads = controller.advertisements;
                                      if (ads.isEmpty) {
                                        return const SizedBox.shrink();
                                      }
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
                                                enableInfiniteScroll:
                                                    ads.length > 1,
                                                reverse: false,
                                                autoPlay: ads.length > 1,
                                                autoPlayInterval:
                                                    const Duration(seconds: 3),
                                                autoPlayAnimationDuration:
                                                    const Duration(
                                                        milliseconds: 800),
                                                autoPlayCurve:
                                                    Curves.fastOutSlowIn,
                                                enlargeCenterPage: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                onPageChanged: (index, reason) {
                                                  setState(() {
                                                    _currentIndex = index;
                                                  });
                                                },
                                              ),
                                              items: ads
                                                  .map((ad) =>
                                                      _buildCarouselItem(
                                                          ad, context))
                                                  .toList(),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: List.generate(
                                              ads.length,
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
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 4.0),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                    color:
                                                        _currentIndex == index
                                                            ? Colors.blue
                                                            : Colors.grey
                                                                .withValues(
                                                                    alpha: 0.5),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                                  }
                                  // Last item — load-more footer
                                  if (sectionIndex ==
                                      controller.category.length + 2) {
                                    return Obx(() {
                                      if (controller.isLoadingMore.value) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 24),
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        );
                                      }
                                      if (!controller.hasMore) {
                                        return SizedBox(height: 24);
                                      }
                                      // Trigger load when this item becomes visible
                                      controller.loadMoreCategories();
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 24),
                                        child: Center(
                                            child: CircularProgressIndicator()),
                                      );
                                    });
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
    var stateId = await controller.getActiveStateId();
    var lgaId = await controller.getActiveLgaId();
    controller.searchProducts(value, lgaId, stateId);
  }

  void _openPriceFilter() {
    final minController = TextEditingController(
        text: controller.minPrice?.toStringAsFixed(0) ?? '');
    final maxController = TextEditingController(
        text: controller.maxPrice?.toStringAsFixed(0) ?? '');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 50,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Filter by price',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: minController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Min price (₦)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: maxController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Max price (₦)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        Navigator.pop(sheetContext);
                        await controller.applyPriceFilter(
                            minPrice: null, maxPrice: null);
                        if (mounted) setState(() {});
                      },
                      child: const Text('Clear'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final min = double.tryParse(minController.text.trim());
                        final max = double.tryParse(maxController.text.trim());
                        Navigator.pop(sheetContext);
                        await controller.applyPriceFilter(
                            minPrice: min, maxPrice: max);
                        if (mounted) setState(() {});
                      },
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // The grid is fixed-height because it sits in a scrolling column, so the
  // height reserved for it and the height its rows actually take up have to
  // come from the same numbers. Deriving row height from childAspectRatio
  // while hard-coding 70.0 per row is what clipped the second row of labels
  // once the screen was wide enough to make a cell taller than 70.
  static const int _gridColumns = 4;
  static const int _gridMaxItems = 8;
  static const double _gridRowExtent = 80.0;
  static const double _gridRowSpacing = 8.0;

  Widget _buildCategorySection(int categoryIndex) {
    final products = controller.category[categoryIndex].products ?? const [];
    final itemCount =
        products.length > _gridMaxItems ? _gridMaxItems : products.length;
    final rowCount = (itemCount / _gridColumns).ceil();

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
          products.isEmpty
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
                  height: rowCount * _gridRowExtent +
                      (rowCount - 1) * _gridRowSpacing,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: itemCount,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _gridColumns,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: _gridRowSpacing,
                      // Pinning the row height outright, instead of letting it
                      // fall out of childAspectRatio and the screen width, is
                      // what keeps it in step with the SizedBox above.
                      mainAxisExtent: _gridRowExtent,
                    ),
                    itemBuilder: (context, index) {
                      final product = products[index];

                      final tile = GestureDetector(
                        onTap: () {
                          _showProductDialog(context, products, index);
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              padding: EdgeInsets.all(
                                product.imageUrl != null ? 0 : 5,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[200],
                              ),
                              child: Center(
                                child: product.imageUrl != null
                                    ? ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: product.imageUrl.toString(),
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
                                          width: 44,
                                          height: 44,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : SvgPicture.asset(
                                        'assets/images/product_image.svg'),
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Two lines with a real ellipsis, rather than
                            // chopping every name at 7 characters whatever
                            // room the cell actually has.
                            Expanded(
                              child: Text(
                                product.name.toString(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12,
                                  height: 1.15,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                      // Only the very first food is a tour step.
                      if (categoryIndex != 0 || index != 0) return tile;
                      return AppTour.step(
                        key: _foodTourKey,
                        scope: AppTour.home,
                        title: 'Pick a food',
                        description:
                            'Tap any food to choose Individual or Corporate shopping and see its ingredients.',
                        child: tile,
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(Advertisement ad, BuildContext context) {
    final hasImage = ad.image != null && ad.image!.isNotEmpty;
    final adText =
        (ad.type == 'discount' || ad.type == 'off') && ad.value != null
            ? 'MIN ${ad.value}${ad.type == 'discount' ? '%' : ''}\nOFF'
            : 'Special Offer';
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        color: const Color(0xFFFBBC05),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (hasImage)
              CustomImageView(
                imagePath: ad.image,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            if (hasImage)
              // Dark scrim behind the text so it stays legible over any image.
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black.withValues(alpha: 0.45),
                      Colors.black.withValues(alpha: 0.05),
                    ],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    adText,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: hasImage ? Colors.white : const Color(0xff3F1405),
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

  Future<void> _showProductDialog(
      BuildContext context, List category, int index) async {
    final item = category[index];
    final type = await showShoppingTypeSheet(context, item.name ?? 'this food');
    if (type == null || !context.mounted) return;
    Navigator.of(context).push(CupertinoPageRoute(
        builder: (context) =>
            FoodDetailScreen(item: item, shoppingType: type)));
  }
}

class _WelcomeStep extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;

  const _WelcomeStep({
    required this.number,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0xFFFFAA00),
            shape: BoxShape.circle,
          ),
          child: Text(
            number,
            style: const TextStyle(
                color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xFF888888), height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }
}

/// The "set it on the map" row inside the Delivery Address sheet.
class _DeliveryPinRow extends StatelessWidget {
  const _DeliveryPinRow({
    required this.busy,
    required this.latitude,
    required this.longitude,
    required this.onTap,
  });

  final bool busy;
  final double? latitude;
  final double? longitude;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasPin = latitude != null && longitude != null;
    return InkWell(
      onTap: busy ? null : onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: hasPin ? const Color(0xFFFFF8E1) : Colors.grey.shade50,
          border: Border.all(
              color: hasPin ? const Color(0xFFFFB300) : Colors.black12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              busy
                  ? Icons.hourglass_top
                  : hasPin
                      ? Icons.check_circle
                      : Icons.my_location,
              size: 20,
              color: hasPin ? Colors.green : const Color(0xFFFF9800),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    busy
                        ? 'Finding the delivery area…'
                        : hasPin
                            ? 'Location pinned'
                            : 'Use my location',
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    hasPin
                        ? '${latitude!.toStringAsFixed(5)}, '
                            '${longitude!.toStringAsFixed(5)} — tap to adjust'
                        : 'Pin the exact spot on the map and we\'ll fill in '
                            'the state and LGA',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}
