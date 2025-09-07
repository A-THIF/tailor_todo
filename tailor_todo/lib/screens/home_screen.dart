import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/todo.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../widgets/home_header_bar.dart';
import '../widgets/todo_list_tile.dart';
import '../widgets/archive_bottom_bar.dart';
import '../widgets/confirmation_dialog.dart';
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading todos: $e'),
            backgroundColor: AppColors.brandRed,
          ),
        );
      }
    }
  }

  Future<void> _deleteTodo(String id) async {
    try {
      await supabase.from('todos').delete().eq('id', id);
      _loadTodos();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task deleted successfully'),
            backgroundColor: AppColors.accent,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting todo: $e'),
            backgroundColor: AppColors.brandRed,
          ),
        );
      }
    }
  }

  Future<void> _archiveTodo(String id) async {
    try {
      await supabase
          .from('todos')
          .update({
            'archived': !showArchived,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id);
      _loadTodos();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(showArchived ? 'Task unarchived' : 'Task archived'),
            backgroundColor: AppColors.accent,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating todo: $e'),
            backgroundColor: AppColors.brandRed,
          ),
        );
      }
    }
  }

  void _showDeleteDialog(String todoId) {
    showDialog(
      context: context,
      builder: (context) =>
          DeleteConfirmationDialog(onConfirm: () => _deleteTodo(todoId)),
    );
  }

  void _toggleArchiveView() {
    setState(() {
      showArchived = !showArchived;
      loading = true;
    });
    _loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    // height + padding for the bottom bar (adjust if you change bar height)
    const double archiveBarHeight = 64;
    const double fabBottomGap = 84;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                HomeHeaderBar(
                  onProfileTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  },
                ),
                Expanded(
                  child: loading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppColors.accent,
                          ),
                        )
                      : todos.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                showArchived ? Icons.archive : Icons.task_alt,
                                size: 64,
                                color: AppColors.brandText.withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                showArchived
                                    ? 'No archived todos'
                                    : 'No todos yet',
                                style: AppFonts.cardo(
                                  color: AppColors.brandText,
                                  size: 16,
                                ),
                              ),
                              if (!showArchived) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'Tap + to create your first todo',
                                  style: AppFonts.cardo(
                                    color: AppColors.brandText.withOpacity(0.7),
                                    size: 14,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(
                            16,
                            8,
                            16,
                            archiveBarHeight + 16,
                          ),
                          itemCount: todos.length,
                          itemBuilder: (context, index) {
                            final todo = todos[index];
                            return TodoListTile(
                              todo: todo,
                              showArchived: showArchived,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        TodoDetailsScreen(todo: todo),
                                  ),
                                ).then((_) => _loadTodos());
                              },
                              onDelete: () => _showDeleteDialog(todo.id),
                              onArchive: () => _archiveTodo(todo.id),
                            );
                          },
                        ),
                ),
              ],
            ),
            // Docked bottom bar
            Align(
              alignment: Alignment.bottomCenter,
              child: ArchiveBottomBar(
                isArchived: showArchived,
                onTap: _toggleArchiveView,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: showArchived
          ? null
          : Padding(
              padding: const EdgeInsets.only(bottom: fabBottomGap, right: 8),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddTaskScreen()),
                  ).then((_) => _loadTodos());
                },
                backgroundColor: AppColors.surface,
                elevation: 8,
                child: Icon(Icons.add, color: AppColors.accent, size: 28),
              ),
            ),
    );
  }
}
