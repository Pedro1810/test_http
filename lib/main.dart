import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'show_code.dart';

class Article {
  final int id;
  final String name;

  Article({this.id, this.name});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['_id'],
      name: json['name'],
    );
  }
}

class Articles {
  final List<Article> articles;

  Articles({this.articles});

  factory Articles.fromJson(Map<String, dynamic> json) {
    return Articles(
      articles: json['articles'],
    );
  }
}

class TestHttp extends StatefulWidget {
  final String url = 'https://all.culture.ru/api/2.3/articles';

  @override
  State<StatefulWidget> createState() => TestHttpState();
} // TestHttp

class TestHttpState extends State<TestHttp> {

  String _url, _body;
  int _status;

  @override
  void initState() {
    _url = widget.url;
    super.initState();
  } //initState

  _sendRequestGet() {
    http.get(_url).then((response) {
      _status = response.statusCode;
      _body = response.body;

      final articles = Articles.fromJson(json.decode(response.body));
      print(articles);

      setState(() {}); //reBuildWidget
    }).catchError((error) {
      _status = 0;
      _body = error.toString();

      setState(() {}); //reBuildWidget
    });
  } //_sendRequestGet

  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            RaisedButton(
                child: Text('Send request GET'), onPressed: _sendRequestGet),
            SizedBox(height: 20.0),
            Text('Response status',
                style: TextStyle(fontSize: 20.0, color: Colors.blue)),
            Text(_status == null ? '' : _status.toString()),
            SizedBox(height: 20.0),
            Text('Response body',
                style: TextStyle(fontSize: 20.0, color: Colors.blue)),
            Text(_body == null ? '' : _body),
          ],
        ),
      ),
    );
  } //build
} //TestHttpState

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Test HTTP API'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.code),
                tooltip: 'Code',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CodeScreen()));
                })
          ],
        ),
        body: TestHttp());
  }
}

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
