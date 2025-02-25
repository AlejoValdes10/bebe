import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<String> favoriteEvents = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fiesta Finder")),
      body: _getScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  Widget _getScreen() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeScreen();
      case 1:
        return _buildFavoritesScreen();
      case 2:
        setState(() => _selectedIndex = 0);
        return _buildHomeScreen();
      case 3:
        return _buildProfileScreen();
      default:
        return _buildHomeScreen();
    }
  }

  Widget _buildHomeScreen() {
    List<String> events = List.generate(16, (index) => 'Evento $index');
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: events.length,
        itemBuilder: (context, index) {
          String event = events[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                if (favoriteEvents.contains(event)) {
                  favoriteEvents.remove(event);
                } else {
                  favoriteEvents.add(event);
                }
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: favoriteEvents.contains(event)
                    ? Colors.purple.withOpacity(0.7)
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Text(event)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFavoritesScreen() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: favoriteEvents.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: Text(favoriteEvents[index], style: TextStyle(color: Colors.white))),
          );
        },
      ),
    );
  }

  Widget _buildProfileScreen() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
          ),
          const SizedBox(height: 20),
          _buildTextField('Nombre', 'John Smith'),
          const SizedBox(height: 10),
          _buildTextField('Correo', 'john.smith@example.com'),
          const SizedBox(height: 10),
          _buildTextField('Contraseña', '********', obscureText: true),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Actualizar Información'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String value, {bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: value,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
