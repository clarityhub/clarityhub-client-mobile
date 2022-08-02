import 'package:clarityhub/domains/app/pages/dashboard.dart';
import 'package:clarityhub/domains/app/redux/store/appState.dart';
import 'package:clarityhub/domains/auth/pages/login.dart';
import 'package:clarityhub/domains/auth/redux/actions/actions.dart';
import 'package:clarityhub/domains/workspaces/pages/manageWorkspaces.dart';
import 'package:clarityhub/theme.dart';
import 'package:clarityhub/widgets/appTitle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class MainScaffold extends StatefulWidget {
  final title;
  final body;
  final floatingActionButton;
  final leading;
  final bool drawer;
  final List<Widget> actions;

  MainScaffold({ this.title, this.body, this.floatingActionButton, this.leading, this.drawer = true, this.actions });

  @override
  _MainScaffold createState() => _MainScaffold();
}

class _MainScaffold extends State<MainScaffold> {
  void handleTapInterviews() {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
              builder: (BuildContext context) => new Dashboard()));
  }

  void handleLogout() {
    final store = StoreProvider.of<AppState>(context);

    store.dispatch(logout());

    Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => new Login()));
  }

  void handleManageWorkspaces() {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => new ManageWorkspaces()));
  }

  @override
  Widget build(BuildContext context) {
    MyTheme.init(context);

    return Scaffold(
      appBar: AppBar(
        actions: widget.actions ?? null,
        centerTitle: true,
        title: new StoreConnector<AppState, _MainScaffoldTitleViewModel>(
          converter: (store) {
            return _MainScaffoldTitleViewModel(
              title: store.state.workspaceState.currentWorkspace?.name ?? '',
              isActive: store.state.authState.workspaceStatus,
            );
          },
          builder: (context, _MainScaffoldTitleViewModel viewModel) {
            return AppTitle(
              (viewModel.isActive ? '' : '[Inactive] ') + (widget.title ?? viewModel.title ?? ''),
            );
          }
        ),   
        leading: widget.leading ?? null,
      ),
      body: widget.body,
      floatingActionButton: widget.floatingActionButton ?? null,
      drawer: widget.drawer ? Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: MyTheme.primary,
              ),
              child: Text(
                MyTheme.appName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              onTap: handleTapInterviews,
              leading: Icon(Icons.description),
              title: Text('Notebooks'),
            ),
            ListTile(
              onTap: handleManageWorkspaces,
              leading: Icon(Icons.settings),
              title: Text('Manage Workspaces'),
            ),
            ListTile(
              onTap: handleLogout,
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
            ),
          ],
        ),
      ) : null,
    );
  }
}

class _MainScaffoldTitleViewModel {
  final String title;
  final bool isActive;

  _MainScaffoldTitleViewModel({
    this.title,
    this.isActive,
  });
}
