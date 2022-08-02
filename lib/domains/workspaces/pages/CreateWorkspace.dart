import 'package:clarityhub/domains/app/pages/dashboard.dart';
import 'package:clarityhub/domains/app/redux/store/appState.dart';
import 'package:clarityhub/domains/app/widgets/backScaffold.dart';
import 'package:clarityhub/domains/auth/redux/actions/actions.dart';
import 'package:clarityhub/domains/workspaces/models/workspace.dart';
import 'package:clarityhub/domains/workspaces/redux/actions/actions.dart';
import 'package:clarityhub/domains/workspaces/widgets/createWorkspaceForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class CreateWorkspace extends StatefulWidget {
  @override
  _CreateWorkspaceState createState() => _CreateWorkspaceState();
}

// TODO set loading and disable form
class _CreateWorkspaceState extends State<CreateWorkspace> {
  // TODO refactor with pickWorkspace
  void _handleLoginToWorkspace(Workspace workspace) async {
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

  void _handleCreateWorkspace({ String title }) async {
    final store = StoreProvider.of<AppState>(context);

    Workspace workspace = await store.dispatch(createWorkspace(title));

    // Now log into that workspace
    _handleLoginToWorkspace(workspace);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BackScaffold(
        title: 'Create Workspace',
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new StoreConnector(
              converter: (Store<AppState> store) {
                return new CreateWorkspaceViewModel(
                  isCreating: store.state.workspaceState.isCreating,
                );
              },
              builder: (BuildContext buildContext, CreateWorkspaceViewModel viewModel) {
                return new CreateWorkspaceForm(
                  isLoading: viewModel.isCreating,
                  onSubmit: _handleCreateWorkspace,
                );
              },
            )
          ]
        )
      )
    );
  }
}

class CreateWorkspaceViewModel {
  final bool isCreating;

  CreateWorkspaceViewModel({ this.isCreating });
} 