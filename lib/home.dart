import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:barcode_scan/barcode_scan.dart';
import 'dart:async';
import 'package:flutter/services.dart';

//import 'package:audioplayers/audio_cache.dart';

class ListPage extends StatefulWidget {
  ListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ListPageState createState() => _ListPageState();
}

class ProductLine {
  String key = "";
  String name = "";
  num amount = 0;
  num price = 0.0;

  ProductLine(this.key, this.name, this.amount, this.price);
}

class _ListPageState extends State<ListPage> {
  String barcode = "";

  List<ProductLine> lines = [];

  var total = "0.0";

  Widget _buildLineItem(BuildContext context, int index) {
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.black),
        child: ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 1.0, color: Colors.white24))),
            child: Text(lines[index].amount.toString(),
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          title: Text(
            lines[index].name,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          trailing: Icon(Icons.remove, color: Colors.white, size: 30.0),
          onTap: () {
            var localLines = this.lines;
            localLines.removeAt(index);
            setState(() {
              this.lines = localLines;
            });
          },
        ),
      ),
    );
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.black,
        title: Text("Barcoding", style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          IconButton(
            icon: Icon(CupertinoIcons.photo_camera_solid),
            color: Colors.white,
            onPressed: scan,
          )
        ],
      ),
      body: Container(
          child: lines.isEmpty
              ? Center(
                  child: Text('Empty cart. Use the camera icon to add items.',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)))
              : ListView.builder(
                  itemBuilder: _buildLineItem,
                  itemCount: lines.length,
                )),
      bottomNavigationBar: Container(
        height: 55.0,
        child: BottomAppBar(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new CupertinoButton(
                  color: lines.isNotEmpty ? Colors.black : Colors.black38,
                  borderRadius: BorderRadius.zero,
                  onPressed: () {
                    if (lines.isNotEmpty) {
                      checkOutDialog(context);
                    }
                  },
                  child: new Text("Checkout($total)"))
            ],
          ),
        ),
      ),
    );
  }

  /*
ListView.builder(
                  itemBuilder: _buildLineItem,
                  itemCount: lines.length,
                )

                AnimatedList(
                  initialItemCount: lines.length,
                  itemBuilder: (context, index, animation) {
                    return SlideTransition(
                        position: animation.drive(Tween<Offset>(
                          begin: const Offset(100.0, 50.0),
                          end: const Offset(200.0, 300.0),
                        )),
                        child: _buildLineItem(index));
                  })
  */

  Future<void> checkOutDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('All Done'),
          content: Text('$total paid!'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                setState(() {
                  //asd
                  this.lines = [];
                  this.barcode = "";
                  this.total = "0.0";
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();

      var exists = false;
      lines.forEach((line) {
        if (line.key == barcode) {
          line.amount = line.amount + 1;
          exists = true;
        }
      });

      if (!exists) {
        var p = await _asyncInputDialog(context, barcode);
        if (p != null) {
          lines.insert(0, p);
        }
      } else {
        //AudioCache player = new AudioCache();
        //player.play('barcode_beep.mp3');
      }

      setState(() {
        //asd
        this.lines = lines;
        this.barcode = barcode;
        this.total =
            lines.fold(0.0, (t, e) => t + e.price * e.amount).toString();
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  Future<ProductLine> _asyncInputDialog(
      BuildContext context, String barcode) async {
    var p = ProductLine(barcode, "", 1, 0.0);
    return showDialog<ProductLine>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter new product'),
          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: (MediaQuery.of(context).size.height) / 2,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new Container(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: new CupertinoTextField(
                        autofocus: true,
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 2.0, color: Colors.black)),
                        placeholder: "Product name",
                        onChanged: (value) {
                          p.name = value;
                        },
                      )),
                  new CupertinoTextField(
                    autofocus: true,
                    decoration: BoxDecoration(
                        border: Border.all(width: 2.0, color: Colors.black)),
                    keyboardType: TextInputType.number,
                    placeholder: "Price",
                    onChanged: (value) {
                      p.price = int.parse(value);
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              textColor: Colors.black26,
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            FlatButton(
              child: Text('Save'),
              color: Colors.black,
              textColor: Colors.white,
              onPressed: () {
                if (p.name.isNotEmpty) {
                  Navigator.of(context).pop(p);
                }
              },
            ),
          ],
        );
      },
    );
  }
}

final makeBottom = Container(
  height: 55.0,
  child: BottomAppBar(
    color: Colors.white,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.receipt, color: Colors.black),
          onPressed: () {},
        )
      ],
    ),
  ),
);

class HomeScreen extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Barcoding',
      theme: new ThemeData(primaryColor: Colors.white),
      home: new ListPage(title: 'Barcoding'),
      debugShowCheckedModeBanner: false,
    );
  }
}
