// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'freezed_test.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TestClass {
  String get name => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TestClassCopyWith<TestClass> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TestClassCopyWith<$Res> {
  factory $TestClassCopyWith(TestClass value, $Res Function(TestClass) then) =
      _$TestClassCopyWithImpl<$Res, TestClass>;
  @useResult
  $Res call({String name});
}

/// @nodoc
class _$TestClassCopyWithImpl<$Res, $Val extends TestClass>
    implements $TestClassCopyWith<$Res> {
  _$TestClassCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TestClassImplCopyWith<$Res>
    implements $TestClassCopyWith<$Res> {
  factory _$$TestClassImplCopyWith(
          _$TestClassImpl value, $Res Function(_$TestClassImpl) then) =
      __$$TestClassImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name});
}

/// @nodoc
class __$$TestClassImplCopyWithImpl<$Res>
    extends _$TestClassCopyWithImpl<$Res, _$TestClassImpl>
    implements _$$TestClassImplCopyWith<$Res> {
  __$$TestClassImplCopyWithImpl(
      _$TestClassImpl _value, $Res Function(_$TestClassImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_$TestClassImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$TestClassImpl implements _TestClass {
  const _$TestClassImpl({required this.name});

  @override
  final String name;

  @override
  String toString() {
    return 'TestClass(name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TestClassImpl &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TestClassImplCopyWith<_$TestClassImpl> get copyWith =>
      __$$TestClassImplCopyWithImpl<_$TestClassImpl>(this, _$identity);
}

abstract class _TestClass implements TestClass {
  const factory _TestClass({required final String name}) = _$TestClassImpl;

  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$TestClassImplCopyWith<_$TestClassImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
