// ignore_for_file: avoid_print

import 'package:ejara_fire/local_lotification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

LocalNotification local = LocalNotification();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init firebase
  await Firebase.initializeApp();

  // FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
  //   await Firebase.initializeApp();
  // });

  local.initializeNotifications();

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        local.singleNotification(notification.title ?? 'Title', notification.body ?? 'Body');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title ?? 'Title'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body ?? 'Body')],
                  ),
                ),
              );
            });
      }
    });

    // Get token
    final token = FirebaseMessaging.instance.getToken();

    print("################################### TOKEN");
    token.then((value) => print(value ?? 'NOFOUND'));
  }

  void _showNotif() {
    setState(() {
      _counter++;
    });

    local.singleNotification('Testin $_counter', 'How you doing ?');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNotif,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
