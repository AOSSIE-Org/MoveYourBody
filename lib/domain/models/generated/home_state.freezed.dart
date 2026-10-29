// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeState {

 DateTime get selectedDate; List<DateTime> get currentWeekDays; List<Exercise> get recommendedExercises; bool get isLoading; bool get isCreatingSession; Session? get currentSession; bool get hasIncompleteSession; String? get errorMessage;
/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeStateCopyWith<HomeState> get copyWith => _$HomeStateCopyWithImpl<HomeState>(this as HomeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeState&&(identical(other.selectedDate, selectedDate) || other.selectedDate == selectedDate)&&const DeepCollectionEquality().equals(other.currentWeekDays, currentWeekDays)&&const DeepCollectionEquality().equals(other.recommendedExercises, recommendedExercises)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isCreatingSession, isCreatingSession) || other.isCreatingSession == isCreatingSession)&&(identical(other.currentSession, currentSession) || other.currentSession == currentSession)&&(identical(other.hasIncompleteSession, hasIncompleteSession) || other.hasIncompleteSession == hasIncompleteSession)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,selectedDate,const DeepCollectionEquality().hash(currentWeekDays),const DeepCollectionEquality().hash(recommendedExercises),isLoading,isCreatingSession,currentSession,hasIncompleteSession,errorMessage);

@override
String toString() {
  return 'HomeState(selectedDate: $selectedDate, currentWeekDays: $currentWeekDays, recommendedExercises: $recommendedExercises, isLoading: $isLoading, isCreatingSession: $isCreatingSession, currentSession: $currentSession, hasIncompleteSession: $hasIncompleteSession, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $HomeStateCopyWith<$Res>  {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) _then) = _$HomeStateCopyWithImpl;
@useResult
$Res call({
 DateTime selectedDate, List<DateTime> currentWeekDays, List<Exercise> recommendedExercises, bool isLoading, bool isCreatingSession, Session? currentSession, bool hasIncompleteSession, String? errorMessage
});




}
/// @nodoc
class _$HomeStateCopyWithImpl<$Res>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._self, this._then);

  final HomeState _self;
  final $Res Function(HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedDate = null,Object? currentWeekDays = null,Object? recommendedExercises = null,Object? isLoading = null,Object? isCreatingSession = null,Object? currentSession = freezed,Object? hasIncompleteSession = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
selectedDate: null == selectedDate ? _self.selectedDate : selectedDate // ignore: cast_nullable_to_non_nullable
as DateTime,currentWeekDays: null == currentWeekDays ? _self.currentWeekDays : currentWeekDays // ignore: cast_nullable_to_non_nullable
as List<DateTime>,recommendedExercises: null == recommendedExercises ? _self.recommendedExercises : recommendedExercises // ignore: cast_nullable_to_non_nullable
as List<Exercise>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isCreatingSession: null == isCreatingSession ? _self.isCreatingSession : isCreatingSession // ignore: cast_nullable_to_non_nullable
as bool,currentSession: freezed == currentSession ? _self.currentSession : currentSession // ignore: cast_nullable_to_non_nullable
as Session?,hasIncompleteSession: null == hasIncompleteSession ? _self.hasIncompleteSession : hasIncompleteSession // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeState].
extension HomeStatePatterns on HomeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeState value)  $default,){
final _that = this;
switch (_that) {
case _HomeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeState value)?  $default,){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime selectedDate,  List<DateTime> currentWeekDays,  List<Exercise> recommendedExercises,  bool isLoading,  bool isCreatingSession,  Session? currentSession,  bool hasIncompleteSession,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.selectedDate,_that.currentWeekDays,_that.recommendedExercises,_that.isLoading,_that.isCreatingSession,_that.currentSession,_that.hasIncompleteSession,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime selectedDate,  List<DateTime> currentWeekDays,  List<Exercise> recommendedExercises,  bool isLoading,  bool isCreatingSession,  Session? currentSession,  bool hasIncompleteSession,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _HomeState():
return $default(_that.selectedDate,_that.currentWeekDays,_that.recommendedExercises,_that.isLoading,_that.isCreatingSession,_that.currentSession,_that.hasIncompleteSession,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime selectedDate,  List<DateTime> currentWeekDays,  List<Exercise> recommendedExercises,  bool isLoading,  bool isCreatingSession,  Session? currentSession,  bool hasIncompleteSession,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.selectedDate,_that.currentWeekDays,_that.recommendedExercises,_that.isLoading,_that.isCreatingSession,_that.currentSession,_that.hasIncompleteSession,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _HomeState implements HomeState {
  const _HomeState({required this.selectedDate, required final  List<DateTime> currentWeekDays, final  List<Exercise> recommendedExercises = const [], this.isLoading = false, this.isCreatingSession = false, this.currentSession, this.hasIncompleteSession = false, this.errorMessage}): _currentWeekDays = currentWeekDays,_recommendedExercises = recommendedExercises;
  

@override final  DateTime selectedDate;
 final  List<DateTime> _currentWeekDays;
@override List<DateTime> get currentWeekDays {
  if (_currentWeekDays is EqualUnmodifiableListView) return _currentWeekDays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_currentWeekDays);
}

 final  List<Exercise> _recommendedExercises;
@override@JsonKey() List<Exercise> get recommendedExercises {
  if (_recommendedExercises is EqualUnmodifiableListView) return _recommendedExercises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recommendedExercises);
}

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isCreatingSession;
@override final  Session? currentSession;
@override@JsonKey() final  bool hasIncompleteSession;
@override final  String? errorMessage;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeStateCopyWith<_HomeState> get copyWith => __$HomeStateCopyWithImpl<_HomeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeState&&(identical(other.selectedDate, selectedDate) || other.selectedDate == selectedDate)&&const DeepCollectionEquality().equals(other._currentWeekDays, _currentWeekDays)&&const DeepCollectionEquality().equals(other._recommendedExercises, _recommendedExercises)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isCreatingSession, isCreatingSession) || other.isCreatingSession == isCreatingSession)&&(identical(other.currentSession, currentSession) || other.currentSession == currentSession)&&(identical(other.hasIncompleteSession, hasIncompleteSession) || other.hasIncompleteSession == hasIncompleteSession)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,selectedDate,const DeepCollectionEquality().hash(_currentWeekDays),const DeepCollectionEquality().hash(_recommendedExercises),isLoading,isCreatingSession,currentSession,hasIncompleteSession,errorMessage);

