import 'package:voyzon/redux/tasks/tasksState.dart';

class AppState {
  final TasksState tasksState;
  AppState({required this.tasksState});

  AppState copyWith({TasksState? tasksState}) {
    return AppState(tasksState: tasksState ?? this.tasksState);
  }

  factory AppState.initial() {
    return AppState(tasksState: TasksState.initial());
  }

  @override
  String toString() {
    return 'AppState{tasksState=$tasksState}';
  }
}
