import 'dart:io' as io;

import 'package:emoji_picker_flutter/src/emoji_picker_internal_utils.dart';
import 'package:flutter/material.dart';

final RegExp _emojiRegex = RegExp(
    r'(\u00a9|\u00ae|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');

/// Type of the current emoji
// ignore: public_member_api_docs
enum EmojiType { UNICODE, IMAGE, URL }

/// Extensions on EmojiType
extension EmojiTypeExtensions on EmojiType {
  /// Get the type for a given emoji value
  /// Order: Check if valid unicode, check if valid URL, check if image exists
  static EmojiType? fromValue(String value) {
    if (_isValidUnicodeEmoji(value)) {
      return EmojiType.UNICODE;
    }
    if (_isValidURL(value)) {
      return EmojiType.URL;
    }
    if (_isValidImage(value)) {
      return EmojiType.IMAGE;
    }
    return null;
  }

  static bool _isValidURL(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || uri.hasAbsolutePath == false) {
      return false;
    }
    return true;
  }

  static bool _isValidUnicodeEmoji(String unicode) {
    return _emojiRegex.hasMatch(unicode);
  }

  static bool _isValidImage(String path) {
    return io.File(path).existsSync();
  }
}

/// A class to store data for each individual emoji
@immutable
class Emoji {
  /// Emoji constructor

  /// Emoji constructor
  const Emoji(this.name, this.type, this.emoji, {this.hasSkinTone = false});

  /// The type of the emoji
  final EmojiType type;

  /// The name or description for this emoji
  final String name;

  /// The unicode string for this emoji
  ///
  /// This is the string that should be displayed to view the emoji (IF NO CUSTOM EMOJIS ARE PROVIDED)
  final String emoji;

  /// The content for this emoji which should be used in texts
  /// Depends on the type:
  /// [EmojiType.UNICODE] - [emoji]
  /// [EmojiType.IMAGE] - [name]
  /// [EmojiType.URL] - [name]
  ///
  /// This is the string that should be displayed to view the emoji
  String get textEmoji {
    final hasResource = type == EmojiType.IMAGE || type == EmojiType.URL;
    return hasResource ? name : emoji;
  }

  /// Flag if emoji supports multiple skin tones
  final bool hasSkinTone;

  @override
  String toString() {
    return 'Name: $name, Emoji: $emoji, HasSkinTone: $hasSkinTone';
  }

  /// Parse Emoji from json
  static Emoji fromJson(Map<String, dynamic> json) {
    return Emoji(
      json['name'] as String,
      EmojiPickerInternalUtils.fromString(
              EmojiType.values, (json['type'] ?? '') as String) ??
          EmojiType.UNICODE,
      json['emoji'] as String,
      hasSkinTone:
          json['hasSkinTone'] != null ? json['hasSkinTone'] as bool : false,
    );
  }

  ///  Encode Emoji to json
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': EmojiPickerInternalUtils.convertToString(type),
      'emoji': emoji,
      'textEmoji': textEmoji,
      'hasSkinTone': hasSkinTone,
    };
  }

  /// Copy method
  Emoji copyWith(
      {String? name, String? emoji, EmojiType? type, bool? hasSkinTone}) {
    return Emoji(
      name ?? this.name,
      type ?? this.type,
      emoji ?? this.emoji,
      hasSkinTone: hasSkinTone ?? this.hasSkinTone,
    );
  }
}
