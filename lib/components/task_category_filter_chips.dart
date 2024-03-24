import 'package:flutter/material.dart';

import '../screens/homePage.dart';

class TaskCategoryFilterChips extends StatelessWidget {
  bool isAllSelected;
  bool isUrgentSelected;
  bool isImportantSelected;

  Function(bool) allChipSelected;
  Function(bool) urgentChipSelected;
  Function(bool) importantChipSelected;

  TaskCategoryFilterChips(
      this.isAllSelected,
      this.isUrgentSelected,
      this.isImportantSelected,
      this.allChipSelected,
      this.urgentChipSelected,
      this.importantChipSelected,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TaskFilterChip("All", isAllSelected, allChipSelected),
        const _SizedBox(),
        _TaskFilterChip(
            TaskCategory.URGENT.name, isUrgentSelected, urgentChipSelected),
        const _SizedBox(),
        _TaskFilterChip(TaskCategory.IMPORTANT.name, isImportantSelected,
            importantChipSelected),
      ],
    );
  }
}

class _TaskFilterChip extends StatelessWidget {
  final String filter;
  bool isSelected;
  Function(bool) onSelected;

  _TaskFilterChip(this.filter, this.isSelected, this.onSelected, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(filter),
      selected: isSelected,
      onSelected: (state) {
        onSelected(state);
      },
    );
  }
}

class _SizedBox extends StatelessWidget {
  const _SizedBox({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: MediaQuery.of(context).size.height * 0.015);
  }
}
