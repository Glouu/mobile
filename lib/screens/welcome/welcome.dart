import 'package:flutter/material.dart';
import 'package:gloou/screens/sign_up/sign_up.dart';
import 'package:gloou/shared/colors/colors.dart';
import 'package:gloou/widgets/slider_widget.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  int _currentPage = 0;
  PageController _pageController = PageController();

  List _pages = [
    SliderPage(
      bgImage: "assets/images/welcome_logo.png",
      image: "assets/images/get_started1.svg",
      title: "Welcome to GLOOU",
      description:
          "Lorem Ipsum is simply dummy text of the printing and typesetting Lorem Ipsum is simply dummy text of Ipsum ",
    ),
    SliderPage(
      bgImage: "assets/images/connect_logo.png",
      image: "assets/images/get_started2.svg",
      title: "Connect with friends",
      description: "Connect Description Will Be Here",
    ),
    SliderPage(
      bgImage: "assets/images/everything_logo.png",
      image: "assets/images/get_started3.svg",
      title: "Everything in one place",
      description: "Everything Description Will Be Here",
    ),
  ];

  _onChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Stack(
        children: [
          PageView.builder(
            itemBuilder: (context, int index) {
              return _pages[index];
            },
            onPageChanged: _onChanged,
            scrollDirection: Axis.horizontal,
            controller: _pageController,
            itemCount: _pages.length,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    (_currentPage == (_pages.length - 1))
                        ? Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => SignUp()))
                        : _pageController.nextPage(
                            duration: Duration(milliseconds: 800),
                            curve: Curves.easeInOutQuint,
                          );
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: 50,
                    alignment: Alignment.center,
                    width: (_currentPage == (_pages.length - 1)) ? 250 : 50,
                    decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: (_currentPage == (_pages.length - 1))
                        ? Text(
                            "Get Started",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        : Icon(
                            Icons.navigate_next_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                  ),
                ),
                SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
