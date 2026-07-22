// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../session_execution_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionExecutionState {

 Session get session; List<Exercise> get exercises; Map<String, int> get exerciseDurations; int get preparationTime; int get restTime; ExecutionPhase get currentPhase; int get currentExerciseIndex; int get remainingSeconds; bool get isPaused; int get totalElapsedSeconds; bool get isInitializing;
/// Create a copy of SessionExecutionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionExecutionStateCopyWith<SessionExecutionState> get copyWith => _$SessionExecutionStateCopyWithImpl<SessionExecutionState>(this as SessionExecutionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionExecutionState&&(identical(other.session, session) || other.session == session)&&const DeepCollectionEquality().equals(other.exercises, exercises)&&const DeepCollectionEquality().equals(other.exerciseDurations, exerciseDurations)&&(identical(other.preparationTime, preparationTime) || other.preparationTime == preparationTime)&&(identical(other.restTime, restTime) || other.restTime == restTime)&&(identical(other.currentPhase, currentPhase) || other.currentPhase == currentPhase)&&(identical(other.currentExerciseIndex, currentExerciseIndex) || other.currentExerciseIndex == currentExerciseIndex)&&(identical(other.remainingSeconds, remainingSeconds) || other.remainingSeconds == remainingSeconds)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused)&&(identical(other.totalElapsedSeconds, totalElapsedSeconds) || other.totalElapsedSeconds == totalElapsedSeconds)&&(identical(other.isInitializing, isInitializing) || other.isInitializing == isInitializing));
}


@override
int get hashCode => Object.hash(runtimeType,session,const DeepCollectionEquality().hash(exercises),const DeepCollectionEquality().hash(exerciseDurations),preparationTime,restTime,currentPhase,currentExerciseIndex,remainingSeconds,isPaused,totalElapsedSeconds,isInitializing);

@override
String toString() {
  return 'SessionExecutionState(session: $session, exercises: $exercises, exerciseDurations: $exerciseDurations, preparationTime: $preparationTime, restTime: $restTime, currentPhase: $currentPhase, currentExerciseIndex: $currentExerciseIndex, remainingSeconds: $remainingSeconds, isPaused: $isPaused, totalElapsedSeconds: $totalElapsedSeconds, isInitializing: $isInitializing)';
}


}

