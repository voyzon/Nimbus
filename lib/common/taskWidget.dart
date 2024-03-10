import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:voyzon/models/task.dart';

class TaskWidget extends StatefulWidget {
  final Task task;
  const TaskWidget({super.key, required this.task});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  final f = DateFormat('yyyy-MM-dd');
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.02),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.task.title!,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              InkWell(
                onTap: () {},
                child: Icon(
                  Icons.circle_outlined,
                  size: MediaQuery.of(context).size.height * 0.02,
                ),
              )
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.018,
          ),
          Text(
            widget.task.description!,
            maxLines: 3,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              overflow: TextOverflow.fade,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.018,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Today"),
              Text(f.format(widget.task.dueDate!))
            ],
          )
        ],
      ),
    );
  }
}
