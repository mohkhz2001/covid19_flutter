import 'package:flutter/material.dart';

class AboutPanel extends StatefulWidget {
  const AboutPanel({Key? key}) : super(key: key);

  @override
  _AboutPanelState createState() => _AboutPanelState();
}

class _AboutPanelState extends State<AboutPanel> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          children: [
            Center(
                child: Text(
              "Refrence",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )),
          ],
        ),
      ),
    );
  }
}
