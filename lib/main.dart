import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqllite/bloc/user_bloc.dart';
import 'package:sqllite/bloc/user_event.dart';
import 'package:sqllite/data/repositories/user_repository.impl.dart';
import 'package:sqllite/helper/database_helper.dart';
import 'package:sqllite/pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final dbHelper = DatabaseHelper();
  final userRepository = UserRepositoryImpl(dbHelper);

  runApp(MyApp(repository: userRepository));
}

class MyApp extends StatelessWidget {
  final UserRepositoryImpl repository;
  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(repository)..add(LoadUsers()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
        home: const HomePage(),
      ),
    );
  }
}