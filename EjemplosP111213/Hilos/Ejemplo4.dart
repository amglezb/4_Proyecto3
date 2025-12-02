import 'dart:isolate';

void sumaGrande(SendPort port) {
  int total = 0;
  for (int i = 0; i < 500000000; i++) {
    total += i;
  }
  port.send(total);
}

void main() async {
  final receive = ReceivePort();

  print("Iniciando tarea pesada en hilo paralelo...");
  await Isolate.spawn(sumaGrande, receive.sendPort);

  print("Mientras tanto, sigo ejecutando en el hilo principal...");

  receive.listen((resultado) {
    print("Resultado: $resultado");
    receive.close();
  });
}