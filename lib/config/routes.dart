import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:jara_market/screens/add_money_screen/add_money_screen.dart';
import 'package:jara_market/screens/add_money_screen/bindings/add_money_bindings.dart';
import 'package:jara_market/screens/browse_screen/bindings/browse_bindings.dart';
import 'package:jara_market/screens/browse_screen/browse_screen.dart';
import 'package:jara_market/screens/cart_screen/bindings/cart_bindings.dart';
import 'package:jara_market/screens/cart_screen/cart_screen.dart';
import 'package:jara_market/screens/categories_screen/bindings/categories_bindings.dart';
import 'package:jara_market/screens/categories_screen/categories_screen.dart';
import 'package:jara_market/screens/category_screen/bindings/category_bindings.dart';
import 'package:jara_market/screens/category_screen/category_screen.dart';
import 'package:jara_market/screens/checkout_address_change/bindings/checkout_address_change_binding.dart';
import 'package:jara_market/screens/checkout_address_change/checkout_address_change.dart';
import 'package:jara_market/screens/contact_screen/bindings/contact_bindings.dart';
import 'package:jara_market/screens/contact_screen/contact_screen.dart';
import 'package:jara_market/screens/egusi_soup_detail_screen/egusi_soup_detail_screen.dart';
import 'package:jara_market/screens/email_verification/bindings/email_verification_bindings.dart';
import 'package:jara_market/screens/email_verification/email_verification.dart';
import 'package:jara_market/screens/faq_screen/bindings/faq_bindings.dart';
import 'package:jara_market/screens/faq_screen/faq_screen.dart';
import 'package:jara_market/screens/favorites_screen/bindings/favorites_bindings.dart';
import 'package:jara_market/screens/favorites_screen/favorites_screen.dart';
import 'package:jara_market/screens/forget_password_screen/bindings/forget_password_bindings.dart';
import 'package:jara_market/screens/forget_password_screen/forget_password_screen.dart';
import 'package:jara_market/screens/grains_detailed_screen/bindings/grains_detailed_bindings.dart';
import 'package:jara_market/screens/grains_detailed_screen/grains_detailed_screen.dart';
import 'package:jara_market/screens/grains_screen/bindings/grains_bindings.dart';
import 'package:jara_market/screens/grains_screen/grains_screen.dart';
import 'package:jara_market/screens/home_screen/bindings/home_bindings.dart';
import 'package:jara_market/screens/home_screen/home_screen.dart';
import 'package:jara_market/screens/legal/privacy_policy_screen.dart';
import 'package:jara_market/screens/legal/terms_of_service_screen.dart';
import 'package:jara_market/screens/login%20email_verification/bindings/email_verification_bindings.dart';
import 'package:jara_market/screens/login%20email_verification/login_email_verification.dart';
import 'package:jara_market/screens/login_screen/bindings/login_bindings.dart';
import 'package:jara_market/screens/login_screen/login_screen.dart';
import 'package:jara_market/screens/main_screen/bindings/main_bindings.dart';
import 'package:jara_market/screens/main_screen/main_screen.dart';
import 'package:jara_market/screens/new_password_screen/bindings/new_password_bindings.dart';
import 'package:jara_market/screens/new_password_screen/new_password_screen.dart';
import 'package:jara_market/screens/order_details_screen/order_details_screen.dart';
import 'package:jara_market/screens/order_history_screen/bindings/order_history_bindings.dart';
import 'package:jara_market/screens/order_history_screen/order_history_screen.dart';
import 'package:jara_market/screens/order_receipt_screen/order_receipt_screen.dart';
import 'package:jara_market/screens/order_summary_screen/order_summary_screen.dart';
import 'package:jara_market/screens/order_tracking_screen/order_tracking_screen.dart';
import 'package:jara_market/screens/otp_verification/otp_verification.dart';
import 'package:jara_market/screens/product_detail_screen/bindings/product_detail_bindings.dart';
import 'package:jara_market/screens/product_detail_screen/product_detail_screen.dart';
import 'package:jara_market/screens/recipe_detail_screen/bindings/recipe_detail_bindings.dart';
import 'package:jara_market/screens/recipe_detail_screen/recipe_detail_screen.dart';
import 'package:jara_market/screens/referral_screen/bindings/referral_bindings.dart';
import 'package:jara_market/screens/referral_screen/referral_screen.dart';
import 'package:jara_market/screens/signup_screen/bindings/signup_bindings.dart';
import 'package:jara_market/screens/signup_screen/signup_screen.dart';
import 'package:jara_market/screens/soup_list_screen/soup_list_screen.dart';
import 'package:jara_market/screens/splash/onboarding_screen.dart';
import 'package:jara_market/screens/splash/splash_screen.dart';
import 'package:jara_market/screens/success_screen/bindings/success_bindings.dart';
import 'package:jara_market/screens/success_screen/success_screen.dart';
import 'package:jara_market/screens/summary_home_screen/bindings/summary_home_bindings.dart';
import 'package:jara_market/screens/summary_home_screen/summary_home_screen.dart';
import 'package:jara_market/screens/orders_screen/bindings/orders_bindings.dart';
import 'package:jara_market/screens/orders_screen/orders_screen.dart';
import 'package:jara_market/screens/user_orders_screen/bindings/user_orders_bindings.dart';
import 'package:jara_market/screens/user_orders_screen/user_orders_screen.dart';
import 'package:jara_market/screens/wallet_screen/bindings/wallet_bindings.dart';
import 'package:jara_market/screens/wallet_screen/wallet_screen.dart';
import 'package:jara_market/screens/wallet_screen/withdraw_screen.dart';
import 'package:jara_market/widgets/payment_method_card.dart';

