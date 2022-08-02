import 'package:clarityhub/domains/workspaces/models/workspace.dart';
import 'package:clarityhub/theme.dart';
import 'package:clarityhub/widgets/customtext.dart';
import 'package:flutter/material.dart';

class PickWorkspaceList extends StatelessWidget {
  final List<Workspace> workspaces;
  final Function(Workspace workspace) onPickWorkspace;
  final currentWorkspaceId;

  PickWorkspaceList({
    this.onPickWorkspace,
    this.workspaces,
    this.currentWorkspaceId,
  });

  getListItem(Workspace workspace) {
    return InkWell(
      onTap: workspace.id != currentWorkspaceId ? () {
        onPickWorkspace(workspace);
      } : null,
      child: ListTile(
        trailing: workspace.id != currentWorkspaceId ?
          Icon(Icons.arrow_forward_ios, color: MyTheme.primary) :
          null,
        title: CustomText(
          title: workspace.name ?? '',
          alignment: TextAlign.left,
          size: MyTheme.headingSize(),
          color: Colors.black,
        )
      )
    );
  }

  getListItems() {
    List<Widget> listItems = new List();
  
    listItems.add(Divider(height: 1));

    for (Workspace workspace in workspaces) {
      listItems.add(
         getListItem(workspace)
      );

      listItems.add(Divider(height: 1));
    }

    return listItems;
  }

  @override
  Widget build(BuildContext context) {
    MyTheme.init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: getListItems(),
    );
  }
}