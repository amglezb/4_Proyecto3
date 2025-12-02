import 'dart:math';

/// =========================
///        MODELO
/// =========================

class Pokemon {
  final String nombre;
  final int nivel;
  final String tipo;
  double vida;
  final double velocidad;

  static final Random _random = Random();

  Pokemon({
    required this.nombre,
    required this.nivel,
    required this.tipo,
  })  : vida = (_random.nextDouble() * 5 + 1) * nivel,
        velocidad = (_random.nextDouble() * 3 + 1) * nivel;
}

class PokemonFuego extends Pokemon {
  PokemonFuego({required String nombre, required int nivel})
      : super(nombre: nombre, nivel: nivel, tipo: 'Fuego');
}

class PokemonHierba extends Pokemon {
  PokemonHierba({required String nombre, required int nivel})
      : super(nombre: nombre, nivel: nivel, tipo: 'Hierba');
}

class Ataque {
  final String nombre;
  final String tipo;
  final int potencia;

  Ataque({
    required this.nombre,
    required this.tipo,
    required this.potencia,
  });
}

class AtaqueFuego extends Ataque {
  AtaqueFuego({required String nombre, required int potencia})
      : super(nombre: nombre, tipo: 'Fuego', potencia: potencia);
}

class AtaqueHierba extends Ataque {
  AtaqueHierba({required String nombre, required int potencia})
      : super(nombre: nombre, tipo: 'Hierba', potencia: potencia);
}

class AtaqueNormal extends Ataque {
  AtaqueNormal({required String nombre, required int potencia})
      : super(nombre: nombre, tipo: 'Normal', potencia: potencia);
}

/// =========================
///         VISTA
/// =========================

abstract class CombateView {
  void mostrarInformacionPokemon(Pokemon p);
  void mostrarAtaque(Pokemon atacante, Pokemon defensor, Ataque ataque);
  void mostrarSuperEfectivo();
  void mostrarPocoEfectivo();
  void mostrarDanio(double danio);
  void mostrarDesmayo(Pokemon p);
  void mostrarSiguienteTurno();
  void mostrarGanador(Pokemon ganador, Pokemon perdedor);
}

class ConsoleCombateView implements CombateView {
  @override
  void mostrarInformacionPokemon(Pokemon p) {
    print('Nombre: ${p.nombre}');
    print('Nivel: ${p.nivel}');
    print('Tipo: ${p.tipo}');
    print('Vida: ${p.vida.toInt()}');
    print('Velocidad: ${p.velocidad.toInt()}');
    print('----------------------');
  }

  @override
  void mostrarAtaque(Pokemon atacante, Pokemon defensor, Ataque ataque) {
    print(
        '${atacante.nombre} ataca a ${defensor.nombre} con ${ataque.nombre}!');
  }

  @override
  void mostrarSuperEfectivo() {
    print('¡Es súper efectivo!');
  }

  @override
  void mostrarPocoEfectivo() {
    print('¡No es muy efectivo!');
  }

  @override
  void mostrarDanio(double danio) {
    print('El Pokémon rival recibe $danio puntos de daño.');
  }

  @override
  void mostrarDesmayo(Pokemon p) {
    print('¡${p.nombre} se ha desmayado!');
  }

  @override
  void mostrarSiguienteTurno() {
    print('-- Siguiente turno --');
  }

  @override
  void mostrarGanador(Pokemon ganador, Pokemon perdedor) {
    print(
        '¡${perdedor.nombre} ha sido derrotado!, ¡${ganador.nombre} gana el combate!');
  }
}

/// =========================
///      CONTROLADOR
/// =========================

class CombateController {
  final CombateView view;
  final Random _random = Random();

  CombateController(this.view);

  void iniciarCombate(
    Pokemon p1,
    Pokemon p2,
    Ataque ataquePorDefecto,
  ) {
    // Mostrar info inicial
    view.mostrarInformacionPokemon(p1);
    view.mostrarInformacionPokemon(p2);

    print('========== COMBATE INICIADO ==========');

    while (p1.vida > 0 && p2.vida > 0) {
      if (p1.velocidad > p2.velocidad) {
        _turno(p1, p2, ataquePorDefecto);
      } else if (p2.velocidad > p1.velocidad) {
        _turno(p2, p1, ataquePorDefecto);
      } else {
        // Velocidades iguales, decidir al azar
        final velocidadIgual = _random.nextInt(2);
        if (velocidadIgual == 0) {
          _turno(p1, p2, ataquePorDefecto);
        } else {
          _turno(p2, p1, ataquePorDefecto);
        }
      }

      if (p1.vida <= 0) {
        p1.vida = 0;
        view.mostrarDesmayo(p1);
        view.mostrarGanador(p2, p1);
      } else if (p2.vida <= 0) {
        p2.vida = 0;
        view.mostrarDesmayo(p2);
        view.mostrarGanador(p1, p2);
      } else {
        view.mostrarSiguienteTurno();
      }
    }

    print('========== COMBATE TERMINADO ==========');
  }

  void _turno(Pokemon atacante, Pokemon defensor, Ataque ataque) {
    _atacar(atacante, defensor, ataque);
    if (defensor.vida > 0) {
      _atacar(defensor, atacante, ataque);
    }
  }

  void _atacar(Pokemon atacante, Pokemon defensor, Ataque ataque) {
    double vidaActual = defensor.vida;

    view.mostrarAtaque(atacante, defensor, ataque);

    double multiplicador = 1.0;

    if (ataque.tipo == 'Fuego' && defensor.tipo == 'Hierba') {
      multiplicador = 2.0;
      view.mostrarSuperEfectivo();
    } else if (ataque.tipo == 'Hierba' && defensor.tipo == 'Fuego') {
      multiplicador = 0.5;
      view.mostrarPocoEfectivo();
    }

    final double danio = ataque.potencia * multiplicador;
    vidaActual -= danio;
    defensor.vida = vidaActual;
    view.mostrarDanio(danio);
  }
}

/// =========================
///         MAIN
/// =========================

void main() {
  final view = ConsoleCombateView();
  final controller = CombateController(view);

  final charmander = PokemonFuego(nombre: 'Charmander', nivel: 50);
  final bulbasaur = PokemonHierba(nombre: 'Bulbasaur', nivel: 50);

  final tacleada = AtaqueNormal(nombre: 'Tacleada', potencia: 35);
  // También podrías crear:
  // final lanzallamas = AtaqueFuego(nombre: 'Lanzallamas', potencia: 50);
  // final hojaAfilada = AtaqueHierba(nombre: 'Hoja Afilada', potencia: 40);

  controller.iniciarCombate(charmander, bulbasaur, tacleada);
}