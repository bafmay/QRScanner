import 'package:flutter/material.dart';
import 'package:qr_scanner_app/src/bloc/scans_bloc.dart';
import 'package:qr_scanner_app/src/models/scan_model.dart';
import 'package:qr_scanner_app/src/utils/utils.dart' as utils;

class MapasPage extends StatelessWidget {

  final scansBloc = ScansBloc();
  
  @override
  Widget build(BuildContext context) {

    scansBloc.obtenerScans();

    return StreamBuilder<List<ScanModel>>(
      stream: scansBloc.scansStream,
      builder: (BuildContext context,AsyncSnapshot<List<ScanModel>> snapshot){
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator());
        }

        final scans = snapshot.data;
        if(scans.length == 0 ) return Center(child: Text('No hay información'));

        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (context,i) => Dismissible(
            key: UniqueKey(),
            background: Container(color: Colors.red),
            onDismissed: (direction) => scansBloc.borrarScan(scans[i].id),
            child: ListTile(
              onTap: () => utils.abrirScan(context,scans[i]),
              leading: Icon(Icons.map,color: Theme.of(context).primaryColor),
              title: Text(scans[i].valor),
              subtitle: Text('Id: ${scans[i].id}'),
              trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey),
            )
          )
        );
      });
  }
}