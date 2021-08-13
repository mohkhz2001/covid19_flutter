import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Color backGround = const Color(0xFFCECECE);
Color pandelBackground = const Color(0xFF222B45);

class TotalStatistics extends StatelessWidget {
  var _Infected, _Recovered, _Death;

  TotalStatistics(this._Infected, this._Recovered, this._Death);

  var f = NumberFormat("###,###", "en_US");

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(color: Color(0xff1F273D), borderRadius: BorderRadius.all(Radius.circular(20))),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Total Statistics",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(11, 5, 11, 5),
            margin: EdgeInsets.fromLTRB(8, 13, 8, 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [
                    Color(0xffF1AE13),
                    Color(0xffE4C97D),
                  ],
                  tileMode: TileMode.repeated,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Infected",
                  style: TextStyle(fontSize: 22, fontStyle: FontStyle.italic, color: Colors.black),
                ),
                Text(
                  f.format(int.parse(_Infected)),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 7, 10, 7),
            margin: EdgeInsets.only(top: 10, right: 10, left: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [
                    Color(0xff13F147),
                    Color(0xff7DE48A),
                  ],
                  tileMode: TileMode.repeated,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recovered",
                  style: TextStyle(fontSize: 22, fontStyle: FontStyle.italic, color: Colors.black),
                ),
                Text(
                  f.format(int.parse(_Recovered)),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 7, 10, 7),
            margin: EdgeInsets.only(top: 10, right: 10, left: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [
                    Color(0xffF13713),
                    Color(0xffE4A37D),
                  ],
                  tileMode: TileMode.repeated,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Death",
                  style: TextStyle(fontSize: 22, fontStyle: FontStyle.italic, color: Colors.black),
                ),
                Text(
                  f.format(int.parse(_Death)),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
