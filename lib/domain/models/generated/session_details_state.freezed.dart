// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../session_details_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionDetailsState {

 Session? get session; List<Exercise> get exercises; bool get isLoading; String? get errorMessage; Map<String, int> get exerciseDurations; int get preparationTime; int get restTime;
/// Create a copy of SessionDetailsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionDetailsStateCopyWith<SessionDetailsState> get copyWith => _$SessionDetailsStateCopyWithImpl<SessionDetailsState>(this as SessionDetailsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionDetailsState&&(identical(other.session, session) || other.session == session)&&const DeepCollectionEquality().equals(other.exercises, exercises)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other.exerciseDurations, exerciseDurations)&&(identical(other.preparationTime, preparationTime) || other.preparationTime == preparationTime)&&(identical(other.restTime, restTime) || other.restTime == restTime));
}


@override
int get hashCode => Object.hash(runtimeType,session,const DeepCollectionEquality().hash(exercises),isLoading,errorMessage,const DeepCollectionEquality().hash(exerciseDurations),preparationTime,restTime);

@override
String toString() {
  return 'SessionDetailsState(session: $session, exercises: $exercises, isLoading: $isLoading, errorMessage: $errorMessage, exerciseDurations: $exerciseDurations, preparationTime: $preparationTime, restTime: $restTime)';
}


}

/// @nodoc
abstract mixin class $SessionDetailsStateCopyWith<$Res>  {
  factory $SessionDetailsStateCopyWith(SessionDetailsState value, $Res Function(SessionDetailsState) _then) = _$SessionDetailsStateCopyWithImpl;
@useResult
$Res call({
 Session? session, List<Exercise> exercises, bool isLoading, String? errorMessage, Map<String, int> exerciseDurations, int preparationTime, int restTime
});




}
/// @nodoc
class _$SessionDetailsStateCopyWithImpl<$Res>
    implements $SessionDetailsStateCopyWith<$Res> {
  _$SessionDetailsStateCopyWithImpl(this._self, this._then);

  final SessionDetailsState _self;
  final $Res Function(SessionDetailsState) _then;

/// Create a copy of SessionDetailsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? session = freezed,Object? exercises = null,Object? isLoading = null,Object? errorMessage = freezed,Object? exerciseDurations = null,Object? preparationTime = null,Object? restTime = null,}) {
  return _then(_self.copyWith(
session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as Session?,exercises: null == exercises ? _self.exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<Exercise>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,exerciseDurations: null == exerciseDurations ? _self.exerciseDurations : exerciseDurations // ignore: cast_nullable_to_non_nullable
as Map<String, int>,preparationTime: null == preparationTime ? _self.preparationTime : preparationTime // ignore: cast_nullable_to_non_nullable
as int,restTime: null == restTime ? _self.restTime : restTime // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionDetailsState].
extension SessionDetailsStatePatterns on SessionDetailsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionDetailsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionDetailsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionDetailsState value)  $default,){
final _that = this;
switch (_that) {
case _SessionDetailsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionDetailsState value)?  $default,){
final _that = this;
switch (_that) {
case _SessionDetailsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Session? session,  List<Exercise> exercises,  bool isLoading,  String? errorMessage,  Map<String, int> exerciseDurations,  int preparationTime,  int restTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionDetailsState() when $default != null:
return $default(_that.session,_that.exercises,_that.isLoading,_that.errorMessage,_that.exerciseDurations,_that.preparationTime,_that.restTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Session? session,  List<Exercise> exercises,  bool isLoading,  String? errorMessage,  Map<String, int> exerciseDurations,  int preparationTime,  int restTime)  $default,) {final _that = this;
switch (_that) {
case _SessionDetailsState():
return $default(_that.session,_that.exercises,_that.isLoading,_that.errorMessage,_that.exerciseDurations,_that.preparationTime,_that.restTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Session? session,  List<Exercise> exercises,  bool isLoading,  String? errorMessage,  Map<String, int> exerciseDurations,  int preparationTime,  int restTime)?  $default,) {final _that = this;
switch (_that) {
case _SessionDetailsState() when $default != null:
return $default(_that.session,_that.exercises,_that.isLoading,_that.errorMessage,_that.exerciseDurations,_that.preparationTime,_that.restTime);case _:
  return null;

}
}

}

/// @nodoc


class _SessionDetailsState implements SessionDetailsState {
  const _SessionDetailsState({this.session, final  List<Exercise> exercises = const [], this.isLoading = true, this.errorMessage, final  Map<String, int> exerciseDurations = const {}, this.preparationTime = 5, this.restTime = 20}): _exercises = exercises,_exerciseDurations = exerciseDurations;
  

@override final  Session? session;
 final  List<Exercise> _exercises;
@override@JsonKey() List<Exercise> get exercises {
  if (_exercises is EqualUnmodifiableListView) return _exercises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exercises);
}

@override@JsonKey() final  bool isLoading;
@override final  String? errorMessage;
 final  Map<String, int> _exerciseDurations;
@override@JsonKey() Map<String, int> get exerciseDurations {
  if (_exerciseDurations is EqualUnmodifiableMapView) return _exerciseDurations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_exerciseDurations);
}

@override@JsonKey() final  int preparationTime;
@override@JsonKey() final  int restTime;

/// Create a copy of SessionDetailsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionDetailsStateCopyWith<_SessionDetailsState> get copyWith => __$SessionDetailsStateCopyWithImpl<_SessionDetailsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionDetailsState&&(identical(other.session, session) || other.session == session)&&const DeepCollectionEquality().equals(other._exercises, _exercises)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other._exerciseDurations, _exerciseDurations)&&(identical(other.preparationTime, preparationTime) || other.preparationTime == preparationTime)&&(identical(other.restTime, restTime) || other.restTime == restTime));
}


