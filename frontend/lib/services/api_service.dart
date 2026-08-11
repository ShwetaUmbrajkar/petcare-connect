import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Central place for the backend base URL.
/// - Local emulator talking to a backend on your laptop: use 10.0.2.2 (Android emulator alias for localhost)
/// - Real device or FlutLab: replace with your deployed backend URL (e.g. Render/Railway link)
class ApiConfig {
  static const String baseUrl = 'http://10.0.2.2:5000/api';
  // static const String baseUrl = 'https://your-deployed-backend.onrender.com/api';
}

class ApiService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, String>> _headers({bool auth = false}) async {
    final headers = {'Content-Type': 'application/json'};
    if (auth) {
      final token = await _getToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<Map<String, dynamic>> register(
      String name, String email, String password, String phone) async {
    final res = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/auth/register'),
      headers: await _headers(),
      body: jsonEncode({'name': name, 'email': email, 'password': password, 'phone': phone}),
    );
    return _handleResponse(res);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/auth/login'),
      headers: await _headers(),
      body: jsonEncode({'email': email, 'password': password}),
    );
    return _handleResponse(res);
  }

  Future<List<dynamic>> getProviders({String? category, String? search}) async {
    final query = <String, String>{};
    if (category != null && category.isNotEmpty) query['category'] = category;
    if (search != null && search.isNotEmpty) query['search'] = search;

    final uri = Uri.parse('${ApiConfig.baseUrl}/providers').replace(queryParameters: query);
    final res = await http.get(uri, headers: await _headers());
    final data = _handleResponse(res);
    return data is List ? data : [];
  }

  Future<Map<String, dynamic>> getProviderById(String id) async {
    final res = await http.get(Uri.parse('${ApiConfig.baseUrl}/providers/$id'),
        headers: await _headers());
    return _handleResponse(res);
  }

  Future<Map<String, dynamic>> createBooking(
      String providerId, String petName, String date, String time) async {
    final res = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/bookings'),
      headers: await _headers(auth: true),
      body: jsonEncode({'providerId': providerId, 'petName': petName, 'date': date, 'time': time}),
    );
    return _handleResponse(res);
  }

  Future<List<dynamic>> getMyBookings() async {
    final res = await http.get(Uri.parse('${ApiConfig.baseUrl}/bookings/my'),
        headers: await _headers(auth: true));
    final data = _handleResponse(res);
    return data is List ? data : [];
  }

  Future<Map<String, dynamic>> markBookingPaid(String bookingId) async {
    final res = await http.patch(Uri.parse('${ApiConfig.baseUrl}/bookings/$bookingId/pay'),
        headers: await _headers(auth: true));
    return _handleResponse(res);
  }

  dynamic _handleResponse(http.Response res) {
    final decoded = jsonDecode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return decoded;
    }
    throw Exception(decoded['message'] ?? 'Something went wrong');
  }
}
