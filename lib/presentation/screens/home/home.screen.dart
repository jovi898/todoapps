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
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide.none,
  );

  static const colorGrey = Colors.grey;
  static const colorWhite = Colors.white;

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

  void editTask() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Icon(Icons.menu_outlined, color: colorWhite),
        title: Text(
          'To Do List',
          style: TextStyle(
            color: colorWhite,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
            color: colorWhite,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Text(
                    'Groceries',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 18),
                          hintText: 'Add a task..',
                          hintStyle: TextStyle(color: colorGrey, fontSize: 14),
                          prefixIcon: IconButton(
                            icon: Icon(Icons.add, size: 28),
                            color: colorGrey,
                            onPressed: addTask,
                          ),
                          fillColor: colorWhite,
                          filled: true,
                          focusedBorder: borderFocusAndEnabled,
                          enabledBorder: borderFocusAndEnabled,
                        ),
                        onFieldSubmitted: (value) => addTask(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Expanded(
                  child: tasks.isEmpty
                      ? Center(child: Text('Список пустой'))
                      : ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: colorWhite,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                  border: Border.all(color: colorWhite),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        size: 28,
                                        task.isDone
                                            ? Icons.check_circle
                                            : Icons.circle_outlined,
                                        color: task.isDone
                                            ? Colors.blue
                                            : Colors.blue,
                                      ),
                                      highlightColor: Colors.transparent,
                                      onPressed: () => updateTask(index),
                                    ),
                                    Expanded(
                                      child: Text(
                                        task.text,
                                        style: TextStyle(
                                          color: task.isDone
                                              ? Colors.blue
                                              : Colors.black,
                                          decoration: task.isDone
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {},
                                      highlightColor: Colors.transparent,
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        task.favorite
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: task.favorite
                                            ? Colors.blue
                                            : colorGrey,
                                      ),
                                      onPressed: () =>
                                          updateTaskFavorite(index),
                                      highlightColor: Colors.transparent,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
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
