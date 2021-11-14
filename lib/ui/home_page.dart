import 'package:flutter/material.dart';

//not used for now
class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      drawer: Drawer(),
      body: Center(
        child: Text('Home'),
      ),
    );
  }
}
