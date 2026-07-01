import 'package:power_sense/features/alerts/domain/alert.dart';

class AlertDto{
  final String id;
  final String type;
  final String severity;
  final String? deviceId;
  final double? threshold;
  final String message;
  final bool acknowledged;
  final String? acknowledgedAt;
  final String createdAt;
  final String updatedAt;

  AlertDto({
    required this.id,
    required this.type,
    required this.severity,
    this.deviceId,
    this.threshold,
    required this.message,
    required this.acknowledged,
    this.acknowledgedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AlertDto.fromJson(Map<String, dynamic> json) {
    return AlertDto(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      severity: json['severity'] ?? '',
      deviceId: json['deviceId'],
      threshold: json['threshold'] != null ? (json['threshold'] as num).toDouble() : null,
      message: json['message'] ?? '',
      acknowledged: json['acknowledged'] ?? false,
      acknowledgedAt: json['acknowledgedAt'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
  Alert toDomain() {
    return Alert(
      id: id,
      type: type,
      severity: severity,
      deviceId: deviceId,
      threshold: threshold,
      message: message,
      acknowledged: acknowledged,
      acknowledgedAt: acknowledgedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'severity': severity,
      'deviceId': deviceId,
      'threshold': threshold,
      'message': message,
      'acknowledged': acknowledged,
      'acknowledgedAt': acknowledgedAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

}