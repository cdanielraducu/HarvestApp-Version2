import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mesajeSerie/providers/Mesaj.dart';
import 'package:mesajeSerie/providers/Punct.dart';
import 'dart:convert';

import 'package:mesajeSerie/providers/Serie.dart';

class Serii with ChangeNotifier {
  List<Serie> _serii = [
    // Serie(
    //     data: "06-06-2020",
    //     imageUrl:
    //         "https://harvestbucuresti.ro/wp-content/uploads/2016/12/wall-in-constructie.png",
    //     pasaj: "PASAJAA",
    //     rezumat:
    //         "pasaj pasaj pasaj pasaj pasaj pasaj pasaj pasaj pasaj pasaj pasaj pasaj",
    //     titlu: "In constructie"),
  ];

  List<Serie> get serii {
    return [..._serii];
  }

  Serie findByTitle(String titlu) {
    return _serii.firstWhere((element) => element.titlu == titlu);
  }

  Future<void> fetchAndSetSerii() async {
    const url = 'https://harvestmesaje2.firebaseio.com/Serii.json';
    try {
      final response = await http.get(url);
      List<dynamic> extractedData = json.decode(response.body) as List<dynamic>;
      List<dynamic> extractedDataReversed = extractedData.reversed.toList();

      final List<Serie> loadedProducts = [];

      if (extractedDataReversed == null) {
        return;
      }

      extractedDataReversed.forEach((serieData) {
        // print(serieData['titlu']);

        List<Mesaj> mesaje = [];

        serieData['mesaje'].forEach((mesaj) {
          List<Punct> puncte = [];

          if (mesaj['Puncte'] != null) {
            mesaj['Puncte'].forEach((punct) {
              puncte.add(Punct(
                numar: punct['Numar'],
                titluPunct: punct['Titlu'],
              ));
            });
          }

          // print('ZZZZZZZZZZZZZZZZZZZZZZZZZZ');
          // print(mesaj['DurataMin']);

          MediaItem mediaItem = MediaItem(
            id: mesaj['Audiolink'],
            album: serieData['titlu'],
            title: mesaj['Titlu'],
            artist: mesaj['Fratele'],
            duration: Duration(
              minutes: 20,
              // int.parse(mesaj['DurataMin']),
              seconds: 20,
              // int.parse(mesaj['DurataSec']),
            ),
            artUri: serieData['imageUrl'],
          );

          Mesaj mesajReceived = Mesaj(
            data: mesaj['Data'],
            ideeaCentrala: mesaj['IdeeaCentrala'],
            pasaj: mesaj['Pasaj'],
            titlu: mesaj['Titlu'],
            puncte: puncte,
            mediaItem: mediaItem,
            pdfUrl: mesaj['PdfUrl'],
            durataMin: mesaj['DurataMin'],
            durataSec: mesaj['DurataSec'],
          );

          mesaje.add(mesajReceived);
        });

        loadedProducts.add(Serie(
          index: serieData['index'],
          titlu: serieData['titlu'],
          data: serieData['data'],
          pasaj: serieData['pasaj'],
          rezumat: serieData['rezumat'],
          imageUrl: serieData['imageUrl'],
          mesaje: mesaje,
        ));

        _serii = loadedProducts;
      });
    } catch (error) {
      print(error);
      throw (error);
    }
  }
}
