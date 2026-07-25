import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:factory_management/core/theme/app_theme.dart';
import 'package:factory_management/core/config/app_config.dart';
import 'package:factory_management/features/dashboard/presentation/pages/dashboard_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Setting a larger design size for Web/Desktop dashboard
    return ScreenUtilInit(
      designSize: const Size(1920, 1080),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Alam Marble & Granite Factory',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          debugShowCheckedModeBanner: false,
          home: const DashboardPage(),
        );
      },
    );
  }
}
