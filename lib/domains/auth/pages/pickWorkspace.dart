import 'package:clarityhub/domains/app/pages/dashboard.dart';
import 'package:clarityhub/domains/app/redux/store/appState.dart';
import 'package:clarityhub/domains/auth/redux/actions/actions.dart';
import 'package:clarityhub/domains/workspaces/models/workspace.dart';
import 'package:clarityhub/domains/workspaces/redux/actions/actions.dart';
import 'package:clarityhub/domains/workspaces/redux/store/workspaceState.dart';
import 'package:clarityhub/domains/workspaces/widgets/createWorkspaceForm.dart';
import 'package:clarityhub/domains/workspaces/widgets/pickWorkspaceList.dart';
import 'package:clarityhub/theme.dart';
import 'package:clarityhub/widgets/error.dart';
import 'package:clarityhub/widgets/headerText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class PickWorkspace extends StatefulWidget {
  @override
  _WorkspaceState createState() => _WorkspaceState();
}

class _WorkspaceState extends State<PickWorkspace> {
  void handleLoginToWorkspace(Workspace workspace) async {
    final store = StoreProvider.of<AppState>(context);

    var result = await store.dispatch(loginWorkspace(workspace.id));

    if (result != null) {
      await store.dispatch(setCurrentWorkspace(workspace));
      // Navigate to the Dashboard
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => new Dashboard()));
    } else {
      // TODO show error toast?
      print('error is actually thrown');
    }
  }

  void loadWorkspaces(Store<AppState> store) async {
    List<Workspace> workspaces = await store.dispatch(getWorkspaces());

    if (workspaces != null && workspaces.length == 1) {
      // automatically log into that workspace
      handleLoginToWorkspace(workspaces[0]);
    }
  }

  void handleCreateWorkspace({String title}) async {
    final store = StoreProvider.of<AppState>(context);

    Workspace workspace = await store.dispatch(createWorkspace(title));

    // Now log into that workspace
    handleLoginToWorkspace(workspace);
  }

  renderChild(WorkspaceState workspaceState) {
    if (workspaceState.error != null) {
      return new ErrorCard(error: workspaceState.error);
    }

    if (!workspaceState.hasLoaded ||
        workspaceState.isLoading ||
        (workspaceState.workspaces != null &&
            workspaceState.workspaces.length == 1)) {
      return new CircularProgressIndicator();
    }

    if (workspaceState.workspaces == null ||
        workspaceState.workspaces.length == 0) {
      return Padding(
        padding: const EdgeInsets.all(18.0),
        child: new CreateWorkspaceForm(
          isLoading: workspaceState.isCreating,
          onSubmit: this.handleCreateWorkspace,
        )
      );
    }

    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: new PickWorkspaceList(
        workspaces: workspaceState.workspaces,
        onPickWorkspace: handleLoginToWorkspace,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    MyTheme.init(context);

    return Scaffold(
        body: new Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new StoreConnector<AppState, WorkspaceState>(
            onInit: (store) => this.loadWorkspaces(store),
            converter: (store) => store.state.workspaceState,
            builder: (context, workspaceState) {
              bool shouldCreateWorkspace = workspaceState.workspaces == null ||
                  workspaceState.workspaces.length == 0;
              return Column(
                children: <Widget>[
                  HeaderText(shouldCreateWorkspace ? 'Create A Workspace' : 'Pick Your Workspace'),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: renderChild(workspaceState),
                  )
                ]
              );
            }
          ),
        ],
        )
      )
    );
  }
}
