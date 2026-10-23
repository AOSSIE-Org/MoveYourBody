// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../onboarding_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingData {

 Set<String> get goalTags; String get customGoal; Set<String> get healthIssueTags; String get customHealthIssue; String? get difficulty; String? get intensity; Set<String> get targetBodyRegion; Set<String> get equipments; String? get username; double? get height; double? get weight; int? get age; Uint8List? get goalEmbeddings; Uint8List? get healthIssueEmbeddings;
/// Create a copy of OnboardingData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingDataCopyWith<OnboardingData> get copyWith => _$OnboardingDataCopyWithImpl<OnboardingData>(this as OnboardingData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingData&&const DeepCollectionEquality().equals(other.goalTags, goalTags)&&(identical(other.customGoal, customGoal) || other.customGoal == customGoal)&&const DeepCollectionEquality().equals(other.healthIssueTags, healthIssueTags)&&(identical(other.customHealthIssue, customHealthIssue) || other.customHealthIssue == customHealthIssue)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.intensity, intensity) || other.intensity == intensity)&&const DeepCollectionEquality().equals(other.targetBodyRegion, targetBodyRegion)&&const DeepCollectionEquality().equals(other.equipments, equipments)&&(identical(other.username, username) || other.username == username)&&(identical(other.height, height) || other.height == height)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.age, age) || other.age == age)&&const DeepCollectionEquality().equals(other.goalEmbeddings, goalEmbeddings)&&const DeepCollectionEquality().equals(other.healthIssueEmbeddings, healthIssueEmbeddings));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(goalTags),customGoal,const DeepCollectionEquality().hash(healthIssueTags),customHealthIssue,difficulty,intensity,const DeepCollectionEquality().hash(targetBodyRegion),const DeepCollectionEquality().hash(equipments),username,height,weight,age,const DeepCollectionEquality().hash(goalEmbeddings),const DeepCollectionEquality().hash(healthIssueEmbeddings));

@override
String toString() {
  return 'OnboardingData(goalTags: $goalTags, customGoal: $customGoal, healthIssueTags: $healthIssueTags, customHealthIssue: $customHealthIssue, difficulty: $difficulty, intensity: $intensity, targetBodyRegion: $targetBodyRegion, equipments: $equipments, username: $username, height: $height, weight: $weight, age: $age, goalEmbeddings: $goalEmbeddings, healthIssueEmbeddings: $healthIssueEmbeddings)';
}


}

