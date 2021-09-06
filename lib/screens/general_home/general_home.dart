import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gloou/screens/drawer/navigation_drawer.dart';
import 'package:gloou/screens/feeds/feeds.dart';
import 'package:gloou/shared/colors/colors.dart';

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
    Container(
      child: Text(
        'Camera page',
        style: TextStyle(fontSize: 30),
      ),
    ),
    Container(
      child: Text(
        'Profile page',
        style: TextStyle(fontSize: 30),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: NavigationDrawer(),
      appBar: AppBar(
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
              height: 50,
              alignment: Alignment.center,
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {}, icon: Icon(Icons.messenger_outline_rounded))
        ],
      ),
      body: SafeArea(child: pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[500],
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
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
    );
  }
}
