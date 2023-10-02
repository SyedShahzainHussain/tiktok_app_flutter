import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiktok/firebase_options.dart';
import 'package:tiktok/provider/auth_proivder.dart';
import 'package:tiktok/provider/profile_provider.dart';
import 'package:tiktok/provider/upload_provider.dart';
import 'package:tiktok/repository/app_colors.dart';
import 'package:tiktok/view/screen/auth/login_screen.dart';
import 'package:tiktok/view/screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UploadProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileProvider(),
        ),
      
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TikTok Clone',
        theme: ThemeData.dark()
            .copyWith(scaffoldBackgroundColor: AppColors.backgroundColor),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const HomeScreen();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
