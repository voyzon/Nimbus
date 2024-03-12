import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../models/task.dart'; // Assuming your Task model is here

class CreateTaskPage extends StatefulWidget {
  @override
  _CreateTaskPageState createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final _formKey = GlobalKey<FormState>();
  List<DateTime> _dates = [];
  List<bool> _selectedDates = [];
  String _title = '';
  String _description = '';

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    _dates = _getDatesInRange(now, lastDayOfMonth);
    _selectedDates = List.generate(_dates.length, (_) => false);
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
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Task'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _buildDateSelector(),
              const SizedBox(height: 5),
              TextFormField(
                style: const TextStyle(fontSize: 24),
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(color: Colors.grey[700]),
                  contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
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
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Description',
                  hintStyle: TextStyle(color: Colors.grey[700]),
                  contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
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
              ElevatedButton(
                onPressed: _submitTask,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Create'),
              ),
            ],
          ),
        ),
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
        width: 50.0, // Adjust width as needed
        height: 80.0, // Adjust height as needed
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
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
