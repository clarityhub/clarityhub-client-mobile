import 'package:clarityhub/domains/app/redux/store/appState.dart';
import 'package:clarityhub/domains/workspaces/models/workspace.dart';
import 'package:clarityhub/domains/workspaces/utilities/networking.dart';
import 'package:redux/redux.dart';

class GetWorkspacesLoading {}
class GetWorkspacesSuccess {
  final List<Workspace> workspaces;

  GetWorkspacesSuccess({ this.workspaces });
}
class GetWorkspacesFailure {
  final error;

  GetWorkspacesFailure({ this.error });
}

Future<List<Workspace>> Function(Store<AppState>) getWorkspaces({ bool authed = false }) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(new GetWorkspacesLoading());

      List<Workspace> workspaces;
      
      if (authed) {
        workspaces = await WorkspaceNetworkHelper.getWorkspaces();
      } else {
        workspaces = await WorkspaceNetworkHelper.getWorkspacesAuth0();
      }

      store.dispatch(new GetWorkspacesSuccess(workspaces: workspaces));

      return workspaces;
    } catch (e) {
      print(e);

      store.dispatch(new GetWorkspacesFailure(error: e));

      return null;
    }
  };
}

class CreateWorkspaceLoading {}
class CreateWorkspaceFailure{
  final error;

  CreateWorkspaceFailure({ this.error });
}
class CreateWorkspaceSuccess {
  final workspace;

  CreateWorkspaceSuccess({ this.workspace });
}

Future<Workspace> Function(Store<AppState>) createWorkspace(String name) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(new CreateWorkspaceLoading());

      Workspace workspace = await WorkspaceNetworkHelper.createWorkspaceAuth0(name);

      store.dispatch(new CreateWorkspaceSuccess(workspace: workspace));

      return workspace;
    } catch (e) {
      print(e);

      store.dispatch(new CreateWorkspaceFailure(error: e));

      return null;
    }
  };
}

class SetCurrentWorkspace {
  final Workspace workspace;

  SetCurrentWorkspace({ this.workspace });
}

Future<void> Function(Store<AppState>) setCurrentWorkspace(Workspace workspace) {
  return (Store<AppState> store) async {
    store.dispatch(new SetCurrentWorkspace(workspace: workspace));
  };
}