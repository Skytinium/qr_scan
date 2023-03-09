import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scan/providers/scan_list_provider.dart';
import 'package:qr_scan/providers/ui_provider.dart';
import 'package:qr_scan/screens/screens.dart';
import 'package:qr_scan/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              Provider.of<ScanListProvider>(context, listen: false)
                  .esborraTots();
            },
          )
        ],
      ),
      body: const _HomeScreenBody(),
      bottomNavigationBar: CustomNavigationBar(),
      floatingActionButton: const ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _HomeScreenBody extends StatelessWidget {
  const _HomeScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //creamos una instancia de nuestro provider
    final uiProvider = Provider.of<UIProvider>(context);
    // Canviar per a anar canviant entre pantalles
    final currentIndex = uiProvider.selectedMenuOpt;

    final scanListProvider = Provider.of<ScanListProvider>(context,
        listen:
            false); //indicamos false para poder eliminar elementos de la pantalla

    /* // ahora trabajamos directamente através de scan_list_provider
    //Creación temp de la BBDD
    DBProvider.db.database;
    DBProvider.db.getAllScans().then(print);
    //creamos un nuevo Scan para hacer la prueba del insert
    ScanModel nouScan = ScanModel(valor: 'https://paucasesnovescifp.cat');
    DBProvider.db.insertScan(nouScan);*/

    switch (currentIndex) {
      case 0:
        scanListProvider.carregaScansPerTipus('geo');
        return const MapasScreen();

      case 1:
        scanListProvider.carregaScansPerTipus('http');
        return const DireccionsScreen();

      default:
        scanListProvider.carregaScansPerTipus('geo');
        return const MapasScreen();
    }
  }
}
