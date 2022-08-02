import 'dart:collection';

import 'package:clarityhub/domains/medias/models/media.dart';
import 'package:flutter/material.dart';

@immutable
class MediaState {
  final bool isLoading;
  final bool isCreating;
  final bool isUpdating;
  final Map<String, Media> medias;
  final error;
  final Map<String, dynamic> mediaErrors;

  const MediaState({
    this.isLoading = false,
    this.isCreating = false,
    this.isUpdating = false,
    @required this.medias,
    this.error,
    @required this.mediaErrors,
  });

  MediaState copyWith({
    isLoading,
    isCreating,
    isUpdating,
    medias,
    error,
    mediaErrors,
  }) {
    return new MediaState(
      isLoading: isLoading ?? this.isLoading,
      isCreating: isCreating ?? this.isCreating,
      isUpdating: isUpdating ?? this.isUpdating,
      medias: medias ?? this.medias,
      mediaErrors: mediaErrors ?? this.mediaErrors,
      error: error,
    );
  }

  static MediaState fromJson(dynamic json) => MediaState(
    medias: new LinkedHashMap<String, Media>(),
    mediaErrors: new LinkedHashMap<String, dynamic>()
  );

  dynamic toJson() => {
  };
}