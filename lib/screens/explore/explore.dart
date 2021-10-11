import 'package:flutter/material.dart';
import 'package:gloou/screens/explore/exploreForYou/exploreForYou.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 10,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: null,
        elevation: 0.0,
        bottom: TabBar(
          padding: EdgeInsets.only(left: 30, right: 30),
          indicatorColor: Colors.transparent,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey[500],
          controller: _tabController,
          labelStyle: TextStyle(fontSize: 18),
          tabs: [
            Tab(
              text: 'For you',
            ),
            Tab(
              text: 'Challenge',
            ),
            Tab(
              text: 'Timepod',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ExploreForYou(),
          Container(
            child: Text('Challenge'),
          ),
          Container(
            child: Text('Time pod'),
          ),
        ],
      ),
    );
  }
}
