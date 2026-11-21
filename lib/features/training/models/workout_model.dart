import 'exercise_model.dart';

class WorkoutSet {
  final int setNumber;
  final int repetitions;
  final double weightKg;
  final bool isCompleted;

  const WorkoutSet({
    required this.setNumber,
    required this.repetitions,
    required this.weightKg,
    this.isCompleted = false,
  });

  WorkoutSet copyWith({
    int? setNumber,
    int? repetitions,
    double? weightKg,
    bool? isCompleted,
  }) {
    return WorkoutSet(
      setNumber: setNumber ?? this.setNumber,
      repetitions: repetitions ?? this.repetitions,
      weightKg: weightKg ?? this.weightKg,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'set_number': setNumber,
      'repetitions': repetitions,
      'weight_kg': weightKg,
      'is_completed': isCompleted,
    };
  }

  factory WorkoutSet.fromJson(Map<String, dynamic> json) {
    return WorkoutSet(
      setNumber: json['set_number'] as int,
      repetitions: json['repetitions'] as int,
      weightKg: (json['weight_kg'] as num).toDouble(),
      isCompleted: json['is_completed'] as bool? ?? false,
    );
  }
}

class WorkoutExercise {
  final ExerciseModel exercise;
  final List<WorkoutSet> sets;

  const WorkoutExercise({
    required this.exercise,
    required this.sets,
  });

  WorkoutExercise copyWith({
    ExerciseModel? exercise,
    List<WorkoutSet>? sets,
  }) {
    return WorkoutExercise(
      exercise: exercise ?? this.exercise,
      sets: sets ?? this.sets,
    );
  }
}

class WorkoutSession {
  final String id;
  final String title;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int durationSeconds;
  final List<WorkoutExercise> exercises;
  final int xpEarned;
  final double totalVolumeKg;
  final String? notes;

  const WorkoutSession({
    required this.id,
    required this.title,
    required this.startedAt,
    this.endedAt,
    this.durationSeconds = 0,
    required this.exercises,
    this.xpEarned = 100,
    this.totalVolumeKg = 0.0,
    this.notes,
  });

  WorkoutSession copyWith({
    String? title,
    DateTime? endedAt,
    int? durationSeconds,
    List<WorkoutExercise>? exercises,
    int? xpEarned,
    double? totalVolumeKg,
    String? notes,
  }) {
    return WorkoutSession(
      id: id,
      title: title ?? this.title,
      startedAt: startedAt,
      endedAt: endedAt ?? this.endedAt,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      exercises: exercises ?? this.exercises,
      xpEarned: xpEarned ?? this.xpEarned,
      totalVolumeKg: totalVolumeKg ?? this.totalVolumeKg,
      notes: notes ?? this.notes,
    );
  }
}
