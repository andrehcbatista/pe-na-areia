import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_theme.dart';
import '../features/admin/admin_requests_screen.dart';
import '../features/beach_confirmation/beach_confirmation_screen.dart';
import '../features/diagnostics/supabase_diagnostics_screen.dart';
import '../features/establishment_detail/establishment_detail_screen.dart';
import '../features/establishment_signup/establishment_signup_screen.dart';
import '../features/home/home_screen.dart';
import '../features/map/map_screen.dart';
import '../features/menu/menu_screen.dart';
import '../features/splash/splash_screen.dart';
import 'routes.dart';

class PeNaAreiaApp extends StatelessWidget {
  const PeNaAreiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.beachConfirmation: (_) => const BeachConfirmationScreen(),
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.map: (_) => const MapScreen(),
        AppRoutes.establishmentDetail: (_) => const EstablishmentDetailScreen(),
        AppRoutes.menu: (_) => const MenuScreen(),
        AppRoutes.establishmentSignup: (_) => const EstablishmentSignupScreen(),
        AppRoutes.adminRequests: (_) => const AdminRequestsScreen(),
        AppRoutes.supabaseDiagnostics: (_) => const SupabaseDiagnosticsScreen(),
      },
    );
  }
}
