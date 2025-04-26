class Validation {
  // Normaliza el texto eliminando espacios innecesarios
  String normalizeText(String text) {
    return text.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  // Validar nombre y apellido (solo letras y espacios, mínimo 2 caracteres)
  bool isValidName(String name) {
    return RegExp(r"^[a-zA-ZÀ-ÿ\s]{2,50}$").hasMatch(name.trim());
  }

  // Validar email
  bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(email);
  }

  // Validar contraseña (mínimo 8 caracteres, al menos una mayúscula, una minúscula, un número y un carácter especial)
  bool isValidPassword(String password) {
    return RegExp(
            r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#\$%\^&\*\-_]).{8,}$')
        .hasMatch(password);
  }

  // Validar teléfono (exactamente 10 dígitos numéricos)
  bool isValidPhone(String phone) {
    return RegExp(r"^\d{10}$").hasMatch(phone);
  }

  // Validar cédula (8-10 dígitos numéricos)
  bool isValidIdentification(String identification) {
    return RegExp(r"^\d{8,10}$").hasMatch(identification);
  }
}
