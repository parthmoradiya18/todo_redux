import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

enum Actions { addTodo, removeTodo }

class AddTodoAction {
  final String todo;

  AddTodoAction(this.todo);
}

class RemoveTodoAction {
  final int index;

  RemoveTodoAction(this.index);
}

class UpdateTodoAction {
  final int index;
  final String updatedTodo;

  UpdateTodoAction(this.index, this.updatedTodo);
}

// Define reducers
List<String> todoReducer(List<String> todos, dynamic action) {
  if (action is AddTodoAction) {
    return List.from(todos)..add(action.todo);
  } else if (action is RemoveTodoAction) {
    return List.from(todos)..removeAt(action.index);
  } else if (action is UpdateTodoAction) {
    todos[action.index] = action.updatedTodo;
    return List.from(todos);
  }
  return todos;
}

void main() {
  final store = Store<List<String>>(
    todoReducer,
    initialState: [],
  );

  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<List<String>> store;

  const MyApp({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Redux Todo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TodoList(),
      ),
    );
  }
}

class TodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Icon(
          Icons.favorite,
          color: Colors.red.shade800,
        ),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Todo book',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black),
        ),
        actions: [
          IconButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  )),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    String todoText = '';

                    return AlertDialog(
                      title: Text('Add Todo'),
                      content: TextField(
                        onChanged: (value) {
                          todoText = value;
                        },
                      ),
                      actions: [
                        TextButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              )),
                          onPressed: () {
                            StoreProvider.of<List<String>>(context)
                                .dispatch(AddTodoAction(todoText));
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Add',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(
                Icons.bookmark_add,
                color: Colors.black,
              ))
        ],
      ),
      body: StoreConnector<List<String>, List<String>>(
        converter: (store) => store.state,
        builder: (context, todos) {
          return ListView.separated(
            separatorBuilder: (context, index) {
              return Divider(
                color: Colors.black,
                thickness: 1,
              );
            },
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return Card(
                color: Colors.black26,
                child: ListTile(
                    title: Text(todo,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    trailing:

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _editTodo(context, index, todo);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.black),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("you are delete\t${todo}"),
                                  actions: [
                                    TextButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            )),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "cancel",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        )),
                                    TextButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            )),
                                        onPressed: () {
                                          StoreProvider.of<List<String>>(
                                                  context)
                                              .dispatch(
                                                  RemoveTodoAction(index));
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "ok",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        )),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                ),
              );
            },
          );

        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange.shade200,
        elevation: 5,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String todoText = '';

              return AlertDialog(
                title: Text('Add Todo'),
                content: TextField(
                  onChanged: (value) {
                    todoText = value;
                  },
                ),
                actions: [
                  TextButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        )),
                    onPressed: () {
                      StoreProvider.of<List<String>>(context)
                          .dispatch(AddTodoAction(todoText));
                      Navigator.pop(context);
                    },
                    child: Text('Add',style: TextStyle(color: Colors.black),),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  void _editTodo(BuildContext context, int index, String todo) {
    String updatedTodo = todo;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Todo'),
          content: TextField(
            onChanged: (value) {
              updatedTodo = value;
            },
            controller: TextEditingController(text: todo),
          ),
          actions: [
            TextButton(
              onPressed: () {
                StoreProvider.of<List<String>>(context)
                    .dispatch(UpdateTodoAction(index, updatedTodo));
                Navigator.pop(context);
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
