import 'package:redux/redux.dart';
import 'package:voyzon/redux/tasks/tasksAction.dart';
import 'package:voyzon/redux/tasks/tasksState.dart';

TasksState getTasksReducer(
  TasksState state,
  GetTasksAction action,
) {
  return state.copyWith(
    status: TasksStatus.loading,
  );
}

TasksState getTasksSucceededReducer(
  TasksState state,
  GetTasksSucceededAction action,
) {
  return state.copyWith(
    status: TasksStatus.success,
    tasks: action.tasks,
  );
}

TasksState getTasksFailedReducer(
  TasksState state,
  GetTasksFailedAction action,
) {
  return state.copyWith(
    status: TasksStatus.error,
    error: action.error,
  );
}

Reducer<TasksState> tasksReducer = combineReducers<TasksState>([
  TypedReducer<TasksState, GetTasksAction>(getTasksReducer),
  TypedReducer<TasksState, GetTasksSucceededAction>(getTasksSucceededReducer),
  TypedReducer<TasksState, GetTasksFailedAction>(getTasksFailedReducer),
]);
