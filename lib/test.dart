import 'package:flutter/material.dart';
import 'package:flutter_study/AppState/APIS.dart';
import 'package:flutter_study/pov/APIDATA.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData.dark(),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {

  APIS api;

  @override
  void initState() {
    super.initState();
    api = new APIS();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Example App')),
      body: Center(
        child: FutureBuilder<APiData>(
          future: api.fetchSetting(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Text(snapshot.data.prediction.Melanoma);
              Text(snapshot.data.prediction.VascularLesions);
              Text(snapshot.data.prediction.MelanocyticNevi);
              Text(snapshot.data.prediction.dermatofibroma);
              Text(snapshot.data.prediction.actinicKeratoses);
              Text(snapshot.data.prediction.BenignKeratosis);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      )
    );
  }
}