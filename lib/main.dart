import 'package:flutter/material.dart';

import 'ui/home_page.dart';
import 'ui/users/users_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  //const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      routes: {
        "/users": (context) => UsersPage()
      },
      initialRoute: "/users",
    );
  }
}


