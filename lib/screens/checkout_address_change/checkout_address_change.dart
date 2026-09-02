import 'dart:developer' as myLog;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/checkout_address_change/controller/checkout_address_change_controller.dart';
import 'package:jara_market/screens/checkout_address_change/models/lga_model.dart'
    as lgaData;
import 'package:jara_market/screens/checkout_address_change/models/state_model.dart';
import 'package:jara_market/screens/profile_screen/controller/profile_controller.dart';
import 'package:jara_market/widgets/custom_button.dart';
import 'package:jara_market/widgets/custom_text_field.dart';

CheckoutAddressChangeController controller =
    Get.put(CheckoutAddressChangeController());
    ProfileController profileController = Get.put(ProfileController());

class CheckoutAddressChangeScreen extends StatefulWidget {
  @override
  State<CheckoutAddressChangeScreen> createState() =>
      _CheckoutAddressChangeScreenState();
}

class _CheckoutAddressChangeScreenState
    extends State<CheckoutAddressChangeScreen> {
  var isFromProfile = (Get.arguments as Map?)?['isFromProfile'] ?? false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.fetchStates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      extendBody: true,
      bottomNavigationBar: BottomAppBar(
        height: context.height * 0.15,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomButton(
            text: 'Save Address',
            onPressed: () async {
              if (controller.isValid())  {
               
                // Get.snackbar('Success', 'Address changed successfully',
                //     backgroundColor: Colors.green, colorText: Colors.white);
                if (isFromProfile) {
                  var result = await controller.storeAddress();
                  myLog.log('Result from storeAddress: $result');
                  if (result.isNotEmpty) {
                    Get.back(result: result);
                  }
                } else {
                  var result = await controller.processUpdateCheckoutAddress();
                  myLog.log('Result from processUpdateCheckoutAddress: $result');
                  if (result.isNotEmpty) {
                    Get.back(result: result);
                  }
                }
                //Get.back();
              } else {
                Get.snackbar('Error', 'Please select all fields',
                    backgroundColor: Colors.red, colorText: Colors.white);
              }
            },
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     if (controller.isValid()) {
          //       // Handle address change logic
          //       // For example, save the selected address
          //       Get.back();
          //     } else {
          //       Get.snackbar('Error', 'Please select all fields',
          //           backgroundColor: Colors.red, colorText: Colors.white);
          //     }
          //   },
          //   child: Text('Save Address'),
          // ),
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left_rounded,
            color: Colors.black,
            size: 25,
          ),
          onPressed: () {
          //  Get.back();
          Navigator.pop(context);
          },
        ),
        title: Text(
          'Change Address',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Poppins',
            color: Colors.black,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Change your delivery address below:',
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 16.0),
                  child: DropdownSearch<StateData>(
                    onChanged: (value) async {
                      setState(() {
                        controller.selectedState1 = value!.name;
                        controller.selectedStateId = value.id;
                        // With the country picker gone, the country comes
                        // from whichever state the customer chose.
                        controller.selectedCountryId = value.countryId;
                        // The LGA list is about to be replaced, so whatever
                        // was picked under the previous state is no longer a
                        // valid choice -- clear it rather than save an LGA
                        // that belongs to a different state.
                        controller.selectedLGA = null;
                        controller.selectedLGA1 = null;
                        controller.selectedLGAId = null;
                        controller.lgaDataList = [];
                      });
                      print('selected item is: ${controller.selectedState1}');
                      await controller.fetchLgas(controller.selectedState1!);
                      myLog.log('Selected state: ${controller.selectedState1}');
                      myLog.log(
                          'Selected state ID: ${controller.selectedStateId}');
                    },
                    selectedItem: controller.selectedState,
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
                            suffixIconColor: Colors.amber,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    style: BorderStyle.solid,
                                    color: Colors.amber,
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
                    items: (f, cs) => controller.isStateLoading.value
                        ? []
                        : controller.stateDataList,
                    itemAsString: (item) {
                      return item.name ?? '';
                    },
                    popupProps: PopupProps.menu(
                        showSelectedItems: true,
                        searchDelay: Duration(seconds: 0),
                        emptyBuilder: (context, searchEntry) {
                          return controller.isStateLoading.value
                              ? const Center(
                                  child: CircularProgressIndicator(
                                  color: Colors.amber,
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 16.0),
                  child: DropdownSearch<lgaData.LgaData>(
                    key: ValueKey('lga-${controller.selectedStateId}'),
                    onChanged: (value) {
                      setState(() {
                        controller.selectedLGA = value;
                        controller.selectedLGA1 = value!.name;
                        controller.selectedLGAId = value.id;
                      });
                      print('selected item is: ${controller.selectedLGA1}');
                      myLog.log('Selected LGA: ${controller.selectedLGA1}');
                      myLog.log('Selected LGA ID: ${controller.selectedLGAId}');
                    },
                    selectedItem: controller.selectedLGA,
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
                            suffixIconColor: Colors.amber,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    style: BorderStyle.solid,
                                    color: Colors.amber,
                                    width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    style: BorderStyle.solid,
                                    color: Colors.grey[300]!,
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
                          'Enter Your Local Government Area',
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 16,
                          ),
                        );
                      }
                    },
                    items: (f, cs) => controller.isLgaLoading.value
                        ? []
                        : controller.lgaDataList,
                    //
                    itemAsString: (item) {
                      return item.name ?? '';
                    },
                    popupProps: PopupProps.menu(
                        showSelectedItems: true,
                        searchDelay: Duration(seconds: 0),
                        emptyBuilder: (context, searchEntry) {
                          return controller.isStateLoading.value
                              ? const Center(
                                  child: CircularProgressIndicator(
                                  color: Colors.amber,
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
                          child: Text(
                            'Search Local Government Area',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: Colors.black),
                          ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10),
                  child: CustomTextField(
                      hint: 'Contact Address',
                      controller: controller.contactAddressController),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10),
                  child: CustomTextField(
                      hint: 'Phone Number',
                      controller: controller.contactNumberController),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10),
                    child: Row(
                      children: [
                        Obx((){
                          return Checkbox(
                          value: controller.isDefault.value,
                          onChanged: (value) {
                            controller.isDefault.value = value!;
                            print(value);
                          },
                          activeColor: Colors.amberAccent,
                          checkColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                        }),
                        Text(
                          'Set as default address',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
