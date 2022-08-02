import 'package:clarityhub/domains/auth/redux/actions/actions.dart';
import 'package:clarityhub/domains/workspaces/models/workspace.dart';
import 'package:clarityhub/domains/workspaces/redux/actions/actions.dart';
import 'package:clarityhub/domains/workspaces/redux/store/workspaceState.dart';
import 'package:redux/redux.dart';

final workspaceReducer = TypedReducer<WorkspaceState, dynamic>(_workspaceReducer);

WorkspaceState _workspaceReducer(WorkspaceState state, dynamic action) {
  if (action is LoginWorkspaceSuccess) {
    return new WorkspaceState();
  } else if (action is GetWorkspacesLoading) {
    return state.copyWith(
      isLoading: true,
      error: null,
    );
  } else if (action is GetWorkspacesSuccess) {
    return state.copyWith(
      hasLoaded: true,
      isLoading: false,
      workspaces: action.workspaces,
      error: null,
    );
  } else if (action is GetWorkspacesFailure) {
    return state.copyWith(
      isLoading: false,
      error: action.error,
    );
  } else if (action is CreateWorkspaceLoading) {
    return state.copyWith(
      isCreating: true,
      error: null,
    );
  } else if (action is CreateWorkspaceSuccess) {
    List<Workspace> workspaces = state.workspaces ?? new List<Workspace>();
    workspaces.add(action.workspace);

    return state.copyWith(
      isCreating: false,
      workspaces: workspaces,
      error: null,
    );
  } else if (action is CreateWorkspaceFailure) {
    return state.copyWith(
      isCreating: false,
      error: action.error
    );
  } else if (action is SetCurrentWorkspace) {
    return state.copyWith(
      currentWorkspace: action.workspace,
    );
  }

  return state ?? new WorkspaceState();
}