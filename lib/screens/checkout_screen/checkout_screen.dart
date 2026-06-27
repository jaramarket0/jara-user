import 'dart:async';
import 'dart:developer' as myLog;
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:jara_market/config/routes.dart';
import 'package:jara_market/screens/cart_screen/controller/cart_controller.dart';
import 'package:jara_market/screens/checkout_screen/controller/checkout_controller.dart';
import 'package:jara_market/screens/main_screen/main_screen.dart';
import 'package:jara_market/widgets/cart_widgets/cart_summary_card.dart';
import 'package:jara_market/widgets/cart_widgets/checkout_button_paystack.dart';
import 'package:jara_market/widgets/cart_widgets/checkout_summary_cart3.dart';
import 'package:jara_market/widgets/custom_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import '../../widgets/payment_method_card.dart';
import '../../widgets/address_card.dart';
import '../../widgets/summary_breakdown_card.dart';
import '../../widgets/message_box.dart';
import 'package:jara_market/screens/cart_screen/models/models.dart';

CheckoutController controller = Get.put(CheckoutController());
var cartController = Get.find<CartController>();

class CheckoutScreen extends StatefulWidget {
  final double totalAmount;
  final List<CartItem> cartItems;
  final Map<String, dynamic> orderAddress;
  final double balance;
  final String path;

