import 'package:flutter/material.dart';
import 'package:flutter_circle_avatar_extended/flutter_circle_avatar_extended.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: CircleAvatarExtended(
          // imageUrl:
          //     'https://github.com/optimygmbh/flutter_circle_avatar_extended/raw/master/image.jpg',
          // backgroundColor: Colors.black,
          initials: 'ABC',
          radius: 36,
        ),
      ),
    );
  }
}
