import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:my_movie/pages/loginpage.dart';

import 'package:my_movie/pages/transaction_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('Something went wrong');
            } else if (snapshot.hasData) {
              return TransactionPage();
            } else {
              return Login();
            }
          },
        ),
      );
}
