import 'dart:convert';
import 'package:flutter/cupertino.dart';

abstract class Model {
  String? _id;

  String get id => _id ?? '';

  set id(String? value) {
    _id = value;
  }

  bool get hasData => _id != '' && _id != null;

  void fromJson(Map<String, dynamic>? json) {
    _id = stringFromJson(json, 'id');
  }

  @override
  bool operator ==(dynamic other) {
    return other._id == _id;
  }

  @override
  int get hashCode => _id.hashCode;

  Map<String, dynamic>? toJson();

  @override
  String toString() {
    return toJson().toString();
  }

  String colorToString(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  String stringFromJson(Map<String, dynamic>? json, String attribute,
      {String defaultValue = ''}) {
    try {
      return json != null
          ? json[attribute] != null
              ? json[attribute].toString()
              : defaultValue
          : defaultValue;
    } catch (e) {
      throw Exception(
          'Error while parsing $attribute[$e]');
    }
  }

  DateTime? dateFromJson(Map<String, dynamic>? json, String attribute,
      {DateTime? defaultValue}) {
    try {
      return json != null
          ? json[attribute] != null
              ? DateTime.parse(json[attribute]).toLocal()
              : defaultValue
          : defaultValue;
    } catch (e) {
      throw Exception(
          'Error while parsing $attribute[$e]');
    }
  }

  dynamic mapFromJson(Map<String, dynamic>? json, String attribute,
      {Map<dynamic, dynamic>? defaultValue}) {
    try {
      return json != null
          ? json[attribute] != null
              ? jsonDecode(json[attribute])
              : defaultValue
          : defaultValue;
    } catch (e) {
      throw Exception(
          'Error while parsing $attribute[$e]');
    }
  }

  int intFromJson(Map<String, dynamic>? json, String attribute,
      {int defaultValue = 0}) {
    try {
      if (json != null && json[attribute] != null) {
        if (json[attribute] is int) {
          return json[attribute];
        }
        return int.parse(json[attribute]);
      }
      return defaultValue;
    } catch (e) {
      throw Exception(
          'Error while parsing $attribute[$e]');
    }
  }

  double doubleFromJson(Map<String, dynamic>? json, String attribute,
      {int decimal = 2, double defaultValue = 0.0}) {
    try {
      if (json != null && json[attribute] != null && json[attribute] != '') {
        if (json[attribute] is double) {
          return double.parse(json[attribute].toStringAsFixed(decimal));
        }
        if (json[attribute] is int) {
          return double.parse(
              json[attribute].toDouble().toStringAsFixed(decimal));
        }
        return double.parse(
            double.tryParse(json[attribute])!.toStringAsFixed(decimal));
      }
      return defaultValue;
    } catch (e) {
      throw Exception(
          'Error while parsing $attribute[$e]');
    }
  }

  bool boolFromJson(Map<String, dynamic>? json, String attribute,
      {bool defaultValue = false}) {
    try {
      if (json != null && json[attribute] != null) {
        if (json[attribute] is bool) {
          return json[attribute];
        } else if ((json[attribute] is String) &&
            !['0', '', 'false'].contains(json[attribute])) {
          return true;
        } else if ((json[attribute] is int) &&
            ![0, -1].contains(json[attribute])) {
          return true;
        }
        return false;
      }
      return defaultValue;
    } catch (e) {
      throw Exception(
          'Error while parsing $attribute[$e]');
    }
  }

  List<T> listFromJsonArray<T>(Map<String, dynamic>? json,
      List<String> attribute, T Function(Map<String, dynamic>?) callback) {
    String attribute0 = attribute
        .firstWhere((element) => (json?[element] != null), orElse: () => '');
    return listFromJson(json, attribute0, callback);
  }

  List<T> listFromJson<T>(Map<String, dynamic>? json, String attribute,
      T Function(Map<String, dynamic>?) callback) {
    try {
      List<T> list = <T>[];
      if (json != null &&
          json[attribute] != null &&
          json[attribute] is List &&
          json[attribute].length > 0) {
        json[attribute].forEach((v) {
          if (v is Map<String, dynamic>?) {
            list.add(callback(v));
          }
        });
      }
      return list;
    } catch (e) {
      throw Exception('Error while parsing $attribute[$e]');
    }
  }

  T? objectFromJson<T>(Map<String, dynamic>? json, String attribute1,
      T Function(Map<String, dynamic>?) callback,
      {String? attribute2, String? attribute3, T? defaultValue}) {
    try {
      if (json != null) {
        for (var attribute in [attribute1, attribute2, attribute3]) {
          if (json[attribute] != null && json[attribute] is Map<String, dynamic>) {
            return callback(json[attribute]);
          } else if (json[attribute] != null && json[attribute] is String && json[attribute] != "") {
            return callback(jsonDecode(json[attribute]));
          }
        }
      }
      return defaultValue;
    } catch (e) {
      throw Exception(
          'Error while parsing $attribute1 | $attribute2 | $attribute3 [$e]');
    }
  }
}
