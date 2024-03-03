import 'package:ava_hesab/config/app_colors.dart';
import 'package:ava_hesab/core/database/boxes.dart';
import 'package:ava_hesab/core/utils/file_utility.dart';
import 'package:ava_hesab/feature/login/login_screen.dart';
import 'package:ava_hesab/feature/splash/data/model/first_time.dart';
import 'package:flutter/material.dart';

class IntroSlider extends StatefulWidget {
  const IntroSlider({super.key});

  @override
  State<IntroSlider> createState() => _IntroSliderState();
}

class _IntroSliderState extends State<IntroSlider> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  final List<Map<String, dynamic>> _slides = [
    {
      'image': 'assets/svg/ava.svg',
      'title': 'لورم ایپسوم 1',
      'description': 'لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ و با استفاده از طراحان گرافیک است',
    },
    {
      'image': 'assets/svg/ava.svg',
      'title': 'ایپسوم لورم',
      'description': 'لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ و با استفاده از طراحان گرافیک است',
    },
    {
      'image': 'assets/svg/ava.svg',
      'title': 'لورم ایپسوم',
      'description': 'لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ و با استفاده از طراحان گرافیک است',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Directionality(
            textDirection: TextDirection.ltr,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _slides.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (BuildContext context, int index) {
                return Slide(
                  image: _slides[index]['image'],
                  title: _slides[index]['title'],
                  description: _slides[index]['description'],
                );
              },
            ),
          ),
          Positioned(
            bottom: 20.0,
            left: 24.0,
            right: 24.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor:
                            _currentPage == _slides.length - 1 ? AppColorsLight.primaryColor : Colors.transparent,
                        foregroundColor:
                            _currentPage == _slides.length - 1 ? Colors.white : AppColorsLight.textLightDefault),
                    onPressed: () {
                      if (_currentPage != _slides.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      } else {
                        var firstTimeBox = HiveBoxes.getIsFirstTime();
                        firstTimeBox.put('firstTimeBox', FirstTime(isFirstTime: false));
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                            (route) => false);
                      }
                    },
                    child: Text(_currentPage == _slides.length - 1 ? 'تمام' : 'بعدی'),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: _buildPageIndicator(),
                  ),
                ),
                Opacity(
                  opacity: _currentPage != 0 ? 1 : 0,
                  child: SizedBox(
                    width: 100,
                    child: TextButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      },
                      child: const Text('قبلی'),
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

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < _slides.length; i++) {
      indicators.add(_currentPage == i ? _indicator(true) : _indicator(false));
    }
    return indicators;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: isActive ? AppColorsLight.primaryColor : AppColorsLight.surfaceColorHeavy,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class Slide extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  Slide({super.key, required this.image, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: renderSvg(image, height: 200.0),
        ),
        Text(title, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(description, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
