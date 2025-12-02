void main() {
  print("Inicio");

  int total = 0;
  for (int i = 0; i < 500000000; i++) {
    total += i;
  }

  print("Resultado: $total");
  print("Fin");
}