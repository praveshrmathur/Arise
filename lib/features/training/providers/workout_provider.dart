import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../hunter_status/providers/hunter_stats_provider.dart';
import '../models/exercise_model.dart';
import '../models/workout_model.dart';

final exerciseLibraryProvider = Provider<List<ExerciseModel>>((ref) {
  return [
    const ExerciseModel(
      id: 'ex-001',
      name: 'Push-Up',
      category: 'bodyweight',
      primaryMuscle: 'chest',
      secondaryMuscles: ['triceps', 'shoulders', 'core'],
      equipment: 'none',
      instructions: 'Place hands shoulder-width apart. Lower torso until chest is an inch from floor, maintaining rigid core, then press upwards fully.',
      difficulty: 'beginner',
    ),
    const ExerciseModel(
      id: 'ex-002',
      name: 'Pull-Up',
      category: 'bodyweight',
      primaryMuscle: 'back',
      secondaryMuscles: ['biceps', 'forearms', 'core'],
      equipment: 'pull_up_bar',
      instructions: 'Grip bar with overhand grip slightly wider than shoulders. Pull chest up to bar, driving elbows down into ribs.',
      difficulty: 'intermediate',
    ),
    const ExerciseModel(
      id: 'ex-003',
      name: 'Bodyweight Squat',
      category: 'bodyweight',
      primaryMuscle: 'legs',
      secondaryMuscles: ['glutes', 'quadriceps', 'hamstrings'],
      equipment: 'none',
      instructions: 'Feet shoulder-width apart. Hips sink back and down until thighs are parallel to ground. Drive through whole foot to stand.',
      difficulty: 'beginner',
    ),
    const ExerciseModel(
      id: 'ex-004',
      name: 'Dumbbell Floor Press',
      category: 'dumbbell',
      primaryMuscle: 'chest',
      secondaryMuscles: ['triceps', 'shoulders'],
      equipment: 'dumbbells',
      instructions: 'Lie on floor holding dumbbells with arms extended. Lower until upper arms touch floor, pause 1 second, then press up forcefully.',
      difficulty: 'beginner',
    ),
    const ExerciseModel(
      id: 'ex-005',
      name: 'Dumbbell Romanian Deadlift',
      category: 'dumbbell',
      primaryMuscle: 'hamstrings',
      secondaryMuscles: ['glutes', 'lower_back', 'forearms'],
      equipment: 'dumbbells',
      instructions: 'Stand tall holding dumbbells. Push hips back with slight knee bend until deep hamstring stretch is felt. Return to standing.',
      difficulty: 'intermediate',
    ),
    const ExerciseModel(
      id: 'ex-006',
      name: 'Dumbbell Overhead Shoulder Press',
      category: 'dumbbell',
      primaryMuscle: 'shoulders',
      secondaryMuscles: ['triceps', 'upper_chest', 'core'],
      equipment: 'dumbbells',
      instructions: 'Press dumbbells from shoulder height overhead to full lockout without hyperextending lumbar spine.',
      difficulty: 'intermediate',
    ),
    const ExerciseModel(
      id: 'ex-007',
      name: 'Front Plank Hold',
      category: 'bodyweight',
      primaryMuscle: 'core',
      secondaryMuscles: ['shoulders', 'glutes'],
      equipment: 'none',
      instructions: 'Rest on forearms and toes. Squeeze glutes and abdominal wall. Maintain rigid line without hip sag.',
      difficulty: 'beginner',
    ),
    const ExerciseModel(
      id: 'ex-008',
      name: 'Outdoor Interval Run',
      category: 'cardio',
      primaryMuscle: 'cardio',
      secondaryMuscles: ['legs', 'calves'],
      equipment: 'none',
      instructions: 'Alternate between 60 seconds brisk pace and 60 seconds recovery jog.',
      difficulty: 'intermediate',
    ),
    const ExerciseModel(
      id: 'ex-009',
      name: 'Cat-Cow Mobility Flow',
      category: 'mobility',
      primaryMuscle: 'core',
      secondaryMuscles: ['back', 'neck'],
      equipment: 'none',
      instructions: 'Move through gentle spinal flexion and extension synchronized with slow nasal inhalation and exhalation.',
      difficulty: 'beginner',
    ),
  ];
});

class ActiveWorkoutState {
  final WorkoutSession? session;
  final bool isRestTimerActive;
  final int restSecondsRemaining;

  const ActiveWorkoutState({
    this.session,
    this.isRestTimerActive = false,
    this.restSecondsRemaining = 0,
  });

  bool get hasActiveSession => session != null;

  ActiveWorkoutState copyWith({
    WorkoutSession? session,
    bool? isRestTimerActive,
    int? restSecondsRemaining,
  }) {
    return ActiveWorkoutState(
      session: session ?? this.session,
      isRestTimerActive: isRestTimerActive ?? this.isRestTimerActive,
      restSecondsRemaining: restSecondsRemaining ?? this.restSecondsRemaining,
    );
  }
}

class WorkoutNotifier extends StateNotifier<ActiveWorkoutState> {
  final Ref _ref;
  Timer? _restTimer;
  Timer? _sessionDurationTimer;
  final List<WorkoutSession> _history = [];

  WorkoutNotifier(this._ref) : super(const ActiveWorkoutState());

