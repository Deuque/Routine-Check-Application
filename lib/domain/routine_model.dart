import 'package:equatable/equatable.dart';

// This model holds routine information created by the user
class RoutineModel extends Equatable {
  final String title, description;

  // This will be used as the identifier, as every date will be unique
  // and this date will not be changed
  final DateTime createdAt;

  final Set<DateTime> doneSessions;
  final RoutineFrequency frequency;

  const RoutineModel({
    required this.title,
    required this.description,
    required this.createdAt,
    required this.doneSessions,
    required this.frequency,
  });

  RoutineModel copyWith(Set<DateTime> newDoneSessions) {
    return RoutineModel(
      title: title,
      description: description,
      createdAt: createdAt,
      doneSessions: newDoneSessions,
      frequency: frequency,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'frequency': frequency.name,
        'createdAt': createdAt.toIso8601String(),
        'doneSessions': doneSessions.map((e) => e.toIso8601String()).toList(),
      };

  static RoutineModel fromJson(Map<String, dynamic> json) => RoutineModel(
        title: json['title'],
        description: json['description'],
        createdAt: DateTime.parse(json['createdAt']),
        doneSessions:
            List<String>.from(json['doneSessions']).map(DateTime.parse).toSet(),
        frequency: RoutineFrequency.values
            .firstWhere((e) => e.name == json['frequency']),
      );

  @override
  List<Object?> get props =>
      [title, description, createdAt, doneSessions, frequency];
}

enum RoutineFrequency { hourly, daily, weekly, monthly, yearly }
