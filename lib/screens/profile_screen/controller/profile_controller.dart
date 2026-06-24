import 'package:alert_info/alert_info.dart';
import 'package:jara_market/screens/splash/onboarding_screen.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:developer' as myLog;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jara_market/screens/main_screen/main_screen.dart';
import 'package:jara_market/screens/profile_screen/models/model.dart';
import 'package:jara_market/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  ApiService _apiService = ApiService(Duration(seconds: 60 * 5));

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  ImagePicker? picker = ImagePicker();
  Rx<XFile?> file1 = Rx<XFile?>(null);
  RxBool isToUpdate = false.obs;
  RxBool isLoading = false.obs;
  ProfileModel profileModel =
      ProfileModel(status: false, message: '', data: ProfileData());
  ProfileData data = ProfileData();

  RxString? errorMessage = ''.obs;

  void fetchUserProfileByCondition() {
    // Replace 'id' with a field that is always present in ProfileData and indicates data presence
    if (data.id != null) return;
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    isLoading.value = true;
    try {
      // Replace fetchUserProfile with getUser
      final response = await _apiService.getUser();
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        isLoading.value = false;
        profileModel = profileModelFromJson(response.body);
        data = profileModel.data;
      } else {
        isLoading.value = false;

        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(content: Text('Failed to load profile: ${response.body}')),
        );
      }
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack Trace: $stackTrace');

      isLoading.value = false;
      errorMessage!.value = e.toString();
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> obtainImageFromGallery({Function? updateState}) async {
    try {
      final file = await picker?.pickImage(source: ImageSource.gallery);
      if (file != null) {
        // Correctly assign the XFile to the reactive Rx<XFile?>
        file1.value = file;
        isToUpdate.value = true;
        myLog.log('setting the obtain profile image to true');
        print(isToUpdate);
        // Update the state if necessary using GetX update()
        update();

        // Log the file path
        myLog.log(file1.value?.path ?? 'No file selected');
      }

      // Call updateState if provided
      // if (updateState != null) {
      //   updateState();
      // }
    } catch (e) {
      myLog.log("error: $e");
      _safeSnackbar('Error', e.toString());
    }
  }

  Future<void> obtainImageFromCamera({Function? updateState}) async {
    try {
      final file = await picker?.pickImage(source: ImageSource.camera);
      if (file != null) {
        // Correctly assign the XFile to the reactive Rx<XFile?>
        file1.value = file;
        isToUpdate.value = true;
        myLog.log('setting the obtain profile image to true');
        print(isToUpdate);
        // Update the state if necessary using GetX update()
        update();

        // Log the file path
        myLog.log(file1.value?.path ?? 'No file selected');
      }

      // Call updateState if provided
      // if (updateState != null) {
      //   updateState();
      // }
    } catch (e) {
      myLog.log("error: $e");
      _safeSnackbar('Error', e.toString());
    }
  }

  ApiService apiService = ApiService(Duration(seconds: 60 * 5));
  Future<void> updateUserProfile() async {
    try {
      isLoading.value = true;
      var token = await dataBase.getToken();
      // final response = await _apiService.editUserProfile(email, updatedData);
      String url =
          '${apiService.baseUrl}/update-profile'; // Replace with your API endpoint
      isLoading.value = false;
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        //'Content-Type': 'multipart/form-data', // Important for multipart
      };
      myLog.log(token);
      // Create multipart request
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(headers);
      request.fields['firstname'] = firstNameController.text;
      request.fields['lastname'] = lastNameController.text;
      request.fields['phone_number'] = phoneController.text;
      request.fields['country_id'] = '4';
      myLog.log('country_id: 4');
      myLog.log('firstName: ${firstNameController.text}');
      myLog.log('lastName: ${lastNameController.text}');
      myLog.log('phoneNumber: ${phoneController.text}');

      if (file1.value != null) {
        myLog.log('profile photo adding');
        XFile? imageFile = file1.value;
        String mimeType = lookupMimeType(imageFile!.path) ?? 'image/jpeg';
        String fileName = basename(imageFile.path);

        // Convert image to MultipartFile and add it to the request
        var multipartFile1 = await http.MultipartFile.fromPath(
          'profile_picture', // The name of the field in your API
          imageFile.path,
          filename: fileName,
          contentType:
              MediaType(mimeType.split('/')[0], mimeType.split('/')[1]),
        );
        request.files.add(multipartFile1);
      }

      // Send the request
      var response = await request.send();
      print(response.headers);
      print(response.stream);
      print(response.request);
      myLog.log('Response status: ${response.statusCode}');
      myLog.log('Response headers: ${response.headers}');
      myLog.log('Response request: ${response.request}');
      // var responseBody = await response.stream.bytesToString();
      //   myLog.log('Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // var responseBody = await response.stream.bytesToString();
        // myLog.log('Response Body: $responseBody');
        //   // Refresh profile data
        //   fetchUserProfile();
        //   ScaffoldMessenger.of(Get.context!).showSnackBar(
        //     const SnackBar(content: Text('Profile updated successfully')),
        //   );
        // } else {
        //   ScaffoldMessenger.of(Get.context!).showSnackBar(
        //     SnackBar(content: Text('Failed to update profile: ${response.body}')),
        //   );
        Get.snackbar("Success", "Profile updated successfully");
        myLog.log('Profile updated successfully');
        isToUpdate.value = false;
        file1.value = null; // Reset the file after successful update
        firstNameController.clear();
        lastNameController.clear();
        phoneController.clear();
        isLoading.value = false;
      } else {
        var responseBody = await response.stream.bytesToString();
        myLog.log('Profile update failed: ${response.statusCode} - $responseBody');
        _safeSnackbar("Error", "Profile update failed (${response.statusCode})");
      }
    } catch (e) {
      isLoading.value = false;
      myLog.log('Profile update exception: $e');
      _safeSnackbar("Error", "An error occurred while updating profile");
      // ScaffoldMessenger.of(Get.context!).showSnackBar(
      //   SnackBar(content: Text('Error: $e')),
      // );
    } finally {
      isLoading.value = false;
      // Optionally, you can refresh the profile data after updating
      fetchUserProfile();
      // Get.offAll(() => MainScreen());
    }
  }

  void logOut() async {
    // Clear user data and navigate to login screen
    var response = await apiService.logOut();
    if (response.statusCode == 200 || response.statusCode == 201) {
      myLog.log('User logged out successfully');
      dataBase.logOut();
      Get.offAll(() => OnboardingScreen());
      Get.snackbar("Logged out", "You have been logged out successfully");
    }
  }

  // PIN Management Methods
  RxBool isPINSet = false.obs;
  TextEditingController pinController = TextEditingController();
  TextEditingController confirmPinController = TextEditingController();

  Future<void> setPIN(String pin, String confirmPin) async {
    try {
      isLoading.value = true;
      if (pin != confirmPin) {
        Get.snackbar('Error', 'PINs do not match');
        isLoading.value = false;
        return;
      }

      if (pin.length < 4) {
        Get.snackbar('Error', 'PIN must be at least 4 digits');
        isLoading.value = false;
        return;
      }

      final response = await apiService.setPin(
        //{
        pin,
        confirmPin,
        // 'pin': pin,
        // 'confirm_pin': confirmPin,
        //}
      );

      isLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        isPINSet.value = true;
        pinController.clear();
        confirmPinController.clear();
        //Get.snackbar('Success', 'PIN set successfully');
        // AlertInfo.show(
        //     context: Get.context!,
        //     text: 'PIN set successfully',
        //     typeInfo: TypeInfo.success);
        // Fluttertoast.showToast(
        //   msg: 'PIN set successfully',
        //   toastLength: Toast.LENGTH_LONG,
        //   gravity: ToastGravity.BOTTOM,
        //   backgroundColor: Colors.green,
        //   textColor: Colors.white,
        // );
        Get.defaultDialog(
          title: 'Success',
          middleText: 'PIN set successfully',
          onConfirm: () {
            //Get.back();
            Navigator.pop(Get.context!);
          },
        );
        myLog.log('PIN set successfully');
      } else {
        // Get.snackbar('Error', 'Failed to set PIN');
        // AlertInfo.show(
        //     context: Get.context!,
        //     text: 'Failed to set PIN: ${response.body}',
        //     typeInfo: TypeInfo.error);
        // myLog.log('Error setting PIN: ${response.body}');
        Get.defaultDialog(
          title: 'Error',
          middleText: 'Failed to set PIN: ${response.body}',
          onConfirm: () {
            Get.back();
          },
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
      myLog.log('Error setting PIN: $e');
    }
  }

  Future<void> verifyPIN(String pin) async {
    try {
      isLoading.value = true;
      final response = await apiService.verifyPIN({
        'pin': pin,
        'remember': true,
      });

      isLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        // You can extract PIN token from response if needed
        Get.snackbar('Success', 'PIN verified successfully');
        myLog.log('PIN verified successfully');
      } else {
        Get.snackbar('Error', 'Invalid PIN');
        myLog.log('Error verifying PIN: ${response.body}');
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
      myLog.log('Error verifying PIN: $e');
    }
  }

  Future<void> validatePIN() async {
    try {
      final response = await apiService.validatePIN();

      if (response.statusCode == 200 || response.statusCode == 201) {
        isPINSet.value = true;
        myLog.log('PIN is valid');
      } else {
        isPINSet.value = false;
        myLog.log('PIN validation failed: ${response.body}');
      }
    } catch (e) {
      isPINSet.value = false;
      myLog.log('Error validating PIN: $e');
    }
  }

  Future<void> clearPIN() async {
    try {
      isLoading.value = true;
      final response = await apiService.clearPIN();

      isLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        isPINSet.value = false;
        Get.snackbar('Success', 'PIN cleared successfully');
        myLog.log('PIN cleared successfully');
      } else {
        Get.snackbar('Error', 'Failed to clear PIN');
        myLog.log('Error clearing PIN: ${response.body}');
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
      myLog.log('Error clearing PIN: $e');
    }
  }

  void _safeSnackbar(String title, String message) {
    try {
      if (Get.context != null) {
        Get.snackbar(title, message,
            backgroundColor: title == "Error" ? Colors.red : Colors.green,
            colorText: Colors.white);
      } else {
        myLog.log('Snackbar ($title): $message');
      }
    } catch (e) {
      myLog.log('Snackbar ($title): $message');
    }
  }
}
