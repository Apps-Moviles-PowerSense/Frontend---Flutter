class Alert {
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

  Alert({
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
}