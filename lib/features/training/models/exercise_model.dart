class ExerciseModel {
  final String id;
  final String name;
  final String category; // bodyweight, dumbbell, barbell, machine, cardio, mobility
  final String primaryMuscle; // chest, back, legs, shoulders, arms, core, cardio
  final List<String> secondaryMuscles;
  final String equipment; // none, dumbbells, barbell, pull_up_bar, machine
  final String instructions;
  final String difficulty; // beginner, intermediate, advanced

  const ExerciseModel({
    required this.id,
    required this.name,
    required this.category,
    required this.primaryMuscle,
    this.secondaryMuscles = const [],
    required this.equipment,
    required this.instructions,
    this.difficulty = 'beginner',
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      primaryMuscle: json['primary_muscle'] as String,
      secondaryMuscles: List<String>.from(json['secondary_muscles'] as List? ?? []),
      equipment: json['equipment'] as String,
      instructions: json['instructions'] as String,
      difficulty: json['difficulty'] as String? ?? 'beginner',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'primary_muscle': primaryMuscle,
      'secondary_muscles': secondaryMuscles,
      'equipment': equipment,
      'instructions': instructions,
      'difficulty': difficulty,
    };
  }
}
