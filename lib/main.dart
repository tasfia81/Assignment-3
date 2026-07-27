import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'providers/feed_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VogueXApp());
}

class VogueXApp extends StatelessWidget {
  const VogueXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FeedProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'VogueX',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
                centerTitle: true,
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 16.sp,
                  letterSpacing: 1.5,
                ),
              ),
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.black,
                primary: Colors.black,
                secondary: Colors.black,
                surface: Colors.white,
              ),
              textTheme: TextTheme(
                titleLarge: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5, fontSize: 20.sp),
                bodyLarge: TextStyle(color: Colors.black87, fontSize: 14.sp),
              ),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Colors.white,
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.grey,
              ),
            ),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
