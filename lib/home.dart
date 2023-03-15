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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Smart Camera"),
        backgroundColor: Colors.purple,
      ),
      body: commonUI(cameraToUse: widget.cameraToUse),
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