/// @nodoc
abstract mixin class $SessionExecutionStateCopyWith<$Res>  {
  factory $SessionExecutionStateCopyWith(SessionExecutionState value, $Res Function(SessionExecutionState) _then) = _$SessionExecutionStateCopyWithImpl;
@useResult
$Res call({
 Session session, List<Exercise> exercises, Map<String, int> exerciseDurations, int preparationTime, int restTime, ExecutionPhase currentPhase, int currentExerciseIndex, int remainingSeconds, bool isPaused, int totalElapsedSeconds, bool isInitializing
});




}
/// @nodoc
class _$SessionExecutionStateCopyWithImpl<$Res>
    implements $SessionExecutionStateCopyWith<$Res> {
  _$SessionExecutionStateCopyWithImpl(this._self, this._then);

  final SessionExecutionState _self;
  final $Res Function(SessionExecutionState) _then;

/// Create a copy of SessionExecutionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? session = null,Object? exercises = null,Object? exerciseDurations = null,Object? preparationTime = null,Object? restTime = null,Object? currentPhase = null,Object? currentExerciseIndex = null,Object? remainingSeconds = null,Object? isPaused = null,Object? totalElapsedSeconds = null,Object? isInitializing = null,}) {
  return _then(_self.copyWith(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as Session,exercises: null == exercises ? _self.exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<Exercise>,exerciseDurations: null == exerciseDurations ? _self.exerciseDurations : exerciseDurations // ignore: cast_nullable_to_non_nullable
as Map<String, int>,preparationTime: null == preparationTime ? _self.preparationTime : preparationTime // ignore: cast_nullable_to_non_nullable
as int,restTime: null == restTime ? _self.restTime : restTime // ignore: cast_nullable_to_non_nullable
as int,currentPhase: null == currentPhase ? _self.currentPhase : currentPhase // ignore: cast_nullable_to_non_nullable
as ExecutionPhase,currentExerciseIndex: null == currentExerciseIndex ? _self.currentExerciseIndex : currentExerciseIndex // ignore: cast_nullable_to_non_nullable
as int,remainingSeconds: null == remainingSeconds ? _self.remainingSeconds : remainingSeconds // ignore: cast_nullable_to_non_nullable
as int,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,totalElapsedSeconds: null == totalElapsedSeconds ? _self.totalElapsedSeconds : totalElapsedSeconds // ignore: cast_nullable_to_non_nullable
as int,isInitializing: null == isInitializing ? _self.isInitializing : isInitializing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionExecutionState].
extension SessionExecutionStatePatterns on SessionExecutionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionExecutionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionExecutionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionExecutionState value)  $default,){
final _that = this;
switch (_that) {
case _SessionExecutionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionExecutionState value)?  $default,){
final _that = this;
switch (_that) {
case _SessionExecutionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Session session,  List<Exercise> exercises,  Map<String, int> exerciseDurations,  int preparationTime,  int restTime,  ExecutionPhase currentPhase,  int currentExerciseIndex,  int remainingSeconds,  bool isPaused,  int totalElapsedSeconds,  bool isInitializing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionExecutionState() when $default != null:
return $default(_that.session,_that.exercises,_that.exerciseDurations,_that.preparationTime,_that.restTime,_that.currentPhase,_that.currentExerciseIndex,_that.remainingSeconds,_that.isPaused,_that.totalElapsedSeconds,_that.isInitializing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Session session,  List<Exercise> exercises,  Map<String, int> exerciseDurations,  int preparationTime,  int restTime,  ExecutionPhase currentPhase,  int currentExerciseIndex,  int remainingSeconds,  bool isPaused,  int totalElapsedSeconds,  bool isInitializing)  $default,) {final _that = this;
switch (_that) {
case _SessionExecutionState():
return $default(_that.session,_that.exercises,_that.exerciseDurations,_that.preparationTime,_that.restTime,_that.currentPhase,_that.currentExerciseIndex,_that.remainingSeconds,_that.isPaused,_that.totalElapsedSeconds,_that.isInitializing);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Session session,  List<Exercise> exercises,  Map<String, int> exerciseDurations,  int preparationTime,  int restTime,  ExecutionPhase currentPhase,  int currentExerciseIndex,  int remainingSeconds,  bool isPaused,  int totalElapsedSeconds,  bool isInitializing)?  $default,) {final _that = this;
switch (_that) {
case _SessionExecutionState() when $default != null:
return $default(_that.session,_that.exercises,_that.exerciseDurations,_that.preparationTime,_that.restTime,_that.currentPhase,_that.currentExerciseIndex,_that.remainingSeconds,_that.isPaused,_that.totalElapsedSeconds,_that.isInitializing);case _:
  return null;

}
}

}

/// @nodoc


class _SessionExecutionState implements SessionExecutionState {
  const _SessionExecutionState({required this.session, required final  List<Exercise> exercises, required final  Map<String, int> exerciseDurations, required this.preparationTime, required this.restTime, this.currentPhase = ExecutionPhase.preparation, this.currentExerciseIndex = 0, this.remainingSeconds = 0, this.isPaused = false, this.totalElapsedSeconds = 0, this.isInitializing = true}): _exercises = exercises,_exerciseDurations = exerciseDurations;
  

@override final  Session session;
 final  List<Exercise> _exercises;
@override List<Exercise> get exercises {
  if (_exercises is EqualUnmodifiableListView) return _exercises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exercises);
}

 final  Map<String, int> _exerciseDurations;
@override Map<String, int> get exerciseDurations {
  if (_exerciseDurations is EqualUnmodifiableMapView) return _exerciseDurations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_exerciseDurations);
}

@override final  int preparationTime;
@override final  int restTime;
@override@JsonKey() final  ExecutionPhase currentPhase;
@override@JsonKey() final  int currentExerciseIndex;
@override@JsonKey() final  int remainingSeconds;
@override@JsonKey() final  bool isPaused;
@override@JsonKey() final  int totalElapsedSeconds;
@override@JsonKey() final  bool isInitializing;

