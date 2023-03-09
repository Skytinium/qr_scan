import 'package:flutter/foundation.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:qr_scan/providers/db_provider.dart';

//Esta clase sirve de interfaz intemediaria entre db_provider y los widgets
class ScanListProvider extends ChangeNotifier {
  //lista de Scanmodel inicializada vacia
  List<ScanModel> scans = [];
  //Nos indica el tipo seleccionado en ese momento
  String tipusSeleccionat = 'http';

  //Función nuevo scan, que retorna un future de tipo ScanModel y nos pasan por parámetro
  //solo el valor es un trabajo de tipo asíncrono
  Future<ScanModel> nouScan(String valor) async {
    //Definimos un nuevo Scan a partir de ScanModel (valor)
    final nouScan = ScanModel(valor: valor);
    //Declaramos variable de tipo id que ejecutará un insert en la BD
    final id = await DBProvider.db.insertScan(nouScan);
    nouScan.id = id;

    //Verificamos si este nuevo scan, si es de tipo http
    if (nouScan.tipus == tipusSeleccionat) {
      scans.add(nouScan);
      notifyListeners(); //notificamos que se tiene que repintar
    }
    return nouScan;
  }

  //Método que devuelve una lista de ScanModel
  carregaScans() async {
    final scans = await DBProvider.db.getAllScans();
    this.scans = [
      ...scans
    ]; //spread operator permite agregar la lista dentro de otra lista
    notifyListeners();
  }

  carregaScansPerTipus(String tipus) async {
    final scans = await DBProvider.db.getScanByTipus(tipus);
    this.scans = scans!; //Podríamos utilizar el spread
    this.tipusSeleccionat = tipus;
    notifyListeners();
  }

  esborraTots() async {
    final scans = await DBProvider.db.deleteAllScan();
    this.scans = [];
    notifyListeners();
  }

  esborraPerId(int id) async {
    final scans = await DBProvider.db.deleteScan(id);
  }
}
