import 'package:clarityhub/domains/interviews/models/interview.dart';
import 'package:flutter/material.dart';

@immutable
class InterviewState {
  final bool hasLoaded;
  final bool isLoading;
  final bool isCreating;
  final bool isUpdating;
  final List<Interview> interviews;
  final error;
  final String currentInterviewId;

  const InterviewState({
    this.hasLoaded = false,
    this.isLoading = false,
    this.isCreating = false,
    this.isUpdating = false,
    this.interviews,
    this.error,
    this.currentInterviewId,
  });

  InterviewState copyWith({
    hasLoaded,
    isLoading,
    isCreating,
    isUpdating,
    interviews,
    error,
    currentInterviewId,
  }) {
    return new InterviewState(
      hasLoaded: hasLoaded ?? this.hasLoaded,
      isLoading: isLoading ?? this.isLoading,
      isCreating: isCreating ?? this.isCreating,
      isUpdating: isUpdating ?? this.isUpdating,
      interviews: interviews ?? this.interviews,
      error: error, // always clear unless it is set
      currentInterviewId: currentInterviewId ?? this.currentInterviewId,
    );
  }

  static InterviewState fromJson(dynamic json) => InterviewState();

  dynamic toJson() => {
  };
}