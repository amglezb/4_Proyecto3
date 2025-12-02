import 'dart:isolate';

void worker(SendPort mainPort) {
  // Puerto para recibir mensajes desde el main
  final receive = ReceivePort();

  // Enviar al main el SendPort del worker
  mainPort.send(receive.sendPort);

  // Escuchar mensajes que mande el main
  receive.listen((msg) {
    final respuesta = "Recibido en worker: $msg";
    mainPort.send(respuesta);
  });
}

void main() async {
  final mainReceive = ReceivePort();

  // Crear isolate y pasarle el SendPort del main
  final isolate = await Isolate.spawn(worker, mainReceive.sendPort);

  SendPort? workerSendPort;

  // Escuchar mensajes que lleguen al main
  mainReceive.listen((mensaje) {
    if (mensaje is SendPort) {
      // Primer mensaje: es el SendPort del worker
      workerSendPort = mensaje;
      print("Main: recibí el SendPort del worker.");

      // Enviar un mensaje al worker
      workerSendPort!.send("Mensaje desde main");
    } else {
      // Segundo mensaje: respuesta del worker
      print("Main: respuesta del worker -> $mensaje");

      // Cerrar el puerto y matar el isolate para terminar el programa
      mainReceive.close();
      isolate.kill(priority: Isolate.immediate);
    }
  });
}