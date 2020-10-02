import 'package:flutter/material.dart';
import 'package:mesajeSerie/providers/Serie.dart';
import 'package:mesajeSerie/providers/Serii.dart';
import 'package:mesajeSerie/screens/MesajeScreen.dart';
import 'package:parallax_image/parallax_image.dart';

import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class SeriiOverviewScreen extends StatefulWidget {
  @override
  _SeriiOverviewScreenState createState() => _SeriiOverviewScreenState();
}

class _SeriiOverviewScreenState extends State<SeriiOverviewScreen> {
  var _isInit = true;
  var _isLoading = false;
  var _loading = false;
  Serii _seriiDataFromFirebase;

  _updateSeriiData() {
    getSeriiDataFromFirebase(context).then((val) => setState(() {
          _seriiDataFromFirebase = val;
          setState(() {
            _loading = false;
          });
        }));
  }

  Future<Serii> getSeriiDataFromFirebase(BuildContext context) async {
    return Provider.of<Serii>(context);
  }

  Future<void> _refreshSerii(BuildContext context) async {
    setState(() {
      _loading = true;
    });
    await Provider.of<Serii>(context).fetchAndSetSerii();

    //print(_seriiDataFromFirebase.serii[0].mesaje[0]);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Serii>(context).fetchAndSetSerii().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HarvestApp'),
        actions: [
          //for favorites
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _refreshSerii(context);
            },
          )
        ],
      ),
      body: Container(
        child: RefreshIndicator(
          onRefresh: () => _refreshSerii(context),
          child: _listaSerii(context),
        ),
      ),
    );
  }

  Widget _listaSerii(BuildContext context) {
    _updateSeriiData();

    return _loading
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: EdgeInsets.all(8),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return _buildVerticalChild(
                    context,
                    index,
                    _seriiDataFromFirebase,
                    _seriiDataFromFirebase.serii.length);
              },
            ),
          );
  }

  Widget _buildVerticalChild(
      BuildContext context, int i, Serii seriiData, int length) {
    if (i > length - 1) return null;
    Serie serie = Serie(
      index: seriiData.serii[i].index,
      titlu: seriiData.serii[i].titlu,
      data: seriiData.serii[i].data,
      pasaj: seriiData.serii[i].pasaj,
      rezumat: seriiData.serii[i].rezumat,
      imageUrl: seriiData.serii[i].imageUrl,
      mesaje: seriiData.serii[i].mesaje,
    );
    i++;
    NetworkImage networkImage = NetworkImage(serie.imageUrl);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 1.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push<void>(
              SwipeablePageRoute(builder: (_) => MesajeScreen(serie)));
          // .pushNamed(MesajeScreen.routeName, arguments: serie);
        },
        child: Card(
          elevation: 10.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Stack(
              children: [
                Stack(
                  children: [
                    Container(
                      color: Colors.black,
                      // width: 50,
                      // height: 50,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.black,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(6.0),
                      height: MediaQuery.of(context).size.height * 0.27,
                      width: double.infinity,
                      child: Text(
                        serie.titlu,
                        style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Container(
                  color: Colors.transparent,
                  width: double.infinity,
                  foregroundDecoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x00000000),
                        Color(0x00000000),
                        // Color(0x3E3E3E3E),
                        // Color(0xff000000),
                      ],
                    ),
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.27,
                    child: Image.network(
                      serie.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  //     ParallaxImage(
                  //   extent: 120.0,
                  //   image: networkImage,
                  // ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
