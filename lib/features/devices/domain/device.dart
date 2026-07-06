class Device {
  final String id;
  final String name;
  final String category;
  final String status;
  final String roomId;
  final String roomName;
  final int watts;

  Device({
    required this.id,
    required this.name,
    required this.category,
    required this.status,
    required this.roomId,
    required this.roomName,
    required this.watts,
  });
}