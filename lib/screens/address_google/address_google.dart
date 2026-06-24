import 'dart:developer' as myLog;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/address_google/controller/address_google.dart';
// import 'package:jara_market/screens/checkout_address_change/controller/checkout_address_change_controller.dart';
// import 'package:jara_market/screens/checkout_address_change/models/country_model.dart';
// import 'package:jara_market/screens/checkout_address_change/models/lga_model.dart'
  //  as lgaData;
import 'package:jara_market/screens/checkout_address_change/models/state_model.dart';
import 'package:jara_market/screens/main_screen/main_screen.dart';
import 'package:jara_market/screens/profile_screen/controller/profile_controller.dart';
import 'package:jara_market/widgets/custom_button.dart';
//import 'package:jara_market/widgets/custom_text_field.dart';

AddressGoogleChangeController controller =
    Get.put(AddressGoogleChangeController());
ProfileController profileController = Get.put(ProfileController());

class AddressGoogleChangeScreen extends StatefulWidget {
  @override
  State<AddressGoogleChangeScreen> createState() =>
      _AddressGoogleChangeScreenState();
}

class _AddressGoogleChangeScreenState extends State<AddressGoogleChangeScreen> {
  // var isFromProfile = Get.arguments['isFromProfile'] ?? false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.fetchCountries();
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
            text: 'Proceed',
            onPressed: () async {
              // Get.back();
              Get.offAll(
                () => MainScreen(),
                transition: Transition.rightToLeft,
                duration: Duration(milliseconds: 300),
              );
            },
          ),
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
            //Get.back();
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Delivery Address',
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
                      });
                      await dataBase
                          .saveSateAddress(
                              controller.selectedStateId.toString())
                          .then((_) {
                        myLog.log(
                            'State ID saved successfully: ${controller.selectedStateId}');
                      }).catchError((error) {
                        myLog.log('Error saving state ID: $error');
                      });
                      print('selected item is: ${controller.selectedState1}');
                      await controller.fetchLgas(controller.selectedState1!);
                      myLog.log('Selected state: ${controller.selectedState1}');
                      myLog.log(
                          'Selected state ID: ${controller.selectedStateId}');
                      await dataBase.saveSateAddress(
                          controller.selectedStateId.toString());
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10),
                    child: Row(
                      children: [
                        Obx(() {
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
