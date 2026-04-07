class AiChatResponse {
  final String answer;
  final String route;
  final List<Map<String, dynamic>> recommendProducts;
  final List<Map<String, dynamic>> sources;

  const AiChatResponse({
    required this.answer,
    required this.route,
    required this.recommendProducts,
    required this.sources,
  });

  static Map<String, dynamic> _asMap(dynamic v) {
    if (v is Map<String, dynamic>) return v;
    if (v is Map) return v.map((k, val) => MapEntry(k.toString(), val));
    return const <String, dynamic>{};
  }

  static List<Map<String, dynamic>> _asListOfMaps(dynamic v) {
    if (v is List) {
      return v.map(_asMap).where((e) => e.isNotEmpty).toList();
    }
    return const <Map<String, dynamic>>[];
  }

  static String _pickString(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final v = map[key];
      if (v is String) return v;
    }
    return '';
  }

  factory AiChatResponse.fromApi(dynamic json) {
    final root = _asMap(json);
    final data = _asMap(root['data']);

    final payload = data.isNotEmpty ? data : root;

    final answer = _pickString(payload, const ['answer', 'reply', 'response']);
    final route = _pickString(payload, const ['route', 'type']);
    final products = _asListOfMaps(
      payload['recommend_products'] ?? payload['recommendProducts'],
    );
    final sources = _asListOfMaps(payload['sources']);

    return AiChatResponse(
      answer: answer,
      route: route,
      recommendProducts: products,
      sources: sources,
    );
  }
}
