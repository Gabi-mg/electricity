import 'dart:developer';

import 'package:electricity/common/utils/constants.dart';
import 'package:electricity/di/injection.dart' as di; //Dependency injector
import 'package:electricity/di/injection.dart';
import 'package:electricity/presentation/routes.dart';
import 'package:electricity/presentation/screens/home/bloc/home_bloc.dart';
import 'package:electricity/presentation/theme.dart';
import 'package:electricity/presentation/widgets/custom_dropdown_widget/bloc/place_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDi();
  _setupLogging();
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) => serviceLocator<HomeBloc>(),
        ),
        BlocProvider<PlaceBloc>(
          create: (context) => serviceLocator<PlaceBloc>(),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final placeBlocProvider = BlocProvider.of<PlaceBloc>(context);
    placeBlocProvider.add(const LoadingPlaceEvent());

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.theme,
      title: 'Precio de la luz',
      onGenerateRoute: Routers.generateRoute,
      initialRoute: homeRoute,
    );
  }
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    log('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}
