import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:voyzon/common/dateSelectorWidget.dart';
import 'package:voyzon/models/user.dart';
import 'package:voyzon/services/databaseServices.dart';
import '../models/task.dart';

class CreateTaskPage extends StatefulWidget {
  final Task? task;
  final User? user;
  CreateTaskPage({this.user, this.task});


  @override
  _CreateTaskPageState createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final DatabaseService _databaseService = DatabaseService();
  final _formKey = GlobalKey<FormState>();
  late User? user;
  List<DateTime> _dates = [];
  List<bool> _selectedDates = [];
  bool _isUrgent = false;
  bool _isImportant = false;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  Task task = Task();

  @override
  void initState() {
  super.initState();
  DateTime now = DateTime.now();
  DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
  user = widget.user;
  task = widget.task ?? Task(); // Use provided task or create new one
  _titleController = TextEditingController(text: task.title);
  _descriptionController = TextEditingController(text: task.description);
  _dates = _getDatesInRange(now, lastDayOfMonth);
  _selectedDates = List.generate(_dates.length, (_) => false);
  _isUrgent = task.urgent ?? false;
  _isImportant = task.important ?? false;

  if (user != null) {
    task.uid = user!.uid;
  }
}


  List<DateTime> _getDatesInRange(DateTime startDate, DateTime endDate) {
    List<DateTime> dates = [];
    for (int i = 0; startDate.add(Duration(days: i)).isBefore(endDate); i++) {
      dates.add(startDate.add(Duration(days: i)));
    }
    return dates;
  }

  void _submitTask() {
  if (_formKey.currentState!.validate()) {
    // Populate task with form values
    task.title = _titleController.text;
    task.description = _descriptionController.text;
    task.urgent = _isUrgent;
    task.important = _isImportant;
    task.isActive = true;
    task.createdAt = Timestamp.fromDate(DateTime.now());
    print(user?.uid);

    if (widget.task == null) {
      // If task is null, it's a new task, so add it
      _databaseService.addTask(task);
    } else {
      // If task is not null, it's an existing task, so update it
      _databaseService.updateTask(task);
    }

    // Navigate back
    Navigator.of(context).pop();
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task != null ? 'Edit Task' : 'New Task'),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        DateSelectorWidget(
                          dates: _dates,
                          selectedDates: _selectedDates,
                          onDateSelected: _handleDateSelected,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _titleController,
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: 'Title',
                            hintStyle: TextStyle(color: Colors.grey[700]),
                            contentPadding:
                                const EdgeInsets.fromLTRB(5, 0, 5, 0),
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            task.title = value!;
                          },
                        ),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: null,
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Description',
                            hintStyle: TextStyle(color: Colors.grey[700]),
                            contentPadding:
                                const EdgeInsets.fromLTRB(5, 0, 5, 0),
                            border: InputBorder.none,
                          ),
                          onSaved: (value) {
                            task.description = value!;
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      ChoiceChip(
                        label: Text('Urgent'),
                        selected: _isUrgent,
                        backgroundColor:
                            _isUrgent ? Colors.orange[100] : Colors.transparent,
                        selectedColor: Colors.orange[100],
                        labelStyle: TextStyle(
                            fontSize: 14,
                            color:  Colors.orange[600]),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.orange[600] ?? Colors.transparent,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        showCheckmark: false,
                        onSelected: (isSelected) {
                          setState(() {
                            _isUrgent = isSelected;
                          });
                        },
                      ),
                      SizedBox(width: 10),
                      ChoiceChip(
                        label: Text('Important'),
                        selected: _isImportant,
                        backgroundColor: _isImportant
                            ? Colors.orange[100]
                            : Colors.transparent,
                        selectedColor: Colors.orange[100],
                        labelStyle: TextStyle(
                            fontSize: 14,
                            color:  Colors.orange[600]),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.orange[600] ?? Colors.transparent,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        showCheckmark: false,
                        onSelected: (isSelected) {
                          setState(() {
                            _isImportant = isSelected;
                          });
                        },
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _submitTask,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Create'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleDateSelected(int index, bool selected) {
    setState(() {
      _selectedDates[index] = selected;
    });
  }
}

