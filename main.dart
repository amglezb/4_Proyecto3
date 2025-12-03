import 'dart:math';
import 'package:flutter/material.dart';

// =========================
//        DATOS
// =========================
class TablaTipos {
  static final Map<String, Map<String, double>> efectividad = {
    'Normal': {'Roca': 0.5, 'Fantasma': 0.0, 'Acero': 0.5},
    'Fuego': {'Fuego': 0.5, 'Agua': 0.5, 'Hierba': 2.0, 'Hielo': 2.0, 'Bicho': 2.0, 'Roca': 0.5, 'Dragon': 0.5, 'Acero': 2.0},
    'Agua': {'Fuego': 2.0, 'Agua': 0.5, 'Hierba': 0.5, 'Tierra': 2.0, 'Roca': 2.0, 'Dragon': 0.5},
    'Hierba': {'Fuego': 0.5, 'Agua': 2.0, 'Hierba': 0.5, 'Veneno': 0.5, 'Tierra': 2.0, 'Volador': 0.5, 'Bicho': 0.5, 'Roca': 2.0, 'Dragon': 0.5, 'Acero': 0.5},
    'Electrico': {'Agua': 2.0, 'Hierba': 0.5, 'Electrico': 0.5, 'Tierra': 0.0, 'Volador': 2.0, 'Dragon': 0.5},
    'Hielo': {'Fuego': 0.5, 'Agua': 0.5, 'Hierba': 2.0, 'Hielo': 0.5, 'Tierra': 2.0, 'Volador': 2.0, 'Dragon': 2.0, 'Acero': 0.5},
    'Lucha': {'Normal': 2.0, 'Hielo': 2.0, 'Veneno': 0.5, 'Volador': 0.5, 'Psiquico': 0.5, 'Bicho': 0.5, 'Roca': 2.0, 'Fantasma': 0.0, 'Oscuro': 2.0, 'Acero': 2.0},
    'Veneno': {'Hierba': 2.0, 'Veneno': 0.5, 'Tierra': 0.5, 'Roca': 0.5, 'Fantasma': 0.5, 'Acero': 0.0},
    'Tierra': {'Fuego': 2.0, 'Hierba': 0.5, 'Electrico': 2.0, 'Veneno': 2.0, 'Volador': 0.0, 'Bicho': 0.5, 'Roca': 2.0, 'Acero': 2.0},
    'Volador': {'Hierba': 2.0, 'Electrico': 0.5, 'Lucha': 2.0, 'Bicho': 2.0, 'Roca': 0.5, 'Acero': 0.5},
    'Psiquico': {'Lucha': 2.0, 'Veneno': 2.0, 'Psiquico': 0.5, 'Oscuro': 0.0, 'Acero': 0.5},
    'Bicho': {'Fuego': 0.5, 'Hierba': 2.0, 'Lucha': 0.5, 'Veneno': 0.5, 'Volador': 0.5, 'Psiquico': 2.0, 'Fantasma': 0.5, 'Oscuro': 2.0, 'Acero': 0.5},
    'Roca': {'Fuego': 2.0, 'Hielo': 2.0, 'Lucha': 0.5, 'Tierra': 0.5, 'Volador': 2.0, 'Bicho': 2.0, 'Acero': 0.5},
    'Fantasma': {'Normal': 0.0, 'Psiquico': 2.0, 'Fantasma': 2.0, 'Oscuro': 0.5},
    'Dragon': {'Dragon': 2.0, 'Acero': 0.5},
    'Oscuro': {'Lucha': 0.5, 'Psiquico': 2.0, 'Fantasma': 2.0, 'Oscuro': 0.5},
    'Acero': {'Fuego': 0.5, 'Agua': 0.5, 'Electrico': 0.5, 'Hielo': 2.0, 'Roca': 2.0, 'Acero': 0.5}
  };

  static double obtenerMultiplicador(String tipoAtaque, String tipoDefensor) {
    if (efectividad.containsKey(tipoAtaque)) {
      var mapaDefensor = efectividad[tipoAtaque];
      if (mapaDefensor != null && mapaDefensor.containsKey(tipoDefensor)) {
        return mapaDefensor[tipoDefensor]!;
      }
    }
    return 1.0;
  }
}

// =========================
//        MODELO
// =========================

enum Estado { sano, envenenado, quemado, congelado, paralizado }

