import 'package:flutter/material.dart';
import 'models/client.dart';
import 'services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter CRUD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ClientListScreen(),
    );
  }
}

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  _ClientListScreenState createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  late Future<List<Client>> futureClients;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureClients = apiService.fetchClients();
  }

  void _showForm(Client? client) {
    final codeClientController =
        TextEditingController(text: client?.codeClient ?? '');
    final nomClientController =
        TextEditingController(text: client?.nomClient ?? '');
    final adresseController =
        TextEditingController(text: client?.adresse ?? '');
    final codePostalController =
        TextEditingController(text: client?.codepostal ?? '');
    final villeController = TextEditingController(text: client?.ville ?? '');
    final telephoneController =
        TextEditingController(text: client?.telephone ?? '');
    final emailController = TextEditingController(text: client?.email ?? '');
    final matriculeController =
        TextEditingController(text: client?.matricule ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(client == null ? 'Add Client' : 'Edit Client'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: codeClientController,
                  decoration: const InputDecoration(labelText: 'Code Client'),
                ),
                TextField(
                  controller: nomClientController,
                  decoration: const InputDecoration(labelText: 'Nom Client'),
                ),
                TextField(
                  controller: adresseController,
                  decoration: const InputDecoration(labelText: 'Adresse'),
                ),
                TextField(
                  controller: codePostalController,
                  decoration: const InputDecoration(labelText: 'Code Postal'),
                ),
                TextField(
                  controller: villeController,
                  decoration: const InputDecoration(labelText: 'Ville'),
                ),
                TextField(
                  controller: telephoneController,
                  decoration: const InputDecoration(labelText: 'Téléphone'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: matriculeController,
                  decoration: const InputDecoration(labelText: 'Matricule'),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (codeClientController.text.isEmpty ||
                    nomClientController.text.isEmpty ||
                    adresseController.text.isEmpty ||
                    codePostalController.text.isEmpty ||
                    villeController.text.isEmpty ||
                    telephoneController.text.isEmpty ||
                    emailController.text.isEmpty ||
                    matriculeController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all fields'),
                    ),
                  );
                  return;
                }

                if (client == null) {
                  // Create
                  await apiService.createClient(Client(
                    codeClient: codeClientController.text,
                    nomClient: nomClientController.text,
                    adresse: adresseController.text,
                    codepostal: codePostalController.text,
                    ville: villeController.text,
                    telephone: telephoneController.text,
                    email: emailController.text,
                    matricule: matriculeController.text,
                  ));
                } else {
                  // Update
                  await apiService.updateClient(Client(
                    codeClient: codeClientController.text,
                    nomClient: nomClientController.text,
                    adresse: adresseController.text,
                    codepostal: codePostalController.text,
                    ville: villeController.text,
                    telephone: telephoneController.text,
                    email: emailController.text,
                    matricule: matriculeController.text,
                  ));
                }
                setState(() {
                  futureClients = apiService.fetchClients();
                });
                Navigator.of(context).pop();
              },
              child: Text(client == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter CRUD'),
      ),
      body: FutureBuilder<List<Client>>(
        future: futureClients,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No clients found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final client = snapshot.data![index];
                return ListTile(
                  title: Text(client.nomClient ?? ''),
                  subtitle: Text(client.ville ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showForm(client),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await apiService.deleteClient(client.codeClient!);
                          setState(() {
                            futureClients = apiService.fetchClients();
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
