import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../../routes/app_routes.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {

  @override
  Widget build(BuildContext context) {
    PageDecoration pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodyTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.black,
      ),
      imagePadding: EdgeInsets.only(top: 48),
    );

    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          title: "Expert Car Repairs",
          body:
          "Get professional help for car repairs, battery jumps, and flat tire fixes anytime, anywhere.",
          image: buildImage('car-repair.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Fast Towing Services",
          body:
          "Need a tow? We’ll get your vehicle to the nearest repair shop quickly and safely.",
          image: buildImage('towing.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Easy Online Payments",
          body:
          "Securely pay for services online with multiple payment options for a hassle-free experience.",
          image: buildImage('pay-online.png'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => goSignUp(context),
      onSkip: () => goSignUp(context),
      showSkipButton: true,
      nextFlex: 0,
      skip: const Text(
        'Skip',
        style: TextStyle(color: Colors.black),
      ),
      next: const Icon(
        Icons.arrow_forward,
        color: Color(0xff3A3434),
      ),
      done: const Text(
        'Getting Started!',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        color: Colors.grey,
        activeColor: const Color(0xff3A3434),
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}

void goSignUp(context) {
  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
}

Widget buildImage(String assetName) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Image.asset(
      'assets/images/intro/$assetName',
      width: 400,
    ),
  );
}
