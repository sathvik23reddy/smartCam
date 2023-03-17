import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'common.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.cameraToUse});
  final CameraDescription cameraToUse;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  //To update the selectedIndex (Page) value
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Top App Bar
      appBar: AppBar(
        title: const Text("Smart Camera"),
        backgroundColor: Colors.purple,
      ),
      //Common UI contains all common elements like Drop Down Menu & Image Chooser
      body:
          commonUI(cameraToUse: widget.cameraToUse, pageIndex: _selectedIndex),
      //Bottom Nav Bar to switch between 2 modes
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_objects_outlined),
            label: 'Object',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.text_fields_sharp),
            label: 'Text',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple,
        onTap: _onItemTapped,
      ),
    );
  }
}
