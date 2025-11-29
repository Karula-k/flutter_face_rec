import 'package:flutter/material.dart';
import 'package:flutter_face_rec/core/router/go_router..dart';
import 'package:flutter_face_rec/core/theme/lightheme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp((const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: lightTheme,
      routerConfig: AppRouter.goRouter,
    );
  }
}
