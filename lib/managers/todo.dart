import 'package:flutter/foundation.dart';
import '../models/todo.dart';

class TodoManager extends ChangeNotifier {
  List<Todo> todos = [];

  void addTodo(Todo todo) {
    todos.add(todo);
    notifyListeners();
  }

  List<Todo> getTodos() {
    return todos;
  }
}
