import 'package:flutter/material.dart';
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
  }

  Country? selectedCountry;
  var pasDays = "set day", countryName = "set country";
  int _currentValue = 3;

  void getHistory() async {
    var url_getHistory = Uri.parse('https://disease.sh/v3/covid-19/historical/${selectedCountry!._name}?lastdays=30');
    var response = await http.get(url_getHistory);
    setState(() {
      var test = response.body;
      if (response.body.length > 0) {
        var data = json.jsonDecode(response.body);

        Map<String, dynamic> timeline = data!['timeline'];
        for (int i = 0; i < 30; i++) {
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
        : Center(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          margin: EdgeInsets.only(right: 10),
                          child: TextButton(
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all(4),
                                backgroundColor: MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0), side: BorderSide(color: Colors.blue, width: 2)))),
                            onPressed: () {
                              _bottomSheet_setDay();
                            },
                            child: Text(
                              pasDays,
                              style: TextStyle(color: Colors.black, fontSize: 20, fontStyle: FontStyle.normal),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          margin: EdgeInsets.only(left: 10),
                          child: TextButton(
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all(4),
                                backgroundColor: MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0), side: BorderSide(color: Colors.blue, width: 2)))),
                            onPressed: () {
                              _bottomSheet_setCountry();
                            },
                            child: Text(
                              countryName,
                              style: TextStyle(color: Colors.black, fontSize: 20, fontStyle: FontStyle.normal),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Expanded(
                //   child: Container(
                //       decoration:
                //           BoxDecoration(color: backGround, borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
                //       child:
                //       ExpansionPanelList(
                //         expansionCallback: (int index, bool isExpanded) {
                //           setState(() {
                //             coun[index].isExpanded = !isExpanded;
                //           });
                //         },
                //         children: _data.map<ExpansionPanel>((Item item) {
                //           return ExpansionPanel(
                //             headerBuilder: (BuildContext context, bool isExpanded) {
                //               return ListTile(
                //                 title: Text(item.headerValue),
                //               );
                //             },
                //             body: ListTile(
                //                 title: Text(item.expandedValue),
                //                 subtitle: const Text('To delete this panel, tap the trash can icon'),
                //                 trailing: const Icon(Icons.delete),
                //                 onTap: () {}),
                //             isExpanded: item.isExpanded,
                //           );
                //         }).toList(),
                //       )
                //   ),
                // )
              ],
            ),
          );
  }

  _selectItem(Country selectedCountry) {
    Navigator.pop(context);
    setState(() {
      this.selectedCountry = selectedCountry;
      getHistory();
    });
  }

  _selectDay() {
    Navigator.pop(context);
    setState(() {
      this.pasDays = "${_currentValue}";
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
                                  // _search(text);
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
                                        _selectItem(countriesName[index]);
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
                                                countriesName[index]._name,
                                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ), // name of the country
                                      ),
                                    );
                                  },
                                  itemCount: countriesName == null ? 0 : countriesName.length,
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
                            Expanded(
                              child: NumberPicker(
                                selectedTextStyle: TextStyle(color: Colors.blue ,fontSize: 20 , fontWeight: FontWeight.bold ),
                                value: _currentValue,
                                minValue: 1,
                                maxValue: 29,

                                onChanged: (value) => setState(() => _currentValue = value),
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
  var _date, _cases, _deaths, _recovered;

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
}
