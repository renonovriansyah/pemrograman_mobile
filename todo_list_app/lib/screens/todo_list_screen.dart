import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/todo.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> with SingleTickerProviderStateMixin {
  List<Todo> todos = [];
  late TabController _tabController;
  int _selectedIndex = 0; // Untuk Bottom Navigation Bar

  @override
  void initState() {
    super.initState();
    _loadTodos(); // Muat data saat aplikasi dibuka
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // --- Persistent Storage Logic ---

  Future<void> _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    String? todosString = prefs.getString('todos');

    if (todosString != null) {
      List<dynamic> todosJson = jsonDecode(todosString);
      setState(() {
        todos = todosJson.map((json) => Todo.fromJson(json)).toList();
      });
    }
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> todosJson =
        todos.map((todo) => todo.toJson()).toList();
    String todosString = jsonEncode(todosJson);
    await prefs.setString('todos', todosString);
  }

  // --- CRUD Operations ---

  void _addTodo(String title) {
    if (title.isEmpty) return;
    setState(() {
      todos.add(
        Todo(
          id: DateTime.now().toString(),
          title: title,
          createdAt: DateTime.now(),
        ),
      );
    });
    _saveTodos();
    _showSnackBar('Todo berhasil ditambahkan');
  }

  void _toggleCompletion(int index) {
    setState(() {
      todos[index].isCompleted = !todos[index].isCompleted;
    });
    _saveTodos();
  }

  void _updateTodo(int index, String newTitle) {
    if (newTitle.isEmpty) return;
    setState(() {
      todos[index].title = newTitle;
    });
    _saveTodos();
    _showSnackBar('Todo berhasil diperbarui');
  }

  void _deleteTodo(int index) {
    final deletedTitle = todos[index].title;
    setState(() {
      todos.removeAt(index);
    });
    _saveTodos();
    _showSnackBar('Todo "$deletedTitle" dihapus');
  }

  // --- UI/Dialogs ---

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showNoteDialog({int? index}) {
    final isEdit = index != null;
    final titleController = TextEditingController(
      text: isEdit ? todos[index].title : '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            isEdit ? 'Edit Todo' : 'Tambah Todo Baru',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: titleController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Judul Todo',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  if (isEdit) {
                    _updateTodo(index, titleController.text);
                  } else {
                    _addTodo(titleController.text);
                  }
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              child: Text(isEdit ? 'Update' : 'Simpan',
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.purple.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.apps, size: 20, color: Colors.purple.shade700),
            ),
            const SizedBox(width: 8),
            const Text(
              'Spectrum Flow',
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.deepPurpleAccent.shade100.withAlpha(3),
                ),
                labelColor: Colors.deepPurple,
                unselectedLabelColor: Colors.grey.shade600,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(text: '  Inbox  '),
                  Tab(text: '  Today  '),
                  Tab(text: '  Upcoming  '),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Today',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            Text(
              'October ${DateTime.now().day}, ${DateTime.now().year}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: todos.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.check_box_outline_blank,
                              size: 80, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Yey! Belum ada tugas hari ini.',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        final todo = todos[index];

                        return Dismissible(
                          key: ValueKey(todo.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            decoration: BoxDecoration(
                              color: Colors.red.shade400,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.centerRight,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: const Icon(Icons.delete_forever,
                                color: Colors.white, size: 30),
                          ),
                          confirmDismiss: (direction) {
                            return showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Konfirmasi Hapus'),
                                content: Text(
                                    'Yakin ingin menghapus todo "${todo.title}"?'),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(false),
                                      child: const Text('Batal')),
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(true),
                                      child: const Text('Hapus',
                                          style: TextStyle(color: Colors.red))),
                                ],
                              ),
                            );
                          },
                          onDismissed: (direction) {
                            _deleteTodo(index);
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 8.0),
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                onTap: () => _showNoteDialog(index: index),
                                leading: GestureDetector(
                                  onTap: () => _toggleCompletion(index),
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: todo.isCompleted
                                            ? Colors.green
                                            : Colors.grey.shade400,
                                        width: 2,
                                      ),
                                      color: todo.isCompleted
                                          ? Colors.green
                                          : Colors.transparent,
                                    ),
                                    child: todo.isCompleted
                                        ? const Icon(Icons.check,
                                            size: 18, color: Colors.white)
                                        : null,
                                  ),
                                ),
                                title: Text(
                                  todo.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: todo.isCompleted
                                        ? Colors.grey
                                        : Colors.black87,
                                    decoration: todo.isCompleted
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                                trailing: const Icon(Icons.more_vert,
                                    color: Colors.grey),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Colors.deepPurpleAccent.shade400,
              Colors.pinkAccent.shade400
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FloatingActionButton(
          onPressed: () => _showNoteDialog(),
          tooltip: 'Tambah Todo',
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, size: 30, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        elevation: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home,
                  color: _selectedIndex == 0 ? Colors.deepPurple : Colors.grey),
              onPressed: () {
                setState(() {
                  _selectedIndex = 0;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.calendar_today,
                  color: _selectedIndex == 1 ? Colors.deepPurple : Colors.grey),
              onPressed: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
            ),
            const SizedBox(width: 48), // Space for the FAB
            IconButton(
              icon: Icon(Icons.chat_bubble_outline,
                  color: _selectedIndex == 2 ? Colors.deepPurple : Colors.grey),
              onPressed: () {
                setState(() {
                  _selectedIndex = 2;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.settings_outlined,
                  color: _selectedIndex == 3 ? Colors.deepPurple : Colors.grey),
              onPressed: () {
                setState(() {
                  _selectedIndex = 3;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}