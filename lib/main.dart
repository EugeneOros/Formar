import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:form_it/app.dart';
import 'package:provider/provider.dart';

import 'logic/models/AppStateNotifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider<AppStateNotifier>(
      create: (context) => AppStateNotifier(),
      child: FormarApp(),
    ),
  );
}
