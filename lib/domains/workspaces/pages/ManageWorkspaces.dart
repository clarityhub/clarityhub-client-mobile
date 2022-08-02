import 'package:clarityhub/domains/app/pages/dashboard.dart';
import 'package:clarityhub/domains/app/redux/store/appState.dart';
import 'package:clarityhub/domains/app/widgets/mainScaffold.dart';
import 'package:clarityhub/domains/auth/redux/actions/actions.dart';
import 'package:clarityhub/domains/workspaces/models/workspace.dart';
import 'package:clarityhub/domains/workspaces/pages/createWorkspace.dart';
import 'package:clarityhub/domains/workspaces/redux/actions/actions.dart';
import 'package:clarityhub/domains/workspaces/widgets/pickWorkspaceList.dart';
import 'package:clarityhub/widgets/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';

class ManageWorkspaces extends StatefulWidget {
  @override
  _ManageWorkspacesState createState() => _ManageWorkspacesState();
}

class _ManageWorkspacesState extends State<ManageWorkspaces> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  // TODO I shouldn't be passing context around like this
  // Use the ViewModel
  Future<Null> Function(Workspace) _handleLoginToWorkspace(BuildContext context) {
    return (Workspace workspace) async {
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
    };
  }

  _handleRefresh(getInterviews) async {
    try {
        await getInterviews();

        _refreshController.refreshCompleted();
      } catch (e) {
        _refreshController.refreshFailed();
      }
  }

  _onRefresh(getInterviews) {
    return () async {
      _handleRefresh(getInterviews);
    };
  }

  @override
  dispose() {
    _refreshController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MainScaffold(
        title: 'Your Workspaces',
        body: new StoreConnector(
          onInit: (store) => store.dispatch(getWorkspaces(authed: true)),
          converter: (Store<AppState> store) {
            return _ManageWorkspacesViewModel(
              isLoading: store.state.workspaceState.isLoading && store.state.workspaceState.workspaces != null,
              error: store.state.workspaceState.error,
              currentWorkspaceId: store.state.workspaceState.currentWorkspace.id,
              workspaces: store.state.workspaceState.workspaces,
              getWorkspaces: () => store.dispatch(getWorkspaces(authed: true)),
            );
          },
          builder: (context, _ManageWorkspacesViewModel viewModel) {
            return ModalProgressHUD(
              inAsyncCall: viewModel.isLoading,
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: false,
                header: WaterDropHeader(),
                controller: _refreshController,
                onRefresh: _onRefresh(viewModel.getWorkspaces),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: getListItems(viewModel, context),
                ),
              )
            );
          },
        ),

        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Colors.indigo,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => new CreateWorkspace(),
                ),
              );
            },
          ),
      ),
    );
  }

  getListItems(_ManageWorkspacesViewModel viewModel, BuildContext context) {
    List<Widget> listItems = new List();

    if (viewModel.error != null) {
      listItems.add(
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: ErrorCard(error: viewModel.error),
        ),
      );
    }

    if (viewModel.workspaces != null) {
      listItems.add(
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: new PickWorkspaceList(
            workspaces: viewModel.workspaces,
            currentWorkspaceId: viewModel.currentWorkspaceId,
            onPickWorkspace: _handleLoginToWorkspace(context),
          ),
        )
      );
    }

    return listItems;
  }
}

class _ManageWorkspacesViewModel {
  final isLoading;
  final error;
  final currentWorkspaceId;
  final List<Workspace> workspaces;
  final Function getWorkspaces;

  _ManageWorkspacesViewModel({
    this.isLoading,
    this.error,
    this.currentWorkspaceId,
    this.workspaces,
    this.getWorkspaces,
  });
}
