import 'package:flutter/material.dart';
import 'package:logistics/data/models/response/onboarding_model.dart';
import 'package:logistics/services/route_helper.dart';
import 'package:logistics/views/base/common_button.dart';

import '../../../generated/assets.dart';
import '../auth/login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < onboardinglist.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        getCustomRoute(child: LoginPage()),
        (route) => false,
      );
    }
  }

  final List<OnboardingModel> onboardinglist = [
    OnboardingModel(Assets.imagesOnBoarding1, "On-Demand Logistics Made Easy",
        "Need to transport goods? Book a ride in seconds and get hassle-free delivery at your doorstep."),
    OnboardingModel(Assets.imagesOnBoarding2, "Reliable & Affordable",
        "Trusted delivery partners ensure your goods reach safely and on time, at the best prices."),
    OnboardingModel(Assets.imagesOnBoarding3, "Track & Manage Deliveries",
        "Track your delivery in real time, manage bookings, and get instant updates—all in one place."),
  ];
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Stack(children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: onboardinglist.length,
                  itemBuilder: (context, index) {
                    var data = onboardinglist[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          data.image,
                          width: 250,
                          height: 250,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          data.title,
                          style: Theme.of(context).textTheme.displayLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          data.subtitle,
                          style: Theme.of(context).textTheme.displaySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                ),
                Positioned(
                  bottom: 0,
                  top: MediaQuery.of(context).size.height * 0.55,
                  left: 50,
                  right: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardinglist.length,
                      (index) => Container(
                        height: 20,
                        width: 20,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Colors.black
                              : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            CustomButton(
              onTap: _onNext,
              elevation: 0,
              title: "Next",
            )
          ],
        ),
      ),
    );
  }
}
