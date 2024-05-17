import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:priority_soft_test/firebase_options.dart';
import 'package:priority_soft_test/providers/cart_provider.dart';
import 'package:priority_soft_test/providers/selected_shoe_provider.dart'; // Import the SelectedShoeProvider
import 'package:priority_soft_test/providers/shoe_provider.dart';
import 'package:priority_soft_test/screens/discover_screen.dart';
import 'package:priority_soft_test/utils/theme/theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ShoeProvider()),
        ChangeNotifierProvider(create: (context) => SelectedShoeProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: const DiscoverScreen(),
      ),
    );
  }
}
