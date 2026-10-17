import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/user_data.freezed.dart';

@freezed
abstract class UserData with _$UserData {
  const factory UserData({
    @Default({}) Set<String> goalTags,
    String? customGoal,
    @Default({}) Set<String> healthIssueTags,
    String? customHealthIssue,
    String? difficulty,
    String? intensity,
    @Default({}) Set<String> targetBodyRegion,
    @Default({}) Set<String> equipments,
    String? username,
    double? height,
    double? weight,
    int? age,
  }) = _UserData;
}
