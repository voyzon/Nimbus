import 'package:flutter/material.dart';

class DateSelectorWidget extends StatelessWidget {
  final List<DateTime> dates;
  final List<bool> selectedDates;
  final Function(int, bool) onDateSelected;

  DateSelectorWidget({
    required this.dates,
    required this.selectedDates,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
        spacing: 8.0,
        runSpacing: 16.0,
        children: List<Widget>.generate(dates.length, (int index) {
          return CustomChoiceChip(
            selected: selectedDates[index],
            onSelected: (bool selected) {
              onDateSelected(index, selected);
            },
            day: '${dates[index].day}',
            dayOfWeek: _formatDayOfWeek(dates[index].weekday),
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

  List<DateTime> _getDatesInRange(DateTime startDate, DateTime endDate) {
    List<DateTime> dates = [];
    for (int i = 0; startDate.add(Duration(days: i)).isBefore(endDate); i++) {
      dates.add(startDate.add(Duration(days: i)));
    }
    return dates;
  }
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
          color: selected ? Colors.orange[100] : Colors.transparent,
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
