import 'dart:io';

import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'domains/app/redux/reducers/reducer.dart';
import 'domains/app/redux/store/appState.dart';

class ClarityHubStore {
  static ClarityHubStore _instance;

  Store<AppState> store;

  ClarityHubStore._internal(store) {
    this.store = store;
  }

  static Future<Store<AppState>> getStore() async {
    if (_instance == null) {
      final persistor = Persistor<AppState>(
        storage: FlutterStorage(),
        serializer: JsonSerializer<AppState>(AppState.fromJson),
      );
      
      final initialState = await persistor.load();
      
      var store = new Store<AppState>(
        appReducer,
        initialState: initialState ?? new AppState.initialState(),
        middleware: [
          thunkMiddleware,
          new LoggingMiddleware.printer(),
          persistor.createMiddleware()
        ]
      );

      _instance = new ClarityHubStore._internal(store);
    }

    return _instance.store;
  }
}
