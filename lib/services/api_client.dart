import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../app/config.dart';

/// Thrown for any failed API call. `message` is always safe to show directly
/// to the user (SRS: "Submission flows must never silently fail").
class ApiException implements Exception {
  ApiException(this.message, {this.code = 'UNKNOWN', this.statusCode});

  final String message;
  final String code;
  final int? statusCode;

  @override
  String toString() => message;
}

/// Thin wrapper around the shared Chekkam backend (see ../chekkam-backend).
/// Every method throws [ApiException] with a plain-language message on
/// failure rather than a raw network/parse error, per the brand guide's
/// "calm, action-oriented" voice principle.
class ApiClient {
  ApiClient({http.Client? client, this.accessToken, this.languageCode = 'en'})
    : _client = client ?? http.Client();

  final http.Client _client;
  final String? accessToken;
  final String languageCode;

  static const _timeout = Duration(seconds: 15);

  String get _language => languageCode == 'fr' ? 'fr' : 'en';
  String get _connectionErrorMessage => _language == 'fr'
      ? 'Impossible de joindre le serveur Chekkam. Vérifiez votre connexion et réessayez.'
      : 'Could not reach the Chekkam server. Check your connection and try again.';
  String get _unexpectedResponseMessage => _language == 'fr'
      ? 'Le serveur a renvoyé une réponse inattendue.'
      : 'The server returned an unexpected response.';
  String get _genericErrorMessage => _language == 'fr'
      ? 'Une erreur est survenue. Veuillez réessayer.'
      : 'Something went wrong. Please try again.';

  Uri _uri(String path, [Map<String, String>? query]) {
    final queryWithLanguage = {if (query != null) ...query, 'lang': _language};
    return Uri.parse(
      '${AppConfig.apiBaseUrl}$path',
    ).replace(queryParameters: queryWithLanguage);
  }

  Map<String, String> get _jsonHeaders => {
    'Content-Type': 'application/json',
    'Accept-Language': _language,
    if (accessToken != null) 'Authorization': 'Bearer $accessToken',
  };

  /// FR-010: submit suspicious text/link content and get back the AI risk result.
  Future<Map<String, dynamic>> submitReport({
    required String contentType,
    String? rawContent,
    String? fileUrl,
    String channel = 'mobile',
    String? language,
  }) {
    return _post('/api/reports', {
      'content_type': contentType,
      'raw_content': ?rawContent,
      'file_url': ?fileUrl,
      'channel': channel,
      'language': language ?? _language,
    });
  }

  Future<Map<String, dynamic>> getReport(String id) => _get('/api/reports/$id');

  /// FR-043: verify by scanned QR payload, typed verification ID, or PIN.
  Future<Map<String, dynamic>> verifyDocumentById(String verificationId) {
    return _get(
      '/api/documents/verify/$verificationId',
      query: const {'channel': 'mobile'},
    );
  }

  /// FR-043: verify by an uploaded photo/file of the document (hash comparison).
  Future<Map<String, dynamic>> verifyDocumentUpload({
    required List<int> fileBytes,
    required String filename,
    String? verificationId,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        _uri('/api/documents/verify-upload'),
      );
      if (accessToken != null) {
        request.headers['Authorization'] = 'Bearer $accessToken';
      }
      request.headers['Accept-Language'] = _language;
      request.files.add(
        http.MultipartFile.fromBytes('file', fileBytes, filename: filename),
      );
      request.fields['channel'] = 'mobile';
      request.fields['language'] = _language;
      if (verificationId != null && verificationId.isNotEmpty) {
        request.fields['verification_id'] = verificationId;
      }

      final streamed = await _client.send(request).timeout(_timeout);
      final response = await http.Response.fromStream(streamed);
      return _handle(response);
    } on SocketException {
      throw ApiException(_connectionErrorMessage, code: 'NETWORK_ERROR');
    } on http.ClientException {
      throw ApiException(_connectionErrorMessage, code: 'NETWORK_ERROR');
    }
  }

  Future<Map<String, dynamic>> listPublicAlerts() => _get('/api/public-alerts');

  Future<Map<String, dynamic>> _get(
    String path, {
    Map<String, String>? query,
  }) async {
    try {
      final response = await _client
          .get(_uri(path, query), headers: _jsonHeaders)
          .timeout(_timeout);
      return _handle(response);
    } on SocketException {
      throw ApiException(_connectionErrorMessage, code: 'NETWORK_ERROR');
    } on http.ClientException {
      throw ApiException(_connectionErrorMessage, code: 'NETWORK_ERROR');
    }
  }

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _client
          .post(_uri(path), headers: _jsonHeaders, body: jsonEncode(body))
          .timeout(_timeout);
      return _handle(response);
    } on SocketException {
      throw ApiException(_connectionErrorMessage, code: 'NETWORK_ERROR');
    } on http.ClientException {
      throw ApiException(_connectionErrorMessage, code: 'NETWORK_ERROR');
    }
  }

  Map<String, dynamic> _handle(http.Response response) {
    dynamic decoded;
    try {
      decoded = response.body.isEmpty
          ? <String, dynamic>{}
          : jsonDecode(response.body);
    } on FormatException {
      throw ApiException(
        _unexpectedResponseMessage,
        statusCode: response.statusCode,
      );
    }

    if (decoded is! Map<String, dynamic>) {
      throw ApiException(
        _unexpectedResponseMessage,
        statusCode: response.statusCode,
      );
    }
    final body = decoded;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    final error = body['error'] as Map<String, dynamic>?;
    throw ApiException(
      error?['message'] as String? ?? _genericErrorMessage,
      code: error?['code'] as String? ?? 'UNKNOWN',
      statusCode: response.statusCode,
    );
  }
}