class AppRoutes {
  static const addMoneyScreen = '/add_money_screen';
  static const browseScreen = '/browse_screen';
  static const cartScreen = '/cart_screen';
  static const categoriesScreen = '/categories_screen';
  static const categoryScreen = '/category_screen';
  static const checkoutScreen = '/checkout_screen';
  static const contactScreen = '/contact_screen';
  static const foodDetailScreen = '/food_detailScreen';
  static const emailVerificationScreen = '/emailVerificationScreen';
  static const loginEmailVerification = '/loginEmailVerificationScreen';
  static const faqScreen = '/faq_screen';
  static const favoritesScreen = '/favorites_screen';
  static const forgetPasswordScreen = '/forget_password_screen';
  static const grainsDetailedScreen = '/grains_detailed_screen';
  static const grainsScreen = '/grains_screen';
  static const homeScreen = '/home_screen';
  static const loginScreen = '/login_screen';
  static const mainScreen = '/main_screen';
  static const newPasswordScreen = '/new_password_screen';
  static const orderDetailsScreen = '/order_details_screen';
  static const orderHistoryScreen = '/order_history_screen';
  static const orderReceiptScreen = '/order_receipt_screen';
  static const orderSummaryScreen = '/order_summary_screen';
  static const orderTrackingScreen = '/order_tracking_screen';
  static const oTPVerificationScreen = '/oTP_verification_screen';
  static const paymentMethodScreen = '/payment_method_screen';
  static const productDetailScreen = '/product_detail_screen';
  static const recipeDetailScreen = '/recipe_detail_screen';
  static const referralScreen = '/referral_screen';
  static const signupScreen = '/signup_screen';
  static const soupListScreen = '/soupList_screen';
  static const splashScreen = '/splash_screen';
  static const onboardingScreen = '/onboarding_screen';
  static const successScreen = '/success_screen';
  static const summaryHomeScreen = '/summary_home_screen';
  static const ordersScreen = '/orders_screen';
  static const userOrdersScreen = '/user_orders_screen';
  static const walletScreen = '/user_orders_screen';
  static const privacyPolicyScreen = '/privacy_policy_screen';
  static const termsOfServiceScreen = '/terms_of_service_screen';
  static const checkoutAddressChange = '/checkout-address-change';

