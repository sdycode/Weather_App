import 'dart:convert';
import 'dart:io';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:weather/screens/screen1.dart';
import 'package:weather/screens/screen2,.dart';

import '../constants/constants.dart';
import '../providers/provider_file.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Widget> tabs = [Text(""), Text("")];

  void updateMainUI() {
    print("visi main UI");
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  }

  @override
  void initState() {
    // TODO: implement initState
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    // SystemUiOverlayStyle(statusBarColor:Color.fromARGB(255, 1, 5, 8).withAlpha(244), );
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("visi top in main  ${MediaQuery.of(context).viewPadding.top}");
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    ProviderClass providerClass = Provider.of<ProviderClass>(context,  );
     print("build in main");
//  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    tabs = [
      Screen1( MediaQuery.of(context).viewPadding.top,providerClass ),
      Screen2(),
    ];

    return Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BottomNavyBar(
          
          backgroundColor: Constants.currentMainColor,
          
          containerHeight: h * 0.08,
          selectedIndex: _selectedIndex,

          showElevation: false, // use this to remove appBar's elevation
          onItemSelected: (index) => setState(() {
            _selectedIndex = index;
            // _pageController.animateToPage(index,
            //     duration: Duration(milliseconds: 300), curve: Curves.ease);
          }),
          items: [
            BottomNavyBarItem(
              icon: Icon(Icons.apps),
              title: Text("City"),
              activeColor: Color.fromARGB(255, 18, 5, 77),
            ),
            BottomNavyBarItem(
                icon: Icon(Icons.people),
                title: Text('Compare Cities'),
                activeColor: Color.fromARGB(255, 5, 4, 58)),
            // BottomNavyBarItem(
            //     icon: Icon(Icons.message),
            //     title: Text('Messages'),
            //     activeColor: Colors.pink),
            // BottomNavyBarItem(
            //     icon: Icon(Icons.settings),
            //     title: Text('Settings'),
            //     activeColor: Colors.blue),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
            children: [
              SizedBox( 
                // height: MediaQuery.of(context).viewPadding.top,
              ),
              tabs[_selectedIndex],
              Container(
                height: MediaQuery.of(context).viewPadding.bottom,
              )
            ],
          )),
        ));
  }
}
