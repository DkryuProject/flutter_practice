import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../managers/todo.dart';
import '../models/todo.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoManager>(
      builder: (context, todoManager, child) {
        List<Todo> todos = todoManager.getTodos();

        return ListView.builder(
          itemCount: todos.length,
          itemBuilder: (BuildContext context, int index) {
            Todo todo = todos[index];

            return ListTile(
              title: Text(todo.title),
            );
          },
        );
      },
    );
  }
}
