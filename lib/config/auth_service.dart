// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   // Sign in with Google
//   Future<UserCredential?> signInWithGoogle() async {
//     try {
//       // 1. Trigger the Google authentication flow
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

//       if (googleUser == null) {
//         // The user canceled the sign-in flow
//         return null; 
//       }

//       // 2. Obtain the auth details from the request
//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

//       // 3. Create a new credential for Firebase
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       // 4. Sign in to Firebase with the credential
//       return await _auth.signInWithCredential(credential);
//     } catch (e) {
//       print("Error signing in with Google: $e");
//       return null;
//     }
//   }

//   // Sign out
//   Future<void> signOut() async {
//     try {
//       await _googleSignIn.signOut();
//       await _auth.signOut();
//     } catch (e) {
//       print("Error signing out: $e");
//     }
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer' as myLog;

import 'package:jara_market/config/local_storage.dart';
import 'package:jara_market/services/api_service.dart';
ApiService apiService = ApiService(Duration(seconds: 60 * 5)); // Replace with your actual API service instance
class AuthController extends GetxController {
  // Observables for UI state management
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isLoggedIn = false.obs;

  bool _googleSignInInitialized = false;

  // Mocked/Placeholder references based on your code context
  final _db = DataBase(); // Replace with your actual local storage instance
  //final myLog = YourLogger();        // Replace with your logger

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
    initGoogleSignIn();
  }

  /// Ensures Google Sign-In is configured with native options
  Future<void> initGoogleSignIn() async {
    if (_googleSignInInitialized) return;
    try {
      await GoogleSignIn.instance.initialize();
      _googleSignInInitialized = true;
    } catch (e) {
      myLog.log("Failed to initialize Google Sign-In: $e");
    }
  }

  /// Unified Sign-In / Sign-Up Flow via Google
  Future<void> loginWithGoogle() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      await initGoogleSignIn();

      // Setup a listener to catch the authentication event
      final completer = Completer<GoogleSignInAccount?>();

      final sub = GoogleSignIn.instance.authenticationEvents.listen((event) {
        if (event is GoogleSignInAuthenticationEventSignIn) {
          myLog.log(event.toString());
          completer.complete(event.user);
        } else if (event is GoogleSignInAuthenticationEventSignOut) {
          myLog.log(event.toString());
          completer.complete(null);
        }
      }, onError: (e) => completer.completeError(e));

      // Trigger the native platform sign-in flow
      await GoogleSignIn.instance.authenticate();

      final account = await completer.future;
      await sub.cancel(); // Clean up subscription immediately

      if (account == null) {
        isLoading.value = false;
        myLog.log('Google Sign-In interaction was canceled by user.');
        return;
      }

      // Fetch the security tokens required by your web backend
      final GoogleSignInAuthentication auth = await account.authentication;
      final String? idToken = auth.idToken;

      if (idToken == null) {
        errorMessage.value = 'Google sign-in failed. Token missing.';
        isLoading.value = false;
        return;
      }

      // Send payloads to your custom ApiService 
      // Note: Backend processes this single endpoint as both Sign In / Sign Up (Upsert)
      final res1 = await apiService.googleSignIn(
        idToken: idToken,
        // email: account.email,
        // displayName: account.displayName,
        // photoUrl: account.photoUrl,
        role: 'customer',
      );
      
      isLoading.value = false;
      var res = jsonDecode(res1.body); // Adjust based on your actual response structure
      myLog.log('Google backend response received: $res');
      if (res['success'] == true) {
        final data = res['data'];
        
        // Persist session tokens locally
        await _db.saveToken(data['access'] ?? data['token'] ?? '');
        await _db.saveRefreshToken(data['refresh'] ?? '');
        await _db.saveUserName(data['username'] ?? account.displayName ?? '');
        await _db.saveEmail(data['email'] ?? account.email);
        
        isLoggedIn.value = true;
        await fetchMe(); // Fetch current user details from server

        // Route matching backend status instructions
        if (data['code'] == 200) {
          Get.offAllNamed('/main_screen');
        } else {
          Get.offAllNamed('/preferences_screen');
        }
      } else {
        errorMessage.value = res['error'] ?? 'Google authentication rejected.';
      }
    } catch (e) {
      isLoading.value = false;
      if (e is GoogleSignInException) {
        if (e.code != GoogleSignInExceptionCode.canceled) {
          errorMessage.value = 'Google sign-in error: ${e.description}';
        }
      } else {
        errorMessage.value = 'Google sign-in error: $e';
      }
    }
  }

  /// Complete Logout Flow
  Future<void> logout() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      await initGoogleSignIn();

      // 1. Disconnect / Clear native Google token cache so the account picker shows up next time
      await GoogleSignIn.instance.signOut();

      // 2. Clear local application cache/tokens
      await _db.clearAuthSession(); // Implement this in your DB wrapper to delete tokens

      isLoggedIn.value = false;
      isLoading.value = false;

      // 3. Kick user out back to the authentication portal
      Get.offAllNamed('/login_screen');
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Error logging out: $e';
      myLog.log('Logout error: $e');
    }
  }

  /// Helper functions to replicate missing context blocks
  Future<void> _checkLoginStatus() async {
    // Read from your DB implementation to flip `isLoggedIn.value` state on startup
    String token = await _db.getToken() ?? '';
    if (token.isNotEmpty) {
      isLoggedIn.value = true;
    }
  }

  Future<void> fetchMe() async {
    // Fetch profile data here if required
  }
}