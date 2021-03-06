import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sevenclass/bloc/splash/bloc.dart';
import 'package:sevenclass/screens/splash_screen.dart';

import 'app.dart';
import 'bloc/auth/bloc.dart';
import 'bloc/classes/bloc.dart';
import 'bloc/home/bloc.dart';

class MainLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashBloc>(create: (BuildContext context) => SplashBloc()),
        BlocProvider<AuthBloc>(create: (BuildContext context) => AuthBloc()),
        BlocProvider<HomeBloc>(create: (BuildContext context) => HomeBloc()),
        BlocProvider<ClassesBloc>(create: (BuildContext context) => ClassesBloc())
      ],
      child: MaterialApp(
        title: App().appTitle,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
