import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/item.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  var items = new List<Item>();

  HomePage() {
    items = [];
    items.add(Item(id: "1", title: "estudar flutter", done: true));
    items.add(Item(id: "2", title: "estudar react native", done: false));
    items.add(Item(id: "3", title: "estudar ionic", done: false));
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo App List "),
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (BuildContext ctxt, int index) {
          final item = widget.items[index];
          return CheckboxListTile(
            title: Text(item.title),
            key: Key(item.id),
            value: item.done,
            onChanged: (value) {
              setState(() {
                item.done = value;
              });
              print(value);
            },
          );
        },
      ),
    );
  }
}
