import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_links/app_links.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeepLinkHandler {
  static final DeepLinkHandler _instance = DeepLinkHandler._internal();
  factory DeepLinkHandler() => _instance;
  DeepLinkHandler._internal();

  final SupabaseClient _supabase = Supabase.instance.client;
  late AppLinks _appLinks;

  Future<void> initDeepLinkListener() async {
    _appLinks = AppLinks();

    // Escuchar enlaces en segundo plano
    _appLinks.uriLinkStream.listen(
      (Uri? uri) {
        if (uri != null) {
          handleDeepLink(uri);
        }
      },
      onError: (err) {
        debugPrint("❌ Error al procesar deep link: $err");
      },
    );

    // Verificar si la app fue abierta con un deep link inicial
    await _handleInitialDeepLink();
  }

  Future<void> _handleInitialDeepLink() async {
    try {
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        handleDeepLink(initialUri);
      }
    } catch (e) {
      debugPrint("❌ Error obteniendo deep link inicial: $e");
    }
  }

  Future<void> handleDeepLink(Uri uri) async {
      debugPrint("🔗 Deep link recibido: $uri");

      if (uri.scheme == 'unistay' && uri.host == 'password-reset') {
        String? code = uri.queryParameters['code'];  // CAMBIO: Usar 'code' en lugar de 'access_token'
        debugPrint("🔑 Código recibido: $code");

        if (code != null) {
          // Pasamos el código como argumento a la pantalla de restablecimiento
          if (Get.context != null) {
            debugPrint("🛠 Redirigiendo a /ResetPasswordPage...");
            Get.offAllNamed('/ResetPasswordPage', arguments: {"code": code});
          } else {
            debugPrint("⚠️ No hay contexto de navegación disponible. Intentando en 500ms...");
            Future.delayed(const Duration(milliseconds: 500), () {
              if (Get.context != null) {
                Get.offAllNamed('/ResetPasswordPage', arguments: {"code": code});
              } else {
                debugPrint("❌ No se pudo redirigir a /ResetPasswordPage. Contexto aún no disponible.");
              }
            });
          }
        } else {
          debugPrint("⚠️ No se recibió un código válido en el deep link.");
        }
      }
  }

}
