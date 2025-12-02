import 'dart:isolate';

void tarea(SendPort port) {
  port.send("Hola desde otro isolate");
}

void main() async {
  final receivePort = ReceivePort();

  await Isolate.spawn(tarea, receivePort.sendPort);

  receivePort.listen((mensaje) {
    print(mensaje);
    receivePort.close();
  });
}