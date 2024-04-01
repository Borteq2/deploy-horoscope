import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GetIt.I<GoRouter>(),
      title: 'Deploy Horoscope',
      theme: ThemeData.dark(),
    );
  }
}