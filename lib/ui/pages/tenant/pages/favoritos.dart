import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../colors/colors.dart';

class FavoritosInquilinoPage extends StatefulWidget {
  FavoritosInquilinoPage({super.key});

  @override
  State<FavoritosInquilinoPage> createState() => _FavoritosInquilinoPageState();
}

class _FavoritosInquilinoPageState extends State<FavoritosInquilinoPage> {
  final List<Map<String, dynamic>> apartamentos = [
    {
      'imagen': 'https://www.shutterstock.com/image-photo/modern-facade-luxury-house-architecture-600nw-2509552467.jpg', // Cambia por tu imagen real
      'nombre': 'Apartamento em Orlando',
      'ubicacion': 'Orlando, Florida',
      'precio': 'COP\$ 459,0',
      'rating': 4.8,
    },
    {
      'imagen': 'https://www.shutterstock.com/image-photo/modern-facade-luxury-house-architecture-600nw-2509552467.jpg',
      'nombre': 'Apartamento em Orlando',
      'ubicacion': 'Orlando, Florida',
      'precio': 'COP\$ 459,0',
      'rating': 4.8,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: apartamentos.length,
                itemBuilder: (context, index) {
                  final apto = apartamentos[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 8),
                        leading: Image.network(apto['imagen'], width: 80, fit: BoxFit.cover),
                        title: Text(apto['nombre'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(HugeIcons.strokeRoundedLocation05, size: 14, color: AppColors.primary),
                                const SizedBox(width: 4),
                                Text(apto['ubicacion']),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(apto['precio'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(HugeIcons.strokeRoundedDelete02, color: Colors.red, size: 22),
                              onPressed: () {
                                
                              },
                            ),
                            // Icon(HugeIcons.strokeRoundedDelete02, color: Colors.amber, size: 22),
                            // Text(apto['rating'].toString(), style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}