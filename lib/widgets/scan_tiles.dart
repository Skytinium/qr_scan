import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scan/providers/scan_list_provider.dart';
import 'package:qr_scan/utils/utils.dart';

class ScanTiles extends StatelessWidget {
  final String tipus;
  const ScanTiles({Key? key, required this.tipus});

  @override
  Widget build(BuildContext context) {
    final scanListProvider = Provider.of<ScanListProvider>(context);
    final scans = scanListProvider.scans;
    final ConfirmDismissCallback? confirDismiss;

    return ListView.builder(
      itemCount: scans.length,
      itemBuilder: (_, index) => Dismissible(
        //widget para arrastrar el elemento de la lista
        key: UniqueKey(),
        background: Container(
          color: const Color.fromARGB(255, 215, 125, 231),
          child: const Align(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.delete_forever),
            ),
            alignment: Alignment.centerRight,
          ),
        ),
        onDismissed: (DismissDirection direccio) {
          Provider.of<ScanListProvider>(context, listen: false)
              .esborraPerId(scans[index].id!);
        },
        child: ListTile(
          leading: Icon(
            tipus == 'http' ? Icons.home_outlined : Icons.map_outlined,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(scans[index].valor),
          subtitle: Text(scans[index].id.toString()),
          trailing: const Icon(Icons.keyboard_arrow_right, color: Colors.blue),
          onTap: () {
            launchUrl(context, scans[index]);
          },
        ),
        confirmDismiss: (_) {
          //Creamos una ventana que nos pregunta si queremos eliminar el elemento
          return showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Eliminar element'),
              content: const Text("¿Segur que vols esborrar l'element"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('No')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Si')),
              ],
            ),
          );
        },
      ),
    );
  }
}
