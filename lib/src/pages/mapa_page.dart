
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qr_scanner_app/src/models/scan_model.dart';

class MapaPage extends StatefulWidget {

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final mapController = MapController();

  String tipoMapa = "satellite";

  @override
  Widget build(BuildContext context) {
    final ScanModel model = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location), 
            onPressed: (){
              mapController.move(model.getLatLng(), 18);
            }
          )
        ],
      ),
      body:_crearFlutterMap(model),
      floatingActionButton: _crearBotonFlotante(context),
    );
  }

  Widget _crearFlutterMap(ScanModel model) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        center: model.getLatLng(),
        zoom: 18
      ),
      layers: [
        _crearMapa(),
        _crearMarcadores(model)
      ],
    );
  }

  LayerOptions _crearMapa() {
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
        'accessToken' : 'pk.eyJ1IjoiYmFmbWF5IiwiYSI6ImNrYXlxOWFnajAwMHEzMXI4ZnU1OHVrenEifQ.1gtQ1qnyAV-aPiZyR_XExA',
        'id': 'mapbox.$tipoMapa'
      }
      // mapbox.mapbox-streets-v8
    );
  }

  LayerOptions _crearMarcadores(ScanModel model) {
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 120.0,
          height: 120.0,
          point: model.getLatLng(),
          builder: (context) => Container(
            child: Icon(Icons.location_on, size: 50.0, color: Theme.of(context).primaryColor,),
          )
        )
      ]
    );
  }

  Widget _crearBotonFlotante(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: (){
        if(tipoMapa == 'satellite') {
          tipoMapa = 'mapbox-streets-v8';
        }else if(tipoMapa == 'mapbox-streets-v8'){
          tipoMapa = 'satellite';
        }

        setState((){});
      }
    );
  }
}