import 'package:equatable/equatable.dart';

// This model holds routine information created by the user
class RoutineModel extends Equatable {
  final String title, description;
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
  List<Object?> get props => [title, description, createdAt, doneSessions];
}

enum RoutineFrequency { hourly, daily, weekly, monthly, yearly }
