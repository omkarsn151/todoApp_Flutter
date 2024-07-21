class Task {
  String content;
  bool done;

  Task({
    required this.content,
    required this.done,
  });

  factory Task.fromMap(Map task) {
    return Task(
      content: task["content"],
      done: task["done"],
    );
  }

  Map toMap() {
    return {
      "content": content,
      "done": done,
    };
  }
}
