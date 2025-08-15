import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final supabase = Supabase.instance.client;
  final controller = TextEditingController();
  List<dynamic> todos = [];

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    final data = await supabase.from('todos').select().order('created_at', ascending: false);
    setState(() {
      todos = data;
    });
  }

  Future<void> addTodo() async {
    final userId = supabase.auth.currentUser?.id;
    if (controller.text.isEmpty || userId == null) return;

    await supabase.from('todos').insert({
      'title': controller.text,
      'is_done': false,
      'user_id': userId,
    });

    controller.clear();
    fetchTodos();
  }

  Future<void> toggleTodo(int id, bool isDone) async {
    await supabase.from('todos').update({'is_done': !isDone}).eq('id', id);
    fetchTodos();
  }

  Future<void> deleteTodo(int id) async {
    await supabase.from('todos').delete().eq('id', id);
    fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Tasks"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await supabase.auth.signOut();
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(hintText: 'Add a task...'),
                  ),
                ),
                IconButton(icon: const Icon(Icons.add), onPressed: addTodo),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  leading: Checkbox(
                    value: todo['is_done'],
                    onChanged: (_) => toggleTodo(todo['id'], todo['is_done']),
                  ),
                  title: Text(
                    todo['title'],
                    style: TextStyle(
                      decoration: todo['is_done']
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deleteTodo(todo['id']),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
