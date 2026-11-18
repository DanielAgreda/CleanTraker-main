import 'dart:convert';

class RouteAddressModel {
  final String id;
  final String street;
  final String zone;
  final String distanceKm;
  final int estimatedMinutes;
  final String scheduleInfo;

  RouteAddressModel({
    required this.id,
    required this.street,
    required this.zone,
    required this.distanceKm,
    required this.estimatedMinutes,
    required this.scheduleInfo,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'street': street,
        'zone': zone,
        'distanceKm': distanceKm,
        'estimatedMinutes': estimatedMinutes,
        'scheduleInfo': scheduleInfo,
      };

  factory RouteAddressModel.fromMap(Map<String, dynamic> map) => RouteAddressModel(
        id: map['id'] ?? '',
        street: map['street'] ?? '',
        zone: map['zone'] ?? '',
        distanceKm: map['distanceKm'] ?? '2,4 km',
        estimatedMinutes: map['estimatedMinutes'] ?? 12,
        scheduleInfo: map['scheduleInfo'] ?? 'Lunes, Miércoles y Viernes • 7:00 PM',
      );

  String toJson() => json.encode(toMap());
  factory RouteAddressModel.fromJson(String source) =>
      RouteAddressModel.fromMap(json.decode(source));
}
