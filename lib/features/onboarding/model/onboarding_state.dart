class OnboardingState {
  final Set<String> goalTags;
  final String customGoal;
  final Set<String> healthIssueTags;
  final String customHealthIssue;
  final String? difficulty;
  final String? intensity;
  final Set<String> targetbodyRegion;
  final Set<String> equipments;
  final String? username;
  final double? height;
  final double? weight;
  final int? age;
  const OnboardingState({
    this.goalTags = const {},
    this.customGoal = '',
    this.healthIssueTags = const {},
    this.customHealthIssue = '',
    this.difficulty,
    this.intensity,
    this.targetbodyRegion = const {},
    this.equipments = const {},
    this.username,
    this.height,
    this.weight,
    this.age,
  });

  static const Object _sentinel = Object();

  OnboardingState copyWith({
    Set<String>? goalTags,
    String? customGoal,
    Set<String>? healthIssueTags,
    String? customHealthIssue,
    Object? difficulty = _sentinel,
    Object? intensity = _sentinel,
    Set<String>? targetbodyRegion,
    Set<String>? equipments,
    Object? username = _sentinel,
    Object? height = _sentinel,
    Object? weight = _sentinel,
    Object? age = _sentinel,
  }) {
    return OnboardingState(
      goalTags: goalTags ?? this.goalTags,
      customGoal: customGoal ?? this.customGoal,
      healthIssueTags: healthIssueTags ?? this.healthIssueTags,
      customHealthIssue: customHealthIssue ?? this.customHealthIssue,
      difficulty: identical(difficulty, _sentinel) ? this.difficulty : difficulty as String?,
      intensity: identical(intensity, _sentinel) ? this.intensity : intensity as String?,
      targetbodyRegion: targetbodyRegion ?? this.targetbodyRegion,
      equipments: equipments ?? this.equipments,
      username: identical(username, _sentinel) ? this.username : username as String?,
      height: identical(height, _sentinel) ? this.height : height as double?,
      weight: identical(weight, _sentinel) ? this.weight : weight as double?,
      age: identical(age, _sentinel) ? this.age : age as int?,
    );
  }
}
