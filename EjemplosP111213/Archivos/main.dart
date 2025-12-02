import 'dart:io';

void main() {
  while (true) {
    print('==============================');
    print('       MENÚ DE ARCHIVOS');
    print('==============================');
    print('1) Crear archivo .txt y escribir texto');
    print('2) Leer archivo existente');
    print('3) Sobrescribir archivo existente');
    print('4) Salir');
    stdout.write('Elige una opción: ');

    String? opcionStr = stdin.readLineSync();
    int? opcion = int.tryParse(opcionStr ?? '');

    switch (opcion) {
      case 1:
        _crearYEscribirArchivo();
        break;
      case 2:
        _leerArchivoExistente();
        break;
      case 3:
        _sobrescribirArchivo();
        break;
      case 4:
        print('Saliendo del programa...');
        return;
      default:
        print('Opción no válida. Intenta de nuevo.\n');
    }
  }
}

/// Opción 1: Crear archivo y escribir texto
void _crearYEscribirArchivo() {
  stdout.write('Nombre del archivo a crear (ej: notas.txt): ');
  String? nombreArchivo = stdin.readLineSync();

  if (nombreArchivo == null || nombreArchivo.trim().isEmpty) {
    print('Nombre de archivo no válido.\n');
    return;
  }

  print('\nEscribe el texto que deseas guardar.');
  print('Para terminar, escribe SOLO: FIN');
  print('----------------------------------');

  List<String> lineas = [];
  while (true) {
    String? linea = stdin.readLineSync();
    if (linea == null || linea.trim() == 'FIN') break;
    lineas.add(linea);
  }

  try {
    File archivo = File(nombreArchivo);
    archivo.writeAsStringSync(lineas.join('\n'));
    print('\nArchivo creado y guardado correctamente.\n');
  } catch (e) {
    print('\nOcurrió un error al guardar el archivo: $e\n');
  }
}

/// Opción 2: Leer archivo existente
void _leerArchivoExistente() {
  stdout.write('Ingresa el nombre o ruta del archivo a leer: ');
  String? ruta = stdin.readLineSync();

  if (ruta == null || ruta.trim().isEmpty) {
    print('Ruta no válida.\n');
    return;
  }

  try {
    File archivo = File(ruta);
    if (!archivo.existsSync()) {
      print('\nEl archivo no existe.\n');
      return;
    }

    String contenido = archivo.readAsStringSync();
    print('\n========== CONTENIDO DEL ARCHIVO ==========');
    print(contenido);
    print('===========================================\n');
  } catch (e) {
    print('\nError al leer el archivo: $e\n');
  }
}

/// Opción 3: Sobrescribir archivo existente
void _sobrescribirArchivo() {
  stdout.write('Ingresa el nombre o ruta del archivo a sobrescribir: ');
  String? ruta = stdin.readLineSync();

  if (ruta == null || ruta.trim().isEmpty) {
    print('Ruta no válida.\n');
    return;
  }

  File archivo = File(ruta);

  if (!archivo.existsSync()) {
    print('\nEl archivo no existe. No se puede sobrescribir.\n');
    return;
  }

  print('\nSE ENCONTRÓ EL ARCHIVO.');
  print('¿Deseas sobrescribirlo? Esto borrará todo su contenido.');
  stdout.write('Escribe "SI" para confirmar: ');
  String? confirmacion = stdin.readLineSync();

  if (confirmacion == null || confirmacion.toUpperCase() != 'SI') {
    print('\nOperación cancelada.\n');
    return;
  }

  print('\nEscribe el nuevo contenido del archivo.');
  print('Cuando termines, escribe: FIN');
  print('----------------------------------');

  List<String> nuevasLineas = [];

  while (true) {
    String? linea = stdin.readLineSync();
    if (linea == null || linea.trim() == 'FIN') break;
    nuevasLineas.add(linea);
  }

  try {
    archivo.writeAsStringSync(nuevasLineas.join('\n'));
    print('\nArchivo sobrescrito correctamente.\n');
  } catch (e) {
    print('\nError al sobrescribir el archivo: $e\n');
  }
}