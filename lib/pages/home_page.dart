import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/models/task.dart';
import 'package:todo/widgets/task_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  late double _deviceHeight, _deviceWidth;
  String? _newTaskContent;
  Box? _box;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Hive.openBox('tasks').then((box) {
      setState(() {
        _box = box;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: Colors.white12,
      appBar: AppBar(
        backgroundColor: Colors.white24,
        // toolbarHeight: _deviceHeight * 0.15,
        title: const Text(
          "To_oD",
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.w800
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _tasksView(),
          _taskInputField(),
        ],
      ),
      // floatingActionButton: _addTaskButton(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _tasksView() {
    if (_box == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Expanded(
          child: ValueListenableBuilder(
              valueListenable: _box!.listenable(),
              builder: (context, Box box, widget){
            return TaskList(box: box);
      }
          )
      );
    }
  }

  Widget _taskInputField() {
    return Padding(
      padding: const EdgeInsets.only(left: 15,right: 15,bottom: 15),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.white),
              controller: _controller,
              onChanged: (value) {
                _newTaskContent = value;
              },
              onSubmitted: (value) {
                _addTask();
              },
              decoration: InputDecoration(
                hintText: 'Enter a new task...',
                hintStyle: const TextStyle(color: Colors.white38),
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.white)
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.white60)
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.white)
                )
              ),
            ),
          ),
          const SizedBox(width: 8),
          // _addTaskButton(),
          FloatingActionButton(onPressed: _addTask,
          child: const Icon((Icons.add),),)
        ],
      ),
    );
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      onPressed: _addTask,
      child: const Icon(Icons.add),
    );
  }



  void _addTask() {
    if (_newTaskContent != null && _newTaskContent!.trim().isNotEmpty) {
      var newTask = Task(
        content: _newTaskContent!,
        done: false,
      );
      _box!.add(newTask.toMap());
      setState(() {
        _newTaskContent = null;
        _controller.clear();
      });
    }
  }



}


// ----gradient effect
// Container(
// decoration: BoxDecoration(
// gradient: LinearGradient(
// colors: [
// Colors.blue.withOpacity(0.5), // Adjust opacity and colors as needed
// Colors.transparent,
// ],
// begin: Alignment.bottomCenter,
// end: Alignment.topCenter,
// ),
// borderRadius: BorderRadius.circular(10.0),
// ),),