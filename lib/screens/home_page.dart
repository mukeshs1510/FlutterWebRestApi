import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simple_yes_no_api/models/queans_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _questionFieldController = TextEditingController();
  String url = "https://yesno.wtf/api";

  // to store current answer
  AnswerModel _currentAnswer;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // a func. will handle the yes or no
  _handleGetAnswer() async {
    String que = _questionFieldController.text?.trim();
    if (que == null || que.length == 0) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Please ask the valid question..."),
        duration: Duration(milliseconds: 3000),
      ));
      return;
    } else if (que[que.length - 1] != '?') {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Please add '?' at the last as its a QUESTION"),
        duration: Duration(milliseconds: 5000),
      ));
      return;
    } else {
      try {
        http.Response response = await http.get(Uri.parse(url));
        if (response.statusCode == 200 && response.body != null) {
          Map<String, dynamic> responseBody = json.decode(response.body);
          AnswerModel answer = AnswerModel.fromMap(responseBody);
          setState(() {
            _currentAnswer = answer;
          });
        }
      } catch (e, stackTrace) {
        print(e);
        print(stackTrace);
      }
    }
  }

  _handleReset() {
    _questionFieldController.text = '';
    setState(() {
      _currentAnswer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Simple Questions WebApp"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 0.5 * MediaQuery.of(context).size.width,
              child: TextField(
                controller: _questionFieldController,
                decoration: InputDecoration(
                  hintText: "Ask a Question",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          if (_currentAnswer != null)
            Stack(
              children: [
                Container(
                  width: 0.30 * MediaQuery.of(context).size.width,
                  height: 0.20 * MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(_currentAnswer.image),
                      )),
                ),
                Positioned.fill(
                  bottom: 20,
                  right: 20,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      _currentAnswer.answer.toUpperCase(),
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
              ],
            ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RaisedButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  child: Text(
                    "Get Answer",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: _handleGetAnswer,
                color: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
              SizedBox(
                width: 20,
              ),
              RaisedButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  child: Text(
                    "Reset",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: _handleReset,
                color: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