@override
String toString() {
  return 'HomeState(selectedDate: $selectedDate, currentWeekDays: $currentWeekDays, recommendedExercises: $recommendedExercises, isLoading: $isLoading, isCreatingSession: $isCreatingSession, currentSession: $currentSession, hasIncompleteSession: $hasIncompleteSession, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$HomeStateCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory _$HomeStateCopyWith(_HomeState value, $Res Function(_HomeState) _then) = __$HomeStateCopyWithImpl;
@override @useResult
$Res call({
 DateTime selectedDate, List<DateTime> currentWeekDays, List<Exercise> recommendedExercises, bool isLoading, bool isCreatingSession, Session? currentSession, bool hasIncompleteSession, String? errorMessage
});




}
/// @nodoc
class __$HomeStateCopyWithImpl<$Res>
    implements _$HomeStateCopyWith<$Res> {
  __$HomeStateCopyWithImpl(this._self, this._then);

  final _HomeState _self;
  final $Res Function(_HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedDate = null,Object? currentWeekDays = null,Object? recommendedExercises = null,Object? isLoading = null,Object? isCreatingSession = null,Object? currentSession = freezed,Object? hasIncompleteSession = null,Object? errorMessage = freezed,}) {
  return _then(_HomeState(
selectedDate: null == selectedDate ? _self.selectedDate : selectedDate // ignore: cast_nullable_to_non_nullable
as DateTime,currentWeekDays: null == currentWeekDays ? _self._currentWeekDays : currentWeekDays // ignore: cast_nullable_to_non_nullable
as List<DateTime>,recommendedExercises: null == recommendedExercises ? _self._recommendedExercises : recommendedExercises // ignore: cast_nullable_to_non_nullable
as List<Exercise>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isCreatingSession: null == isCreatingSession ? _self.isCreatingSession : isCreatingSession // ignore: cast_nullable_to_non_nullable
as bool,currentSession: freezed == currentSession ? _self.currentSession : currentSession // ignore: cast_nullable_to_non_nullable
as Session?,hasIncompleteSession: null == hasIncompleteSession ? _self.hasIncompleteSession : hasIncompleteSession // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