class Ataque {
  final String nombre;
  final String tipo;
  final int potencia;
  final Estado? efectoEstado;

  Ataque({required this.nombre, required this.tipo, required this.potencia, this.efectoEstado});
}

class Pokemon {
  final int id;
  final String nombre;
  final int nivel;
  final String tipo;
  double vidaMax;
  double vida;
  double velocidadBase;
  double velocidad;
  Estado estado;
  List<Ataque> movimientos;
  static final Random _random = Random();

  String get spriteUrlFront => "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/showdown/$id.gif";
  String get spriteUrlBack => "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/showdown/back/$id.gif";

  Pokemon({
    required this.id,
    required this.nombre, 
    required this.nivel, 
    required this.tipo, 
    required this.movimientos
  }) : vidaMax = (_random.nextDouble() * 50 + 50) * (nivel / 10),
        vida = 0,
        velocidadBase = (_random.nextDouble() * 30 + 10) * (nivel / 10),
        velocidad = 0,
        estado = Estado.sano {
    vida = vidaMax;
    velocidad = velocidadBase;
  }

  String? aplicarEfectoDeEstado() {
    String? msg;
    if (estado == Estado.quemado) {
      double danio = vidaMax / 8;
      vida -= danio;
      msg = "$nombre sufre por quemadura (-${danio.toInt()}).";
    } else if (estado == Estado.envenenado) {
      double danio = vidaMax / 8;
      vida -= danio;
      msg = "$nombre sufre por veneno (-${danio.toInt()}).";
    }
    if (vida < 0) vida = 0;
    return msg;
  }
}

// --- ITEMS ---
abstract class Item {
  String nombre;
  Item(this.nombre);
  String? usar(Pokemon p);
}

class Pocion extends Item {
  Pocion() : super("Poción (+20 HP)");
  @override
  String? usar(Pokemon p) {
    if (p.vida >= p.vidaMax) return null;
    p.vida += 20;
    if (p.vida > p.vidaMax) p.vida = p.vidaMax;
    return "${p.nombre} recuperó 20 HP.";
  }
}

class MaxPocion extends Item {
  MaxPocion() : super("Max Poción (Full HP)");
  @override
  String? usar(Pokemon p) {
    if (p.vida >= p.vidaMax) return null;
    p.vida = p.vidaMax;
    return "${p.nombre} recuperó toda su salud.";
  }
}

class CuraTotal extends Item {
  CuraTotal() : super("Cura Total (Estado)");
  @override
  String? usar(Pokemon p) {
    if (p.estado == Estado.sano) return null;
    p.estado = Estado.sano;
    p.velocidad = p.velocidadBase;
    return "${p.nombre} se curó de su problema de estado.";
  }
}

// =========================
//   INTERFAZ GRÁFICA (VISTA)
// =========================

void main() {
  runApp(const PokemonApp());
}

class PokemonApp extends StatelessWidget {
  const PokemonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Batalla Pokemon',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.redAccent,
          secondary: Colors.cyanAccent,
        ),
      ),
      home: const CombateScreen(),
    );
  }
}

enum FaseTurno { menuPrincipal, seleccionAtaque, seleccionMochila, animacion, finJuego }

class CombateScreen extends StatefulWidget {
  const CombateScreen({super.key});

  @override
  State<CombateScreen> createState() => _CombateScreenState();
}

class _CombateScreenState extends State<CombateScreen> {
  late Pokemon jugador;
  late Pokemon rival;
  List<Item> mochila = [];
  
