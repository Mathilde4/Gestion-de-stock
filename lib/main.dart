// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:gestion_stock/screens/Acceuil.dart';
import 'package:gestion_stock/screens/AcceuilUsers.dart';
import 'package:gestion_stock/screens/AdminLog.dart';
import 'package:gestion_stock/screens/Connect.dart';
import 'package:gestion_stock/screens/Home.dart';
import 'package:gestion_stock/screens/Login.dart';
import 'package:gestion_stock/screens/Register.dart';
import 'package:gestion_stock/screens/SignUp.dart';
import 'package:gestion_stock/screens/categories.dart';
import 'package:gestion_stock/screens/products.dart';
import 'package:gestion_stock/screens/purchases.dart';
import 'package:gestion_stock/screens/sales.dart';
import 'package:gestion_stock/screens/stats.dart';
import 'package:gestion_stock/screens/suppliers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/login': (context) => Login(),
        '/signup': (context) => SignUp(),
        '/acceuil': (context) => AcceuilPage(),
        '/suppliers': (context) => SuppliersPage(),
        '/products': (context) => ProductsPage(),
        '/categories': (context) => CategoriesPage(),
        '/sales': (context) => SalesPage(),
        '/purchases': (context) => PurchasesPage(),
        '/acceuilUsers': (context) => AcceuilUsersPage(),
        '/admin': (context) => AdminLog(),
        '/connect': (context) => Connect(),
        '/register': (context) => Register(),
        '/stats': (context) => StatsPage(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
