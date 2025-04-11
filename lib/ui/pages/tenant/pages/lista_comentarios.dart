import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../colors/colors.dart';

class ComentariosPage extends StatefulWidget {
  const ComentariosPage({super.key});

  @override
  State<ComentariosPage> createState() => _ComentariosPageState();
}

class _ComentariosPageState extends State<ComentariosPage> {
  final TextEditingController _comentarioController = TextEditingController();
  double _rating = 3;

  final List<Map<String, dynamic>> dummyComentarios = [
    {
      'nombre': 'Ana Luisa',
      'rating': 4.8,
      'texto':
          'Um moderno apartamento em Orlando, completo com cozinha equipada e quartos confortáveis.'
    },
    {
      'nombre': 'Carlos Mendes',
      'rating': 4.6,
      'texto': 'Apartamento bem localizado e muito limpo. Voltarei com certeza!'
    },
    {
      'nombre': 'Carlos Mendes',
      'rating': 4.6,
      'texto': 'Apartamento bem localizado e muito limpo. Voltarei com certeza!'
    },
    {
      'nombre': 'Carlos Mendes',
      'rating': 4.6,
      'texto': 'Apartamento bem localizado e muito limpo. Voltarei com certeza!'
    },
    {
      'nombre': 'Carlos Mendes',
      'rating': 4.6,
      'texto': 'Apartamento bem localizado e muito limpo. Voltarei com certeza!'
    },
    {
      'nombre': 'Carlos Mendes',
      'rating': 4.6,
      'texto': 'Apartamento bem localizado e muito limpo. Voltarei com certeza!'
    },
    {
      'nombre': 'Carlos Mendes',
      'rating': 4.6,
      'texto': 'Apartamento bem localizado e muito limpo. Voltarei com certeza!'
    },
    {
      'nombre': 'Carlos Mendes',
      'rating': 4.6,
      'texto': 'Apartamento bem localizado e muito limpo. Voltarei com certeza!'
    },
    {
      'nombre': 'Carlos Mendes',
      'rating': 4.6,
      'texto': 'Apartamento bem localizado e muito limpo. Voltarei com certeza!'
    }
  ];

  String limitarTexto(String texto, int maxPalabras) {
    final palabras = texto.split(' ');
    if (palabras.length <= maxPalabras) return texto;
    return palabras.sublist(0, maxPalabras).join(' ') + '...';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secundary,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "Comentarios",
          style: GoogleFonts.saira(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LISTA DE COMENTARIOS con scroll propio
            Expanded(
              child: ListView.separated(
                itemCount: dummyComentarios.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final comentario = dummyComentarios[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7EDFB),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nombre y rating
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              comentario['nombre'],
                              style: GoogleFonts.saira(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  comentario['rating'].toString(),
                                  style: GoogleFonts.saira(
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
                          style: GoogleFonts.saira(fontSize: 14),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // FLECHA DECORATIVA AJUSTADA
            const SizedBox(height: 6),
            const Center(
              child: Icon(
                Icons.expand_more_rounded,
                size: 36,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),

            // FORMULARIO DE COMENTARIO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hola, Mariana Perez",
                    style: GoogleFonts.saira(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Comparte tu experiencia.",
                    style: GoogleFonts.saira(fontSize: 12),
                  ),
                  const SizedBox(height: 10),

                  // ESTRELLAS
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 22,
                        ),
                        onPressed: () {
                          setState(() {
                            _rating = index + 1.0;
                          });
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      );
                    }),
                  ),

                  const SizedBox(height: 8),

                  // CAMPO DE TEXTO
                  TextField(
                    controller: _comentarioController,
                    maxLines: 2,
                    style: GoogleFonts.saira(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: "Escribe tu comentario...",
                      hintStyle: GoogleFonts.saira(color: Colors.grey[600]),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // BOTÓN ENVIAR
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_comentarioController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Por favor escribe un comentario"),
                            ),
                          );
                          return;
                        }

                        print("Comentario: ${_comentarioController.text}");
                        print("Puntuación: $_rating");

                        _comentarioController.clear();
                        setState(() {
                          _rating = 3;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 1,
                      ),
                      child: Text(
                        "Comentar",
                        style: GoogleFonts.saira(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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
