import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gloou/screens/camera/camera_setup.dart';
import 'package:gloou/screens/drawer/navigation_drawer.dart';
import 'package:gloou/screens/explore/explore.dart';
import 'package:gloou/screens/feeds/feeds.dart';
import 'package:gloou/screens/message/message.dart';
import 'package:gloou/screens/profile/profile.dart';
import 'package:gloou/shared/colors/colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GeneralHome extends StatefulWidget {
  final int selectPage;
  const GeneralHome({Key? key, this.selectPage = 0}) : super(key: key);

  @override
  _GeneralHomeState createState() => _GeneralHomeState();
}

class _GeneralHomeState extends State<GeneralHome> {
  int _selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    _selectedIndex = widget.selectPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration.copyAncestor(
      context: context,
      enableLoadingWhenFailed: true,
      headerBuilder: () => WaterDropMaterialHeader(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      footerTriggerDistance: 30,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        drawer: _selectedIndex == 0 || _selectedIndex == 3
            ? NavigationDrawer()
            : null,
        appBar: getAppBar(),
        body: SafeArea(
          child: getBody(_selectedIndex),
          // child: IndexedStack(
          //   index: _selectedIndex,
          //   children: pages,
          // ),
        ),
        bottomNavigationBar: _selectedIndex == 2
            ? null
            : BottomNavigationBar(
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.grey[500],
                backgroundColor: Colors.black,
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: 'Search',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.camera_alt_sharp),
                    label: 'Camera',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
      ),
    );
  }

  getAppBar() {
    if (_selectedIndex == 0) {
      return AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/logo.svg',
              color: mainColor,
              height: 30,
              alignment: Alignment.center,
            ),
          ],
        ),
        actions: [
          // IconButton(
          //     onPressed: () {}, icon: Icon(Icons.messenger_outline_rounded))
          Bounce(
            child: SvgPicture.asset('assets/images/chat_icon.svg'),
            duration: Duration(milliseconds: 500),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Message()),
              );
            },
          )
        ],
      );
    }
    if (_selectedIndex == 3) {
      return AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      );
    }
  }

  // List<Widget> pages = [
  //   Feeds(),
  //   Explore(),
  //   CameraSetUp(),
  //   Profile(),
  // ];

  Widget getBody(int i) {
    switch (i) {
      case 0:
        return Feeds();
      case 1:
        return Explore();
      case 2:
        return CameraSetUp();
      case 3:
        return Profile();
    }

    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
