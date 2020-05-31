import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_scanner_app/src/bloc/scans_bloc.dart';
import 'package:qr_scanner_app/src/models/scan_model.dart';
import 'package:qr_scanner_app/src/pages/direcciones_page.dart';
import 'package:qr_scanner_app/src/pages/mapas_page.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:qr_scanner_app/src/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scansBloc = ScansBloc();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever), 
            onPressed: scansBloc.borrarScanTodos
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: _scanQR
      ),
    );
  }

  Widget _crearBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text('Direcciones')
        )
      ],
      onTap: (index){
        setState(() {
          currentIndex = index;
        });
      },
    );
  }

  Widget _callPage(int paginaActual) {
    switch(paginaActual){
      case 0: return MapasPage();
      case 1: return DireccionesPage();
      default: return MapasPage();
    }
  }

  _scanQR() async{

// geo:-12.160256229785535,-76.96701422175296
// https://www.figma.com/

    String futureString = 'https://www.figma.com/';

    // try{
    //   futureString = await scanner.scan();
    // }catch(e){
    //   futureString = e.toString();
    // }

    

    if(futureString != null){
      final model = ScanModel(valor: futureString);
      scansBloc.agregarScan(model);

      final model2 = ScanModel(valor: 'geo:-12.160256229785535,-76.96701422175296');
      scansBloc.agregarScan(model2);

      if(Platform.isIOS){
        Future.delayed(Duration(milliseconds: 750),(){
          utils.abrirScan(model);
        });
      }else{
        utils.abrirScan(model);
      }
      
    }
 
  }
}