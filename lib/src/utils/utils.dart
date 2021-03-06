
import 'package:qr_scanner_app/src/models/scan_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

abrirScan(BuildContext context, ScanModel model) async {

  if(model.tipo == 'http'){
    if (await canLaunch(model.valor)) {
    await launch(model.valor);
    } else {
      throw 'Could not launch ${model.valor}';
    }
  }else{
    Navigator.pushNamed(context, 'mapa',arguments: model);
  }


  
}