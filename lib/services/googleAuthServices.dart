import 'package:flutter_application_1/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Googleauthservices {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '44657891689-3sh4vl7auf5ek279ar5ht1e4j1kkremj.apps.googleusercontent.com', // Reemplaza con tu Client ID
    scopes: [
      'email'
    ],
  );

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
    try{
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // Usuario cancela

      // Obtenims les dades pel model del usuari
      final user = UserModel(
        username: googleUser.email.split('@')[0],
        name: googleUser.displayName ?? 'Usuario Google',
        email: googleUser.email,
        password: '1234567', // La contraseña no se usa en este caso
        actualUbication: [],
        admin: true,
      );
      return user;
    }
    catch(error) {
      print("Error al registrar-te amb Google: $error");
      return null;
    }
  }
}