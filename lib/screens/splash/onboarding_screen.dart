import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/page_indicator.dart';
import 'package:jara_market/screens/login_screen/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _contents = [
    OnboardingContent(
      image: 'assets/images/clock_illustration.png',
      title: 'Offer a convenient time saving shopping solution at best price.',
      backgroundColor: Colors.white,
    ),
    OnboardingContent(
      image: 'assets/images/shopping_cart_illustration.png',
      title: 'Discount on bulk purchases up to 50% on service charge',
      backgroundColor: Colors.white,
    ),
    OnboardingContent(
      image: 'assets/images/megaphone_illustration.png',
      title: 'Refer and earn monetary commission',
      backgroundColor: Colors.white,
    ),
    OnboardingContent(
      image: 'assets/images/meal_prep.png',
      title: 'Fresh, prepped ingredients—so you can cook with ease and enjoy every meal!',
      backgroundColor: const Color(0xFFF8F0FF),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _contents.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Container(
                    color: _contents[index].backgroundColor,
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        Image.asset(
                          _contents[index].image,
                          height: 250,
                        ),
                        const SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            _contents[index].title,
                            style: const TextStyle(
                              fontSize: 22,
                              //fontWeight: FontWeight.bold,
                              fontFamily: 'Mont',
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  PageIndicator(
                    count: _contents.length,
                    currentIndex: _currentPage,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                        },
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (_currentPage < _contents.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => const LoginScreen()),
                            // );
                            Get.offAllNamed('/signup_screen');
                          }
                        },
                        child: Text(
                          _currentPage < _contents.length - 1 ? 'Next' : 'Get Started',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Updated CTA button to match the design in the image
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFA000), // Orange/amber color
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => const LoginScreen()),
                          // );
                           Get.offAllNamed('/login_screen');
                        },
                        borderRadius: BorderRadius.circular(28),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Already existing user',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 18),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.black,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
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
}

class OnboardingContent {
  final String image;
  final String title;
  final Color backgroundColor;

  OnboardingContent({
    required this.image,
    required this.title,
    required this.backgroundColor,
  });
}