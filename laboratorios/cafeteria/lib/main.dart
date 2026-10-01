import 'package:flutter/material.dart';

void main() => runApp(const CafeteriaApp());

class CafeteriaApp extends StatelessWidget {
  const CafeteriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi pedido',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF6F4E37), // café
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MiPedidoPage(),
    );
  }
}

/// Datos de un producto del menú.
class Producto {
  const Producto({
    required this.nombre,
    required this.precio,
    required this.icono,
  });

  final String nombre;
  final double precio;
  final IconData icono;
}

class MiPedidoPage extends StatefulWidget {
  const MiPedidoPage({super.key});

  @override
  State<MiPedidoPage> createState() => _MiPedidoPageState();
}

class _MiPedidoPageState extends State<MiPedidoPage> {
  static const List<Producto> _productos = [
    Producto(nombre: 'Café', precio: 10.00, icono: Icons.coffee),
    Producto(nombre: 'Sándwich', precio: 25.00, icono: Icons.lunch_dining),
    Producto(nombre: 'Jugo', precio: 12.00, icono: Icons.local_drink),
  ];

  // Una cantidad por producto, en el mismo orden. Todas inician en 0.
  final List<int> _cantidades = List.filled(_productos.length, 0);

  // Total = suma de precio × cantidad de cada producto.
  double get _total {
    double total = 0;
    for (var i = 0; i < _productos.length; i++) {
      total += _productos[i].precio * _cantidades[i];
    }
    return total;
  }

  void _sumar(int i) {
    setState(() => _cantidades[i]++);
  }

  void _restar(int i) {
    if (_cantidades[i] == 0) return; // nunca permite negativos
    setState(() => _cantidades[i]--);
  }

  void _vaciarPedido() {
    setState(() => _cantidades.fillRange(0, _cantidades.length, 0));
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mi pedido',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filas de productos
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                itemCount: _productos.length,
                separatorBuilder: (context, index) =>
                    const Divider(height: 32),
                itemBuilder: (context, i) => ProductoPedido(
                  nombre: _productos[i].nombre,
                  precio: _productos[i].precio,
                  icono: _productos[i].icono,
                  cantidad: _cantidades[i],
                  onSumar: () => _sumar(i),
                  onRestar: () => _restar(i),
                ),
              ),
            ),

            // Pie: total y botón Vaciar pedido
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: tema.dividerColor)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: tema.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Q${_total.toStringAsFixed(2)}',
                        style: tema.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _vaciarPedido,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Vaciar pedido'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFD7263D),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(52),
                      shape: const StadiumBorder(),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Fila reutilizable: ícono, nombre, precio unitario y controles
/// -1 / cantidad / +1. No guarda estado propio: recibe los datos y las
/// acciones de los botones como parámetros.
class ProductoPedido extends StatelessWidget {
  const ProductoPedido({
    super.key,
    required this.nombre,
    required this.precio,
    required this.icono,
    required this.cantidad,
    required this.onSumar,
    required this.onRestar,
  });

  final String nombre;
  final double precio;
  final IconData icono;
  final int cantidad;
  final VoidCallback onSumar;
  final VoidCallback onRestar;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Row(
      children: [
        // Recuadro con ícono en lugar de fotografía
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: tema.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icono, size: 36, color: tema.colorScheme.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(nombre, style: tema.textTheme.titleMedium),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Q${precio.toStringAsFixed(2)}',
                    style: tema.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  _ControlCantidad(
                    nombre: nombre,
                    cantidad: cantidad,
                    onSumar: onSumar,
                    onRestar: onRestar,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Píldora gris con  −  cantidad  +
class _ControlCantidad extends StatelessWidget {
  const _ControlCantidad({
    required this.nombre,
    required this.cantidad,
    required this.onSumar,
    required this.onRestar,
  });

  final String nombre;
  final int cantidad;
  final VoidCallback onSumar;
  final VoidCallback onRestar;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onRestar,
            icon: const Icon(Icons.remove, size: 20),
            tooltip: 'Quitar $nombre',
            visualDensity: VisualDensity.compact,
          ),
          SizedBox(
            width: 28,
            child: Text(
              '$cantidad',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            onPressed: onSumar,
            icon: const Icon(Icons.add, size: 20),
            tooltip: 'Agregar $nombre',
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}