  static List<GetPage> pages = [
    GetPage(
        name: checkoutAddressChange,
        page: () => CheckoutAddressChangeScreen(),
        bindings: [CheckoutAddressChangeBinding()]),
    GetPage(
        name: addMoneyScreen,
        page: () => const AddMoneyScreen(),
        bindings: [AddMoneyBindings()]),
    GetPage(
        name: browseScreen,
        page: () => const BrowseScreen(),
        bindings: [BrowseBindings()]),
    GetPage(
        name: cartScreen,
        page: () => const CartScreen(),
        bindings: [CartBindings()]),
    GetPage(
        name: categoriesScreen,
        page: () => const CategoriesScreen(),
        bindings: [CategoriesBindings()]),
    GetPage(
        name: categoryScreen,
        page: () => const CategoryScreen(),
        bindings: [CategoryBindings()]),
    GetPage(
        name: contactScreen,
        page: () => const ContactScreen(),
        bindings: [ContactBindings()]),
    GetPage(
        name: faqScreen,
        page: () => const FaqScreen(),
        bindings: [FaqBindings()]),
    GetPage(
        name: favoritesScreen,
        page: () => const AIMealPrepFlow(),
        bindings: [FavoritesBindings()]),
    GetPage(
        name: forgetPasswordScreen,
        page: () => const ForgetPasswordScreen(),
        bindings: [ForgetPasswordBindings()]),
    GetPage(
        name: grainsDetailedScreen,
        page: () => const GrainsDetailedScreen(),
        bindings: [GrainsDetailedBindings()]),
    GetPage(
        name: grainsScreen,
        page: () => const GrainsScreen(
              forProduct: false,
            ),
        bindings: [GrainsBindings()]),
    GetPage(
      name: homeScreen,
      page: () => const HomeScreen(),
      bindings: [HomeBindings()],
    ),
    GetPage(
      name: loginScreen,
      page: () => const LoginScreen(),
      bindings: [LoginBindings()],
    ),
    GetPage(
        name: mainScreen,
        page: () => const MainScreen(),
        bindings: [MainBindings()]),
    GetPage(
        name: newPasswordScreen,
        page: () => const NewPasswordScreen(),
        bindings: [NewPasswordBindings()]),
    GetPage(
        name: orderHistoryScreen,
        page: () => OrderHistoryScreen(),
        bindings: [OrderHistoryBindings()]),
    GetPage(
        name: productDetailScreen,
        page: () => const ProductDetailScreen(),
        bindings: [ProductDetailBindings()]),
    GetPage(
        name: recipeDetailScreen,
        page: () => const RecipeDetailScreen(),
        bindings: [RecipeDetailBindings()]),
    GetPage(
        name: referralScreen,
        page: () => const ReferralScreen(),
        bindings: [ReferralBindings()]),
    GetPage(
        name: signupScreen,
        page: () => const SignupScreen(),
        bindings: [SignupBindings()]),
    GetPage(
      name: splashScreen,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: onboardingScreen,
      page: () => const OnboardingScreen(),
    ),
    GetPage(
        name: successScreen,
        page: () => const SuccessScreen(),
        bindings: [SuccessBindings()]),
    GetPage(
        name: summaryHomeScreen,
        page: () => const SummaryHomeScreen(),
        bindings: [SummaryHomeBindings()]),
    GetPage(
        name: ordersScreen,
        page: () => const OrdersScreen(),
        bindings: [OrdersBindings()]),
    GetPage(
        name: walletScreen,
        page: () => const WalletScreen(),
        bindings: [WalletBindings()]),
    GetPage(
      name: privacyPolicyScreen,
      page: () => const PrivacyPolicyScreen(),
    ),
    GetPage(
        name: termsOfServiceScreen, page: () => const TermsOfServiceScreen()),
    GetPage(
        name: emailVerificationScreen,
        page: () => const EmailVerificationScreen(),
        bindings: [EmailVerificationBindings()]),
    GetPage(
        name: loginEmailVerification,
        page: () => const LoginEmailVerification(),
        bindings: [LoginEmailVerificationBindings()]),
  ];
}
