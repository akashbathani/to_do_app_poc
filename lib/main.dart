import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_app_poc/route/route.dart';
import 'package:to_do_app_poc/view/task_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: TaskListScreen(),
      getPages: AppRoutes.routes,
    );
  }
}
