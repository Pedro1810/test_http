import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'show_code.dart';
import 'dart:convert';

class PictureInfo{
  final double height;
  final double width;
  final String breeds;
  final String url;

  PictureInfo({this.height, this.width, this.breeds, this.url});

  factory PictureInfo.fromJson(Map<String, dynamic> json) {
    var streetsFromJson = json['streets'];
    List<String> streetsList = new List<String>.from(streetsFromJson);

    return PictureInfo(
      breeds: json['breeds'],
      height: json['height'],
      width: json['width'],
      url: json['url'],
    );
  }
}

class TestHttp extends StatefulWidget {
  final String url = "https://api.thecatapi.com/v1/images/search";

  @override
  State<StatefulWidget> createState() => TestHttpState();
}// TestHttp

class TestHttpState extends State<TestHttp> {
  String _url;
  PictureInfo _pictureInfo = PictureInfo(
      breeds: '',
      height: 0,
      width: 0,
      url: ''
  );
  int _status;

  @override
  void initState() {
    _url = widget.url;
    super.initState();
  }//initState

  _sendRequestGet() {

    http.get(_url).then((response){
      _status = response.statusCode;
      _pictureInfo = PictureInfo.fromJson(json.decode(response.body));
      setState(() {});//reBuildWidget
    }).catchError((error){
      _status = 0;
      print(error);
      print("Response status: $_status");
      setState(() {});//reBuildWidget
    });
  }//_sendRequestGet

  Widget build(BuildContext context) {
    return Center(child: SingleChildScrollView(child: Column(
      children: <Widget>[
        SizedBox(
            height: 20.0),
        RaisedButton(
            child: Text('Send request GET'),
            onPressed: _sendRequestGet),

        SizedBox(height: 20.0),
        Text(_pictureInfo.breeds),

        SizedBox(height: _pictureInfo.height, width: _pictureInfo.width),
        Image.network(_pictureInfo.url),
      ],
    )));
  }//build
}//TestHttpState

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Test HTTP API'),
          actions: <Widget>[IconButton(icon: Icon(Icons.code), tooltip: 'Code', onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => CodeScreen()));
          })],
        ),
        body: TestHttp()
    );
  }
}

void main() => runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyApp()
    )
);