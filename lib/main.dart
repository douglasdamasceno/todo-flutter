import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newTaskCtrl = TextEditingController();
  var uuid = Uuid();

  void add() {
    if (newTaskCtrl.text.isEmpty) return;
    setState(() {
      widget.items.add(Item(
        id: uuid.v1(),
        title: newTaskCtrl.text,
        done: false,
      ));
      newTaskCtrl.text = "";
      save();
    });
  }

  void remove(int index) {
    setState(() {
      widget.items.removeAt(index);
      save();
    });
  }

  Future load() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');

    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();
      setState(() {
        widget.items = result;
      });
    }
  }

  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(widget.items));
  }

  _HomePageState() {
    load();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: newTaskCtrl,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          decoration: InputDecoration(
              labelText: "Nova tarefa",
              labelStyle: TextStyle(
                color: Colors.white,
                fontSize: 18,
              )),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (BuildContext ctxt, int index) {
          final item = widget.items[index];
          return Dismissible(
            child: CheckboxListTile(
              title: Text(item.title),
              value: item.done,
              onChanged: (value) {
                setState(() {
                  item.done = value;
                  save();
                });
              },
            ),
            key: Key(item.id),
            background: Container(
              color: Colors.red.withOpacity(0.8),
            ),
            onDismissed: (direction) {
              if (direction == DismissDirection.startToEnd) {}
              remove(index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          add();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
