import 'dart:async';
import 'package:qr_scanner_app/src/bloc/validator.dart';
import 'package:qr_scanner_app/src/providers/db_provider.dart';

class ScansBloc with Validators{

  static final ScansBloc _singleton = ScansBloc._internal();

  factory ScansBloc(){
    return _singleton;
  }

  ScansBloc._internal(){
    obtenerScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream     => _scansController.stream.transform(validarGeo);
  Stream<List<ScanModel>> get scansStreamHttp => _scansController.stream.transform(validarHttp);


  dispose(){
    _scansController?.close();
  }

  agregarScan(ScanModel model) async{
    await DBProvider.db.nuevoScan(model);
    obtenerScans();
  }

  obtenerScans() async{
    _scansController.sink.add(await DBProvider.db.getTodosScans());
  }

  borrarScan(int id) async{
    await DBProvider.db.deleteScan(id);
    obtenerScans();
  }

  borrarScanTodos() async{
    await DBProvider.db.deleteAll();
    obtenerScans();
  }

}