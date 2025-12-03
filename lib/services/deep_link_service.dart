import 'package:app_links/app_links.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:jugaenequipo/main.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  bool _isInitialized = false;

  /// Inicializa el servicio de deep linking
  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;

    _appLinks = AppLinks();

    // Manejar link inicial cuando la app se abre desde un link
    _checkInitialLink();

    // Manejar links cuando la app está abierta o en background
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        try {
          _handleDeepLink(uri);
        } catch (e) {
          if (kDebugMode) {
            debugPrint('Error parsing deep link: $e');
          }
        }
      },
      onError: (err) {
        if (kDebugMode) {
          debugPrint('Deep link error: $err');
        }
      },
    );
  }

  /// Verifica si hay un link inicial cuando la app se abre
  Future<void> _checkInitialLink() async {
    try {
      final uri = await _appLinks.getInitialAppLink();
      if (uri != null) {
        _handleDeepLink(uri);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error checking initial link: $e');
      }
    }
  }

  /// Dispose del servicio
  void dispose() {
    _linkSubscription?.cancel();
    _isInitialized = false;
  }

  /// Maneja el deep link y navega a la pantalla correspondiente
  void _handleDeepLink(Uri uri) {
    if (kDebugMode) {
      debugPrint('Deep link received: $uri');
    }

    final path = uri.path;
    final queryParameters = uri.queryParameters;
    final fragment = uri.fragment;

    // Manejar reset password
    // Soporta diferentes formatos:
    // - https://jugaenequipo.com/recover/{token} (Universal Link)
    // - jugaenequipo://recover/{token} (Custom Scheme)
    // - https://jugaenequipo.com/reset-password?token=xxx (formato alternativo)
    // - jugaenequipo://reset-password?token=xxx (formato alternativo)

    String? token;

    // Formato nuevo: /recover/{token} (token en el path)
    if (path.startsWith('/recover/')) {
      final pathSegments = path.split('/');
      if (pathSegments.length >= 3) {
        token = pathSegments[2]; // El token está después de /recover/
      }
    }
    // Formato alternativo: /reset-password?token=xxx
    else if (path == '/reset-password' ||
        path == '/resetpassword' ||
        path == 'reset-password' ||
        path == 'resetpassword' ||
        uri.host == 'reset-password' ||
        uri.host == 'resetpassword') {
      // Intentar obtener el token de query parameters o fragment
      token = queryParameters['token'] ??
          queryParameters['t'] ??
          (fragment.isNotEmpty && fragment.contains('token=')
              ? fragment.split('token=')[1].split('&')[0]
              : null);
    }

    if (token != null && token.isNotEmpty) {
      _navigateToResetPassword(token);
    } else {
      if (kDebugMode) {
        debugPrint('Reset password link missing token. Path: $path');
      }
    }
  }

  /// Navega a la pantalla de reset password con el token
  void _navigateToResetPassword(String token) {
    final navigator = navigatorKey.currentState;
    if (navigator == null) {
      if (kDebugMode) {
        debugPrint('Navigator not available, will navigate when ready');
      }
      // Si el navigator no está listo, esperamos un poco y lo intentamos de nuevo
      Future.delayed(const Duration(milliseconds: 500), () {
        _navigateToResetPassword(token);
      });
      return;
    }

    // Navegar a la pantalla de reset password con el token
    navigator.pushNamed(
      'reset-password',
      arguments: {'token': token},
    );
  }

  /// Obtiene el link actual (útil para debugging)
  Future<Uri?> getCurrentLink() async {
    try {
      return await _appLinks.getInitialAppLink();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error getting current link: $e');
      }
      return null;
    }
  }
}