/// Create a copy of SessionExecutionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionExecutionStateCopyWith<_SessionExecutionState> get copyWith => __$SessionExecutionStateCopyWithImpl<_SessionExecutionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionExecutionState&&(identical(other.session, session) || other.session == session)&&const DeepCollectionEquality().equals(other._exercises, _exercises)&&const DeepCollectionEquality().equals(other._exerciseDurations, _exerciseDurations)&&(identical(other.preparationTime, preparationTime) || other.preparationTime == preparationTime)&&(identical(other.restTime, restTime) || other.restTime == restTime)&&(identical(other.currentPhase, currentPhase) || other.currentPhase == currentPhase)&&(identical(other.currentExerciseIndex, currentExerciseIndex) || other.currentExerciseIndex == currentExerciseIndex)&&(identical(other.remainingSeconds, remainingSeconds) || other.remainingSeconds == remainingSeconds)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused)&&(identical(other.totalElapsedSeconds, totalElapsedSeconds) || other.totalElapsedSeconds == totalElapsedSeconds)&&(identical(other.isInitializing, isInitializing) || other.isInitializing == isInitializing));
}


@override
int get hashCode => Object.hash(runtimeType,session,const DeepCollectionEquality().hash(_exercises),const DeepCollectionEquality().hash(_exerciseDurations),preparationTime,restTime,currentPhase,currentExerciseIndex,remainingSeconds,isPaused,totalElapsedSeconds,isInitializing);

@override
String toString() {
  return 'SessionExecutionState(session: $session, exercises: $exercises, exerciseDurations: $exerciseDurations, preparationTime: $preparationTime, restTime: $restTime, currentPhase: $currentPhase, currentExerciseIndex: $currentExerciseIndex, remainingSeconds: $remainingSeconds, isPaused: $isPaused, totalElapsedSeconds: $totalElapsedSeconds, isInitializing: $isInitializing)';
}


}

/// @nodoc
abstract mixin class _$SessionExecutionStateCopyWith<$Res> implements $SessionExecutionStateCopyWith<$Res> {
  factory _$SessionExecutionStateCopyWith(_SessionExecutionState value, $Res Function(_SessionExecutionState) _then) = __$SessionExecutionStateCopyWithImpl;
@override @useResult
$Res call({
 Session session, List<Exercise> exercises, Map<String, int> exerciseDurations, int preparationTime, int restTime, ExecutionPhase currentPhase, int currentExerciseIndex, int remainingSeconds, bool isPaused, int totalElapsedSeconds, bool isInitializing
});




}
/// @nodoc
class __$SessionExecutionStateCopyWithImpl<$Res>
    implements _$SessionExecutionStateCopyWith<$Res> {
  __$SessionExecutionStateCopyWithImpl(this._self, this._then);

  final _SessionExecutionState _self;
  final $Res Function(_SessionExecutionState) _then;

/// Create a copy of SessionExecutionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? session = null,Object? exercises = null,Object? exerciseDurations = null,Object? preparationTime = null,Object? restTime = null,Object? currentPhase = null,Object? currentExerciseIndex = null,Object? remainingSeconds = null,Object? isPaused = null,Object? totalElapsedSeconds = null,Object? isInitializing = null,}) {
  return _then(_SessionExecutionState(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as Session,exercises: null == exercises ? _self._exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<Exercise>,exerciseDurations: null == exerciseDurations ? _self._exerciseDurations : exerciseDurations // ignore: cast_nullable_to_non_nullable
as Map<String, int>,preparationTime: null == preparationTime ? _self.preparationTime : preparationTime // ignore: cast_nullable_to_non_nullable
as int,restTime: null == restTime ? _self.restTime : restTime // ignore: cast_nullable_to_non_nullable
as int,currentPhase: null == currentPhase ? _self.currentPhase : currentPhase // ignore: cast_nullable_to_non_nullable
as ExecutionPhase,currentExerciseIndex: null == currentExerciseIndex ? _self.currentExerciseIndex : currentExerciseIndex // ignore: cast_nullable_to_non_nullable
as int,remainingSeconds: null == remainingSeconds ? _self.remainingSeconds : remainingSeconds // ignore: cast_nullable_to_non_nullable
as int,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,totalElapsedSeconds: null == totalElapsedSeconds ? _self.totalElapsedSeconds : totalElapsedSeconds // ignore: cast_nullable_to_non_nullable
as int,isInitializing: null == isInitializing ? _self.isInitializing : isInitializing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
