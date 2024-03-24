import 'package:voyzon/redux/appState.dart';
import 'tasks/tasksReducer.dart';

AppState reducer(AppState state, dynamic action) {
  return AppState(
    tasksState: tasksReducer(state.tasksState, action),
  );
}
