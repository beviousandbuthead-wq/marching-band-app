class SetData {
  final String id;
  String name;
  int counts;
  // playerId → Offset (x: -50 to 50 yards, y: 0 to 53.3 yards)
  Map<String, Offset> positions;

  SetData({
    required this.id,
    required this.name,
    this.counts = 16,
    Map<String, Offset>? positions,
  }) : positions = positions ?? {};

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'counts': counts,
        'positions': positions.map(
          (key, value) => MapEntry(key, {'dx': value.dx, 'dy': value.dy}),
        ),
      };

  factory SetData.fromJson(Map<String, dynamic> json) {
    final pos = <String, Offset>{};
    (json['positions'] as Map<String, dynamic>?)?.forEach((key, value) {
      pos[key] = Offset(value['dx'], value['dy']);
    });
    return SetData(
      id: json['id'],
      name: json['name'],
      counts: json['counts'] ?? 16,
      positions: pos,
    );
  }
}
