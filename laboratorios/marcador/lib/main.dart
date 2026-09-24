import 'package:flutter/material.dart';

void main() => runApp(const MarcadorApp());

class MarcadorApp extends StatelessWidget {
  const MarcadorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marcador Deportivo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const MarcadorPage(),
    );
  }
}

class MarcadorPage extends StatefulWidget {
  const MarcadorPage({super.key});

  @override
  State<MarcadorPage> createState() => _MarcadorPageState();
}

class _MarcadorPageState extends State<MarcadorPage> {
  static const String equipoA = 'Equipo A';
  static const String equipoB = 'Equipo B';

  // Estado local: solo se guardan los puntos.
  int puntosA = 0;
  int puntosB = 0;

  void sumarA() => setState(() => puntosA++);
  void sumarB() => setState(() => puntosB++);

  void restarA() {
    if (puntosA > 0) setState(() => puntosA--);
  }

  void restarB() {
    if (puntosB > 0) setState(() => puntosB--);
  }

  void reiniciar() {
    setState(() {
      puntosA = 0;
      puntosB = 0;
    });
  }

  // El mensaje se calcula a partir de los puntos.
  String get mensaje {
    if (puntosA == puntosB) return 'Empate';
    return puntosA > puntosB ? 'Va ganando $equipoA' : 'Va ganando $equipoB';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marcador Deportivo'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _tarjetaEquipo(
                      nombre: equipoA,
                      puntos: puntosA,
                      ganando: puntosA > puntosB,
                      onSumar: sumarA,
                      onRestar: restarA,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _tarjetaEquipo(
                      nombre: equipoB,
                      puntos: puntosB,
                      ganando: puntosB > puntosA,
                      onSumar: sumarB,
                      onRestar: restarB,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                mensaje,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: reiniciar,
                icon: const Icon(Icons.refresh),
                label: const Text('Reiniciar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tarjetaEquipo({
    required String nombre,
    required int puntos,
    required bool ganando,
    required VoidCallback onSumar,
    required VoidCallback onRestar,
  }) {
    // Verde si va ganando; gris neutro si pierde o hay empate.
    final Color fondo = ganando ? Colors.green : Colors.grey.shade300;
    final Color texto = ganando ? Colors.white : Colors.black87;

    return Card(
      color: fondo,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              nombre,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: texto,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$puntos',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: texto,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onRestar,
                    style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
                    child: const Text('−1'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onSumar,
                    style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
                    child: const Text('+1'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}