import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voyzon/authentication/authService.dart';
import 'package:voyzon/common/routeNames.dart';
import 'package:voyzon/common/taskWidget.dart';
import 'package:voyzon/models/task.dart';
import 'package:voyzon/services/databaseServices.dart';
import '../models/user.dart';
import 'createTaskPage.dart';

class HomePage extends StatefulWidget {
  final User? user;

  HomePage({Key? key, required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();
  List<bool> _isSelected = [true, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              bool? confirmSignOut = await _showConfirmationDialog(context);
              if (confirmSignOut ?? false) {
                await _authService.signOut(context);
              }
            },
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          children: [
            Row(
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _isSelected[0],
                  onSelected: (isSelected) {
                    setState(() {
                      _isSelected[0] = isSelected;
                    });
                  },
                ),
                SizedBox(width: MediaQuery.of(context).size.height * 0.015),
                ChoiceChip(
                  label: const Text('Urgent'),
                  selected: _isSelected[1],
                  onSelected: (isSelected) {
                    setState(() {
                      _isSelected[1] = isSelected;
                    });
                  },
                ),
                SizedBox(width: MediaQuery.of(context).size.height * 0.015),
                ChoiceChip(
                  label: const Text('Important'),
                  selected: _isSelected[2],
                  onSelected: (isSelected) {
                    setState(() {
                      _isSelected[2] = isSelected;
                    });
                  },
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _databaseService.getAllTasks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final tasks = snapshot.data!.docs
                        .map((doc) {
                          var data = doc.data() as Map<String, dynamic>;
                          data['taskId'] = doc.id;
                          return Task.fromJson(data);
                        })
                        .where((task) =>
                            task.uid ==
                            widget.user?.uid)
                        .toList();

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
                    if (_isSelected[0]) {
                      filteredTasks = tasks;
                    } else {
                      filteredTasks.addAll(tasks.where((task) =>
                          (_isSelected[1] && task.urgent == true) ||
                          (_isSelected[2] && task.important == true)));
                    }

                    return ListView.builder(
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        return TaskWidget(task: filteredTasks[index]);
                      },
                    );
                  } else {
                    return const Text('No tasks found');
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RouteNames.CREATE_TASK, arguments: widget.user);
        },
        child: const Icon(Icons.edit),
      ),
    );
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
}
