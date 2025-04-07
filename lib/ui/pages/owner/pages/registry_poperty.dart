import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../domain/controllers/landlord_controller.dart';
import '../../../colors/colors.dart';

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
  final TextEditingController habitacionesController = TextEditingController();
  bool disponible = false;
  String? selectedCategory;
  List<String> selectedVentajas = [];

  final LandlordController _controller = Get.put(LandlordController());

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secundary,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dirección
              _buildLabel("Dirección"),
              _buildTextField(
                  direccionController, "La dirección es obligatoria"),

              // Ventajas
              _buildLabel("Ventajas"),
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
                          List<String> newList = List.from(selectedVentajas);
                          selected
                              ? newList.add(ventaja)
                              : newList.remove(ventaja);
                          selectedVentajas = newList;
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

              // Categoría
              const SizedBox(height: 10),
              _buildLabel("Categoría"),
              _buildDropdown(),

              // Precio
              _buildLabel("Precio (\$)"),
              _buildTextField(priceController, "El precio es obligatorio",
                  isNumeric: true),

              // Descripción
              _buildLabel("Descripción"),
              _buildTextField(
                  descripcionController, "La descripción es obligatoria",
                  maxLines: 3),

              // Número de habitaciones
              _buildLabel("Número de habitaciones"),
              _buildTextField(habitacionesController,
                  "El número de habitaciones es obligatorio",
                  isNumeric: true),

              // Disponibilidad
              _buildLabel("Disponibilidad"),
              SwitchListTile(
                title: Text("Disponible", style: GoogleFonts.saira(fontSize: 16)),
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
                      bool success = await _controller.createAccommodation(
                        direccion: direccionController.text,
                        fotos: [],
                        ventajas: selectedVentajas,
                        price: int.parse(priceController.text),
                        descripcion: descripcionController.text,
                        numeroHabitaciones:
                            int.parse(habitacionesController.text),
                        disponible: disponible,
                        categoria: selectedCategory ?? "",
                      );
                      if (success) {
                        Get.offNamed(
                            '/properties'); // Redirige a LandlordPage
                      } else {
                        Get.snackbar(
                            "Éxito", "Alojamiento registrado correctamente",
                            backgroundColor: Colors.green,
                            colorText: Colors.white);
                      }
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

  Widget _buildTextField(TextEditingController controller, String errorText,
      {bool isNumeric = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: AppColors.primary)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: AppColors.primary)),
      ),
      validator: (value) => (value?.isEmpty ?? true) ? errorText : null,
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
          prefixIcon: const Icon(
            Icons.category,
            color: AppColors.primary,
          ),
          labelText: "Categoría",
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

