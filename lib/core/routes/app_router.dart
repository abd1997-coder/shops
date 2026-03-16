import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/shops/presentation/pages/shops_page.dart';
import '../../features/shops/presentation/cubit/shops_cubit.dart';
import '../injection/injection_container.dart' as di;

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => SplashPage(
            onSplashComplete: () {
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (context) => LoginPage(
            onLoginComplete: () {
              Navigator.of(context).pushReplacementNamed('/shops');
            },
          ),
        );
      case '/shops':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di.sl<ShopsCubit>(),
            child: const ShopsPage(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => SplashPage(
            onSplashComplete: () {
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        );
    }
  }
}
