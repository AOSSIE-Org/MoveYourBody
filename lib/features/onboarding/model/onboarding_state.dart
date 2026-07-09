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
  final bool isOnboarded;
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
    this.isOnboarded = false,
  });
  OnboardingState copyWith({
    Set<String>? goalTags,
    String? customGoal,
    Set<String>? healthIssueTags,
    String? customHealthIssue,
    String? difficulty,
    String? intensity,
    Set<String>? targetbodyRegion,
    Set<String>? equipments,
    String? username,
    double? height,
    double? weight,
    int? age,
    bool? isOnboarded,
  }) {
    return OnboardingState(
      goalTags: goalTags ?? this.goalTags,
      customGoal: customGoal ?? this.customGoal,
      healthIssueTags: healthIssueTags ?? this.healthIssueTags,
      customHealthIssue: customHealthIssue ?? this.customHealthIssue,
      difficulty: difficulty ?? this.difficulty,
      intensity: intensity ?? this.intensity,
      targetbodyRegion: targetbodyRegion ?? this.targetbodyRegion,
      equipments: equipments ?? this.equipments,
      username: username ?? this.username,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      age: age ?? this.age,
      isOnboarded: isOnboarded ?? this.isOnboarded,
    );
  }
}
