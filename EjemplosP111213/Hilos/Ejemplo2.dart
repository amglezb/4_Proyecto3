Future<void> main() async {
  print("Inicio");

  await Future.delayed(Duration(seconds: 2));
  print("Tarea completada con await");

  print("Fin");
}