  List<WorkoutSession> get history => List.unmodifiable(_history);

  void startWorkout(String title, List<ExerciseModel> exercises) {
    _sessionDurationTimer?.cancel();
    _restTimer?.cancel();

    final workoutExercises = exercises.map((ex) {
      return WorkoutExercise(
        exercise: ex,
        sets: [
          const WorkoutSet(setNumber: 1, repetitions: 10, weightKg: 0.0),
          const WorkoutSet(setNumber: 2, repetitions: 10, weightKg: 0.0),
          const WorkoutSet(setNumber: 3, repetitions: 10, weightKg: 0.0),
        ],
      );
    }).toList();

    final session = WorkoutSession(
      id: 'workout-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      startedAt: DateTime.now(),
      exercises: workoutExercises,
    );

    state = ActiveWorkoutState(session: session);

    // Increment duration timer every second
    _sessionDurationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.session != null) {
        state = state.copyWith(
          session: state.session!.copyWith(
            durationSeconds: state.session!.durationSeconds + 1,
          ),
        );
      }
    });
  }

  void toggleSetCompletion(int exerciseIndex, int setIndex) {
    if (state.session == null) return;

    final exercises = List<WorkoutExercise>.from(state.session!.exercises);
    final currentExercise = exercises[exerciseIndex];
    final sets = List<WorkoutSet>.from(currentExercise.sets);

    final currentSet = sets[setIndex];
    final newCompletion = !currentSet.isCompleted;
    sets[setIndex] = currentSet.copyWith(isCompleted: newCompletion);

    exercises[exerciseIndex] = currentExercise.copyWith(sets: sets);
    state = state.copyWith(session: state.session!.copyWith(exercises: exercises));

    // If completed set, automatically start 60s rest timer
    if (newCompletion) {
      startRestTimer(60);
    }
  }

  void updateSetValues(int exerciseIndex, int setIndex, {int? reps, double? weight}) {
    if (state.session == null) return;

    final exercises = List<WorkoutExercise>.from(state.session!.exercises);
    final currentExercise = exercises[exerciseIndex];
    final sets = List<WorkoutSet>.from(currentExercise.sets);

    sets[setIndex] = sets[setIndex].copyWith(
      repetitions: reps ?? sets[setIndex].repetitions,
      weightKg: weight ?? sets[setIndex].weightKg,
    );

    exercises[exerciseIndex] = currentExercise.copyWith(sets: sets);
    state = state.copyWith(session: state.session!.copyWith(exercises: exercises));
  }

  void addSetToExercise(int exerciseIndex) {
    if (state.session == null) return;

    final exercises = List<WorkoutExercise>.from(state.session!.exercises);
    final currentExercise = exercises[exerciseIndex];
    final sets = List<WorkoutSet>.from(currentExercise.sets);

    final newSetNumber = sets.length + 1;
    final lastSet = sets.isNotEmpty ? sets.last : const WorkoutSet(setNumber: 1, repetitions: 10, weightKg: 0);

    sets.add(WorkoutSet(
      setNumber: newSetNumber,
      repetitions: lastSet.repetitions,
      weightKg: lastSet.weightKg,
    ));

    exercises[exerciseIndex] = currentExercise.copyWith(sets: sets);
    state = state.copyWith(session: state.session!.copyWith(exercises: exercises));
  }

  void startRestTimer(int seconds) {
    _restTimer?.cancel();
    state = state.copyWith(isRestTimerActive: true, restSecondsRemaining: seconds);

    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.restSecondsRemaining <= 1) {
        timer.cancel();
        state = state.copyWith(isRestTimerActive: false, restSecondsRemaining: 0);
      } else {
        state = state.copyWith(restSecondsRemaining: state.restSecondsRemaining - 1);
      }
    });
  }

  void dismissRestTimer() {
    _restTimer?.cancel();
    state = state.copyWith(isRestTimerActive: false, restSecondsRemaining: 0);
  }

  WorkoutSession? finishWorkout() {
    if (state.session == null) return null;

    _sessionDurationTimer?.cancel();
    _restTimer?.cancel();

    double totalVolume = 0;
    for (final ex in state.session!.exercises) {
      for (final s in ex.sets) {
        if (s.isCompleted) {
          totalVolume += (s.weightKg * s.repetitions);
        }
      }
    }

    final finished = state.session!.copyWith(
      endedAt: DateTime.now(),
      totalVolumeKg: totalVolume,
      xpEarned: 100,
    );

    _history.insert(0, finished);

    // Award XP to player profile
    _ref.read(hunterStatsProvider.notifier).awardXp(
          amount: 100,
          reason: 'Workout: ${finished.title}',
          category: 'strength',
        );

    _ref.read(hunterStatsProvider.notifier).incrementWorkoutCount();

    state = const ActiveWorkoutState(session: null);
    return finished;
  }

  void cancelWorkout() {
    _sessionDurationTimer?.cancel();
    _restTimer?.cancel();
    state = const ActiveWorkoutState(session: null);
  }

  @override
  void dispose() {
    _sessionDurationTimer?.cancel();
    _restTimer?.cancel();
    super.dispose();
  }
}

final workoutProvider =
    StateNotifierProvider<WorkoutNotifier, ActiveWorkoutState>((ref) {
  return WorkoutNotifier(ref);
});
