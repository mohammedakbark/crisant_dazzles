class CreatedAt {
  DateTime date;
  int timezoneType;
  String timezone;

  CreatedAt({
    required this.date,
    required this.timezoneType,
    required this.timezone,
  });

  factory CreatedAt.fromJson(Map<String, dynamic> json) => CreatedAt(
        date: DateTime.parse(json["date"]??''),
        timezoneType: json["timezone_type"] ?? 0,
        timezone: json["timezone"] ?? "N/A",
      );

  Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
        "timezone_type": timezoneType,
        "timezone": timezone,
      };
}
