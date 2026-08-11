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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:developer' as myLog;

import 'package:jara_market/config/local_storage.dart';
import 'package:jara_market/services/api_service.dart';
ApiService apiService = ApiService(Duration(seconds: 60 * 5)); // Replace with your actual API service instance

// The "Web client" OAuth client ID from Google Cloud Console (client_type 3
// in google-services.json). google_sign_in v7 needs this passed explicitly
// on Android to return a usable idToken — without it, idToken comes back
// null and the backend never receives anything to verify.
const _googleServerClientId =
    '915451905241-s4d5m4bqg764u142n9biopk0rl6ats8j.apps.googleusercontent.com';
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
    ever(errorMessage, (String value) {
      if (value.isNotEmpty) {
        Get.snackbar(
          'Sign-In',
          value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    });
  }

  /// Ensures Google Sign-In is configured with native options
  Future<void> initGoogleSignIn() async {
    if (_googleSignInInitialized) return;
    try {
      await GoogleSignIn.instance.initialize(
        serverClientId: _googleServerClientId,
      );
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
      await _handleSocialResponse(
        res1.body,
        provider: 'Google',
        fallbackName: account.displayName ?? '',
        fallbackEmail: account.email,
      );
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

  /// Sign-In / Sign-Up via Apple (iOS). Same backend upsert contract as Google.
  Future<void> loginWithApple() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final String? identityToken = credential.identityToken;
      if (identityToken == null) {
        errorMessage.value = 'Apple sign-in failed. Token missing.';
        isLoading.value = false;
        return;
      }

      // Apple only provides the name on the FIRST authorization, so pass it
      // along for the backend to use when it creates the account.
      final res1 = await apiService.appleSignIn(
        identityToken: identityToken,
        role: 'customer',
        firstName: credential.givenName,
        lastName: credential.familyName,
      );

      isLoading.value = false;
      await _handleSocialResponse(
        res1.body,
        provider: 'Apple',
        fallbackName:
            '${credential.givenName ?? ''} ${credential.familyName ?? ''}'.trim(),
        fallbackEmail: credential.email ?? '',
      );
    } catch (e) {
      isLoading.value = false;
      if (e is SignInWithAppleAuthorizationException) {
        if (e.code != AuthorizationErrorCode.canceled) {
          errorMessage.value = 'Apple sign-in error: ${e.message}';
        }
      } else {
        errorMessage.value = 'Apple sign-in error: $e';
      }
    }
  }

  /// Shared backend-response handling for Google/Apple sign-in.
  Future<void> _handleSocialResponse(
    String body, {
    required String provider,
    required String fallbackName,
    required String fallbackEmail,
  }) async {
    var res = jsonDecode(body);
    myLog.log('$provider backend response received: $res');
    if (res['status'] == true) {
      final data = res['data'];

      // Persist session tokens locally
      await _db.saveToken(data['token'] ?? '');
      await _db.saveRefreshToken(data['refresh_token'] ?? '');
      final backendName =
          '${data['firstname'] ?? ''} ${data['lastname'] ?? ''}'.trim();
      await _db.saveUserName(backendName.isNotEmpty ? backendName : fallbackName);
      await _db.saveEmail(data['email'] ?? fallbackEmail);

      isLoggedIn.value = true;
      Get.offAllNamed('/main_screen');
    } else {
      errorMessage.value = res['message'] ?? '$provider authentication rejected.';
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