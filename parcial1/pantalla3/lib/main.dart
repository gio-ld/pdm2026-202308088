import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}


const kFondo = Color(0xFFF4F5F2);
const kTarjeta = Color(0xFFFFFFFF);
const kBorde = Color(0xFFE6E8E3);
const kIconoFondo = Color(0xFFF1F3EE);
const kTexto = Color(0xFF16181A);
const kMuted = Color(0xFF8B9099);
const kLima = Color(0xFFC8F04B);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: kFondo,
        colorScheme: ColorScheme.fromSeed(seedColor: kLima),
      ),
      home: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Encabezado
              const Center(
                child: Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: kTexto,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Avatar
              Center(child: avatar()),
              const SizedBox(height: 26),

              // Personal info
              Container(
                decoration: BoxDecoration(
                  color: kTarjeta,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: kBorde),
                ),
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text(
                          'Personal info',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: kTexto,
                          ),
                        ),
                        Spacer(),
                        Text(
                          'Edit',
                          style: TextStyle(fontSize: 13, color: kMuted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    filaInfo(
                      icon: Icons.person_outline,
                      label: 'Name',
                      value: 'Terry Melton',
                    ),
                    filaInfo(
                      icon: Icons.mail_outline,
                      label: 'E-mail',
                      value: 'melton89@gmail.com',
                    ),
                    filaInfo(
                      icon: Icons.phone_outlined,
                      label: 'Phone number',
                      value: '+1 201 555-0123',
                    ),
                    filaInfo(
                      icon: Icons.home_outlined,
                      label: 'Home address',
                      value: '70 Rainey Street, Apartment 146, Austin TX 78701',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Account info
              Container(
                decoration: BoxDecoration(
                  color: kTarjeta,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: kBorde),
                ),
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Account info',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: kTexto,
                      ),
                    ),
                    const SizedBox(height: 16),
                    filaInfo(
                      icon: Icons.credit_card,
                      label: 'Debit card',
                      value: '•••• 4568',
                    ),
                    filaInfo(
                      icon: Icons.account_balance_outlined,
                      label: 'Account number',
                      value: '•••• 8842',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 4,
          type: BottomNavigationBarType.fixed,
          backgroundColor: kTarjeta,
          selectedItemColor: kTexto,
          unselectedItemColor: kMuted,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.view_column_outlined),
              label: 'Map',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.swap_horiz),
              label: 'Transfer',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: 'Settings',
            ),
            BottomNavigationBarItem(
              icon: Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  color: kLima,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, size: 16, color: kTexto),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

Widget avatar() {
  return SizedBox(
    width: 112,
    height: 112,
    child: Stack(
      children: [
        Container(
          width: 112,
          height: 112,
          decoration: BoxDecoration(
            color: kIconoFondo,
            shape: BoxShape.circle,
            border: Border.all(color: kBorde, width: 3),
          ),
          child: const Icon(Icons.person, size: 62, color: kMuted),
        ),
        Positioned(
          right: 2,
          bottom: 6,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: kTarjeta,
              shape: BoxShape.circle,
              border: Border.all(color: kBorde),
            ),
            child: const Icon(Icons.edit_outlined, size: 16, color: kTexto),
          ),
        ),
      ],
    ),
  );
}

Widget filaInfo({
  required IconData icon,
  required String label,
  required String value,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: const BoxDecoration(
            color: kIconoFondo,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 17, color: kTexto),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: kMuted)),
              const SizedBox(height: 3),
              Text(value, style: const TextStyle(fontSize: 14, color: kTexto)),
            ],
          ),
        ),
      ],
    ),
  );
}