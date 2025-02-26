import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Map<String, String>> events = [
    {"name": "Fiesta Electrónica", "image": "assets/fiesta_electronica.jpg", "localidad": "Chapinero", "fecha": "2025-03-01"},
    {"name": "Noche de Salsa", "image": "assets/noche_salsa.jpg", "localidad": "Usaquén", "fecha": "2025-03-05"},
    {"name": "Rock en Vivo", "image": "assets/rock_en_vivo.jpg", "localidad": "Centro", "fecha": "2025-03-10"},
    {"name": "Festival de Reggaetón", "image": "assets/festival_reggaeton.jpg", "localidad": "Suba", "fecha": "2025-03-15"},
    {"name": "Fiesta de los 80s", "image": "assets/fiesta_80s.jpg", "localidad": "Kennedy", "fecha": "2025-03-20"},
  ];

  List<Map<String, String>> filteredEvents = [];
  List<Map<String, String>> favoriteEvents = [];
  TextEditingController searchController = TextEditingController();
  String selectedFilter = "Todos";
  String selectedDate = "Todas";
  List<String> localidades = ["Todos", "Chapinero", "Usaquén", "Centro", "Suba", "Kennedy"];
  List<String> fechas = ["Todas", "2025-03-01", "2025-03-05", "2025-03-10", "2025-03-15", "2025-03-20"];

  @override
  void initState() {
    super.initState();
    filteredEvents = events;
    searchController.addListener(_filterEvents);
  }

  void _filterEvents() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredEvents = events.where((event) {
        return event["name"]!.toLowerCase().contains(query) &&
            (selectedFilter == "Todos" || event["localidad"] == selectedFilter) &&
            (selectedDate == "Todas" || event["fecha"] == selectedDate);
      }).toList();
    });
  }

  void _toggleFavorite(Map<String, String> event) {
    setState(() {
      if (favoriteEvents.contains(event)) {
        favoriteEvents.remove(event);
      } else {
        favoriteEvents.add(event);
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fiesta Finder")),
      body: Column(
        children: [
          const CircleAvatar(radius: 50, backgroundImage: AssetImage('assets/user.png')),
          const SizedBox(height: 10),
          const Text("Usuario", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Buscar evento...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(child: _buildScreenContent()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _buildScreenContent() {
    if (_selectedIndex == 1) {
      return _buildFavoriteScreen();
    } else {
      return _buildHomeScreen();
    }
  }

  Widget _buildHomeScreen() {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: filteredEvents.length,
      itemBuilder: (context, index) {
        var event = filteredEvents[index];
        return _buildEventCard(event);
      },
    );
  }

  Widget _buildFavoriteScreen() {
    return favoriteEvents.isEmpty
        ? Center(child: Text("No hay eventos favoritos"))
        : GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: favoriteEvents.length,
            itemBuilder: (context, index) {
              var event = favoriteEvents[index];
              return _buildEventCard(event);
            },
          );
  }

  Widget _buildEventCard(Map<String, String> event) {
    bool isFavorite = favoriteEvents.contains(event);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EventDetailScreen(event: event)),
        );
      },
      child: Card(
        child: Column(
          children: [
            Expanded(child: Image.asset(event["image"]!, fit: BoxFit.cover)),
            Text(event["name"]!, style: TextStyle(fontWeight: FontWeight.bold)),
            Text("${event["localidad"]} - ${event["fecha"]}"),
            IconButton(
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : Colors.grey),
              onPressed: () => _toggleFavorite(event),
            ),
          ],
        ),
      ),
    );
  }
}

class EventDetailScreen extends StatelessWidget {
  final Map<String, String> event;
  const EventDetailScreen({required this.event});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event["name"]!)),
      body: Center(child: Text("Detalles del evento")),
    );
  }
}
