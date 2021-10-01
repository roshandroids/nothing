import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nothing/app_config.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    this.appConfig,
  }) : super(key: key);
  final AppConfig? appConfig;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'You are running ${appConfig?.appName}'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('facts').snapshots(),
        builder: (context, snapshots) {
          if (snapshots.hasData) {
            return Text('${snapshots}');

            // return ListView.builder(itemCount: snapshots.data,)
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await FirebaseFirestore.instance
              .collection('facts')
              .doc()
              .set({'question': 'RAMDONNNNMMM'});
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
