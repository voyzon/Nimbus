import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voyzon/models/task.dart';

const String TODO_COLLECTION_REF = "tasks";

class DatabaseService{
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _tasksRef;

  DatabaseService(){
    _tasksRef = _firestore.collection(TODO_COLLECTION_REF);
  }

  Stream<QuerySnapshot> getAllTasks(){
    return _tasksRef.snapshots();
  }

  Future<void> addTask(Task task) async {
    try {
      DocumentReference docRef = await _tasksRef.add(task.toJson());
      String taskId = docRef.id;
      task.taskId = taskId;
      await docRef.update({'taskId': taskId});
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
      await _firestore.collection('tasks').doc(task.taskId).update(task.toJson());
    } catch (e) {
      print('Error updating task: $e');
      throw Exception('Failed to update task');
    }
  }

}