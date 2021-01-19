import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class TimeStamp extends StatefulWidget {
  @override
  _TimeStampState createState() => _TimeStampState();
}

class _TimeStampState extends State<TimeStamp> {
  TextEditingController _timestampController = TextEditingController();
  String _localTime, _utcTime;
  final _resultStates = [0, 1, -1];
  int _currentResultState = 0;
  String _day;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(20, 52, 112, 1)),
                ),
              ),
              SizedBox(height: 10.0),
              _buildTimeStampConverter(),
              Row(
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 5.0),
                      child: Icon(
                        Icons.info_outline,
                      )),
                  Flexible(child: _buildText("Supports Unix timestamps in seconds, milliseconds, microseconds and nanoseconds.", Colors.black)),
                ],
              ),
              Divider(
                color: Colors.green,
              ),
              if (_currentResultState == 1) _buildResultWidget(_localTime, _utcTime, "seconds"),
              if (_currentResultState == -1) _buildText("Sorry this timestamp is  not valid.Check your timestamp,  strip letters and  punctuation  marks!", Colors.red),
              Divider()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeStampConverter() {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Container(
            margin: EdgeInsets.only(left: 5.0),
            height: 35,
            child: TextField(
              keyboardType: TextInputType.number,
              controller: _timestampController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d+(?:\.\d+)?$')),
              ],
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
          ),
        ),
        Expanded(
            flex: 4,
            child: Container(
              height: 35,
              margin: EdgeInsets.only(
                left: 5.0,
              ),
              child: RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
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
        Expanded(
            flex: 1,
            child: Container(
              height: 35,
              margin: EdgeInsets.only(right: 5.0),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _currentResultState = _resultStates[0];
                    _timestampController.text = "";
                  });
                },
                icon: Icon(
                  Icons.refresh_sharp,
                  color: Colors.green,
                ),
              ),
            )),
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
                    text: TextSpan(style: TextStyle(color: Colors.black), text: "Assuming that this  timestamp is in ", children: [TextSpan(text: '$type:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))]),
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
        ],
      ),
    );
  }

  void _onConvertButtonPressed(TextEditingController controller) {
    Pattern pattern = '^(?!(?:^[-+]?[0.]+(?:[Ee]|\$)))(?!(?:^-))(?:(?:[+-]?)(?=[0123456789.])(?:(?:(?:[0123456789]+)(?:(?:[.])(?:[0123456789]*))?|(?:(?:[.])(?:[0123456789]+))))(?:(?:[Ee])(?:(?:[+-]?)(?:[0123456789]+))|))\$';
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
