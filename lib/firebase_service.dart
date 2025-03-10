import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para guardar un empresario en Firestore
  Future<void> guardarEmpresario({
    required String nombre,
    required String correo,
    required String contraseña,
    required String tipoIdentificacion,
    required String numIdentificacion,
  }) async {
    try {
      await _firestore.collection('empresas').add({
        'nombre': nombre,
        'correo': correo,
        'contraseña': contraseña, // ⚠️ Se recomienda encriptarla
        'tipo_identificación': tipoIdentificacion,
        'num_identificación': numIdentificacion,
        'fecha_registro': DateTime.now(),
      });
      print('✅ Empresario guardado en Firestore correctamente');
    } catch (e) {
      print('❌ Error al guardar el empresario: $e');
    }
  }
}
