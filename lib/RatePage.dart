import 'dart:convert' as json;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class RatePage extends StatefulWidget {
  const RatePage({Key? key}) : super(key: key);

  @override
  _RatePageState createState() => _RatePageState();
}

class _RatePageState extends State<RatePage> {
  String dropdownValue = 'todayCases';

  var url_all;

  var f = NumberFormat("###,###", "en_US");

  void set_url() {
    url_all = Uri.parse('https://disease.sh/v3/covid-19/countries?sort=${dropdownValue}');
  }

  List? countriesData; // save data from Api
  List<Country> countriesInfo = []; // after fetching => save the country info

  fetchWorldWideData() async {
    try {
      countriesData = [];
      countriesInfo = [];
      set_url();
      var response = await http.get(url_all);
      setState(() {
        var test = response.body;
        if (response.body.length > 0) {
          countriesData = json.jsonDecode(response.body);
          fetchCountries(countriesData!);
        } else
          _showMyDialog("error connection", 're-connect', 'error connection');
      });
    } on Exception catch (e) {
      print(e.toString());
      _showMyDialog("error connection", 're-connect', 'error connection');
    }
  }

  void fetchCountries(List countriesData) {
    for (int i = 0; i < countriesData.length; i++) {
      Map<String, dynamic> map = countriesData[i];
      Country country = new Country();
      country.name = map['country'];
      country.flag = map['countryInfo']['flag'].toString();
      country.cases = map['cases'];
      country.todayCases = map['todayCases'];
      country.deaths = map['deaths'];
      country.todayDeaths = map['todayDeaths'];
      country.recovered = map['recovered'];
      country.todayRecovered = map['todayRecovered'];

      countriesInfo.add(country);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWorldWideData();
  }

  Future<void> _showMyDialog(var message, var btn, var title) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(btn),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: countriesInfo.length < 1
          ? CircularProgressIndicator()
          : Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple, fontSize: 20),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                        fetchWorldWideData();
                      });
                    },
                    items: <String>['cases', 'todayCases', 'deaths', 'recovered'].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 20),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10, offset: Offset(0, 10))],
                          ),
                          child: Row(
                            children: [
                              Text(
                                "${index + 1}",
                                style: TextStyle(fontSize: 13),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                child: Image.network(
                                  countriesInfo[index]._flag,
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                              Flexible(
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        strutStyle: StrutStyle(fontSize: 12.0),
                                        text: TextSpan(
                                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                            text: countriesInfo[index]._name),
                                      ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(left: 20),
                                        child: RichText(
                                            overflow: TextOverflow.ellipsis,
                                            strutStyle: StrutStyle(fontSize: 12.0),
                                            text: TextSpan(
                                              style: TextStyle(fontSize: 13, color: Colors.black),
                                              text: "${dropdownValue} : ${f.format(txt(index))}",
                                            )))
                                  ],
                                ),
                              ),
                            ],
                          ), // name of the country
                        );
                      },
                      itemCount: countriesInfo == null ? 0 : countriesInfo.length,
                    ),
                  ),
                ),
              ],
            ),
      // Column(
      //         children: [
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               Container(margin: EdgeInsets.all(20), child: Text("sort by: ", style: TextStyle(fontSize: 20, color: Colors.black))),
      //               DropdownButton<String>(
      //                 value: dropdownValue,
      //                 icon: const Icon(Icons.arrow_drop_down),
      //                 iconSize: 24,
      //                 elevation: 16,
      //                 style: const TextStyle(color: Colors.deepPurple, fontSize: 20),
      //                 underline: Container(
      //                   height: 2,
      //                   color: Colors.deepPurpleAccent,
      //                 ),
      //                 onChanged: (String? newValue) {
      //                   setState(() {
      //                     dropdownValue = newValue!;
      //                     fetchWorldWideData();
      //                   });
      //                 },
      //                 items: <String>['cases', 'todayCases', 'deaths', 'recovered'].map<DropdownMenuItem<String>>((String value) {
      //                   return DropdownMenuItem<String>(
      //                     value: value,
      //                     child: Text(value),
      //                   );
      //                 }).toList(),
      //               ),
      //
      //             ],
      //           ),
      //
      //         ],
      //       ),
    );
  }

  // 'cases', 'todayCases', 'deaths', 'recovered', 'active'
  int txt(int index) {
    int t = 0;
    switch (dropdownValue) {
      case 'cases':
        t = countriesInfo[index]._cases;
        break;
      case 'todayCases':
        t = countriesInfo[index]._todayCases;
        break;
      case 'deaths':
        t = countriesInfo[index]._deaths;
        break;
      case 'recovered':
        t = countriesInfo[index]._recovered;
        break;
    }

    return t;
  }
}

class Country {
  var _name, _flag, _cases, _todayCases, _deaths, _todayDeaths, _recovered, _todayRecovered;

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
}
