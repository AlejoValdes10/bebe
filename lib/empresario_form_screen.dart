import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'styles.dart';
import 'firebase_service.dart';
import 'package:logger/logger.dart';

class EmpresarioFormScreen extends StatefulWidget {
  const EmpresarioFormScreen({super.key});

  @override
  EmpresarioFormScreenState createState() => EmpresarioFormScreenState();
}

class EmpresarioFormScreenState extends State<EmpresarioFormScreen> {
  late VideoPlayerController _controller;
  final Logger _logger = Logger();
  final FirebaseService _firebaseService = FirebaseService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  String? tipoIdentificacion; // Guardará la opción seleccionada en el dropdown

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/inicio3.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.play();
      }).catchError((e) {
        _logger.e("Error al cargar el video: $e");
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: _controller.value.isInitialized
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: AppStyles.containerDecoration,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedOpacity(
                      opacity: 1.0,
                      duration: const Duration(seconds: 2),
                      child: Image.asset(
                        'assets/ff.png',
                        height: 100,
                      ),
                    ),
                    const SizedBox(height: 10),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(seconds: 1),
                      style: AppStyles.titleTextStyle.copyWith(
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                      child: const Text('EMPRESARIO'),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(nameController, 'Nombre del Empresario'),
                    const SizedBox(height: 10),
                    _buildTextField(emailController, 'Correo', keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 10),
                    _buildTextField(passwordController, 'Contraseña', obscureText: true),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      items: const [
                        DropdownMenuItem(value: 'Cédula', child: Text('Cédula')),
                        DropdownMenuItem(value: 'Cédula Extranjera', child: Text('Cédula Extranjera')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          tipoIdentificacion = value;
                        });
                      },
                      decoration: AppStyles.textFieldDecoration('Tipo de identificación'),
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(numberController, 'Número', keyboardType: TextInputType.number),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _registrarEmpresario,
                      style: AppStyles.elevatedButtonStyle,
                      child: const Text("Enviar", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      {bool obscureText = false, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: AppStyles.textFieldDecoration(hintText),
    );
  }

  // Método para registrar el empresario en Firebase
  Future<void> _registrarEmpresario() async {
    String nombre = nameController.text.trim();
    String correo = emailController.text.trim();
    String contraseña = passwordController.text.trim();
    String numIdentificacion = numberController.text.trim();

    if (nombre.isEmpty || correo.isEmpty || contraseña.isEmpty || tipoIdentificacion == null || numIdentificacion.isEmpty) {
      _mostrarMensaje('Por favor, llena todos los campos.');
      return;
    }

    try {
      await _firebaseService.guardarEmpresario(
        nombre: nombre,
        correo: correo,
        contraseña: contraseña,
        tipoIdentificacion: tipoIdentificacion!,
        numIdentificacion: numIdentificacion,
      );

      _mostrarMensaje('✅ Empresario registrado con éxito.');
      _limpiarCampos();
    } catch (e) {
      _mostrarMensaje('❌ Error al registrar: $e');
    }
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  void _limpiarCampos() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    numberController.clear();
    setState(() {
      tipoIdentificacion = null;
    });
  }
}
