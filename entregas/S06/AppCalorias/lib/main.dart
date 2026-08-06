import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────
// Paleta (la misma del design system de inkash)
// ─────────────────────────────────────────────────────────────
const kFondo = Color(0xFF0E120C);
const kSuperficie = Color(0xFF181E14);
const kBorde = Color(0xFF2A3222);
const kTexto = Color(0xFFF1F4EA);
const kMuted = Color(0xFF8F9C80);
const kLima = Color(0xFFC8F54E);
const kIconoFondo = Color(0xFF37491C);

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Registrar comida',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kFondo,
        colorScheme: ColorScheme.fromSeed(
          seedColor: kLima,
          brightness: Brightness.dark,
        ),
      ),
      home: const PantallaRegistrarComida(),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Modelo
// ─────────────────────────────────────────────────────────────
class Alimento {
  final String nombre;
  final String porcion;
  final int kcal;

  const Alimento(this.nombre, this.porcion, this.kcal);
}

const kAlimentosRecientes = <Alimento>[
  Alimento('Avena', '1/2 taza', 150),
  Alimento('Huevo', '1 unidad', 78),
  Alimento('Manzana', '1 mediana', 95),
  Alimento('Banano', '1 mediano', 105),
];

// ─────────────────────────────────────────────────────────────
// Pantalla
// ─────────────────────────────────────────────────────────────
class PantallaRegistrarComida extends StatefulWidget {
  const PantallaRegistrarComida({super.key});

  @override
  State<PantallaRegistrarComida> createState() =>
      _PantallaRegistrarComidaState();
}

class _PantallaRegistrarComidaState extends State<PantallaRegistrarComida> {
  final TextEditingController _controlador = TextEditingController();
  String _busqueda = '';
  int _indiceNav = 1;

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  List<Alimento> get _resultados {
    final q = _busqueda.trim().toLowerCase();
    if (q.isEmpty) return kAlimentosRecientes;
    return kAlimentosRecientes
        .where((a) => a.nombre.toLowerCase().contains(q))
        .toList();
  }

  void _seleccionar(Alimento alimento) {
    // TODO: navegar a la pantalla de detalle (porción, cantidad, tiempo de comida)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: kSuperficie,
        content: Text(
          '${alimento.nombre} · ${alimento.kcal} kcal',
          style: const TextStyle(color: kTexto),
        ),
      ),
    );
  }

  void _escanearCodigo() {
    // TODO: abrir la cámara / lector de código de barras
  }

  @override
  Widget build(BuildContext context) {
    final resultados = _resultados;
    final buscando = _busqueda.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kFondo,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kTexto),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Registrar comida',
          style: TextStyle(fontSize: 18, color: kTexto),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),

              // Encabezado
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: kIconoFondo,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.search, size: 34, color: kLima),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                '¿Qué vas a registrar?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: kTexto),
              ),
              const SizedBox(height: 18),

              // Buscador
              TextField(
                controller: _controlador,
                cursorColor: kLima,
                style: const TextStyle(color: kTexto),
                textInputAction: TextInputAction.search,
                onChanged: (valor) => setState(() => _busqueda = valor),
                decoration: InputDecoration(
                  hintText: 'Buscar alimento...',
                  hintStyle: const TextStyle(color: kMuted, fontSize: 14),
                  filled: true,
                  fillColor: kSuperficie,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  suffixIcon: buscando
                      ? IconButton(
                          icon: const Icon(Icons.close, color: kMuted),
                          onPressed: () {
                            _controlador.clear();
                            setState(() => _busqueda = '');
                          },
                        )
                      : const Icon(Icons.search, color: kMuted),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: kBorde),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: kBorde),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: kLima),
                  ),
                ),
              ),
              const SizedBox(height: 22),

              // Sección
              Text(
                buscando ? 'Resultados' : 'Alimentos recientes',
                style: const TextStyle(fontSize: 13, color: kMuted),
              ),
              const SizedBox(height: 6),

              // Lista
              Expanded(
                child: resultados.isEmpty
                    ? _sinResultados(_busqueda.trim())
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: resultados.length,
                        itemBuilder: (context, i) =>
                            _filaAlimento(resultados[i], () => _seleccionar(resultados[i])),
                      ),
              ),

              // Escanear código
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _escanearCodigo,
                icon: const Icon(Icons.photo_camera_outlined, color: kLima),
                label: const Text(
                  'Escanear código',
                  style: TextStyle(color: kTexto, fontSize: 15),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: kSuperficie,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: kBorde),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceNav,
        onTap: (i) => setState(() => _indiceNav = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: kFondo,
        selectedItemColor: kLima,
        unselectedItemColor: kMuted,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Registro'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Estadísticas'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Widgets auxiliares
// ─────────────────────────────────────────────────────────────
Widget _filaAlimento(Alimento alimento, VoidCallback onTap) {
  return ListTile(
    onTap: onTap,
    contentPadding: EdgeInsets.zero,
    title: Text(
      alimento.nombre,
      style: const TextStyle(color: kTexto, fontSize: 16),
    ),
    subtitle: Text(
      '${alimento.porcion} · ${alimento.kcal} kcal',
      style: const TextStyle(color: kMuted, fontSize: 12),
    ),
    trailing: const Icon(Icons.chevron_right, color: kMuted),
  );
}

Widget _sinResultados(String consulta) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'No encontramos "$consulta"',
        style: const TextStyle(color: kTexto, fontSize: 15),
      ),
      const SizedBox(height: 6),
      const Text(
        'Escanea el código o créalo manualmente.',
        style: TextStyle(color: kMuted, fontSize: 13),
      ),
    ],
  );
}
