import 'package:get/get.dart';
import 'package:to_do_app_poc/view/add_task_screen.dart';
import 'package:to_do_app_poc/view/task_list_screen.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/', page: () => TaskListScreen()),
    GetPage(name: '/add-task', page: () => AddTaskScreen()),
  ];
}
