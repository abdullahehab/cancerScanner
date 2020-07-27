import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/APIS.dart';
import 'package:flutter_study/pov/APIDATA.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
//      theme: new ThemeData.dark(),
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

  File imageFile;

  Future<void> _showChooseDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Make a choice!'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Gallery'),
              onPressed: () {
                _openImageSource(context, ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: Text('Camera'),
              onPressed: () {
                _openImageSource(context, ImageSource.camera);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  _openImageSource(BuildContext context, ImageSource imageSource) async {
    var picture =
    await ImagePicker.pickImage(source: imageSource, imageQuality: 50);
    saveImage(picture);
  }

  saveImage(var picture) {
    setState(() {
      imageFile = picture;

      convertImageToBase64(imageFile);
    });
  }

  convertImageToBase64(File image) {
    String img64 = base64Encode(image.readAsBytesSync());

    callAPIS(img64);
  }

  String text = '';
  List<String> dataList = [];

  callAPIS(String image) {
    // TODO : CALL OCR API
    api.fetchSetting(image).then((response) {
      if (response.statusCode == 200) {
        List data = [];

        json
            .decode(response.body)['predictions']
            .forEach((k, v) => data.add('${k}: ${v}'));

        for (int i = 0; i < data.length; i++) {
          text = text + data[i] + (i != data.length - 1 ? " - " : "");
        }


        // TODO : CALL TRANSLATE A PI
        api.translate(text).then((response) {
          print("---------------------------------------------");
          setState(() {
            dataList = json
                .decode(response.body)['data']['translations'][0]
            ['translatedText']
                .toString()
                .split("-");
          });
          print(dataList);
          print("---------------------------------------------");
        });
      } else {
        print(response.body);
        print(response.statusCode);
        throw Exception('Failed to load data');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Upload Image for analysis'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Center(
              child: Stack(
                children: <Widget>[
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        color: Colors.grey[200]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      child: imageFile != null
                          ? Image.file(imageFile, fit: BoxFit.cover)
                          : Container(),
                    ),
                  ),
                  Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          color: Colors.transparent),
                      child: IconButton(
                          icon: Icon(Icons.camera_enhance),
                          onPressed: () => _showChooseDialog(context))),
                ],
              ),
            ),
            SizedBox(height: 20),
            dataList.length != 0
                ? ListView.builder(
                shrinkWrap: true,
                itemCount: dataList.length,
                itemBuilder: (context, index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      dataList[index],
                      textAlign: TextAlign.center,
                    )
                  ],
                ))
                : Text("please upload image")
          ],
        ),
      ),
    );
  }
}
