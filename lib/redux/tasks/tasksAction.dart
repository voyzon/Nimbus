import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:voyzon/redux/appState.dart';

import '../../models/task.dart';
import '../../services/databaseServices.dart';
import 'tasksState.dart';

ThunkAction<AppState> getTasksAndDispatch(String uid) {
  return (Store<AppState> store) async {
    store.dispatch(GetTasksAction());
    try {
      final tasksSnapshot = await DatabaseService.getInstace.getTasks(uid);
      List<Task> tasks = tasksSnapshot.docs
          .map(
            (task) => Task.fromJson(task.data() as Map<String, dynamic>),
          )
          .toList();
      store.dispatch(GetTasksSucceededAction(tasks: tasks));
    } catch (error) {
      store.dispatch(GetTasksFailedAction(error: error.toString()));
    }
  };
}

ThunkAction<AppState> updateTasksAndDispatch(Task task) {
  return (Store<AppState> store) async {
    store.dispatch(GetTasksAction());
    try {
      final List<Task> tasks = store.state.tasksState.tasks;
      final index =
          tasks.indexWhere((element) => element.taskId == task.taskId);
      tasks[index] = task;
      store.dispatch(GetTasksSucceededAction(tasks: tasks));
    } catch (error) {
      store.dispatch(GetTasksFailedAction(error: error.toString()));
    }
  };
}

class GetTasksAction {
  @override
  String toString() {
    return 'GetTasksAction{}';
  }
}

class GetTasksFailedAction {
  final String error;
  const GetTasksFailedAction({required this.error});

  @override
  String toString() {
    return 'GetTasksFailedAction{error=$error}';
  }
}

class GetTasksSucceededAction {
  final List<Task> tasks;
  const GetTasksSucceededAction({required this.tasks});

  @override
  String toString() {
    return 'GetTasksSucceededAction{tasks=$tasks}';
  }
}
