import 'package:clarityhub/domains/workspaces/models/workspace.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class WorkspaceState {
  final bool hasLoaded;
  final bool isLoading;
  final bool isCreating;
  final List<Workspace> workspaces;
  final error;
  final Workspace currentWorkspace;

  const WorkspaceState({
    this.hasLoaded = false,
    this.isLoading = false,
    this.isCreating = false,
    this.workspaces,
    this.error,
    this.currentWorkspace,
  });

  WorkspaceState copyWith({
    hasLoaded,
    isLoading,
    isCreating,
    workspaces,
    error,
    currentWorkspace,
  }) {
    return new WorkspaceState(
      hasLoaded: hasLoaded ?? this.hasLoaded,
      isLoading: isLoading ?? this.isLoading,
      isCreating: isCreating ?? this.isCreating,
      workspaces: workspaces ?? this.workspaces,
      error: error, // always clear unless it is set
      currentWorkspace: currentWorkspace ?? this.currentWorkspace,
    );
  }

  static WorkspaceState fromJson(dynamic json) => WorkspaceState(
    currentWorkspace: Workspace.fromJson(json['currentWorkspace']),
  );

  dynamic toJson() => {
    'currentWorkspace': currentWorkspace != null ? currentWorkspace.toJson() : null,
  };
}