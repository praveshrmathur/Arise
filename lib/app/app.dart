import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_constants.dart';
import 'router.dart';
import 'theme/hunter_theme.dart';

class ProjectHunterApp extends ConsumerWidget {
  const ProjectHunterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: HunterTheme.darkTheme,
      routerConfig: hunterRouter,
    );
  }
}
