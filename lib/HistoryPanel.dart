import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as json;

Color backGround = const Color(0xFFCECECE);

class HistoryPanel extends StatefulWidget {
  const HistoryPanel({Key? key}) : super(key: key);

  @override
  _HistoryPanelState createState() => _HistoryPanelState();
}

class _HistoryPanelState extends State<HistoryPanel> {
  var url_getCountry = Uri.parse('https://disease.sh/v3/covid-19/historical?lastdays=1');

  List? countriesData; // save data from Api
  List<Country> countriesName = []; // after fetching => save the country info
  List<History> historyList = [];
  List<Country> countriesInfoDisplay = [];
  var visiblity_set = true;

  var f = NumberFormat("###,###", "en_US");

  fetchWorldWideData() async {
    var response = await http.get(url_getCountry);
    setState(() {
      var test = response.body;
      if (response.body.length > 0) {
        countriesData = json.jsonDecode(response.body);
        fetchCountriesName(countriesData!);
      }
    });
  }

  void fetchCountriesName(List countriesData) {
    int counter = 0;
    for (int i = 0; i < countriesData.length; i++) {
      Map<String, dynamic> map = countriesData[i];
      Country country = new Country();
      country.name = map['country'];

      if (counter == 0) {
        countriesName.add(country);
        counter++;
      } else if (counter != 0 && country._name.toString() != countriesName[counter - 1]._name) {
        countriesName.add(country);
        counter++;
      }
    }
    countriesInfoDisplay = countriesName;
  }

  Country? selectedCountry;
  var pasDays = "set day", countryName = "set country";
  int? _currentValue = 2;

  void getHistory() async {
    var url_getHistory = Uri.parse('https://disease.sh/v3/covid-19/historical/${selectedCountry!._name}?lastdays=30');
    var response = await http.get(url_getHistory);
    setState(() {
      var test = response.body;
      if (response.body.length > 0) {
        var data = json.jsonDecode(response.body);

        Map<String, dynamic> timeline = data!['timeline'];
        for (int i = 0; i < _currentValue!; i++) {
          History history = new History();
          history.date = _calculateDate(i + 1);
          history.cases = timeline['cases'][_calculateDate(i + 1)].toString();
          history.deaths = timeline['deaths'][_calculateDate(i + 1)].toString();
          history.recovered = timeline['recovered'][_calculateDate(i + 1)].toString();
          historyList.add(history);
        }
      }
    });
  }

  String _calculateDate(int dayPass) {
    var now = DateTime.now().toUtc();
    var a = now.add(Duration(days: -dayPass, hours: 0, minutes: 0));
    String year = a.year.toString();

    return ("${a.month}/${a.day}/${year[2] + year[3]}");
  }

  String getData(Map s, int index, String date) {
    return s[index][date];
  }

  @override
  void initState() {
    super.initState();
    fetchWorldWideData();
  }

