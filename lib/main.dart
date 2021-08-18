import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_movie/Home.dart';
import 'package:my_movie/models/transaction.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'google_sign.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionAdapter());
  await Hive.openBox<Transaction>('transactions');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'My Movies';

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: title,
          theme: ThemeData(primarySwatch: Colors.indigo),
          //home: TransactionPage(),
          home: HomePage(),
        ),
      );
}
