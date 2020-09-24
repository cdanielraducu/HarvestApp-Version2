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
        print(serieData['titlu']);

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

          MediaItem mediaItem = MediaItem(
            id: 'https://firebasestorage.googleapis.com/v0/b/harvestapp-24d89.appspot.com/o/Songs%2FDansul%20conjugal%2FCe%20conteaza%20cu%20adevarat%20in%20familie.mp3?alt=media&token=900edb1a-518f-47ea-a1ec-39b6b9b838f0',
            album: serieData['titlu'],
            title: mesaj['Titlu'],
            duration: Duration(minutes: 59),
            artUri: serieData['imageUrl'],
          );

          mesaje.add(Mesaj(
            data: mesaj['Data'],
            ideeaCentrala: mesaj['IdeeaCentrala'],
            pasaj: mesaj['Pasaj'],
            titlu: mesaj['Titlu'],
            puncte: puncte,
            mediaItem: mediaItem,
            pdfUrl: mesaj['PdfUrl'],
          ));
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
