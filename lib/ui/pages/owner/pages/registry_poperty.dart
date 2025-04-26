import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unistay/domain/controllers/owner_controller.dart';
import 'package:unistay/ui/colors/colors.dart';
import 'package:hugeicons/hugeicons.dart';

class RegistryPopertyPage extends StatefulWidget {
  const RegistryPopertyPage({super.key});

  @override
  State<RegistryPopertyPage> createState() => _RegistryPopertyPageState();
}

class _RegistryPopertyPageState extends State<RegistryPopertyPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  int numeroHabitaciones = 1;
  final TextEditingController nombreController = TextEditingController();
  bool disponible = false;
  String? selectedCategory;
  List<String> selectedVentajas = [];

  final OwnerController _controller = Get.find<OwnerController>();
  final List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  final List<String> ventajas = [
    "Wifi",
    "Seguridad 24 horas",
    "Aparcamiento gratuito",
    "Amueblada y Equipada",
    "Servicios incluidos",
    "Mascotas",
    "Transporte",
    "Entrada privada",
    "Zona comercial"
  ];

  Future<void> _pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null && images.isNotEmpty) {
      setState(() {
        int remainingSlots = 3 - _selectedImages.length;
        if (remainingSlots > 0) {
          final imagesToAdd = images.take(remainingSlots).toList();
          _selectedImages.addAll(imagesToAdd);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Botón subir imágenes
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _pickImages,
                  icon: const Icon(HugeIcons.strokeRoundedImageAdd01,
                      color: Colors.white),
                  label: const Text("Subir imágenes",
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _selectedImages.isNotEmpty
                  ? SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _selectedImages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(_selectedImages[index].path),
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: IconButton(
                                    icon: const Icon(
                                        HugeIcons.strokeRoundedDelete03,
                                        size: 20,
                                        color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _selectedImages.removeAt(index);
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  : SizedBox(
                      height: 150,
                      child: Center(
                        child: Text("No hay imágenes seleccionadas",
                            style: GoogleFonts.saira(
                                fontSize: 16, color: Colors.grey)),
                      ),
                    ),
              _buildLabel("Información del alojamiento"),
              // Nombre del alojamiento
              _buildTextField(
                  nombreController,
                  "El nombre del alojamiento es obligatorio",
                  "Nombre del alojamiento"),

              // Dirección
              _buildTextField(direccionController,
                  "La dirección es obligatoria", "Dirección"),

              // Precio
              _buildTextField(
                  priceController, "El precio es obligatorio", "Precio (\$)",
                  isNumeric: true),

              // Categoría
              const SizedBox(height: 10),
              _buildDropdown(),

              // Ventajas
              _buildLabel("Beneficios"),
              Wrap(
                children: ventajas.map((ventaja) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 4.0),
                    child: ChoiceChip(
                      label: Text(ventaja, style: GoogleFonts.saira()),
                      selected: selectedVentajas.contains(ventaja),
                      onSelected: (selected) {
                        setState(() {
                          selected
                              ? selectedVentajas.add(ventaja)
                              : selectedVentajas.remove(ventaja);
                        });
                      },
                      selectedColor: AppColors.primary,
                      backgroundColor: Colors.grey[200],
                      labelStyle: TextStyle(
                          color: selectedVentajas.contains(ventaja)
                              ? Colors.white
                              : AppColors.primary),
                    ),
                  );
                }).toList(),
              ),
              _buildLabel("Información extra"),
              // Descripción
              _buildTextField(descripcionController,
                  "La descripción es obligatoria", "Descripción",
                  maxLines: 3),

              // Número de habitaciones
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabel("Número de habitaciones"),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              if (numeroHabitaciones > 1) {
                                numeroHabitaciones--;
                              }
                            });
                          },
                          icon: HugeIcon(
                              icon: HugeIcons.strokeRoundedMinusSignSquare,
                              color: Colors.black)),
                      Text(numeroHabitaciones.toString(),
                          style: GoogleFonts.saira(
                              fontSize: 14, color: Colors.black)),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              if (numeroHabitaciones < 5) {
                                numeroHabitaciones++;
                              }
                            });
                          },
                          icon: HugeIcon(
                              icon: HugeIcons.strokeRoundedPlusSignSquare,
                              color: Colors.black)),
                    ],
                  ),
                ],
              ),

              // Disponibilidad
              _buildLabel("Disponibilidad"),
              SwitchListTile(
                title:
                    Text("Disponible", style: GoogleFonts.saira(fontSize: 16)),
                value: disponible,
                onChanged: (bool value) {
                  setState(() {
                    disponible = value;
                  });
                },
                activeColor: AppColors.primary,
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _controller.createAccommodationWithImage(
                        nombre: nombreController.text,
                        direccion: direccionController.text,
                        imageFiles: _selectedImages
                            .map((file) => File(file.path))
                            .toList(), // Aquí se pasa la lista de archivos de imagen
                        ventajas: selectedVentajas,
                        price: int.parse(priceController.text),
                        descripcion: descripcionController.text,
                        numeroHabitaciones: numeroHabitaciones,
                        disponible: disponible,
                        categoria: selectedCategory ?? "",
                      );

                      // Limpiar campos
                      setState(() {
                        nombreController.clear();
                        direccionController.clear();
                        priceController.clear();
                        descripcionController.clear();
                        numeroHabitaciones = 1;
                        disponible = false;
                        selectedCategory = null;
                        selectedVentajas.clear();
                        _selectedImages.clear();
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text("Registrar Alojamiento",
                      style: GoogleFonts.saira(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: Text(text,
          style: GoogleFonts.saira(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primary)),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String errorText, String labelText,
      {bool isNumeric = false, int maxLines = 1}) {
    return Column(
      children: [
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          maxLines: maxLines,
          decoration: InputDecoration(
            label: Text(labelText,
                style: GoogleFonts.saira(color: AppColors.primary)),
            filled: true,
            fillColor: Colors.grey[200],
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
          validator: (value) => (value?.isEmpty ?? true) ? errorText : null,
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.primary),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.primary),
            borderRadius: BorderRadius.circular(10.0),
          ),
          prefixIcon:
              const Icon(Icons.category, color: AppColors.primary, size: 20),
          labelText: "Seleccionar categoría",
          labelStyle: GoogleFonts.saira(
            color: AppColors.primary,
            fontSize: 16,
          ),
        ),
        items: ["Casa Estudio", "Departamento", "Habitación"]
            .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category,
                      style: GoogleFonts.montserrat(fontSize: 15)),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedCategory = value;
          });
        },
        validator: (value) => value == null ? "Selecciona una categoría" : null,
      ),
    );
  }
}