@override
int get hashCode => Object.hash(runtimeType,session,const DeepCollectionEquality().hash(_exercises),isLoading,errorMessage,const DeepCollectionEquality().hash(_exerciseDurations),preparationTime,restTime);

@override
String toString() {
  return 'SessionDetailsState(session: $session, exercises: $exercises, isLoading: $isLoading, errorMessage: $errorMessage, exerciseDurations: $exerciseDurations, preparationTime: $preparationTime, restTime: $restTime)';
}


}

/// @nodoc
abstract mixin class _$SessionDetailsStateCopyWith<$Res> implements $SessionDetailsStateCopyWith<$Res> {
  factory _$SessionDetailsStateCopyWith(_SessionDetailsState value, $Res Function(_SessionDetailsState) _then) = __$SessionDetailsStateCopyWithImpl;
@override @useResult
$Res call({
 Session? session, List<Exercise> exercises, bool isLoading, String? errorMessage, Map<String, int> exerciseDurations, int preparationTime, int restTime
});




}
/// @nodoc
class __$SessionDetailsStateCopyWithImpl<$Res>
    implements _$SessionDetailsStateCopyWith<$Res> {
  __$SessionDetailsStateCopyWithImpl(this._self, this._then);

  final _SessionDetailsState _self;
  final $Res Function(_SessionDetailsState) _then;

/// Create a copy of SessionDetailsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? session = freezed,Object? exercises = null,Object? isLoading = null,Object? errorMessage = freezed,Object? exerciseDurations = null,Object? preparationTime = null,Object? restTime = null,}) {
  return _then(_SessionDetailsState(
session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as Session?,exercises: null == exercises ? _self._exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<Exercise>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,exerciseDurations: null == exerciseDurations ? _self._exerciseDurations : exerciseDurations // ignore: cast_nullable_to_non_nullable
as Map<String, int>,preparationTime: null == preparationTime ? _self.preparationTime : preparationTime // ignore: cast_nullable_to_non_nullable
as int,restTime: null == restTime ? _self.restTime : restTime // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
