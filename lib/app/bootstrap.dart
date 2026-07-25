import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:factory_management/app/app_bloc_observer.dart';
import 'package:flutter/widgets.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  runApp(await builder());
}
