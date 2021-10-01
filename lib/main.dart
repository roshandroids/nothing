import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nothing/app_config.dart';
import 'dart:math';

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
        primarySwatch: appConfig!.isProd ? Colors.green : Colors.amber,
      ),
      home: MyHomePage(
        title: 'You are running ${appConfig?.appName}',
        appConfig: appConfig,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
    this.appConfig,
  }) : super(key: key);

  final String title;
  final AppConfig? appConfig;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('facts').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return ListTile(
                    title: Text(data['question']),
                    subtitle: (data['ENV'] as bool)
                        ? Text(
                            'PROD',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(color: Colors.red),
                          )
                        : Text(
                            'STAGE',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(color: Colors.green),
                          ));
              }).toList(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final data = getRandomString(5);
          await FirebaseFirestore.instance
              .collection('facts')
              .doc()
              .set({'question': data, 'ENV': widget.appConfig!.isProd});
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
