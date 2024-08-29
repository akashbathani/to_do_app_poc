import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/task.dart';

class TaskController extends GetxController {
  var tasks = <Task>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  Future<void> addTask(String title) async {
    if (title.isNotEmpty) {
      int id = tasks.isEmpty ? 1 : tasks.last.id + 1;
      tasks.add(Task(id: id, title: title));
      await saveTasks();
    } else {
      Get.snackbar('Error', 'Task title cannot be empty');
    }
  }

  Future<void> updateTask(int id, String title, bool isCompleted) async {
    var task = tasks.firstWhere((task) => task.id == id);
    task.title = title;
    task.isCompleted = isCompleted;
    tasks.refresh(); // Notify listeners
    await saveTasks();
  }

  Future<void> deleteTask(int id) async {
    tasks.removeWhere((task) => task.id == id);
    await saveTasks();
  }

  Future<void> saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskList = tasks.map((task) => json.encode(task.toMap())).toList();
    await prefs.setStringList('tasks', taskList);
  }

  Future<void> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? taskList = prefs.getStringList('tasks');

    if (taskList != null) {
      tasks.value = taskList.map((task) => Task.fromMap(json.decode(task))).toList();
    }
  }
}