/// @nodoc
abstract mixin class $OnboardingDataCopyWith<$Res>  {
  factory $OnboardingDataCopyWith(OnboardingData value, $Res Function(OnboardingData) _then) = _$OnboardingDataCopyWithImpl;
@useResult
$Res call({
 Set<String> goalTags, String customGoal, Set<String> healthIssueTags, String customHealthIssue, String? difficulty, String? intensity, Set<String> targetBodyRegion, Set<String> equipments, String? username, double? height, double? weight, int? age, Uint8List? goalEmbeddings, Uint8List? healthIssueEmbeddings
});




}
/// @nodoc
class _$OnboardingDataCopyWithImpl<$Res>
    implements $OnboardingDataCopyWith<$Res> {
  _$OnboardingDataCopyWithImpl(this._self, this._then);

  final OnboardingData _self;
  final $Res Function(OnboardingData) _then;

/// Create a copy of OnboardingData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? goalTags = null,Object? customGoal = null,Object? healthIssueTags = null,Object? customHealthIssue = null,Object? difficulty = freezed,Object? intensity = freezed,Object? targetBodyRegion = null,Object? equipments = null,Object? username = freezed,Object? height = freezed,Object? weight = freezed,Object? age = freezed,Object? goalEmbeddings = freezed,Object? healthIssueEmbeddings = freezed,}) {
  return _then(_self.copyWith(
goalTags: null == goalTags ? _self.goalTags : goalTags // ignore: cast_nullable_to_non_nullable
as Set<String>,customGoal: null == customGoal ? _self.customGoal : customGoal // ignore: cast_nullable_to_non_nullable
as String,healthIssueTags: null == healthIssueTags ? _self.healthIssueTags : healthIssueTags // ignore: cast_nullable_to_non_nullable
as Set<String>,customHealthIssue: null == customHealthIssue ? _self.customHealthIssue : customHealthIssue // ignore: cast_nullable_to_non_nullable
as String,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String?,intensity: freezed == intensity ? _self.intensity : intensity // ignore: cast_nullable_to_non_nullable
as String?,targetBodyRegion: null == targetBodyRegion ? _self.targetBodyRegion : targetBodyRegion // ignore: cast_nullable_to_non_nullable
as Set<String>,equipments: null == equipments ? _self.equipments : equipments // ignore: cast_nullable_to_non_nullable
as Set<String>,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double?,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,goalEmbeddings: freezed == goalEmbeddings ? _self.goalEmbeddings : goalEmbeddings // ignore: cast_nullable_to_non_nullable
as Uint8List?,healthIssueEmbeddings: freezed == healthIssueEmbeddings ? _self.healthIssueEmbeddings : healthIssueEmbeddings // ignore: cast_nullable_to_non_nullable
as Uint8List?,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingData].
extension OnboardingDataPatterns on OnboardingData {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingData() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingData value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingData():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingData value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingData() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Set<String> goalTags,  String customGoal,  Set<String> healthIssueTags,  String customHealthIssue,  String? difficulty,  String? intensity,  Set<String> targetBodyRegion,  Set<String> equipments,  String? username,  double? height,  double? weight,  int? age,  Uint8List? goalEmbeddings,  Uint8List? healthIssueEmbeddings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingData() when $default != null:
return $default(_that.goalTags,_that.customGoal,_that.healthIssueTags,_that.customHealthIssue,_that.difficulty,_that.intensity,_that.targetBodyRegion,_that.equipments,_that.username,_that.height,_that.weight,_that.age,_that.goalEmbeddings,_that.healthIssueEmbeddings);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Set<String> goalTags,  String customGoal,  Set<String> healthIssueTags,  String customHealthIssue,  String? difficulty,  String? intensity,  Set<String> targetBodyRegion,  Set<String> equipments,  String? username,  double? height,  double? weight,  int? age,  Uint8List? goalEmbeddings,  Uint8List? healthIssueEmbeddings)  $default,) {final _that = this;
switch (_that) {
case _OnboardingData():
return $default(_that.goalTags,_that.customGoal,_that.healthIssueTags,_that.customHealthIssue,_that.difficulty,_that.intensity,_that.targetBodyRegion,_that.equipments,_that.username,_that.height,_that.weight,_that.age,_that.goalEmbeddings,_that.healthIssueEmbeddings);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Set<String> goalTags,  String customGoal,  Set<String> healthIssueTags,  String customHealthIssue,  String? difficulty,  String? intensity,  Set<String> targetBodyRegion,  Set<String> equipments,  String? username,  double? height,  double? weight,  int? age,  Uint8List? goalEmbeddings,  Uint8List? healthIssueEmbeddings)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingData() when $default != null:
return $default(_that.goalTags,_that.customGoal,_that.healthIssueTags,_that.customHealthIssue,_that.difficulty,_that.intensity,_that.targetBodyRegion,_that.equipments,_that.username,_that.height,_that.weight,_that.age,_that.goalEmbeddings,_that.healthIssueEmbeddings);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingData implements OnboardingData {
  const _OnboardingData({final  Set<String> goalTags = const {}, this.customGoal = '', final  Set<String> healthIssueTags = const {}, this.customHealthIssue = '', this.difficulty, this.intensity, final  Set<String> targetBodyRegion = const {}, final  Set<String> equipments = const {}, this.username, this.height, this.weight, this.age, this.goalEmbeddings, this.healthIssueEmbeddings}): _goalTags = goalTags,_healthIssueTags = healthIssueTags,_targetBodyRegion = targetBodyRegion,_equipments = equipments;
  

 final  Set<String> _goalTags;
@override@JsonKey() Set<String> get goalTags {
  if (_goalTags is EqualUnmodifiableSetView) return _goalTags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_goalTags);
}

@override@JsonKey() final  String customGoal;
 final  Set<String> _healthIssueTags;
@override@JsonKey() Set<String> get healthIssueTags {
  if (_healthIssueTags is EqualUnmodifiableSetView) return _healthIssueTags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_healthIssueTags);
}

@override@JsonKey() final  String customHealthIssue;
@override final  String? difficulty;
@override final  String? intensity;
 final  Set<String> _targetBodyRegion;
@override@JsonKey() Set<String> get targetBodyRegion {
  if (_targetBodyRegion is EqualUnmodifiableSetView) return _targetBodyRegion;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_targetBodyRegion);
}

 final  Set<String> _equipments;
@override@JsonKey() Set<String> get equipments {
  if (_equipments is EqualUnmodifiableSetView) return _equipments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_equipments);
}

@override final  String? username;
@override final  double? height;
@override final  double? weight;
@override final  int? age;
@override final  Uint8List? goalEmbeddings;
@override final  Uint8List? healthIssueEmbeddings;

