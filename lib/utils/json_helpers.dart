import 'dart:convert';

/// Extracts an `id` field from an API response body, handling both a
/// top-level object (`{"id": 1, ...}`) and one nested under `data`
/// (`{"data": {"id": 1, ...}}`).
int? extractIdFromResponse(String body) {
  try {
    final decoded = jsonDecode(body);
    if (decoded is Map) {
      final data = decoded['data'];
      if (data is Map && data['id'] != null) {
        return int.tryParse(data['id'].toString());
      }
      if (decoded['id'] != null) {
        return int.tryParse(decoded['id'].toString());
      }
    }
  } catch (_) {}
  return null;
}

/// Finds the item in [list] whose name (via [nameOf]) best matches
/// [target] - exact match (case-insensitive) first, then a loose
/// substring match either way.
T? findByName<T>(List<T> list, String Function(T) nameOf, String target) {
  final normalizedTarget = target.trim().toLowerCase();
  if (normalizedTarget.isEmpty) return null;

  for (final item in list) {
    if (nameOf(item).trim().toLowerCase() == normalizedTarget) return item;
  }
  for (final item in list) {
    final name = nameOf(item).trim().toLowerCase();
    if (name.isEmpty) continue;
    if (name.contains(normalizedTarget) || normalizedTarget.contains(name)) {
      return item;
    }
  }
  return null;
}
