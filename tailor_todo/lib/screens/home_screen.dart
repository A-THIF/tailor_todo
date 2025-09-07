import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/todo.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../widgets/custom_button.dart';
import 'add_task_screen.dart';
import 'todo_details_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final supabase = Supabase.instance.client;
  List<Todo> todos = [];
  bool showArchived = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    try {
      final response = await supabase
          .from('todos')
          .select('*')
          .eq('user_id', supabase.auth.currentUser!.id)
          .eq('archived', showArchived)
          .order('created_at', ascending: false);

      setState(() {
        todos = (response as List).map((json) => Todo.fromJson(json)).toList();
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading todos: $e')));
    }
  }

  Future<void> _deleteTodo(String id) async {
    try {
      await supabase.from('todos').delete().eq('id', id);
      _loadTodos();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error deleting todo: $e')));
    }
  }

  Future<void> _archiveTodo(String id) async {
    try {
      await supabase
          .from('todos')
          .update({'archived': !showArchived})
          .eq('id', id);
      _loadTodos();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error archiving todo: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text(
          'Tailor Todo',
          style: AppFonts.spectral(
            color: AppColors.brandText,
            size: 24,
            weight: FontWeight.w300,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: AppColors.brandText),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Archive toggle
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Archived',
                  style: AppFonts.spectral(
                    color: AppColors.brandText,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: showArchived,
                  onChanged: (value) {
                    setState(() {
                      showArchived = value;
                      loading = true;
                    });
                    _loadTodos();
                  },
                  activeColor: AppColors.accent,
                ),
              ],
            ),
          ),
          // Todos list
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : todos.isEmpty
                ? Center(
                    child: Text(
                      showArchived ? 'No archived todos' : 'No todos yet',
                      style: AppFonts.cardo(
                        color: AppColors.brandText,
                        size: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.accent,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          TodoDetailsScreen(todo: todo),
                                    ),
                                  ).then((_) => _loadTodos());
                                },
                                child: Text(
                                  todo.title,
                                  style: AppFonts.cardo(
                                    color: AppColors.onDark,
                                    size: 16,
                                    weight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            PopupMenuButton<String>(
                              icon: const Icon(
                                Icons.more_vert,
                                color: AppColors.onDark,
                              ),
                              onSelected: (value) {
                                if (value == 'delete') {
                                  _showDeleteDialog(todo.id);
                                } else if (value == 'archive') {
                                  _archiveTodo(todo.id);
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'archive',
                                  child: Text(
                                    showArchived ? 'Unarchive' : 'Archive',
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: showArchived
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddTaskScreen()),
                ).then((_) => _loadTodos());
              },
              backgroundColor: AppColors.surface,
              child: const Icon(Icons.add, color: AppColors.accent),
            ),
    );
  }

  void _showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Really want to delete this task?',
          style: AppFonts.cardo(color: AppColors.brandText, size: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Return',
              style: AppFonts.cardo(color: AppColors.onDark),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteTodo(id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandRed,
            ),
            child: Text(
              'Delete',
              style: AppFonts.cardo(color: AppColors.onDark),
            ),
          ),
        ],
      ),
    );
  }
}
