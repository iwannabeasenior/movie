import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
                child: Center(
                    child: Text('Nguyen Trung Thanh',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.black),)
                )
            )
        )
    );
  }
}
