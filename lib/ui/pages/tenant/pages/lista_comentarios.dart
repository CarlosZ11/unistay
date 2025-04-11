import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../colors/colors.dart';

class ComentariosPage extends StatelessWidget {
  const ComentariosPage({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> dummyComentarios = [
      {
        'nombre': 'Ana Luisa',
        'rating': 4.8,
        'texto': 'Um moderno apartamento em Orlando, completo com cozinha equipada e quartos confortáveis.'
      },
      {
        'nombre': 'Carlos Mendes',
        'rating': 4.6,
        'texto': 'Apartamento bem localizado e muito limpo. Voltarei com certeza!'
      },
      // ... más comentarios
    ];

    String limitarTexto(String texto, int maxPalabras) {
      final palabras = texto.split(' ');
      if (palabras.length <= maxPalabras) return texto;
      return palabras.sublist(0, maxPalabras).join(' ');
    }

    return Scaffold(
      backgroundColor: AppColors.secundary,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Comentarios"),
        titleTextStyle: GoogleFonts.saira(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
        backgroundColor: AppColors.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                ...dummyComentarios.map((comentario) {
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7EDFB),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nombre y calificación
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              comentario['nombre'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  comentario['rating'].toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 3),
                                const Icon(
                                  HugeIcons.strokeRoundedStar,
                                  color: Colors.orange,
                                  size: 16,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          limitarTexto(comentario['texto'], 15),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }).toList()
              ],
            ),
          ),
        ),
      ),
    );
  }
}