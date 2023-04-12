import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum SocialMedia { email, whatsapp }

class History extends StatefulWidget {
  String v3;
  History({this.v3});
  @override
  _HistoryState createState() => _HistoryState(v3);
}

class _HistoryState extends State<History> {
  String v3;
  _HistoryState(this.v3);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade300,
      bottomNavigationBar: buildSocialButtons(),
      body: Container(
          padding: EdgeInsets.all(50),
          child: Column(
            children: [
              Text("my report today:)", style: TextStyle(fontSize: 30)),
              Text("Score is " + v3, style: TextStyle(fontSize: 20)),
            ],
          )),
    );
  }

  Widget buildSocialButtons() => Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildSocialButton(
                icon: Icons.mail,
                color: Colors.black87,
                onClicked: () => share(SocialMedia.email)),
            buildSocialButton(
                icon: FontAwesomeIcons.whatsapp,
                color: Color(0xFF00d856),
                onClicked: () => share(SocialMedia.whatsapp)),
          ],
        ),
      );

  Future share(SocialMedia socialPlatform) async {
    final subject = 'daily report';
    final text = 'my report today:) with score ' + v3.toString();

    final urls = {
      SocialMedia.email: 'mailto:?subject=$subject&body=$text',
      SocialMedia.whatsapp: 'https://api.whatsapp.com/send?text=$text',
    };
    final url = urls[socialPlatform];
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  Widget buildSocialButton({
    @required IconData icon,
    Color color,
    @required VoidCallback onClicked,
  }) =>
      InkWell(
        child: Container(
          width: 64,
          height: 64,
          child: Center(child: FaIcon(icon, color: color, size: 40)),
        ),
        onTap: onClicked,
      );
}
