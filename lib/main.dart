import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:form_it/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FormarApp());
}