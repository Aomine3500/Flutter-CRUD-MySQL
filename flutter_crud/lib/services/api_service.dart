import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/client.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api/clients';

  Future<List<Client>> fetchClients() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((client) => Client.fromJson(client)).toList();
    } else {
      throw Exception('Failed to load clients');
    }
  }

  Future<void> createClient(Client client) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(client.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create client');
    }
  }

  Future<void> updateClient(Client client) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${client.codeClient}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(client.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update client');
    }
  }

  Future<void> deleteClient(String codeClient) async {
    final response = await http.delete(Uri.parse('$baseUrl/$codeClient'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete client');
    }
  }
}
