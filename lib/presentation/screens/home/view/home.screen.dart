import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = TextEditingController();
  final List<Task> tasks = [];
  final borderFocusAndEnabled = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide.none,
  );

  @override
  void initState() {
    super.initState();
  }

  void updateTask(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
    });
  }

  void updateTaskFavorite(int index) {
    setState(() {
      tasks[index].favorite = !tasks[index].favorite;
    });
  }

  void addTask() {
    final text = controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        tasks.add(Task(text, false, false));
        controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu_outlined, color: Colors.grey),
        title: Text(
          'To Do List',
          style: TextStyle(color: Colors.grey, fontSize: 20),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
            color: Colors.grey,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              child: Text(
                'Groceries',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Add a task..',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      prefixIcon: IconButton(
                        icon: Icon(Icons.add),
                        color: Colors.grey,
                        onPressed: addTask,
                      ),
                      border: InputBorder.none,
                      fillColor: const Color.fromARGB(255, 236, 227, 245),
                      filled: true,
                      focusedBorder: borderFocusAndEnabled,
                      enabledBorder: borderFocusAndEnabled,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: tasks.isEmpty
                  ? Center(child: Text('Список пустой'))
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return ListTile(
                          leading: IconButton(
                            icon: Icon(
                              task.isDone
                                  ? Icons.check_circle_outlined
                                  : Icons.circle_outlined,
                            ),
                            highlightColor: Colors.transparent,
                            onPressed: () => updateTask(index),
                          ),
                          title: Text(task.text),
                          trailing: IconButton(
                            icon: Icon(
                              task.favorite ? Icons.star : Icons.star_border,
                              color: task.favorite ? Colors.amber : Colors.grey,
                            ),
                            onPressed: () => updateTaskFavorite(index),
                            focusNode: FocusNode(),
                            highlightColor: Colors.transparent,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class Task {
  String text;
  bool isDone;
  bool favorite;

  Task(this.text, this.isDone, this.favorite);
}
