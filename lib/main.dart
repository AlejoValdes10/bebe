import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'styles.dart'; // Asegúrate de que la ruta sea correcta

// Pantallas adicionales
import 'home_screen.dart';
import 'empresario_form_screen.dart'; // Importamos el formulario de empresario

// Importar logger para mejorar el manejo de logs en lugar de print
import 'package:logger/logger.dart';

void main() {
  runApp(const FiestaFinderApp());
}

class FiestaFinderApp extends StatelessWidget {
  const FiestaFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const FiestaFinderScreen(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Definir las rutas
      routes: {
        '/home': (context) => const HomeScreen(),
        '/empresario': (context) => const EmpresarioFormScreen(),
      },
    );
  }
}

class FiestaFinderScreen extends StatefulWidget {
  const FiestaFinderScreen({super.key});

  @override
  FiestaFinderScreenState createState() => FiestaFinderScreenState();
}

class FiestaFinderScreenState extends State<FiestaFinderScreen> {
  late VideoPlayerController _controller;

  // Crear instancia del logger
  final Logger _logger = Logger();

  @override
void initState() {
  super.initState();

  // Inicializa el controlador de video
  _controller = VideoPlayerController.asset('assets/inicio3.mp4')
    ..initialize().then((_) {
      if (mounted) {
        setState(() {}); // Actualiza la interfaz una vez que el video se haya inicializado
        _controller.setLooping(true); // Establece el video para que se repita
        _controller.play(); // Reproduce el video automáticamente
      }
    }).catchError((e) {
      // Usar el logger para imprimir el error en lugar de print
      _logger.e("Error al cargar el video: $e");
    });
}

@override
void dispose() {
  _controller.dispose(); // Asegúrate de liberar los recursos al salir
  super.dispose();
}

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo del video
          Positioned.fill(
            child: _controller.value.isInitialized
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller), // Muestra el video aquí
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
          // Aquí va el contenido principal
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: AppStyles.containerDecoration,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo o imagen
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
                      child: const Text('FIESTA FINDER'),
                    ),
                    const SizedBox(height: 20),
                    // Campos de texto
                    _buildTextField(nameController, 'Nombre'),
                    const SizedBox(height: 10),
                    _buildTextField(emailController, 'Correo', keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 10),
                    _buildTextField(passwordController, 'Contraseña', obscureText: true),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      items: const [
                        DropdownMenuItem(value: 'opcion1', child: Text('Cédula')),
                        DropdownMenuItem(value: 'opcion2', child: Text('Cédula Extranjera')),
                      ],
                      onChanged: (value) {},
                      decoration: AppStyles.textFieldDecoration('Selecciona...'),
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(numberController, 'Número', keyboardType: TextInputType.number),
                    const SizedBox(height: 20),
                    // Botones para navegar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildElevatedButton('INICIAR', '/home'), // Navegar a HomeScreen
                        _buildElevatedButton('EMPRESARIO', '/empresario'), // Navegar a EmpresarioFormScreen
                      ],
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

  Widget _buildTextField(TextEditingController controller, String hintText, {bool obscureText = false, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: AppStyles.textFieldDecoration(hintText),
    );
  }

  Widget _buildElevatedButton(String text, String route) {
    return ElevatedButton(
      onPressed: () {
        // Navegar a la ruta usando Navigator.pushReplacement para evitar mantener el estado anterior
        Navigator.pushReplacementNamed(context, route);
      },
      style: AppStyles.elevatedButtonStyle,
      child: Text(
        text,
        style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
      ),
    );
  }
}
