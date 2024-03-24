import 'package:redux/redux.dart';

import '../models/task.dart';
import '../redux/appState.dart';
import '../redux/tasks/tasksState.dart';

class ViewModel {
  final List<Task> tasks;
  final TasksStatus status;
  final String error;

  const ViewModel({
    required this.tasks,
    required this.status,
    required this.error,
  });

  factory ViewModel.fromStore(Store<AppState> store) {
    return ViewModel(
      tasks: store.state.tasksState.tasks,
      status: store.state.tasksState.status,
      error: store.state.tasksState.error,
    );
  }

  @override
  String toString() {
    return '_ViewModel{tasks=$tasks, status=$status, error=$error}';
  }
}
