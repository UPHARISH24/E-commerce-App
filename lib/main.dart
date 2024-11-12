import 'package:ec/providers/auth_provider.dart';
import 'package:ec/providers/cart_provider.dart';
import 'package:ec/providers/order_provider.dart';
import 'package:ec/screens/login_screen.dart';
import 'package:ec/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(
        title: 'E-Commerce App',
        theme: AppTheme.darkTheme(),
        home: LoginScreen(),
      ),
    );
  }
}
