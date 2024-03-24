import '../../models/task.dart';

enum TasksStatus { loading, success, error, initial }

class TasksState {
  final TasksStatus status;
  final List<Task> tasks;
  final String error;

  TasksState({
    required this.status,
    required this.tasks,
    required this.error,
  });

  factory TasksState.initial() {
    return TasksState(
      status: TasksStatus.initial,
      tasks: [],
      error: '',
    );
  }

  TasksState copyWith({TasksStatus? status, List<Task>? tasks, String? error}) {
    return TasksState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      error: error ?? this.error,
    );
  }
}
