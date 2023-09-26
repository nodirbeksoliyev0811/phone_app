import 'package:flutter/material.dart';
import 'package:phone_app/ui/contact_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        iconTheme: const IconThemeData(color: Colors.black),
        appBarTheme: const AppBarTheme(color: Colors.white),
      ),
      debugShowCheckedModeBanner: false,
      home: const ContactScreen(),
    );
  }
}