/// Create a copy of OnboardingData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingDataCopyWith<_OnboardingData> get copyWith => __$OnboardingDataCopyWithImpl<_OnboardingData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingData&&const DeepCollectionEquality().equals(other._goalTags, _goalTags)&&(identical(other.customGoal, customGoal) || other.customGoal == customGoal)&&const DeepCollectionEquality().equals(other._healthIssueTags, _healthIssueTags)&&(identical(other.customHealthIssue, customHealthIssue) || other.customHealthIssue == customHealthIssue)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.intensity, intensity) || other.intensity == intensity)&&const DeepCollectionEquality().equals(other._targetBodyRegion, _targetBodyRegion)&&const DeepCollectionEquality().equals(other._equipments, _equipments)&&(identical(other.username, username) || other.username == username)&&(identical(other.height, height) || other.height == height)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.age, age) || other.age == age)&&const DeepCollectionEquality().equals(other.goalEmbeddings, goalEmbeddings)&&const DeepCollectionEquality().equals(other.healthIssueEmbeddings, healthIssueEmbeddings));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_goalTags),customGoal,const DeepCollectionEquality().hash(_healthIssueTags),customHealthIssue,difficulty,intensity,const DeepCollectionEquality().hash(_targetBodyRegion),const DeepCollectionEquality().hash(_equipments),username,height,weight,age,const DeepCollectionEquality().hash(goalEmbeddings),const DeepCollectionEquality().hash(healthIssueEmbeddings));

@override
String toString() {
  return 'OnboardingData(goalTags: $goalTags, customGoal: $customGoal, healthIssueTags: $healthIssueTags, customHealthIssue: $customHealthIssue, difficulty: $difficulty, intensity: $intensity, targetBodyRegion: $targetBodyRegion, equipments: $equipments, username: $username, height: $height, weight: $weight, age: $age, goalEmbeddings: $goalEmbeddings, healthIssueEmbeddings: $healthIssueEmbeddings)';
}


}

/// @nodoc
abstract mixin class _$OnboardingDataCopyWith<$Res> implements $OnboardingDataCopyWith<$Res> {
  factory _$OnboardingDataCopyWith(_OnboardingData value, $Res Function(_OnboardingData) _then) = __$OnboardingDataCopyWithImpl;
@override @useResult
$Res call({
 Set<String> goalTags, String customGoal, Set<String> healthIssueTags, String customHealthIssue, String? difficulty, String? intensity, Set<String> targetBodyRegion, Set<String> equipments, String? username, double? height, double? weight, int? age, Uint8List? goalEmbeddings, Uint8List? healthIssueEmbeddings
});




}
/// @nodoc
class __$OnboardingDataCopyWithImpl<$Res>
    implements _$OnboardingDataCopyWith<$Res> {
  __$OnboardingDataCopyWithImpl(this._self, this._then);

  final _OnboardingData _self;
  final $Res Function(_OnboardingData) _then;

/// Create a copy of OnboardingData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? goalTags = null,Object? customGoal = null,Object? healthIssueTags = null,Object? customHealthIssue = null,Object? difficulty = freezed,Object? intensity = freezed,Object? targetBodyRegion = null,Object? equipments = null,Object? username = freezed,Object? height = freezed,Object? weight = freezed,Object? age = freezed,Object? goalEmbeddings = freezed,Object? healthIssueEmbeddings = freezed,}) {
  return _then(_OnboardingData(
goalTags: null == goalTags ? _self._goalTags : goalTags // ignore: cast_nullable_to_non_nullable
as Set<String>,customGoal: null == customGoal ? _self.customGoal : customGoal // ignore: cast_nullable_to_non_nullable
as String,healthIssueTags: null == healthIssueTags ? _self._healthIssueTags : healthIssueTags // ignore: cast_nullable_to_non_nullable
as Set<String>,customHealthIssue: null == customHealthIssue ? _self.customHealthIssue : customHealthIssue // ignore: cast_nullable_to_non_nullable
as String,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String?,intensity: freezed == intensity ? _self.intensity : intensity // ignore: cast_nullable_to_non_nullable
as String?,targetBodyRegion: null == targetBodyRegion ? _self._targetBodyRegion : targetBodyRegion // ignore: cast_nullable_to_non_nullable
as Set<String>,equipments: null == equipments ? _self._equipments : equipments // ignore: cast_nullable_to_non_nullable
as Set<String>,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double?,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,goalEmbeddings: freezed == goalEmbeddings ? _self.goalEmbeddings : goalEmbeddings // ignore: cast_nullable_to_non_nullable
as Uint8List?,healthIssueEmbeddings: freezed == healthIssueEmbeddings ? _self.healthIssueEmbeddings : healthIssueEmbeddings // ignore: cast_nullable_to_non_nullable
as Uint8List?,
  ));
}


}

// dart format on
