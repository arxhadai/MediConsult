import 'package:freezed_annotation/freezed_annotation.dart';

part 'freezed_test.freezed.dart';

@freezed
class TestClass with _$TestClass {
  const factory TestClass({required String name}) = _TestClass;
}