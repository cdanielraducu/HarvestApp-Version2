import 'dart:ui';

import 'package:expansion_card/expansion_card.dart';
import 'package:flutter/material.dart';
import 'package:mesajeSerie/providers/Mesaj.dart';
import 'package:mesajeSerie/providers/Serie.dart';
import 'package:mesajeSerie/screens/mpScreen.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class MesajeScreen extends StatelessWidget {
  static const routeName = '/mesaje';
  final Serie serie;

  MesajeScreen(this.serie);

  @override
  Widget build(BuildContext context) {
    // final serie = ModalRoute.of(context).settings.arguments as Serie;

    final theme = Theme.of(context).copyWith(
      dividerColor: Colors.transparent,
      unselectedWidgetColor: Colors.orange,
      accentColor: Colors.orange,
    );

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                foregroundDecoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff000000),
                      Color(0x1E1E1E1E),
                      Color(0x00000000),
                      Color(0x00000000),
                      Color(0x00000000),
                      Color(0x00000000),
                    ],
                  ),
                ),
                height: MediaQuery.of(context).size.height * 0.28,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage(serie.imageUrl)),
                ),
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      padding: EdgeInsets.only(top: 80),
                      color: Colors.grey.withOpacity(0.1),
                      child: Text(
                        '${serie.titlu}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Poppins',
                            backgroundColor: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              Theme(
                data: theme,
                child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.2),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.symmetric(horizontal: 20),
                    childrenPadding:
                        EdgeInsets.only(left: 25, right: 25, bottom: 15),
                    title: Text(''),
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '   Rezumat: ',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: serie.rezumat,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 25,
                ),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: _listaMesaje(context, serie),
          ),
        ],
      ),
    );
  }

  Widget _listaMesaje(BuildContext context, Serie serie) {
    return Container(
      child: ListView.builder(
          padding: EdgeInsets.only(top: 0),
          itemBuilder: (ctx, index) {
            if (index == serie.mesaje.length) {
              return null;
            }
            Mesaj currentMesaj =
                serie.mesaje[serie.mesaje.length - (index + 1)];

            String ideiContent = '';
            int j = 1;
            currentMesaj.puncte.forEach((punct) {
              String i = j.toString() + '. ';
              ideiContent += i + punct.titluPunct;
              j++;
              ideiContent += '\n   ';
            });
            //print(ideiContent);
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _expansionCard(context, currentMesaj,
                    serie.mesaje.length - index, ideiContent),
                Divider(),
              ],
            );
          }),
    );
  }

  Widget _expansionCard(
      BuildContext context, Mesaj mesaj, int index, String ideiContent) {
    String header = mesaj.titlu;
    // print(header);
    String sub = "";
    if (mesaj.data != null) {
      sub = mesaj?.data;
    }
    //  print(sub);
    String content = mesaj.ideeaCentrala;

    String content2 = mesaj.pasaj;

    return ExpansionCard(
      margin: EdgeInsets.only(top: 5),
      trailing: IconButton(
        iconSize: 25,
        onPressed: () {
          Navigator.of(context)
              .push<void>(SwipeablePageRoute(builder: (_) => MpScreen(mesaj)));
          // .pushNamed(MpScreen.routeName, arguments: mesaj);
        },
        icon: Icon(
          Icons.arrow_forward,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.black12,
      borderRadius: 30,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IconButton(
          //   icon: Icon(Icons.picture_as_pdf),
          //   onPressed: () {
          //     Navigator.of(context).pushNamed(PdfScreen.routeName);
          //   },
          // ),
          Text(
            '$index. $header',
            style: TextStyle(
                fontSize: 20, color: Colors.black, fontFamily: 'Poppins'),
          ),
          Text(
            sub,
            style: TextStyle(fontSize: 12, color: Colors.black54),
          )
        ],
      ),
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '  $content',
            style: TextStyle(
                fontSize: 15, color: Colors.black, fontFamily: 'Poppins'),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 42),
          child: Text(
            '   $ideiContent',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomRight,
          margin: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            content2,
            style: TextStyle(fontSize: 12, color: Colors.black),
          ),
        )
      ],
    );
  }
}
