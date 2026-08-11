import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_provider.dart';
import 'services/cart_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PetCareConnectApp());
}

class PetCareConnectApp extends StatelessWidget {
  const PetCareConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..loadSession()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'PetCare Connect',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          useMaterial3: true,
          colorSchemeSeed: Colors.teal,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
