import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:voyzon/authentication/authService.dart';
import 'package:voyzon/common/taskWidget.dart';
import 'package:voyzon/models/task.dart';
import 'package:voyzon/services/databaseServices.dart';
import '../models/user.dart';
import 'createTaskPage.dart';

class HomePage extends StatelessWidget {
  final User? user;
  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();
  
  HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await _authService.signOut(context);
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
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Urgent'),
                ),
                SizedBox(width: MediaQuery.of(context).size.height * 0.015),
                ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Important'))
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
                            user?.uid) 
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

                    return ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        return TaskWidget(task: tasks[index]);
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
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CreateTaskPage(user: user)),
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
