import 'dart:convert';
import 'dart:io';

import 'package:flutter_bay/core/constants/api_constants.dart';
import 'package:flutter_bay/core/errors/exceptions.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient({
    http.Client? client,
    this.baseUrl = ApiConstants.baseUrl,
  }) : client = client ?? http.Client();
  final http.Client client;
  final String baseUrl;

  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await client
          .get(
            Uri.parse('$baseUrl$endpoint'),
            headers: _getHeaders(),
          )
          .timeout(ApiConstants.timeout);

      return _handleResponse(response) as Map<String, dynamic>;
    } on SocketException {
      throw NetworkException('No internet connection');
    } on TimeoutException {
      throw TimeoutException('Request timeout');
    } catch (e) {
      throw ServerException('Failed to fetch data: $e');
    }
  }

  Future<List<dynamic>> getList(String endpoint) async {
    try {
      final response = await client
          .get(
            Uri.parse('$baseUrl$endpoint'),
            headers: _getHeaders(),
          )
          .timeout(ApiConstants.timeout);

      final data = _handleResponse(response);
      if (data is List) {
        return data;
      } else {
        throw ParseException('Expected list but got ${data.runtimeType}');
      }
    } on SocketException {
      throw NetworkException('No internet connection');
    } on TimeoutException {
      throw TimeoutException('Request timeout');
    } catch (e) {
      throw ServerException('Failed to fetch data: $e');
    }
  }

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        try {
          return json.decode(response.body);
        } catch (e) {
          throw ParseException('Failed to parse response: $e');
        }
      case 400:
        throw ServerException('Bad request', code: '400');
      case 401:
        throw ServerException('Unauthorized', code: '401');
      case 403:
        throw ServerException('Forbidden', code: '403');
      case 404:
        throw ServerException('Not found', code: '404');
      case 500:
        throw ServerException('Internal server error', code: '500');
      default:
        throw ServerException(
          'Server error: ${response.statusCode}',
          code: response.statusCode.toString(),
        );
    }
  }

  void dispose() {
    client.close();
  }
}
