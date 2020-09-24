import 'package:flutter/material.dart';
import 'package:mesajeSerie/providers/Mesaj.dart';

class SerieItem extends StatelessWidget {
  final int index;
  final String titlu;
  final String imageUrl;
  final String rezumat;
  final List<Mesaj> mesaje;

  SerieItem(
    this.index,
    this.titlu,
    this.imageUrl,
    this.rezumat,
    this.mesaje,
  );

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(titlu),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {},
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {},
              color: Theme.of(context).errorColor,
            )
          ],
        ),
      ),
    );
  }
}
