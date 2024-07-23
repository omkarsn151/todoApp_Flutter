import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo/models/task.dart';

class TaskList extends StatelessWidget {
  final Box box;
  const TaskList({super.key, required this.box});

  @override
  Widget build(BuildContext context) {
    List tasks = box.values.toList();
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        var task = Task.fromMap(tasks[index]);
        return Padding(
          padding: const EdgeInsets.only(top: 15,right: 15,left: 15),
          child: Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) {
              box.deleteAt(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Task '${task.content}' deleted"),
                ),
              );
            },
            background: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey
              ),
              // color: Colors.grey,
              alignment: Alignment.centerLeft,

              padding: const EdgeInsets.only(left: 25.0),
              child: const Icon(
                Icons.delete,
                color: Colors.black,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10)
              ),
              child: ListTile(
                title: Text(
                  task.content,
                  style: TextStyle(
                    decoration: task.done ? TextDecoration.lineThrough : null,
                    color: Colors.white,
                    decorationColor: Colors.white,
                    decorationThickness: task.done? 2.5 : null,
                    decorationStyle: TextDecorationStyle.solid
                  ),
                ),
                trailing: Icon(
                  task.done
                      ? Icons.check_box_outlined
                      : Icons.check_box_outline_blank_outlined,
                  color: Colors.white,
                ),
                onTap: () {
                  task.done = !task.done;
                  box.putAt(
                    index,
                    task.toMap(),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
