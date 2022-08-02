import 'package:clarityhub/theme.dart';
import 'package:clarityhub/widgets/button.dart';
import 'package:flutter/material.dart';

class CreateWorkspaceForm extends StatefulWidget {
  final Function({ String title }) onSubmit;
  final bool isLoading;

  CreateWorkspaceForm({
    this.onSubmit,
    this.isLoading
  });

  @override
  _CreateWorkspaceFormState createState() => _CreateWorkspaceFormState();
}

class _CreateWorkspaceFormState extends State<CreateWorkspaceForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = new TextEditingController();

  @override
  dispose() {
    titleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MyTheme.init(context);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Workspace Name'
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Container(
              width: double.infinity,

              child: CHButton(
                text: widget.isLoading ? 'Creating Workspace...' : 'Create Workspace',
                isLoading: widget.isLoading,
                onPressed: () {
                  if (widget.isLoading) {
                    return;
                  }

                  if (_formKey.currentState.validate()) {
                    widget.onSubmit(
                      title: titleController.text
                    );
                  }
                },
              ),
            ),
          ),
        ],
      )
    );
  }
}