  @override
  Widget build(BuildContext context) {
    return countriesName.length < 1
        ? CircularProgressIndicator()
        : Container(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      visiblity_set = !visiblity_set;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "set value ",
                          style: TextStyle(fontSize: 18),
                        ),
                        Icon(
                          visiblity_set ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                          size: 25,
                        )
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: visiblity_set,
                  child: Column(children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      margin: EdgeInsets.only(right: 20, left: 20),
                      child: TextButton(
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(4),
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0), side: BorderSide(color: Colors.blue, width: 2)))),
                        onPressed: () {
                          _bottomSheet_setDay();
                        },
                        child: Text(
                          "set days",
                          style: TextStyle(color: Colors.black, fontSize: 20, fontStyle: FontStyle.normal),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 10, bottom: 5),
                      margin: EdgeInsets.only(right: 20, left: 20 ),
                      child: TextButton(
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(4),
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0), side: BorderSide(color: Colors.blue, width: 2)))),
                        onPressed: () {
                          _bottomSheet_setCountry();
                        },
                        child: Text(
                          "set country",
                          style: TextStyle(color: Colors.black, fontSize: 20, fontStyle: FontStyle.normal),
                        ),
                      ),
                    ),
                  ]),
                ),
                Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 15),
                      decoration: BoxDecoration(
                        color:Color(0xffb6b6b6),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(30) , topRight: Radius.circular(30))
                      ),
                      child: Container(
                          child: historyList.length > 0
                              ? _HistoryList()
                              : Center(
                                  child: Text("choose the country"),
                                )),
                    )),
              ],
            ),
          );
  }

  _selectItem(Country selectedCountry) {
    Navigator.pop(context);
    setState(() {
      this.historyList.clear();
      this.selectedCountry = selectedCountry;
      this.countryName = selectedCountry._name.toString();
      getHistory();
    });
  }

  _selectDay() {
    Navigator.pop(context);
    setState(() {
      this.pasDays = "${_currentValue}";
    });
  }

  _bottomSheetValue() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 400,
          );
        });
  }

  _bottomSheet_setCountry() {
    return showModalBottomSheet(
        // ---------------------//
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xff737373), // to make the radius visible
            // to make the radius visible
            child: Container(
                height: 450,
                decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                child: countriesName == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Expanded(
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10),
                              child: TextField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: 'country',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                                onChanged: (text) {
                                  _search(text);
                                },
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 10),
                                child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        _selectItem(countriesInfoDisplay[index]);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(left: 10, right: 10),
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10, offset: Offset(0, 10))],
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(left: 10),
                                              child: Text(
                                                countriesInfoDisplay[index]._name,
                                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ), // name of the country
                                      ),
                                    );
                                  },
                                  itemCount: countriesInfoDisplay == null ? 0 : countriesInfoDisplay.length,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
          );
        });
  }

  _bottomSheet_setDay() {
    return showModalBottomSheet(
        // ---------------------//
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xff737373), // to make the radius visible
            // to make the radius visible
            child: Container(
                height: 450,
                decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                child: countriesName == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Expanded(
                        child: Column(
                          children: [
                            Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  // Set height to one line, otherwise the whole vertical space is occupied.
                                  maxHeight: 300,
                                ),
                                child: new ListWheelScrollView.useDelegate(
                                  itemExtent: 30,
                                  childDelegate: ListWheelChildLoopingListDelegate(
                                    children: List<Widget>.generate(
                                      29,
                                      (index) => Text(
                                        '${index + 1}',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 5, bottom: 5),
                              margin: EdgeInsets.only(right: 10),
                              child: TextButton(
                                style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(4),
                                    backgroundColor: MaterialStateProperty.all(Colors.white),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0), side: BorderSide(color: Colors.blue, width: 2)))),
                                onPressed: () {
                                  _selectDay();
                                },
                                child: Text(
                                  pasDays,
                                  style: TextStyle(color: Colors.black, fontSize: 20, fontStyle: FontStyle.normal),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
          );
        });
  }

  _search(var text) {
    text = text.toString().toLowerCase();
    setState(() {
      countriesInfoDisplay = countriesName.where((country) {
        var countryName = country._name.toString().toLowerCase();
        return countryName.contains(text);
      }).toList();
    });
  }

  /*
       formula :
           total of statistics today - total of statistics yesterday  == new case of today
        in this way I calculated the statistics of 29 days ago
         */

  Widget _HistoryList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(15),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Color(0xffd9d9d9)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                historyList[index]._date,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xff1F273D),
                ),
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
                          child: Text(f.format(int.parse(historyList[index]._cases) - int.parse(historyList[index + 1]._cases)),
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
                          child: Text(f.format(int.parse(historyList[index]._recovered) - int.parse(historyList[index + 1]._recovered)),
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
                            f.format(int.parse(historyList[index]._deaths) - int.parse(historyList[index + 1]._deaths)),
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
        );
      },
      itemCount: historyList == null ? 0 : historyList.length - 1,
    );
  }
}

class Country {
  var _name, _flag, _cases, _todayCases, _deaths, _todayDeaths, _recovered, _todayRecovered, _expended;

  Country() {
    _expended = false;
  }

  get name => _name;

  set name(value) {
    _name = value;
  }

  get flag => _flag;

  set flag(value) {
    _flag = value;
  }

  get cases => _cases;

  set cases(value) {
    _cases = value;
  }

  get todayCases => _todayCases;

  set todayCases(value) {
    _todayCases = value;
  }

  get deaths => _deaths;

  set deaths(value) {
    _deaths = value;
  }

  get todayDeaths => _todayDeaths;

  set todayDeaths(value) {
    _todayDeaths = value;
  }

  get recovered => _recovered;

  set recovered(value) {
    _recovered = value;
  }

  get todayRecovered => _todayRecovered;

  set todayRecovered(value) {
    _todayRecovered = value;
  }

  get expended => _expended;

  set expended(value) {
    _expended = value;
  }
}

class History {
  var _date, _name, _flag, _cases, _todayCases, _deaths, _todayDeaths, _recovered, _todayRecovered;

  get date => _date;

  set date(value) {
    _date = value;
  }

  get cases => _cases;

  set cases(value) {
    _cases = value;
  }

  get deaths => _deaths;

  set deaths(value) {
    _deaths = value;
  }

  get recovered => _recovered;

  set recovered(value) {
    _recovered = value;
  }

  get todayRecovered => _todayRecovered;

  set todayRecovered(value) {
    _todayRecovered = value;
  }

  get todayDeaths => _todayDeaths;

  set todayDeaths(value) {
    _todayDeaths = value;
  }

  get todayCases => _todayCases;

  set todayCases(value) {
    _todayCases = value;
  }

  get flag => _flag;

  set flag(value) {
    _flag = value;
  }

  get name => _name;

  set name(value) {
    _name = value;
  }
}
