Future<void> main() async {
  print("Inicio");

  Future.delayed(Duration(seconds: 2), () {
    print("Tarea asíncrona completada");
  });

  print("Fin inmediato (sin esperar)");
}