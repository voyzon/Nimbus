import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:voyzon/authentication/authService.dart';
import 'package:voyzon/common/routeNames.dart';
import 'package:voyzon/common/taskWidget.dart';
import 'package:voyzon/components/completedSeperator.dart';
import 'package:voyzon/components/task_category_filter_chips.dart';
import 'package:voyzon/models/task.dart';
import 'package:voyzon/redux/appState.dart';
import 'package:voyzon/redux/tasks/tasksAction.dart';
import 'package:voyzon/redux/tasks/tasksState.dart';
import 'package:voyzon/services/databaseServices.dart';

import '../common/viewModel.dart';
import '../models/user.dart';

class HomePage extends StatefulWidget {
  final User user;
  final AuthService _authService = AuthService();

  HomePage({super.key, required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

enum TaskCategory {
  URGENT("Urgent"),
  IMPORTANT("Important");

  final String name;

  const TaskCategory(this.name);
}

class _HomePageState extends State<HomePage> {
  bool _isUrgentSelected = false;
  bool _isImportantSelected = false;
  bool _isAllSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          children: [
            TaskCategoryFilterChips(
              _isAllSelected,
              _isUrgentSelected,
              _isImportantSelected,
              _allChipSelected,
              _urgentChipSelected,
              _importantChipSelected,
            ),
            Expanded(
              child: StoreConnector<AppState, ViewModel>(
                  onInit: (Store<AppState> store) {
                    store.dispatch(getTasksAndDispatch(widget.user.uid));
                  },
                  converter: (store) => ViewModel.fromStore(store),
                  builder: (context, vm) {
                    switch (vm.status) {
                      case TasksStatus.loading:
                        return const Center(child: CircularProgressIndicator());
                      case TasksStatus.error:
                        //TODO: Think how to handle this?
                        return Text('Error: ${vm.error}');
                      case TasksStatus.success:
                        return buildTaskListWidget(vm.tasks);
                      default:
                        return const Text('No tasks found');
                    }
                  }),

              // TODO: Remove this code after implementing redux
              // child: FutureBuilder<QuerySnapshot>(
              //   future: DatabaseService.instance.getTasks(widget.user.uid),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const Center(child: CircularProgressIndicator());
              //     } else if (snapshot.hasError) {
              //       return Text('Error: ${snapshot.error}');
              //     } else if (snapshot.hasData) {
              //       return buildTaskListWidget(snapshot);
              //     } else {
              //       return const Text('No tasks found');
              //     }
              //   },
              // ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            RouteNames.CREATE_TASK,
            arguments: widget.user,
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget buildTaskListWidget(List<Task> tasks) {
    // final tasks = _getTaskList(snapshot);
    if (tasks.isEmpty) {
      return const Center(
        child: Text(
          'Create your first task...',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      );
    }

    List<Task> filteredTasks = [];
    if (_isAllSelected) {
      filteredTasks = tasks;
    } else {
      filteredTasks.addAll(tasks.where((task) =>
          (_isUrgentSelected && task.urgent == true) ||
          (_isImportantSelected && task.important == true)));
    }

    final completedTasks =
        filteredTasks.where((task) => !(task.isActive ?? false)).toList();
    final activeTasks =
        filteredTasks.where((task) => task.isActive ?? false).toList();

    return ListView.builder(
      itemCount: activeTasks.length +
          (completedTasks.isNotEmpty ? 1 : 0) +
          completedTasks.length,
      itemBuilder: (context, index) {
        if (index < activeTasks.length) {
          return TaskWidget(task: activeTasks[index]);
        } else if (index == activeTasks.length && completedTasks.isNotEmpty) {
          print('Completed Separator');
          return CompletedSeparator();
        } else {
          final completedIndex =
              index - activeTasks.length - (completedTasks.isNotEmpty ? 1 : 0);
          return TaskWidget(task: completedTasks[completedIndex]);
        }
      },
    );
  }

  _allChipSelected(state) {
    setState(() {
      _isAllSelected = true;
      _isUrgentSelected = false;
      _isImportantSelected = false;
    });
  }

  _appbar() {
    return AppBar(
      title: const Text('To Do'),
      actions: [
        IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () async {
            bool? confirmSignOut = await _showConfirmationDialog(context);
            if (confirmSignOut ?? false) {
              await widget._authService.signOut(context);
            }
          },
        ),
      ],
    );
  }

  _getTaskList(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs
        .map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          data['taskId'] = doc.id;
          return Task.fromJson(data);
        })
        .where((task) => task.uid == widget.user.uid)
        .toList();
  }

  _importantChipSelected(state) {
    setState(() {
      // Logic to unselect a chip only when any another chip is active
      bool isAnyOtherChipActive = _isUrgentSelected || _isAllSelected;
      if (state || isAnyOtherChipActive) {
        _isImportantSelected = state;
      }
      _isAllSelected = false;
    });
  }

  Future<bool?> _showConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirm Sign Out',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Do you really want to sign out?',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5.0,
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(20.0),
        );
      },
    );
  }

  _urgentChipSelected(state) {
    setState(() {
      // Logic to unselect a chip only when any another chip is active
      bool isAnyOtherChipSelected = _isImportantSelected || _isAllSelected;
      if (state || isAnyOtherChipSelected) {
        _isUrgentSelected = state;
      }
      _isAllSelected = false;
    });
  }
}
