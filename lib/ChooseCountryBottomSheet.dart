import 'package:covid19_flutter/CountryPanel.dart';
import 'package:flutter/material.dart';

class ChooseCountry extends StatefulWidget {
  late List<String> countriesName;

  ChooseCountry(List<String> countriesName, {Key? key}) : super(key: key);

  @override
  _ChooseCountryState createState() => _ChooseCountryState(countriesName);
}

class _ChooseCountryState extends State<ChooseCountry> {
  final List<String> name;

  _ChooseCountryState(this.name);

  @override
  Widget build(BuildContext context) {
    return TextButton(
    onPressed: null, child: Text(" "),




        // Column(
        //   children: <Widget>[
        //     Container(
        //       padding: EdgeInsets.all(10),
        //       child: TextField(
        //         keyboardType: TextInputType.text,
        //         decoration: InputDecoration(
        //           labelText: 'country',
        //           border: OutlineInputBorder(
        //             borderRadius: BorderRadius.all(Radius.circular(10)),
        //           ),
        //         ),
        //       ),
        //     ),
        //     new ListView.builder(
        //       itemBuilder: (context, index) {
        //         return GestureDetector(
        //           onTap: () {
        //             _selectItem(countriesInfo[index]);
        //           },
        //           child: Container(
        //             padding: EdgeInsets.only(left: 10, right: 10),
        //             height: 50,
        //             decoration: BoxDecoration(
        //               color: Colors.white,
        //               boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10, offset: Offset(0, 10))],
        //             ),
        //             child: Row(
        //               children: [
        //                 Image.network(
        //                   countriesInfo[index]._flag,
        //                   width: 50,
        //                   height: 50,
        //                 ),
        //                 Text(
        //                   countriesInfo[index]._name,
        //                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        //                 ),
        //               ],
        //             ), // name of the country
        //           ),
        //         );
        //       },
        //       itemCount: countriesInfo == null ? 0 : countriesInfo.length,
        //     ),
        //   ],
        // )),
      //
      //
      //
      // DropdownButton<String>(
      //   value: dropdownValue,
      //   icon: const Icon(Icons.arrow_drop_down),
      //   iconSize: 24,
      //   elevation: 16,
      //   style: const TextStyle(color: Colors.deepPurple, fontSize: 20),
      //   underline: Container(
      //     height: 2,
      //     color: Colors.deepPurpleAccent,
      //   ),
      //   onChanged: (String? newValue) {
      //     setState(() {
      //       dropdownValue = newValue!;
      //       fetchWorldWideData();
      //     });
      //   },
      //   items: <String>['cases', 'todayCases', 'deaths', 'recovered'].map<DropdownMenuItem<String>>((String value) {
      //     return DropdownMenuItem<String>(
      //       value: value,
      //       child: Text(value),
      //     );
      //   }).toList(),
      // ),





//         style: ButtonStyle(
//           backgroundColor: MaterialStateProperty.all(Colors.blue),
//         ),
//         child: Text(
//           selectedCountry==null?"shiit":selectedCountry!._name,
//           style: TextStyle(color: Colors.black, fontSize: 20),
//         ),
//         onPressed: () {
// // ChooseCountry(countriesName);
//           showModalBottomSheet(  // ---------------------//
//               context: context,
//               builder: (context) {
//                 return Container(
//                   color: Color(0xff737373), // to make the radius visible
//                   child: Container(
//                     decoration: BoxDecoration(
//                         color: Theme.of(context).canvasColor,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             topRight: Radius.circular(10))),
//                     child: countriesInfo == null
//                         ? Center(
//                       child: CircularProgressIndicator(),
//                     )
//                         : ListView.builder(
//                       itemBuilder: (context, index) {
//                         return GestureDetector(
//                           onTap: () {
//                             _selectItem(countriesInfo![index]);
//                           },
//                           child: Container(
//                             padding:
//                             EdgeInsets.only(left: 10, right: 10),
//                             height: 50,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               boxShadow: [
//                                 BoxShadow(
//                                     color: Colors.grey,
//                                     blurRadius: 10,
//                                     offset: Offset(0, 10))
//                               ],
//                             ),
//                             child: Row(
//                               children: [
//                                 Image.network(
//                                   countriesInfo![index]._flag,
//                                   width: 50,
//                                   height: 50,
//                                 ),
//                                 Text(
//                                   countriesInfo![index]._name,
//                                   style: TextStyle(
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ],
//                             ), // name of the country
//                           ),
//                         );
//                       },
//                       itemCount: countriesInfo == null
//                           ? 0
//                           : countriesInfo!.length,
//                     ),
//                   ),
//                 );
//               });
//         }
        );
  }
}