  const CheckoutScreen({
    Key? key,
    required this.totalAmount,
    required this.cartItems,
    required this.orderAddress,
    required this.balance,
    required this.path,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = '';

  String fullName = 'Jacob Peter';
  Map<dynamic, dynamic> result = {};

  getName() async {
    var name = await dataBase.getFullName();
    setState(() {
      fullName = name;
    });
  }

  //final TextEditingController _messageController = TextEditingController();
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();

  @override
  void dispose() {
    _recorder.closeRecorder();
    _player.closePlayer();
    super.dispose();
  }

  bool _isRecording = false;
  bool _isPaused = false;
  String? _recordingPath;
  bool _isRecorderInitialized = false;
  bool isPlayed = false;
  bool isResumed = false;
  bool isStoped = false;
  String? recordingPath;
  @override
  void initState() {
    super.initState();
    _initializeRecorder();
    getName();
    if (widget.orderAddress.containsKey('id') && widget.orderAddress['id'] != null) {
      controller.selectedAddressId.value = widget.orderAddress['id'] as int;
    }
  }

  Timer? _timer;
  Duration _recordingDuration = Duration.zero;
  DateTime? _pauseStartTime;
// bool _isPaused = false;

  String get _durationText {
    final minutes =
        _recordingDuration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
        _recordingDuration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _startTimer() {
    _recordingDuration = Duration.zero;
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _recordingDuration += Duration(seconds: 1);
      });
    });
  }

  void _pauseTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      _isPaused = true;
      _pauseStartTime = DateTime.now();
    }
  }

  void _resumeTimer() {
    if (_isPaused) {
      _timer = Timer.periodic(Duration(seconds: 1), (_) {
        setState(() {
          _recordingDuration += Duration(seconds: 1);
        });
      });
      _isPaused = false;
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    _recordingDuration = Duration.zero;
    _isPaused = false;
  }

  Future<void> _initializeRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Microphone permission is required for voice notes'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await _recorder.openRecorder();
      _isRecorderInitialized = true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to initialize recorder: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _startRecording() async {
    if (!_isRecorderInitialized) {
      await _initializeRecorder();
      if (!_isRecorderInitialized) return;
    }

// _recordDuration = 0;
//   _timer?.cancel();
//   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//     setState(() {
//       _recordDuration++;
//     });
//   });

    try {
      final directory = await getApplicationDocumentsDirectory();
      _recordingPath =
          '${directory.path}/voice_note_${DateTime.now().millisecondsSinceEpoch}.aac';

      await _recorder.startRecorder(toFile: _recordingPath);
      setState(() {
        _isRecording = true;
        _isPaused = false;
        isResumed = false;
        isStoped = false;
        recordingPath = _recordingPath;
      });

      // Show recording indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recording started...'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to start recording: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pauseRecording() async {
    if (!_isRecording) return;

    try {
      await _recorder.pauseRecorder();
      setState(() {
        _isPaused = true;
        isResumed = true;
        isStoped = false;
        isPlayed = false;
      });

      // Show paused indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recording paused'),
          duration: Duration(seconds: 1),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pause recording: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _resumeRecording() async {
    if (!_isRecording || !_isPaused) return;

    try {
      await _recorder.resumeRecorder();
      setState(() {
        _isPaused = false;
      });

      // Show resumed indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recording resumed'),
          duration: Duration(seconds: 1),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to resume recording: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;
//_timer?.cancel();
    try {
      final recordingResult = await _recorder.stopRecorder();
      setState(() {
        _isRecording = false;
        _isPaused = false;
        isResumed = false;
        isStoped = true;
        isPlayed = true;
      });

      // Show success message with recording path
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Voice note recorded successfully'),
          action: SnackBarAction(
            label: 'PLAY',
            onPressed: () {
              // Implement playback functionality
              _playRecording(recordingResult);
            },
          ),
        ),
      );

      // Here you would typically upload the voice note to your server
      // _uploadVoiceNote(recordingResult);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to stop recording: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _playRecording(String? path) async {
    if (path == null) return;

    // Implement playback functionality
    // This would typically use FlutterSoundPlayer

    await _player.openPlayer();
    await _player.startPlayer(fromURI: path);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Playing voice note...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  double get deliveryFee => 0;

  void _selectPaymentMethod(String method) {
    setState(() {
      _selectedPaymentMethod = method;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: () {
              //Get.back();
              Navigator.pop(context);
            },
            child: Icon(
              Icons.chevron_left,
              size: 26,
            )),
        centerTitle: true,
        title: const Text(
          'Cart Summary',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    // padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: widget.cartItems.length + 1,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      if (index == widget.cartItems.length) {
                        return cartController.ingredientList.length == 0
                            ? SizedBox.shrink()
                            : Column(
                                children: [
                                  Container(
                                      width: double.infinity,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          //  const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Ingredients',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                    height:
                                        (cartController.ingredientList.length *
                                                110.0)
                                            .clamp(0.0, 300.0),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: ListView.separated(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return CartItemCard3(
                                                  id: cartController
                                                      .ingredientList[index]
                                                      .id!,
                                                  ingredients: cartController
                                                      .ingredientList,
                                                  name: cartController
                                                      .ingredientList[index]
                                                      .name!,
                                                  unit: cartController
                                                          .ingredientList[index]
                                                          .description ??
                                                      'N/A',
                                                  basePrice: cartController
                                                      .ingredientList[index]
                                                      .price!,
                                                  quantity: cartController
                                                      .ingredientList[index]
                                                      .quantity!,
                                                  textController:
                                                      TextEditingController(
                                                    text: (cartController
                                                            .ingredientList[
                                                                index]
                                                            .quantity)
                                                        .toString(),
                                                  ),
                                                  isSelected: false,
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) =>
                                                      const Divider(
                                                        height: 0.5,
                                                        color: Color.fromARGB(
                                                            57, 228, 228, 228),
                                                      ),
                                              itemCount: cartController
                                                  .ingredientList.length),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              );
                      }
                      final item = cartController.cartItems[index];
                      final ingredients = item.ingredients;
                      return CartItemCard2(
                        id: item.id,
                        ingredients: ingredients,
                        name: item.name,
                        unit: item.description,
                        basePrice: item.price,
                        quantity: item.quantity,
                        textController: TextEditingController(
                          text: (item.quantity).toString(),
                        ),
                        isSelected: false,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  widget.path.isEmpty || widget.path == ''
                      ? SizedBox.shrink()
                      : IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade200,
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                          onPressed: () {
                            _playRecording(widget.path);
                          },
                        ),
                  const SizedBox(height: 24),
                  SummaryBreakdown(
                    mealPrep: cartController.mealPrepPrice,
                    itemsTotal: widget.totalAmount,
                    serviceChargePercentage:
                        cartController.calculatedServiceCharge,
                    deliveryFee: cartController.shippingCost.value,
                    total: widget.totalAmount,
                  ),
                  const SizedBox(height: 24),
                  // CustomButton(
                  //     text: 'text',
                  //     onPressed: () {
                  //       print(result);
                  //       myLog.log(widget.orderAddress['state'].toString());
                  //     }),
                  (widget.balance < widget.totalAmount)
                      ? AbsorbPointer(
                          child: CheckoutButtonPaystack(
                            onLocationDetected: (location) {
                              // Auto-fill the address text field
                              controller.selectedAddress.value =
                                  location.fullAddress;

                              // Auto-select state if your controller has a state field:
                              // controller.selectedState1 = location.state;

                              setState(() {}); // refresh UI
                            },
                            address:
                                "${widget.orderAddress['contact_address']},${widget.orderAddress['lga']},${widget.orderAddress['state']},${widget.orderAddress['country']}.",
                            audio: widget.path,
                            color: Colors.grey[400],
                            title: 'Insufficient Balance ${widget.balance}',
                            amount: widget.totalAmount,
                          ),
                        )
                      : Obx(() {
                          return CheckoutButtonPaystack(
                            onLocationDetected: (location) {
                              // Auto-fill the address text field
                              controller.selectedAddress.value =
                                  location.fullAddress;

                              // Auto-select state if your controller has a state field:
                              // controller.selectedState1 = location.state;

                              setState(() {}); // refresh UI
                            },
                            address:
                                "${widget.orderAddress['contact_address']},${widget.orderAddress['lga']},${widget.orderAddress['state']},${widget.orderAddress['country']}.",
                            // != null
                            //        ? widget.orderAddress['contact_address']
                            //        : '${controller.selectedAddress},${controller.selectedState},${controller.selectedCountry}',
                            audio: widget.path,
                            title: controller.isLoading.value
                                ? 'Initializing Payment...'
                                : 'Check Out',
                            amount: widget.totalAmount,
                          );
                        }),
                  const SizedBox(height: 24),
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     children: [
                  //       PaymentMethodCard(
                  //         imagePath: 'assets/images/Paypal.png',
                  //         name: 'Bank Transfer',
                  //         isSelected: _selectedPaymentMethod == 'bank',
                  //         onTap: () => _selectPaymentMethod('bank'),
                  //       ),
                  //       const SizedBox(width: 8),
                  //       PaymentMethodCard(
                  //         imagePath: 'assets/images/Visa.png',
                  //         name: 'Visa',
                  //         isSelected: _selectedPaymentMethod == 'visa',
                  //         onTap: () => _selectPaymentMethod('visa'),
                  //       ),
                  //       const SizedBox(width: 8),
                  //       PaymentMethodCard(
                  //         imagePath: 'assets/images/Mastercard.png',
                  //         name: 'Mastercard',
                  //         isSelected: _selectedPaymentMethod == 'mastercard',
                  //         onTap: () => _selectPaymentMethod('mastercard'),
                  //       ),
                  //       const SizedBox(width: 8),
                  //       PaymentMethodCard(
                  //         imagePath: 'assets/images/Amex.png',
                  //         name: 'USSD',
                  //         isSelected: _selectedPaymentMethod == 'ussd',
                  //         onTap: () => _selectPaymentMethod('ussd'),
                  //       ),
                  //       const SizedBox(width: 8),
                  //       PaymentMethodCard(
                  //         imagePath: 'assets/images/ApplePay.png',
                  //         name: 'Apple Pay',
                  //         isSelected: _selectedPaymentMethod == 'apple',
                  //         onTap: () => _selectPaymentMethod('apple'),
                  //       ),
                  //       const SizedBox(width: 8),
                  //       PaymentMethodCard(
                  //         imagePath: 'assets/images/GPay.png',
                  //         name: 'Google Pay',
                  //         isSelected: _selectedPaymentMethod == 'google',
                  //         onTap: () => _selectPaymentMethod('google'),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 24),
                  result.isNotEmpty
                      ? Obx(() {
                          return AddressCard(
                            name: fullName,
                            action: 'Change',
                            address:
                                '${controller.selectedAddress},${controller.selectedState},${controller.selectedCountry} ',
                            onChangePressed: () async {
                              print('change address pressed');
                              //Get.toNamed(AppRoutes.checkoutAddressChange);
                              // Navigator.of(context).push(
                              //   CupertinoPageRoute(
                              //     builder: (context) => CheckoutAddressChangeScreen(),
                              //   ),
                              // );
                              result = await Get.toNamed(
                                  AppRoutes.checkoutAddressChange,
                                  arguments: {
                                    'isFromProfile': widget.orderAddress.isEmpty
                                        ? true
                                        : false,
                                  });
                              if (result.isNotEmpty) {
                                setState(() {
                                  controller.selectedAddress.value =
                                      result['contact_address'];
                                  controller.selectedCountry.value =
                                      result['country'];
                                  controller.selectedState.value =
                                      result['state'];
                                  controller.selectedLga.value = result['lga'];
                                  controller.number.value =
                                      result['phone_number'];
                                  if (result['id'] != null) {
                                    controller.selectedAddressId.value =
                                        result['id'] as int;
                                  }
                                });
                              }
                            },
                          );
                        })
                      : AddressCard(
                          name: fullName,
                          action:
                              widget.orderAddress.isNotEmpty ? 'Change' : 'Add',
                          address: widget.orderAddress.isNotEmpty
                              ? '${widget.orderAddress['contact_address']},${widget.orderAddress['lga']},${widget.orderAddress['state']},${widget.orderAddress['country']}.'
                              : 'Set Address to recieve your order.',
                          onChangePressed: () async {
                            final newAddress = await Get.toNamed(
                                AppRoutes.checkoutAddressChange,
                                arguments: {
                                  'isFromProfile': widget.orderAddress.isEmpty
                                      ? true
                                      : false,
                                });
                            if (newAddress != null && newAddress.isNotEmpty) {
                              setState(() {
                                result = newAddress;
                                controller.selectedAddress.value =
                                    newAddress['contact_address'] ?? '';
                                controller.selectedCountry.value =
                                    newAddress['country'] ?? '';
                                controller.selectedState.value =
                                    newAddress['state'] ?? '';
                                controller.selectedLga.value =
                                    newAddress['lga'] ?? '';
                                controller.number.value =
                                    newAddress['phone_number'] ?? '';
                                if (newAddress['id'] != null) {
                                  controller.selectedAddressId.value =
                                      newAddress['id'] as int;
                                }
                              });
                            }
                          },
                        ),
                ],
              ),
            ),
            //ElevatedButton(onPressed: (){print(result);}, child: Text('Print Result'))
          ],
        ),
      ),
    );
  }
}


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:jara_market/services/api_service.dart';

// // ─── Model ───────────────────────────────────────────────────────────────────

// class DeliveryAddress {
//   final int? id;
//   final String contactAddress;
//   final String phoneNumber;
//   final int? stateId;
//   final String? stateName;
//   final int? lgaId;
//   final String? lgaName;
//   final int? countryId;
//   final bool isDefault;
//   final double? latitude;
//   final double? longitude;

//   DeliveryAddress({
//     this.id,
//     required this.contactAddress,
//     required this.phoneNumber,
//     this.stateId,
//     this.stateName,
//     this.lgaId,
//     this.lgaName,
//     this.countryId,
//     this.isDefault = false,
//     this.latitude,
//     this.longitude,
//   });

//   factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
//     return DeliveryAddress(
//       id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
//       contactAddress: json['contact_address']?.toString() ?? '',
//       phoneNumber: json['phone_number']?.toString() ?? '',
//       stateId: json['state_id'] is int
//           ? json['state_id']
//           : int.tryParse(json['state_id']?.toString() ?? ''),
//       stateName: json['state']?['name']?.toString(),
//       lgaId: json['lga_id'] is int
//           ? json['lga_id']
//           : int.tryParse(json['lga_id']?.toString() ?? ''),
//       lgaName: json['lga']?['name']?.toString(),
//       countryId: json['country_id'] is int
//           ? json['country_id']
//           : int.tryParse(json['country_id']?.toString() ?? ''),
//       isDefault: json['is_default'] == true || json['is_default'] == 1,
//       latitude: double.tryParse(json['latitude']?.toString() ?? ''),
//       longitude: double.tryParse(json['longitude']?.toString() ?? ''),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'contact_address': contactAddress,
//         'phone_number': phoneNumber,
//         if (stateId != null) 'state_id': stateId,
//         if (lgaId != null) 'lga_id': lgaId,
//         if (countryId != null) 'country_id': countryId,
//         'is_default': isDefault,
//         if (latitude != null) 'latitude': latitude,
//         if (longitude != null) 'longitude': longitude,
//       };
// }

// // ─── Controller ──────────────────────────────────────────────────────────────

// class DeliveryAddressController extends GetxController {
//   final ApiService _api = ApiService(const Duration(seconds: 30));

//   RxList<DeliveryAddress> addresses = <DeliveryAddress>[].obs;
//   Rx<DeliveryAddress?> selected = Rx<DeliveryAddress?>(null);
//   RxBool isLoading = false.obs;
//   RxBool isGeolocating = false.obs;

//   // Form state
//   final addressCtrl = TextEditingController();
//   final phoneCtrl = TextEditingController();
//   RxDouble? detectedLat;
//   RxDouble? detectedLng;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchAddresses();
//   }

//   @override
//   void onClose() {
//     addressCtrl.dispose();
//     phoneCtrl.dispose();
//     super.onClose();
//   }

//   Future<void> fetchAddresses() async {
//     isLoading.value = true;
//     try {
//       final res = await _api.getAddresses();
//       if (res.statusCode == 200) {
//         final body = jsonDecode(res.body);
//         final list = body['data'] as List? ?? [];
//         addresses.value =
//             list.map((e) => DeliveryAddress.fromJson(e)).toList();
//         // Auto-select default
//         final def = addresses.firstWhereOrNull((a) => a.isDefault);
//         if (def != null) selected.value = def;
//       }
//     } catch (_) {} finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> detectLocation() async {
//     isGeolocating.value = true;
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         Get.snackbar('Location Disabled',
//             'Please enable location services in settings.',
//             snackPosition: SnackPosition.BOTTOM);
//         return;
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           Get.snackbar('Permission Denied', 'Location permission was denied.',
//               snackPosition: SnackPosition.BOTTOM);
//           return;
//         }
//       }
//       if (permission == LocationPermission.deniedForever) {
//         Get.snackbar('Permission Denied',
//             'Location permission is permanently denied. Enable it in settings.',
//             snackPosition: SnackPosition.BOTTOM);
//         return;
//       }

//       final position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);

//       detectedLat = position.latitude.obs;
//       detectedLng = position.longitude.obs;

//       // Reverse geocode
//       final placemarks = await placemarkFromCoordinates(
//           position.latitude, position.longitude);
//       if (placemarks.isNotEmpty) {
//         final p = placemarks.first;
//         final addr = [
//           p.street,
//           p.subLocality,
//           p.locality,
//           p.administrativeArea,
//         ].where((s) => s != null && s.isNotEmpty).join(', ');
//         addressCtrl.text = addr;
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Could not detect location: $e',
//           snackPosition: SnackPosition.BOTTOM);
//     } finally {
//       isGeolocating.value = false;
//     }
//   }

//   Future<bool> saveAddress({bool isDefault = false}) async {
//     if (addressCtrl.text.trim().isEmpty || phoneCtrl.text.trim().isEmpty) {
//       Get.snackbar('Incomplete', 'Please fill address and phone number.',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white);
//       return false;
//     }

//     isLoading.value = true;
//     try {
//       final data = DeliveryAddress(
//         contactAddress: addressCtrl.text.trim(),
//         phoneNumber: phoneCtrl.text.trim(),
//         isDefault: isDefault,
//         latitude: detectedLat?.value,
//         longitude: detectedLng?.value,
//       );
//       final res = await _api.storeAddress(data.toJson());
//       final body = jsonDecode(res.body);
//       if (res.statusCode == 200 || res.statusCode == 201) {
//         await fetchAddresses();
//         Get.snackbar('Saved', 'Address saved successfully.',
//             backgroundColor: const Color(0xFF22C55E),
//             colorText: Colors.white,
//             snackPosition: SnackPosition.BOTTOM);
//         return true;
//       }
//       Get.snackbar('Error', body['message'] ?? 'Could not save address.',
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//           snackPosition: SnackPosition.BOTTOM);
//       return false;
//     } catch (_) {
//       Get.snackbar('Error', 'Network error. Please try again.',
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//           snackPosition: SnackPosition.BOTTOM);
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void selectAddress(DeliveryAddress addr) {
//     selected.value = addr;
//   }
// }

// // ─── Screen ──────────────────────────────────────────────────────────────────

// class DeliveryAddressScreen extends StatelessWidget {
//   /// When [selectMode] is true the screen is used at checkout to pick an address
//   /// and returns the selected [DeliveryAddress] via [Get.back].
//   final bool selectMode;

//   const DeliveryAddressScreen({Key? key, this.selectMode = false})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final ctrl = Get.put(DeliveryAddressController());

//     return Scaffold(
//       backgroundColor: const Color(0xFFF9FAFB),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: const BackButton(color: Colors.black),
//         title: Text(
//           selectMode ? 'Select Delivery Address' : 'Delivery Addresses',
//           style: const TextStyle(
//               color: Colors.black, fontWeight: FontWeight.w700, fontSize: 17),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         backgroundColor: const Color(0xFFFFAA00),
//         onPressed: () => _showAddressForm(context, ctrl),
//         icon: const Icon(Icons.add, color: Colors.white),
//         label: const Text('Add Address',
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
//       ),
//       body: Obx(() {
//         if (ctrl.isLoading.value && ctrl.addresses.isEmpty) {
//           return const Center(
//               child: CircularProgressIndicator(color: Color(0xFFFFAA00)));
//         }
//         if (ctrl.addresses.isEmpty) {
//           return _EmptyAddresses(onAdd: () => _showAddressForm(context, ctrl));
//         }
//         return RefreshIndicator(
//           color: const Color(0xFFFFAA00),
//           onRefresh: ctrl.fetchAddresses,
//           child: ListView.builder(
//             padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
//             itemCount: ctrl.addresses.length,
//             itemBuilder: (_, i) {
//               final addr = ctrl.addresses[i];
//               final isSelected = ctrl.selected.value?.id == addr.id;
//               return _AddressCard(
//                 address: addr,
//                 isSelected: isSelected,
//                 selectMode: selectMode,
//                 onTap: () {
//                   ctrl.selectAddress(addr);
//                   if (selectMode) Get.back(result: addr);
//                 },
//               );
//             },
//           ),
//         );
//       }),
//     );
//   }

//   void _showAddressForm(BuildContext context, DeliveryAddressController ctrl) {
//     ctrl.addressCtrl.clear();
//     ctrl.phoneCtrl.clear();
//     bool isDefault = false;

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
//       builder: (_) => StatefulBuilder(
//         builder: (ctx, setState) {
//           return Padding(
//             padding: EdgeInsets.only(
//               left: 24,
//               right: 24,
//               top: 24,
//               bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
//             ),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Handle
//                   Center(
//                     child: Container(
//                       width: 40,
//                       height: 4,
//                       decoration: BoxDecoration(
//                           color: Colors.grey.shade300,
//                           borderRadius: BorderRadius.circular(2)),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text('Add New Address',
//                       style: TextStyle(
//                           fontSize: 18, fontWeight: FontWeight.w700)),
//                   const SizedBox(height: 20),

//                   // ── Geolocation button ──
//                   Obx(() => SizedBox(
//                         width: double.infinity,
//                         height: 48,
//                         child: OutlinedButton.icon(
//                           onPressed: ctrl.isGeolocating.value
//                               ? null
//                               : () async {
//                                   await ctrl.detectLocation();
//                                   setState(() {}); // refresh form
//                                 },
//                           icon: ctrl.isGeolocating.value
//                               ? const SizedBox(
//                                   width: 16,
//                                   height: 16,
//                                   child: CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                       color: Color(0xFFFFAA00)))
//                               : const Icon(Icons.my_location_rounded,
//                                   color: Color(0xFFFFAA00), size: 18),
//                           label: Text(
//                             ctrl.isGeolocating.value
//                                 ? 'Detecting location...'
//                                 : 'Use My Current Location',
//                             style:
//                                 const TextStyle(color: Color(0xFFFFAA00)),
//                           ),
//                           style: OutlinedButton.styleFrom(
//                             side: const BorderSide(color: Color(0xFFFFAA00)),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12)),
//                           ),
//                         ),
//                       )),
//                   const SizedBox(height: 8),
//                   const Row(
//                     children: [
//                       Expanded(child: Divider()),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 8),
//                         child: Text('or enter manually',
//                             style: TextStyle(
//                                 fontSize: 12, color: Colors.grey)),
//                       ),
//                       Expanded(child: Divider()),
//                     ],
//                   ),
//                   const SizedBox(height: 12),

//                   // ── Address field ──
//                   const Text('Delivery Address',
//                       style: TextStyle(
//                           fontWeight: FontWeight.w600, fontSize: 13)),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: ctrl.addressCtrl,
//                     maxLines: 3,
//                     textCapitalization: TextCapitalization.sentences,
//                     decoration: _inputDec(
//                         hint: 'Enter your full delivery address'),
//                   ),
//                   const SizedBox(height: 16),

//                   // ── Phone field ──
//                   const Text('Phone Number',
//                       style: TextStyle(
//                           fontWeight: FontWeight.w600, fontSize: 13)),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: ctrl.phoneCtrl,
//                     keyboardType: TextInputType.phone,
//                     decoration:
//                         _inputDec(hint: 'Contact number for this address'),
//                   ),
//                   const SizedBox(height: 16),

//                   // ── Set as default ──
//                   Row(
//                     children: [
//                       Checkbox(
//                         value: isDefault,
//                         activeColor: const Color(0xFFFFAA00),
//                         onChanged: (v) => setState(() => isDefault = v!),
//                       ),
//                       const Text('Set as default address',
//                           style: TextStyle(fontSize: 14)),
//                     ],
//                   ),
//                   const SizedBox(height: 20),

//                   // ── Save button ──
//                   Obx(() => SizedBox(
//                         width: double.infinity,
//                         height: 52,
//                         child: ElevatedButton(
//                           onPressed: ctrl.isLoading.value
//                               ? null
//                               : () async {
//                                   final ok = await ctrl.saveAddress(
//                                       isDefault: isDefault);
//                                   if (ok && context.mounted) {
//                                     Navigator.pop(context);
//                                   }
//                                 },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFFFFAA00),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(14)),
//                           ),
//                           child: ctrl.isLoading.value
//                               ? const SizedBox(
//                                   width: 22,
//                                   height: 22,
//                                   child: CircularProgressIndicator(
//                                       color: Colors.white, strokeWidth: 2.5))
//                               : const Text('Save Address',
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w700,
//                                       color: Colors.white)),
//                         ),
//                       )),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   InputDecoration _inputDec({required String hint}) {
//     return InputDecoration(
//       hintText: hint,
//       hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: Colors.grey.shade300),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: Colors.grey.shade300),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Color(0xFFFFAA00), width: 1.5),
//       ),
//       contentPadding: const EdgeInsets.all(14),
//     );
//   }
// }

// // ─── Address Card ─────────────────────────────────────────────────────────────

// class _AddressCard extends StatelessWidget {
//   final DeliveryAddress address;
//   final bool isSelected;
//   final bool selectMode;
//   final VoidCallback onTap;

//   const _AddressCard({
//     required this.address,
//     required this.isSelected,
//     required this.selectMode,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 180),
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(
//             color: isSelected
//                 ? const Color(0xFFFFAA00)
//                 : Colors.grey.shade200,
//             width: isSelected ? 2 : 1,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 color: isSelected
//                     ? const Color(0xFFFFAA00).withOpacity(0.1)
//                     : Colors.grey.shade100,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(
//                 Icons.location_on_rounded,
//                 color: isSelected ? const Color(0xFFFFAA00) : Colors.grey,
//                 size: 20,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       if (address.isDefault)
//                         Container(
//                           margin: const EdgeInsets.only(right: 8),
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 8, vertical: 2),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFFFFAA00).withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                           child: const Text('Default',
//                               style: TextStyle(
//                                   fontSize: 10,
//                                   color: Color(0xFFFFAA00),
//                                   fontWeight: FontWeight.w700)),
//                         ),
//                       Expanded(
//                         child: Text(
//                           address.contactAddress,
//                           style: const TextStyle(
//                               fontWeight: FontWeight.w600, fontSize: 14),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 4),
//                   Text(address.phoneNumber,
//                       style: TextStyle(
//                           fontSize: 13, color: Colors.grey.shade600)),
//                   if (address.stateName != null || address.lgaName != null) ...[
//                     const SizedBox(height: 2),
//                     Text(
//                       [address.lgaName, address.stateName]
//                           .where((s) => s != null && s.isNotEmpty)
//                           .join(', '),
//                       style: TextStyle(
//                           fontSize: 12, color: Colors.grey.shade400),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//             if (selectMode && isSelected)
//               const Icon(Icons.check_circle_rounded,
//                   color: Color(0xFFFFAA00), size: 22),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _EmptyAddresses extends StatelessWidget {
//   final VoidCallback onAdd;
//   const _EmptyAddresses({required this.onAdd});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.location_off_rounded,
//                 size: 64, color: Colors.grey.shade300),
//             const SizedBox(height: 16),
//             const Text('No saved addresses',
//                 style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey)),
//             const SizedBox(height: 8),
//             const Text('Add a delivery address to get started',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.grey)),
//             const SizedBox(height: 24),
//             ElevatedButton.icon(
//               onPressed: onAdd,
//               icon: const Icon(Icons.add, color: Colors.white),
//               label: const Text('Add Address',
//                   style: TextStyle(color: Colors.white)),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFFFFAA00),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─── Checkout Address Widget (inline at checkout) ─────────────────────────────

// class CheckoutAddressWidget extends StatelessWidget {
//   const CheckoutAddressWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final ctrl = Get.put(DeliveryAddressController());

//     return Obx(() {
//       final addr = ctrl.selected.value;
//       return Container(
//         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: Colors.grey.shade200),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 const Icon(Icons.location_on_rounded,
//                     color: Color(0xFFFFAA00), size: 18),
//                 const SizedBox(width: 6),
//                 const Text('Delivery Address',
//                     style: TextStyle(
//                         fontWeight: FontWeight.w700, fontSize: 14)),
//                 const Spacer(),
//                 GestureDetector(
//                   onTap: () async {
//                     final result = await Get.to(
//                         () => const DeliveryAddressScreen(selectMode: true));
//                     if (result is DeliveryAddress) {
//                       ctrl.selectAddress(result);
//                     }
//                   },
//                   child: const Text('Change',
//                       style: TextStyle(
//                           color: Color(0xFFFFAA00),
//                           fontSize: 13,
//                           fontWeight: FontWeight.w600)),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             if (addr == null)
//               GestureDetector(
//                 onTap: () async {
//                   final result = await Get.to(
//                       () => const DeliveryAddressScreen(selectMode: true));
//                   if (result is DeliveryAddress) ctrl.selectAddress(result);
//                 },
//                 child: Row(
//                   children: [
//                     Icon(Icons.add_circle_outline,
//                         color: Colors.grey.shade400, size: 16),
//                     const SizedBox(width: 6),
//                     Text('Tap to select delivery address',
//                         style: TextStyle(
//                             color: Colors.grey.shade400, fontSize: 13)),
//                   ],
//                 ),
//               )
//             else
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(addr.contactAddress,
//                       style: const TextStyle(
//                           fontSize: 14, fontWeight: FontWeight.w500)),
//                   const SizedBox(height: 2),
//                   Text(addr.phoneNumber,
//                       style: TextStyle(
//                           fontSize: 12, color: Colors.grey.shade500)),
//                 ],
//               ),
//           ],
//         ),
//       );
//     });
//   }
// }