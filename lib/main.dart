import 'dart:async';

import 'package:deploy_horoscope/app.dart';
import 'package:deploy_horoscope/feature/_main_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() async {
  runZonedGuarded(() async {
    // WidgetsFlutterBinding.ensureInitialized();

    // await dotenv.load(fileName: "lib/.env");

    // AppMetrica.activate(
    //   AppMetricaConfig(
    //     dotenv.get('APP_METRICA_API_KEY'),
    //     firstActivationAsUpdate: true,
    //     logs: true,
    //     crashReporting: true,
    //     appOpenTrackingEnabled: true,
    //   ),
    // );

    // if (kReleaseMode) {
    //   AppMetrica.reportEvent('Запуск приложения');
    // }

    final Talker talker = Talker();
    final dio = Dio();
    dio.interceptors.add(TalkerDioLogger(
      talker: talker,
      settings: const TalkerDioLoggerSettings(printResponseData: false),
    ));

    GetIt.I.registerSingleton(talker);
    GetIt.I.registerSingleton(dio);
    GetIt.I.registerSingleton(
      GoRouter(
        observers: [
          TalkerRouteObserver(GetIt.I<Talker>()),
          // SentryNavigatorObserver(),
        ],
        routes: [
          GoRoute(
            path: '/',
            builder: (BuildContext context, GoRouterState state) {
              return const MainScreen();
            },
            // routes: [
            //   GoRoute(
            //     path: 'month',
            //     builder: (BuildContext context, GoRouterState state) {
            //       return const MonthScreen();
            //     },
            //   ),
            //   GoRoute(
            //     path: 'day',
            //     builder: (BuildContext context, GoRouterState state) {
            //       return const DayScreen();
            //     },
            //   ),
            // ],
          )
        ],
      ),
    );

    runApp(const MyApp());


    // kReleaseMode
    //     ? await SentryFlutter.init((options) {
    //   options.dsn = sentryKey;
    //   options.tracesSampleRate = 1.0;
    // }, appRunner: () => runApp(const MyApp()))
    //     : runApp(const MyApp());

    // try {
    //   throw Exception('тест 2');
    // } catch (e, st) {
    //   talker.critical('швыряю в сентрю');
    //   await Sentry.captureException(
    //     e,
    //     stackTrace: st,
    //   );
    // }
  }, (exception, stack) async {
    Talker().handle(exception, stack);
    // if (kReleaseMode) {
    //   await Sentry.captureException(exception, stackTrace: stack);
    //   AppMetrica.reportUnhandledException(AppMetricaErrorDescription(stack));
    // }
  });

}



