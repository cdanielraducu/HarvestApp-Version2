import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfWidgetScreen extends StatefulWidget {
  @override
  _PdfWidgetScreenState createState() => _PdfWidgetScreenState();
}

class _PdfWidgetScreenState extends State<PdfWidgetScreen> {
  Future<void> _launched;

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      return const Text('');
    }
  }

  @override
  Widget build(BuildContext context) {
    const String toLaunch =
        'https://harvestbucuresti.ro/wp-content/uploads/2020/06/Serie-%C3%8En-Ora%C5%9F-%C3%8Endemna%C5%A3i-S%C4%83-Practic%C4%83m-Ce-Am-Devenit-%C3%8Entreb%C4%83ri-GM.pdf';
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(padding: EdgeInsets.all(16.0)),
              RaisedButton(
                onPressed: () => setState(() {
                  _launched = _launchInBrowser(toLaunch);
                }),
                child: const Text('Launch in app'),
              ),
              const Padding(padding: EdgeInsets.all(16.0)),
              FutureBuilder<void>(future: _launched, builder: _launchStatus),
            ],
          ),
        ],
      ),
    );
  }
}