  List<String> logs = [];
  FaseTurno faseActual = FaseTurno.menuPrincipal;
  List<Ataque> ataquesAleatoriosDelTurno = [];
  
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    inicializarCombate();
  }

  void inicializarCombate() {
    final placaje = Ataque(nombre: 'Placaje', tipo: 'Normal', potencia: 40);
    final lanzallamas = Ataque(nombre: 'Lanzallamas', tipo: 'Fuego', potencia: 90, efectoEstado: Estado.quemado);
    final hojaAfilada = Ataque(nombre: 'Hoja Afilada', tipo: 'Hierba', potencia: 55);
    final rayo = Ataque(nombre: 'Rayo', tipo: 'Electrico', potencia: 90, efectoEstado: Estado.paralizado);
    final toxico = Ataque(nombre: 'Tóxico', tipo: 'Veneno', potencia: 10, efectoEstado: Estado.envenenado);
    final psiquico = Ataque(nombre: 'Psíquico', tipo: 'Psiquico', potencia: 90);
    final rayoHielo = Ataque(nombre: 'Rayo Hielo', tipo: 'Hielo', potencia: 90, efectoEstado: Estado.congelado);
    final terremoto = Ataque(nombre: 'Terremoto', tipo: 'Tierra', potencia: 100);

    jugador = Pokemon(
        id: 6,
        nombre: 'Charizard',
        nivel: 50,
        tipo: 'Fuego',
        movimientos: [placaje, lanzallamas, hojaAfilada, rayo, toxico, psiquico, rayoHielo, terremoto]);
    
    rival = Pokemon(
        id: 3,
        nombre: 'Venusaur',
        nivel: 50,
        tipo: 'Hierba',
        movimientos: [placaje, lanzallamas, hojaAfilada, rayo, toxico, psiquico, rayoHielo, terremoto]);

    mochila = [Pocion(), MaxPocion(), CuraTotal()];
    logs.clear();
    
    setState(() {
      faseActual = FaseTurno.menuPrincipal;
      agregarLog("¡Un ${rival.nombre} salvaje apareció!");
      agregarLog("¡Ve ${jugador.nombre}!");
    });
  }

  void agregarLog(String mensaje) {
    setState(() {
      logs.add(mensaje);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void irAMenuAtaque() {
    final random = Random();
    List<Ataque> copiaMovimientos = List.from(jugador.movimientos);
    copiaMovimientos.shuffle(random);
    setState(() {
      ataquesAleatoriosDelTurno = copiaMovimientos.take(2).toList();
      faseActual = FaseTurno.seleccionAtaque;
    });
  }

  void irAMochila() {
    setState(() {
      faseActual = FaseTurno.seleccionMochila;
    });
  }

  void volverAlMenu() {
    setState(() {
      faseActual = FaseTurno.menuPrincipal;
    });
  }

  Future<void> usarItem(Item item) async {
    String? resultado = item.usar(jugador);
    
    if (resultado == null) {
      if (item is CuraTotal) {
        agregarLog("¡${jugador.nombre} no tiene problemas de estado!");
      } else {
        agregarLog("¡La vida de ${jugador.nombre} ya está al máximo!");
      }
      return;
    }
    
    mochila.remove(item);
    agregarLog("Usaste ${item.nombre}. $resultado");
    await turnoRival(jugadorAtaco: false);
  }

  Future<void> ejecutarAtaqueJugador(Ataque ataqueJugador) async {
    setState(() => faseActual = FaseTurno.animacion);

    bool rivalPrimero = rival.velocidad > jugador.velocidad;
    if(jugador.estado == Estado.paralizado && Random().nextBool()){
       rivalPrimero = true; 
    }

    if (rivalPrimero) {
      await procesarAtaque(rival, jugador, _ataqueRivalRandom());
      if (jugador.vida > 0) {
        await Future.delayed(const Duration(seconds: 1));
        await procesarAtaque(jugador, rival, ataqueJugador);
      }
    } else {
      await procesarAtaque(jugador, rival, ataqueJugador);
      if (rival.vida > 0) {
        await Future.delayed(const Duration(seconds: 1));
        await procesarAtaque(rival, jugador, _ataqueRivalRandom());
      }
    }
    await finalizarTurno();
  }

  Future<void> turnoRival({required bool jugadorAtaco}) async {
    setState(() => faseActual = FaseTurno.animacion);
    await Future.delayed(const Duration(seconds: 1));
    await procesarAtaque(rival, jugador, _ataqueRivalRandom());
    await finalizarTurno();
  }

  Ataque _ataqueRivalRandom() {
    return rival.movimientos[Random().nextInt(rival.movimientos.length)];
  }

  Future<void> procesarAtaque(Pokemon atacante, Pokemon defensor, Ataque ataque) async {
    if (atacante.estado == Estado.congelado) {
      agregarLog("${atacante.nombre} está congelado.");
      return;
    }
    if (atacante.estado == Estado.paralizado && Random().nextInt(4) == 0) {
       agregarLog("${atacante.nombre} está paralizado.");
       return;
    }

    agregarLog("${atacante.nombre} usó ${ataque.nombre}!");
    await Future.delayed(const Duration(milliseconds: 500));

    double multi = TablaTipos.obtenerMultiplicador(ataque.tipo, defensor.tipo);
    double danio = ataque.potencia * multi * ((Random().nextInt(16) + 85) / 100);
    if (atacante.tipo == ataque.tipo) danio *= 1.5;

    if (multi > 1) agregarLog("¡Es súper efectivo!");
    if (multi < 1 && multi > 0) agregarLog("No es muy efectivo...");
    if (multi == 0) agregarLog("¡No afecta!");

    setState(() {
      defensor.vida -= danio;
      if (defensor.vida < 0) defensor.vida = 0;
    });

    if (ataque.efectoEstado != null && defensor.estado == Estado.sano && defensor.vida > 0) {
      if (Random().nextInt(100) < 20) {
        defensor.estado = ataque.efectoEstado!;
        agregarLog("¡${defensor.nombre} fue ${defensor.estado.name}!");
      }
    }
  }

  Future<void> finalizarTurno() async {
    String? msgJ = jugador.aplicarEfectoDeEstado();
    if (msgJ != null) agregarLog(msgJ);
    String? msgR = rival.aplicarEfectoDeEstado();
    if (msgR != null) agregarLog(msgR);

    if (jugador.vida <= 0) {
      agregarLog("¡${jugador.nombre} se desmayó!");
      setState(() => faseActual = FaseTurno.finJuego);
    } else if (rival.vida <= 0) {
      agregarLog("¡${rival.nombre} derrotado!");
      setState(() => faseActual = FaseTurno.finJuego);
    } else {
      setState(() => faseActual = FaseTurno.menuPrincipal);
    }
  }

  // ============================================
  //             INTERFAZ DE USUARIO
  // ============================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                // Fondo Degradado
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF87CEEB), Color(0xFFE0F7FA), Color(0xFF66BB6A), Color(0xFF2E7D32)],
                      stops: [0.0, 0.4, 0.4, 1.0], 
                    ),
                  ),
                ),
                
                Positioned(
                  top: 50,
                  left: 20,
                  child: _buildPokemonHUD(rival, isRival: true),
                ),
                
                Positioned(
                  top: 80,
                  right: 40,
                  child: Image.network(
                    rival.spriteUrlFront,
                    height: 150,
                    fit: BoxFit.contain,
                    loadingBuilder: (c, child, progress) => progress == null ? child : const SizedBox(),
                    errorBuilder: (c, err, stack) => const Icon(Icons.error, size: 50, color: Colors.red),
                  ),
                ),
                
                Positioned(
                  bottom: 40,
                  left: 40,
                  child: Image.network(
                    jugador.spriteUrlBack,
                    height: 180,
                    fit: BoxFit.contain,
                    loadingBuilder: (c, child, progress) => progress == null ? child : const SizedBox(),
                    errorBuilder: (c, err, stack) => const Icon(Icons.pets, size: 80, color: Colors.white),
                  ),
                ),
                
                Positioned(
                  bottom: 60,
                  right: 20,
                  child: _buildPokemonHUD(jugador, isRival: false),
                ),
              ],
            ),
          ),
          
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFF212121),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, -5))]
              ),
              child: Column(
                children: [
                  Container(
                    height: 80,
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24, width: 1.5),
                    ),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: logs.length,
                      itemBuilder: (c, i) => Text(
                        logs[i], 
                        style: const TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'Courier', fontWeight: FontWeight.bold)
                      ),
                    ),
                  ),

                  Expanded(
                    child: _buildPanelControl(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPokemonHUD(Pokemon p, {required bool isRival}) {
    double porcentaje = p.vida / p.vidaMax;
    Color colorBarra = porcentaje > 0.5 ? Colors.greenAccent : (porcentaje > 0.2 ? Colors.orangeAccent : Colors.redAccent);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: const BorderRadius.only(
           topLeft: Radius.circular(15), 
           bottomRight: Radius.circular(15),
           topRight: Radius.circular(5),
           bottomLeft: Radius.circular(5)
        ),
        border: Border.all(color: Colors.white30, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(p.nombre.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white, letterSpacing: 1.2)),
              const SizedBox(width: 8),
              if (p.estado != Estado.sano)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.circular(4)),
                  child: Text(p.estado.name.toUpperCase(), style: const TextStyle(fontSize: 10, color: Colors.white)),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text("Nv. ${p.nivel}", style: const TextStyle(fontSize: 12, color: Colors.white70)),
          const SizedBox(height: 8),
          // Barra de Vida
          Stack(
            children: [
              Container(height: 12, width: 140, decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(6))),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: 12,
                width: 140 * porcentaje,
                decoration: BoxDecoration(color: colorBarra, borderRadius: BorderRadius.circular(6)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text("${p.vida.toInt()} / ${p.vidaMax.toInt()}", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPanelControl() {
    switch (faseActual) {
      case FaseTurno.menuPrincipal:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _botonAccion("LUCHAR", Colors.red[700]!, Icons.flash_on, irAMenuAtaque),
            _botonAccion("MOCHILA", Colors.orange[800]!, Icons.backpack, irAMochila),
          ],
        );

      case FaseTurno.seleccionAtaque:
        return Column(
          children: [
             const Text("SELECCIONA UN ATAQUE", style: TextStyle(color: Colors.white54, fontSize: 12, letterSpacing: 1.5)),
             const SizedBox(height: 10),
             Expanded(
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: ataquesAleatoriosDelTurno.map((ataque) {
                   return Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 6),
                     child: _botonAtaque(ataque),
                   );
                 }).toList(),
               ),
             ),
             TextButton.icon(
               icon: const Icon(Icons.arrow_back, color: Colors.white54),
               label: const Text("VOLVER", style: TextStyle(color: Colors.white54)),
               onPressed: volverAlMenu
             )
          ],
        );

      case FaseTurno.seleccionMochila:
        if (mochila.isEmpty) {
           return Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               const Icon(Icons.remove_shopping_cart, color: Colors.white24, size: 40),
               const SizedBox(height: 10),
               const Text("Tu mochila está vacía", style: TextStyle(color: Colors.white54)),
               TextButton(onPressed: volverAlMenu, child: const Text("VOLVER", style: TextStyle(color: Colors.white)))
             ],
           );
        }
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                separatorBuilder: (c, i) => const Divider(color: Colors.white10),
                itemCount: mochila.length,
                itemBuilder: (ctx, i) => ListTile(
                  tileColor: Colors.white.withOpacity(0.05),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  leading: const Icon(Icons.medical_services, color: Colors.pinkAccent),
                  title: Text(mochila[i].nombre, style: const TextStyle(color: Colors.white)),
                  onTap: () => usarItem(mochila[i]),
                ),
              ),
            ),
            TextButton(onPressed: volverAlMenu, child: const Text("VOLVER", style: TextStyle(color: Colors.white)))
          ],
        );

      case FaseTurno.animacion:
        return const Center(child: CircularProgressIndicator(color: Colors.redAccent));

      case FaseTurno.finJuego:
        return Center(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.replay),
            label: const Text("NUEVA BATALLA"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent, 
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
            ),
            onPressed: inicializarCombate,
          ),
        );
    }
  }

  Widget _botonAccion(String texto, Color color, IconData icono, VoidCallback accion) {
    return InkWell(
      onTap: accion,
      child: Container(
        width: 140,
        height: 70,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 4))
          ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icono, color: Colors.white, size: 28),
            const SizedBox(height: 5),
            Text(texto, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _botonAtaque(Ataque ataque) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _getColorPorTipo(ataque.tipo),
        minimumSize: const Size(140, 70),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
      ),
      onPressed: () => ejecutarAtaqueJugador(ataque),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(ataque.nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(4)),
            child: Text(ataque.tipo.toUpperCase(), style: const TextStyle(fontSize: 10, color: Colors.white)),
          )
        ],
      ),
    );
  }

  Color _getColorPorTipo(String tipo) {
    switch (tipo) {
      case 'Fuego': return const Color(0xFFF08030);
      case 'Agua': return const Color(0xFF6890F0);
      case 'Hierba': return const Color(0xFF78C850);
      case 'Electrico': return const Color(0xFFF8D030);
      case 'Tierra': return const Color(0xFFE0C068);
      case 'Hielo': return const Color(0xFF98D8D8);
      case 'Psiquico': return const Color(0xFFF85888);
      case 'Normal': return const Color(0xFFA8A878);
      default: return Colors.grey;
    }
  }
}