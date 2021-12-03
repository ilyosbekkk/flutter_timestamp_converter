import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class TimeStamp extends StatefulWidget {
  @override
  _TimeStampState createState() => _TimeStampState();
}

class _TimeStampState extends State<TimeStamp> {
  TextEditingController _timestampController = TextEditingController();
  String _localTime, _utcTime;
  final _resultStates = [0, 1, -1];
  int _currentResultState = 0;
  List<int> _years;
  List<int> _months;
  List<int> _days;
  List<String> _hours;
  List<String> _seconds;
  List<String> _mins;
  List<String> _timeZone;

  @override
  void initState() {
    _years = List<int>.generate(100, (index) => 1970 + index);
    _hours = List<String>.generate(24, (index) {
      if (index >= 0 && index < 9) {
        return "0${index + 1}";
      } else if (index >= 9 && index < 23) {
        return "${index + 1}";
      } else {
        return "00";
      }
    });
    _mins = List<String>.generate(60, (index) {
      if (index >= 0 && index <= 9) {
        return "0$index";
      } else
        return "$index";
    });
    _seconds = List<String>.generate(60, (index) {
      if (index >= 0 && index <= 9) {
        return "0$index";
      } else
        return "$index";
    });

    _months = List<int>.generate(12, (index) => index + 1);
    _days = List<int>.generate(31, (index) => index + 1);
    _timeZone = ["GMT", "LOCAL"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 255, 250, 1.0),
      appBar: AppBar(
        title: Text("EpochConverter"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10.0),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Text(
                  "Convert  epoch to human-readible date and  vice versa",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(20, 52, 112, 1)),
                ),
              ),
              SizedBox(height: 10.0),
              _buildTimeStampToHumanReadible(),
              Row(
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 5.0),
                      child: Icon(
                        Icons.info_outline,
                      )),
                  Flexible(
                      child: _buildText(
                          "Supports Unix timestamps in seconds, milliseconds, microseconds and nanoseconds.",
                          Colors.black)),
                ],
              ),
              Divider(
                color: Colors.green,
              ),
              if (_currentResultState == 1)
                _buildResultWidget(_localTime, _utcTime, "seconds"),
              if (_currentResultState == -1)
                _buildText(
                    "Sorry this timestamp is  not valid.Check your timestamp,  strip letters and  punctuation  marks!",
                    Colors.red),
              _buildHumanReadibleToTimeStamp()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeStampToHumanReadible() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                margin: EdgeInsets.only(left: 5.0),
                height: 35,
                child: TextField(
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  controller: _timestampController,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ),
            ),
            Expanded(
                flex: 4,
                child: Container(
                  height: 35,
                  margin: EdgeInsets.only(left: 5.0, right: 5.0),
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      color: Color.fromRGBO(255, 249, 203, 1.0),
                      onPressed: () {
                        _onConvertButtonPressed(_timestampController);
                      },
                      child: FittedBox(
                        child: Text(
                          "Timestamp  to human date",
                        ),
                      )),
                )),
          ],
        ),
        Container(
            height: 35,
            margin: EdgeInsets.only(top: 10.0),
            child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                color: Color.fromRGBO(255, 249, 203, 1.0),
                onPressed: () {
                  setState(() {
                    _currentResultState = _resultStates[0];
                    _timestampController.text = "";
                  });
                },
                child: Text("reset"))),
      ],
    );
  }

  Widget _buildText(String content, Color textColor) {
    return Container(
      margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
      child: Text(
        content,
        style: TextStyle(color: textColor),
      ),
    );
  }

  Widget _buildResultWidget(String localTime, String utcTime, String type) {
    TextStyle customStyle = TextStyle(fontWeight: FontWeight.bold);
    return Container(
      margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.done_outline_rounded,
                  color: Colors.green,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 5.0),
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        text: "Assuming that this  timestamp is in ",
                        children: [
                          TextSpan(
                              text: '$type:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black))
                        ]),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("GMT:", style: customStyle),
              Text("${localTime}"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Your time zone:", style: customStyle),
              Text("${utcTime}"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Relative:", style: customStyle),
              Text("A few seconds ago"),
            ],
          ),
          Divider()
        ],
      ),
    );
  }

  Widget _buildHumanReadibleToTimeStamp() {
    final columnCrossAxisAlign = CrossAxisAlignment.center;
    return Container(
        child: Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              crossAxisAlignment: columnCrossAxisAlign,
              children: [
                Text("Year"),
                Container(
                  margin: EdgeInsets.only(left: 5.0, right: 5.0),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: DropdownButton<int>(
                      items: _years.map((e) {
                        return DropdownMenuItem<int>(child: Text(e.toString()));
                      }).toList(),
                      onChanged: (_) {}),
                ),
              ],
            ),
            Text("-"),
            Column(
              crossAxisAlignment: columnCrossAxisAlign,
              children: [
                Text("Month"),
                Container(
                  margin: EdgeInsets.only(left: 5.0, right: 5.0),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: DropdownButton<int>(
                      items: _months.map((e) {
                        return DropdownMenuItem<int>(child: Text(e.toString()));
                      }).toList(),
                      onChanged: (_) {}),
                ),
              ],
            ),
            Text("-"),
            Column(
              crossAxisAlignment: columnCrossAxisAlign,
              children: [
                Text("Day"),
                Container(
                  margin: EdgeInsets.only(left: 5.0, right: 5.0),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: DropdownButton<int>(
                      items: _days.map((e) {
                        return DropdownMenuItem<int>(child: Text(e.toString()));
                      }).toList(),
                      onChanged: (_) {}),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: columnCrossAxisAlign,
              children: [
                Text("Hr"),
                Container(
                  margin: EdgeInsets.only(left: 5.0, right: 5.0),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: DropdownButton<String>(
                      items: _hours.map((e) {
                        return DropdownMenuItem<String>(
                            child: Text(e.toString()));
                      }).toList(),
                      onChanged: (_) {}),
                ),
              ],
            ),
            Text(":"),
            Column(
              crossAxisAlignment: columnCrossAxisAlign,
              children: [
                Text("Min"),
                Container(
                  margin: EdgeInsets.only(left: 5.0, right: 5.0),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: DropdownButton<String>(
                      items: _mins.map((e) {
                        return DropdownMenuItem<String>(
                            child: Text(e.toString()));
                      }).toList(),
                      onChanged: (_) {}),
                ),
              ],
            ),
            Text(":"),
            Flexible(
              child: Column(
                crossAxisAlignment: columnCrossAxisAlign,
                children: [
                  Text("Sec"),
                  Container(
                    margin: EdgeInsets.only(left: 5.0, right: 5.0),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: DropdownButton<String>(
                        items: _mins.map((e) {
                          return DropdownMenuItem<String>(
                              child: Text(e.toString()));
                        }).toList(),
                        onChanged: (_) {}),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: 35,
                margin: EdgeInsets.only(top: 10.0, right: 5.0, left: 5.0),
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    color: Color.fromRGBO(255, 249, 203, 1.0),
                    onPressed: () {},
                    child: Text("Human Date to TimeStamp"))),
            Container(
                height: 35,
                margin: EdgeInsets.only(top: 10.0),
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    color: Color.fromRGBO(255, 249, 203, 1.0),
                    onPressed: () {},
                    child: Text("reset"))),
          ],
        )
      ],
    ));
  }

  Widget _buildContainer() {
    return Container(
      child: Text("Hello Wolrd"),
    );
  }

  void _onConvertButtonPressed(TextEditingController controller) {
    Pattern pattern =
        '^(?!(?:^[-+]?[0.]+(?:[Ee]|\$)))(?!(?:^-))(?:(?:[+-]?)(?=[0123456789.])(?:(?:(?:[0123456789]+)(?:(?:[.])(?:[0123456789]*))?|(?:(?:[.])(?:[0123456789]+))))(?:(?:[Ee])(?:(?:[+-]?)(?:[0123456789]+))|))\$';
    RegExp regExp = new RegExp(pattern);
    if (controller.text.isEmpty || !regExp.hasMatch(controller.text)) {
      setState(() {
        _currentResultState = _resultStates[2];
      });
    } else {
      _convertToHumanReadibleForm(controller);
      setState(() {
        _currentResultState = _resultStates[1];
      });
    }
  }

  void _convertToHumanReadibleForm(TextEditingController controller) {
    int timeMillisecs = int.parse(controller.text);
    var localTime = DateTime.fromMillisecondsSinceEpoch(timeMillisecs);
    var utcTime = localTime.toUtc();
    var formatLocalDate = DateFormat("MM/dd/yyyy HH:mm:ss").format(localTime);
    var formatUTCTime = DateFormat("MM/dd/yyyy HH:mm:ss").format(utcTime);
    setState(() {
      _localTime = formatLocalDate;
      _utcTime = formatUTCTime;
    });
  }
}
