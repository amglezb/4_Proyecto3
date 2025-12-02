import 'dart:collection';

/// Clase que representa un documento a imprimir
class Documento {
  final int id;
  final String usuario;
  final String nombre;
  final String contenido;

  Documento({
    required this.id,
    required this.usuario,
    required this.nombre,
    required this.contenido,
  });

  @override
  String toString() => 'Documento #$id - "$nombre" (Usuario: $usuario)';
}

/// Patrón Singleton para la impresora
class Impresora {
  // Instancia única
  static final Impresora _instancia = Impresora._interna();

  // Cola de documentos pendientes
  final Queue<Documento> _colaImpresion = Queue<Documento>();

  // Historial de documentos impresos
  final List<Documento> _historial = [];

  // Constructor privado
  Impresora._interna();

  // Factory que siempre regresa la misma instancia
  factory Impresora() {
    return _instancia;
  }

  /// Agregar un documento a la cola de impresión
  void enviarDocumento(Documento doc) {
    print('Enviando a impresión: $doc');
    _colaImpresion.addLast(doc);
  }

  /// Imprimir el siguiente documento en la cola
  void imprimirSiguiente() {
    if (_colaImpresion.isEmpty) {
      print('No hay documentos en la cola de impresión.');
      return;
    }

    final doc = _colaImpresion.removeFirst();
    print('--- Imprimiendo documento ---');
    print(doc);
    print('Contenido: ${doc.contenido}');
    print('--- Fin de impresión ---\n');

    _historial.add(doc);
  }

  /// Mostrar los documentos pendientes
  void mostrarCola() {
    if (_colaImpresion.isEmpty) {
      print('La cola de impresión está vacía.\n');
      return;
    }

    print('=== Cola de impresión pendiente ===');
    for (final doc in _colaImpresion) {
      print(doc);
    }
    print('===================================\n');
  }

  /// Mostrar el historial de documentos impresos
  void mostrarHistorial() {
    if (_historial.isEmpty) {
      print('No se ha impreso ningún documento aún.\n');
      return;
    }

    print('=== Historial de documentos impresos ===');
    for (final doc in _historial) {
      print(doc);
    }
    print('========================================\n');
  }
}

void main() {
  // Todos estos puntos de acceso obtienen la MISMA impresora
  final impresoraA = Impresora();
  final impresoraB = Impresora();

  // Demostración de que es Singleton
  print('¿Es la misma instancia? ${identical(impresoraA, impresoraB)}\n');

  // Simulación: distintos usuarios de la compañía envían documentos
  impresoraA.enviarDocumento(Documento(
    id: 1,
    usuario: 'Alice',
    nombre: 'Reporte mensual',
    contenido: 'Contenido del reporte mensual...',
  ));

  impresoraB.enviarDocumento(Documento(
    id: 2,
    usuario: 'Bob',
    nombre: 'Contrato de servicio',
    contenido: 'Términos y condiciones del servicio...',
  ));

  impresoraA.enviarDocumento(Documento(
    id: 3,
    usuario: 'Carlos',
    nombre: 'Presentación proyecto X',
    contenido: 'Diapositivas del proyecto X...',
  ));

  // Mostrar cola actual
  impresoraA.mostrarCola();

  // Imprimir algunos documentos
  impresoraA.imprimirSiguiente();
  impresoraB.imprimirSiguiente();

  // Ver cola después de imprimir
  impresoraA.mostrarCola();

  // Imprimir el resto
  impresoraB.imprimirSiguiente();
  impresoraA.imprimirSiguiente(); // No hay más

  // Ver historial completo
  impresoraA.mostrarHistorial();
}