import 'package:equatable/equatable.dart';

// This model holds routine information created by the user
class RoutineModel extends Equatable {
  final String title, description;
  final DateTime createdAt;
  final Set<DateTime> doneSessions;

  const RoutineModel({
    required this.title,
    required this.description,
    required this.createdAt,
    required this.doneSessions,
  });

  @override
  List<Object?> get props => [title, description, createdAt, doneSessions];
}
