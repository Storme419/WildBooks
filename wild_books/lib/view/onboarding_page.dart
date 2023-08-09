import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:wild_books/main.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const RootPage()),
    );
  }

  Widget _buildImage(String assetName) {
    return SafeArea(
      child: Image.asset(
        'lib/images/$assetName', width: 350,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
      bodyAlignment: Alignment.center,
      imageAlignment: Alignment.center,
      imageFlex: 5,
      bodyFlex: 4,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      globalHeader: const SafeArea(
        child: SizedBox(height: 50),
      ),
      pages: [
        PageViewModel(
          title: "Welcome to Wild Books",
          body: "Let's look at how to get started sharing and finding books.",
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Releasing a book",
          body:
              "Share your book with other app users! Register its details and location, and get a code to write inside. Leave it somewhere for others to find.",
          image: _buildImage('wildbooks1.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Search for books",
          body:
              "Use the app's map feature to locate books that have been shared and left in the wild.",
          image: _buildImage('wildbooks3.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Finding a book",
          body: "When you find a book, enter its code to see the journey the book has been on, and share your experience with other readers.",
          image: _buildImage('wildbooks2.png'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
