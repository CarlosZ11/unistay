import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:get/get.dart';
import '../../../colors/colors.dart';
import 'package:unistay/domain/controllers/commentcontroller.dart';
import 'package:unistay/domain/models/comment_model.dart';

class ComentariosPage extends StatefulWidget {
  final String idAlojamiento;

  const ComentariosPage({super.key, required this.idAlojamiento});

  @override
  State<ComentariosPage> createState() => _ComentariosPageState();
}

class _ComentariosPageState extends State<ComentariosPage> {
  final TextEditingController _comentarioController = TextEditingController();
  double _rating = 3.0;

  final CommentController _commentController = Get.put(CommentController());

  @override
  void initState() {
    super.initState();

    _commentController.loadCurrentUser();

    // Esperar a que el build termine antes de cargar comentarios
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _commentController.loadComments(widget.idAlojamiento);
    });
  }

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
        automaticallyImplyLeading: false,
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
      body: Obx(() {
        final comments = _commentController.comments;
        final isLoading = _commentController.isLoading.value;
        final currentUser = _commentController.currentUser.value;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LISTA DE COMENTARIOS
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : comments.isEmpty
                        ? const Center(child: Text("Aún no hay comentarios"))
                        : ListView.separated(
                            itemCount: comments.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final CommentModel comentario = comments[index];
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          comentario.nombreUsuario,
                                          style: GoogleFonts.saira(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              comentario.puntuacion
                                                  .toStringAsFixed(1),
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
                                      limitarTexto(comentario.descripcion, 15),
                                      style: GoogleFonts.saira(fontSize: 14),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
              ),

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
                      currentUser != null
                          ? "Hola, ${currentUser.name} ${currentUser.lastname}"
                          : "Hola, usuario",
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
                        onPressed: () async {
                          final texto = _comentarioController.text.trim();
                          if (texto.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Por favor escribe un comentario"),
                                backgroundColor: Colors.black87,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            return;
                          }

                          try {
                            await _commentController.addComment(
                              idAlojamiento: widget.idAlojamiento,
                              descripcion: texto,
                              puntuacion: _rating.toInt(),
                            );

                            _comentarioController.clear();
                            setState(() {
                              _rating = 3;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Comentario enviado"),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          } catch (e) {
                            final errorStr = e.toString();

                            if (errorStr.contains('duplicate key value') &&
                                errorStr.contains('unique constraint')) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Solo puedes comentar una vez sobre este alojamiento",
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text("Error al enviar comentario: $e"),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          }
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
        );
      }),
    );
  }
}
