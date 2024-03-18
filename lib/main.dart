import 'package:ecommerce_flutter_admin/constans/theme_data.dart';
import 'package:ecommerce_flutter_admin/provider/product_provider.dart';
import 'package:ecommerce_flutter_admin/provider/theme_provider.dart';
import 'package:ecommerce_flutter_admin/screens/DashboardScreen.dart';
import 'package:ecommerce_flutter_admin/screens/editorUploadProduct.dart';
import 'package:ecommerce_flutter_admin/screens/search_screen.dart';
import 'package:ecommerce_flutter_admin/widget/order/order_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
      future: Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyA_duBAB9bhvES3liAgQ4hQ8ib3CUAWH50',
          appId: '1:131255903185:web:c21e252be3a16abf9276f0', 
          messagingSenderId: '131255903185',
          projectId: 'ecommerce-flutter-b8503',
          storageBucket: 'ecommerce-flutter-b8503.appspot.com',
        ),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else if(snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: SelectableText(snapshot.error.toString()),
              ),
            ),
          );
        } else {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => ThemeProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => ProductProvider(),
              ),
            ],
            child: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: "Ecommerce",
                  theme: Styles.themeData(
                    isDarkTheme: themeProvider.getIsDarkTheme,
                    context: context,
                  ),
                  home: const DashboardScreen(),
                  routes: {
                    OrderScreen.routName: (context) => const OrderScreen(),
                    SearchScreen.routName: (context) => const SearchScreen(),
                    EditorUploadProductScreen.routName: (context) => const EditorUploadProductScreen(),
                  },
                );
              },
            ),
          );
        }
      },
    );
  }
}

