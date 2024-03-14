import 'package:flutter/material.dart';
import 'package:voyzon/models/user.dart';
import 'package:voyzon/services/databaseServices.dart';
import '../models/task.dart'; // Assuming your Task model is here

class CreateTaskPage extends StatefulWidget {

  final User? user;
  CreateTaskPage({this.user});


  @override
  _CreateTaskPageState createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final DatabaseService _databaseService = DatabaseService();
  final _formKey = GlobalKey<FormState>();
  List<DateTime> _dates = [];
  List<bool> _selectedDates = [];
  String _title = '';
  String _description = '';
  bool _isUrgent = false;
  bool _isImportant = false;
  late User? user;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    _dates = _getDatesInRange(now, lastDayOfMonth);
    _selectedDates = List.generate(_dates.length, (_) => false);
    user = widget.user;
    print(user?.uid);
  }

  Widget _buildDateSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
        spacing: 8.0,
        runSpacing: 16.0,
        children: List<Widget>.generate(_dates.length, (int index) {
          return CustomChoiceChip(
            selected: _selectedDates[index],
            onSelected: (bool selected) {
              setState(() {
                _selectedDates[index] = selected;
              });
            },
            day: '${_dates[index].day}',
            dayOfWeek: _formatDayOfWeek(_dates[index].weekday),
          );
        }),
      ),
    );
  }

  String _formatDayOfWeek(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  void _submitTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // TODO: Add to db
      Task newTask = Task(
        uid: user?.uid,
        title: _title,
        urgent: _isUrgent,
        important: _isImportant,
        description: _description,
      );

      _databaseService.addTask(newTask);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Task'),
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
                        _buildDateSelector(),
                        const SizedBox(height: 10),
                        TextFormField(
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
                            _title = value!;
                          },
                        ),
                        TextFormField(
                          maxLines: null,
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Description',
                            hintStyle: TextStyle(color: Colors.grey[700]),
                            contentPadding:
                                const EdgeInsets.fromLTRB(5, 0, 5, 0),
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _description = value!;
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

}

List<DateTime> _getDatesInRange(DateTime startDate, DateTime endDate) {
  List<DateTime> dates = [];
  for (int i = 0; startDate.add(Duration(days: i)).isBefore(endDate); i++) {
    dates.add(startDate.add(Duration(days: i)));
  }
  return dates;
}

class CustomChoiceChip extends StatelessWidget {
  final bool selected;
  final Function(bool) onSelected;
  final String day;
  final String dayOfWeek;

  CustomChoiceChip({
    required this.selected,
    required this.onSelected,
    required this.day,
    required this.dayOfWeek,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelected(!selected);
      },
      child: Container(
        width: 50.0,
        height: 80.0,
        padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
        decoration: BoxDecoration(
          color: selected
              ? Colors.orange[100]
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: Colors.orange[600] ?? Colors.transparent,
            width: 1.0, 
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              day,
              style: TextStyle(
                color: Colors.orange[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              dayOfWeek,
              style: TextStyle(
                color: Colors.orange[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
