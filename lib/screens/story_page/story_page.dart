import 'package:flutter/material.dart';
import 'package:gloou/widgets/story_view_widget.dart';

class StoryPage extends StatefulWidget {
  final Map<String, dynamic> singleUserData;
  final List<dynamic> userData;
  final String token;
  const StoryPage({
    Key? key,
    required this.userData,
    required this.singleUserData,
    required this.token,
  }) : super(key: key);

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  late PageController _pageController;

  bool isPageCircular = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var userData = widget.userData;
    final initialPage = userData.indexOf(widget.singleUserData);
    _pageController = PageController(initialPage: initialPage);
    isPageCircular = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: widget.userData
          .map((user) => StoryViewWidget(
                controller: _pageController,
                user: user,
                token: widget.token,
                userData: widget.userData,
              ))
          .toList(),
    );
  }
}
