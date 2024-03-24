import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';
import 'package:voyzon/models/task.dart';

import '../common/constants.dart';

class DatabaseService {
  DatabaseService._()
      : _tasksRef = FirebaseFirestore.instance.collection(TODO_COLLECTION_REF);
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _tasksRef;

  static final DatabaseService instance = DatabaseService._();

  static DatabaseService get getInstace => instance;

  Future<QuerySnapshot> getTasks(uid) async {
    return _tasksRef.where('uid', isEqualTo: uid).get();
  }

  Future<void> addTask(Task task) async {
    try {
      await _tasksRef.doc(task.taskId!).set(task.toJson());
    } catch (error) {
      print('Error adding task: $error');
    }
  }

  Future<void> updateTaskStatus(Task task) async {
    try {
      await _tasksRef.doc(task.taskId).update(task.toJson());
    } catch (e) {
      print('Error updating task: $e');
      throw e;
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _firestore
          .collection('tasks')
          .doc(task.taskId)
          .update(task.toJson());
    } catch (e) {
      print('Error updating task: $e');
      throw Exception('Failed to update task');
    }
  }
}
