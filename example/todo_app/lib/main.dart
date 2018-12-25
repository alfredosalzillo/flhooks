import 'package:flutter/material.dart';
import 'package:flhooks/flhooks.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoPage(),
    );
  }
}

final TodoList = ({
  List<String> todoItems,
  Function(String) onTap,
}) =>
    ListView.builder(
      itemBuilder: (context, index) {
        if (index < todoItems.length) {
          return ListTile(
            title: new Text(todoItems[index]),
            onTap: () => onTap(todoItems[index]),
          );
        }
      },
    );

final AddTodoButton = ({final Function onAdd}) => FloatingActionButton(
      onPressed: onAdd,
      tooltip: 'Add Todo',
      child: Icon(Icons.add),
    );

final showRemoveTodo = ({
  String todo,
  BuildContext context,
  Function onRemove,
}) =>
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(title: Text('Mark "$todo" as done?'), actions: <Widget>[
              FlatButton(
                  child: new Text('CANCEL'),
                  onPressed: () => Navigator.of(context).pop()),
              FlatButton(
                  child: new Text('MARK AS DONE'),
                  onPressed: () {
                    onRemove(todo);
                    Navigator.of(context).pop();
                  })
            ]));

final showAddTodo = ({
  BuildContext context,
  Function onAdd,
}) =>
    showDialog(
        context: context,
        builder: (context) => HookBuilder(builder: (context) {
              // Get a new controller only the first time
              final todoController = useMemo(() => TextEditingController(), []);
              return AlertDialog(
                  title: Text('ADD TODO'),
                  content: TextField(
                    controller: todoController,
                    autofocus: true,
                    decoration: new InputDecoration(
                        hintText: 'Enter something to do...',
                        contentPadding: const EdgeInsets.all(16.0)),
                  ),
                  actions: <Widget>[
                    FlatButton(
                        child: new Text('CANCEL'),
                        onPressed: () => Navigator.of(context).pop()),
                    FlatButton(
                        child: new Text('ADD'),
                        onPressed: () {
                          onAdd(todoController.text);
                          Navigator.of(context).pop();
                        })
                  ]);
            }));

final _todoItems = ['TODO 1', 'TODO 2'];

// Define custom hook function for a remove item from a List HookState
void Function(E) useRemove<E>(HookState<List<E>> state) => useCallback((E item) {
  final newTodo = List<E>();
  newTodo
    ..addAll(state.value)
    ..removeWhere((e) => e == item);
  state.set(newTodo);
}, [state.value]);

// Define custom hook function for a add an item into a List HookState
void Function(E) useAdd<E>(HookState<List<E>> state) => useCallback((E item) {
  final newTodo = List<E>();
  newTodo
    ..addAll(state.value)
    ..add(item);
  state.set(newTodo);
}, [state.value]);


final TodoPage = () => HookBuilder(builder: (context) {
      final todoItems = useState(_todoItems);
      final removeTodo = useRemove(todoItems);
      final addTodo = useAdd(todoItems);
      final appBar = AppBar(
        title: Text('TODO APP'),
      );
      final actionButton = FloatingActionButton(
        onPressed: () => showAddTodo(context: context, onAdd: addTodo),
        tooltip: 'Add Todo',
        child: Icon(Icons.add),
      );
      return Scaffold(
        appBar: appBar,
        body: TodoList(
            todoItems: todoItems.value,
            onTap: (todo) => showRemoveTodo(
                  todo: todo,
                  context: context,
                  onRemove: removeTodo,
                )),
        floatingActionButton: actionButton,
      );
    });
