import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gloou/screens/camera/camera_setup.dart';
import 'package:gloou/screens/drawer/navigation_drawer.dart';
import 'package:gloou/screens/feeds/feeds.dart';
import 'package:gloou/shared/colors/colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GeneralHome extends StatefulWidget {
  const GeneralHome({Key? key}) : super(key: key);

  @override
  _GeneralHomeState createState() => _GeneralHomeState();
}

class _GeneralHomeState extends State<GeneralHome> {
  int _selectedIndex = 0;

  List<Widget> pages = [
    Feeds(),
    Container(
      child: Text(
        'Search page',
        style: TextStyle(fontSize: 30),
      ),
    ),
    CameraSetUp(),
    Container(
      child: Text(
        'Profile page',
        style: TextStyle(fontSize: 30),
      ),
    ),
  ];

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
        drawer: _selectedIndex == 0 ? NavigationDrawer() : null,
        appBar: getAppBar(),
        body: SafeArea(
          child: IndexedStack(
            index: _selectedIndex,
            children: pages,
          ),
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
                  _selectedIndex = index;
                  setState(() {});
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
          IconButton(
              onPressed: () {}, icon: Icon(Icons.messenger_outline_rounded))
        ],
      );
    }
    if (_selectedIndex == 2) {
      return AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Camera',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              setState(() {
                _selectedIndex = 0;
              });
            },
            icon: Icon(Icons.close)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.flash_auto),
          )
        ],
      );
    }
  }
}
