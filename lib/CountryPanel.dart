import 'dart:ffi';
import 'dart:io';
import 'package:covid19_flutter/ChooseCountryBottomSheet.dart';
import 'package:covid19_flutter/TotalStatistics.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as json;
import 'package:intl/intl.dart';

Color backGround = const Color(0xFFCECECE);
Color pandelBackground = const Color(0xFF222B45);

class CountryPanle extends StatefulWidget {
  const CountryPanle({Key? key}) : super(key: key);

  @override
  _CountryPanleState createState() => _CountryPanleState();
}

class _CountryPanleState extends State<CountryPanle> {
  var url_all = Uri.parse('https://disease.sh/v3/covid-19/countries');

  List? countriesData; // save data from Api
  List<Country> countriesInfo = []; // after fetching => save the country info
  List<Country> countriesInfoDisplay = []; // show the item want to display --> for search part

  var f = NumberFormat("###,###", "en_US");

  fetchWorldWideData() async {
    var response = await http.get(url_all);
    setState(() {
      var test = response.body;
      if (response.body.length > 0) {
        countriesData = json.jsonDecode(response.body);
        fetchCountries(countriesData!);
      }
    });
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
    countriesInfoDisplay = countriesInfo;
  }

  @override
  void initState() {
    super.initState();
    fetchWorldWideData();
  }

  var _selected = "push me";

  Country? selectedCountry;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: countriesInfo.length < 1
          ? CircularProgressIndicator()
          : Container(
              width: double.infinity,
              child: ListView(
                children: [
                  Column(
                    children: [
                      Image.network(
                        selectedCountry == null ? countriesInfo[0]._flag : selectedCountry!._flag.toString(),
                        height: 250,
                        scale: 1,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: backGround,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                countriesInfoDisplay = countriesInfo;
                                showModalBottomSheet(
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
                                            child: countriesInfo == null
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
                                                                      boxShadow: [
                                                                        BoxShadow(color: Colors.grey, blurRadius: 10, offset: Offset(0, 10))
                                                                      ],
                                                                    ),
                                                                    child: Row(
                                                                      children: [
                                                                        Image.network(
                                                                          countriesInfoDisplay[index]._flag,
                                                                          width: 50,
                                                                          height: 50,
                                                                        ),
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
                                    }); //  end bottom nav
                              },
                              child: Container(
                                width: double.infinity,
                                margin: EdgeInsets.all(35),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Color(0xFFA3A3A3),
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                    border: Border.all(
                                      color: Color(0xFF747474),
                                      width: 1.5,
                                    )),
                                child: Center(
                                  child: Text(
                                    "${selectedCountry == null ? countriesInfo[0].name : selectedCountry!.name.toString()}",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            ), //  bottom navigation
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
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                child: selectedCountry == null
                                                    ? (_text(countriesInfo[0]._todayCases))
                                                    : (_text(selectedCountry!._todayCases)))
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                              margin: EdgeInsets.only(bottom: 8),
                                              child: selectedCountry == null
                                                  ? (_text(countriesInfo[0]._todayRecovered))
                                                  : (_text(selectedCountry!._todayRecovered)),
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
                                              child: selectedCountry == null
                                                  ? (_text(countriesInfo[0]._todayDeaths))
                                                  : (_text(selectedCountry!._todayDeaths)),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text("* If the government has not yet released the statistics, it will be displayed as N/A",
                                      style: TextStyle(fontSize: 13, color: Color(0xffff0000))),
                                ],
                              ),
                            ),
                            TotalStatistics(
                              (selectedCountry == null ? countriesInfo[0]._cases : selectedCountry!._cases).toString(),
                              (selectedCountry == null ? countriesInfo[0]._recovered : selectedCountry!._recovered).toString(),
                              (selectedCountry == null ? countriesInfo[0]._deaths : selectedCountry!._deaths).toString(),
                            ),
                            _reference()
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
    );
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


  _selectItem(Country selectedCountry) {
    Navigator.pop(context);
    setState(() {
      this.selectedCountry = selectedCountry;
    });
  }

  _search(var text) {
    text = text.toString().toLowerCase();
    setState(() {
      countriesInfoDisplay = countriesInfo.where((country) {
        var countryName = country._name.toString().toLowerCase();
        return countryName.contains(text);
      }).toList();
    });
  }

  // show the text => if value equal 0 show N/A
  _text(var value) {
    print("N/A");
    return value == 0
        ? (Text("N/A", style: TextStyle(color: Color(0xFFEEEEEE), fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center))
        : (Text(value.toString().length > 3 ? (f.format(value)).toString() : value.toString(),
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center));
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
