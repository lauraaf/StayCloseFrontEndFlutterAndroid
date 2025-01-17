import 'package:flutter_application_1/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:math';

class Googleauthservices {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '44657891689-3sh4vl7auf5ek279ar5ht1e4j1kkremj.apps.googleusercontent.com', // Reemplaza con tu Client ID
    scopes: [
      'email'
    ],
  );

  // Funció per generar la contrasenya aleatòria
  String generateRandomPassword({int length = 12}) {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#\$%^&*()_+-=[]{}|;:,.<>?';
    Random random = Random();
    return List.generate(length, (index) => characters[random.nextInt(characters.length)]).join();
  }

  Future<GoogleSignInAccount?> signIn() async {
    try {
      return await _googleSignIn.signIn();
    } catch (error) {
      print("Error en Google Sign-In: $error");
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  Future<UserModel?> signInWithGooggle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // Usuario cancela

      // Generar una contrasenya aleatòria
      final randomPassword = generateRandomPassword();

      // Obtenim les dades pel model del usuari
      final user = UserModel(
        username: googleUser.email.split('@')[0],
        name: googleUser.displayName ?? 'Usuario Google',
        email: googleUser.email,
        password: randomPassword, // La contrasenya aleatòria generada
        actualUbication: [],
        admin: true,
        avatar: '',
        home: ''
      );
      return user;
    } catch (error) {
      print("Error al registrar-te amb Google: $error");
      return null;
    }
  }
}