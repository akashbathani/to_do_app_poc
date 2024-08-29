import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/task_controller.dart';
import '../model/task.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskController taskController = Get.put(TaskController());

  final RxString filter = 'All'.obs;
  // Filter state
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: filter.value,
                icon: const Icon(Icons.filter_list, color: Colors.blueGrey),
                dropdownColor: Colors.white,
                style: const TextStyle(
                    color: Colors.blueGrey, fontSize: 16), // Text style
                items: ['All', 'Completed', 'Incomplete'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    filter.value = newValue;
                  }
                },
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        List<Task> filteredTasks;
        if (filter.value == 'Completed') {
          filteredTasks =
              taskController.tasks.where((task) => task.isCompleted).toList();
        } else if (filter.value == 'Incomplete') {
          filteredTasks =
              taskController.tasks.where((task) => !task.isCompleted).toList();
        } else {
          filteredTasks = taskController.tasks;
        }

        if (filteredTasks.isEmpty) {
          return const Center(
            child: Text('No tasks available. Add some tasks!'),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: ListView.builder(
            itemCount: filteredTasks.length,
            itemBuilder: (context, index) {
              final task = filteredTasks[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 3),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Text(
                                task.title,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                            Checkbox(
                              value: task.isCompleted,
                              onChanged: (value) {
                                if (value != null) {
                                  taskController.updateTask(
                                      task.id, task.title, value);
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showEditTaskDialog(context, task);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _showDeleteConfirmationDialog(context, task);
                              },
                            ),
                          ],
                        ))),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        isExtended: true,
        onPressed: () {
          Get.toNamed('/add-task');
        },
        label: const Text('Add Task'),
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context, Task task) {
    final TextEditingController titleController =
        TextEditingController(text: task.title);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Task Title'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  taskController.updateTask(
                      task.id, titleController.text, task.isCompleted);
                  Get.back();
                } else {
                  Get.snackbar('Error', 'Title cannot be empty');
                }
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                taskController.deleteTask(task.id);
                Get.back();
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
