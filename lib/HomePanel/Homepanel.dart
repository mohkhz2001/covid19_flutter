import 'package:covid19_flutter/TotalStatistics.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as json;
import 'package:intl/intl.dart';

Color backGround = const Color(0xFFCECECE);
Color pandelBackground = const Color(0xFF222B45);

class test extends StatefulWidget {
  const test({Key? key}) : super(key: key);

  @override
  _testState createState() => _testState();
}

class _testState extends State<test> {
  var worldData;
  var url_all = Uri.parse('https://disease.sh/v3/covid-19/all');

  fetchWorldWideData() async {
    var response = await http.get(url_all);
    setState(() {
      var test = response.body;
      worldData = json.jsonDecode(response.body);
    });
  }

  @override
  void initState() {
    fetchWorldWideData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: worldData == null ? CircularProgressIndicator() : HomePanel(worldData: worldData),
    );
  }
}

class HomePanel extends StatelessWidget {
  final Map worldData;

  HomePanel({Key? key, required this.worldData}) : super(key: key);

  var f = NumberFormat("###,###", "en_US");

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return ListView(children: [
      Container(
          child: Column(
        children: [
          Center(
              child: Image(
            image: AssetImage('lib/Images/worldMap.png'),
            width: 200,
          )),
          Container(
            decoration:
                BoxDecoration(color: backGround, borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(20),
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(color: pandelBackground, borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "New Statistic",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(11, 5, 11, 5),
                        margin: EdgeInsets.fromLTRB(8, 13, 8, 5),
                        decoration: BoxDecoration(color: Color(0xff1F273D), borderRadius: BorderRadius.all(Radius.circular(20))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 8, bottom: 10),
                                  child: Text(
                                    "Infected",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 21, color: Color(0xffFFBC00), fontStyle: FontStyle.italic),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 8),
                                  child: Text(f.format(int.parse(worldData['todayCases'].toString())),
                                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 8, bottom: 10),
                                  child: Text(
                                    "Recovered",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 21, color: Color(0xff00FF66), fontStyle: FontStyle.italic),
                                  ),
                                ),
                                Container(
                                  child: Text(f.format(int.parse(worldData['todayRecovered'].toString())),
                                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 8, bottom: 10),
                                  child: Text(
                                    "Death",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 21, color: Color(0xffFF5E00), fontStyle: FontStyle.italic),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    f.format(int.parse(worldData['todayDeaths'].toString())),
                                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                TotalStatistics(worldData['cases'].toString(), worldData['recovered'].toString(), worldData['deaths'].toString()),
                _reference()
              ],
            ),
          )
        ],
      )),
    ]);
  }

  _reference() {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Reference:  ", style: TextStyle(color: Color(0xff1c1c1c), fontSize: 15)),
          GestureDetector(
            onTap: () {},
            child: Text(
              "www.worldometers.info",
              style: TextStyle(color: Colors.blue, fontSize: 15),
            ),
          )
        ],
      ),
    );
  }
}
