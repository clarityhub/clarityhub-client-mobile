import 'package:clarityhub/domains/app/redux/store/appState.dart';
import 'package:clarityhub/domains/app/widgets/backScaffold.dart';
import 'package:clarityhub/domains/interviews/models/interview.dart';
import 'package:clarityhub/domains/interviews/redux/actions/actions.dart';
import 'package:clarityhub/domains/interviews/utilities/networking.dart';
import 'package:clarityhub/theme.dart';
import 'package:clarityhub/widgets/button.dart';
import 'package:clarityhub/widgets/customtext.dart';
import 'package:clarityhub/widgets/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:redux/redux.dart';

class EditInterview extends StatefulWidget {
  @override
  _InterviewState createState() => _InterviewState();
}

class _InterviewState extends State<EditInterview> {
  TextEditingController titleTextEditingController =
      new TextEditingController();
  
  _handleEdit(cb) {
    return () async {
      if (titleTextEditingController.text == "") {
        Fluttertoast.showToast(
          msg: "Please enter all details",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: MyTheme.error,
          textColor: Colors.white,
          fontSize: 16.0
        );
        return;
      }

      String title = titleTextEditingController.text;
      try {
        await cb(title);
        Navigator.of(context).pop();
      } catch (e) {
        // Do nothing
      }
    };
  }

  @override
  void dispose() {
    titleTextEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MyTheme.init(context);

    return SafeArea(
      child: new StoreConnector(
        onInit: (Store<AppState> store) {
          store.dispatch(getInterview(store.state.interviewState.currentInterviewId));

          String id = store.state.interviewState.currentInterviewId;
          List<Interview> interviews = store.state.interviewState.interviews ?? [];
          Interview interview = interviews.firstWhere((Interview interview) => interview.id == id);
          titleTextEditingController.text = interview?.title ?? '';
        },
        converter: (Store<AppState> store) {
          Function callback = (String title) => store.dispatch(editInterview(store.state.interviewState.currentInterviewId, title));

          String id = store.state.interviewState.currentInterviewId;
          List<Interview> interviews = store.state.interviewState.interviews ?? [];
          Interview interview = interviews.firstWhere((Interview interview) => interview.id == id);

          return _InterviewEditModel(
            interview: interview ?? null,
            isLoading: interview == null,
            isUpdating: store.state.interviewState.isUpdating,
            error: store.state.interviewState.error,
            editInterview: callback,
          );
        },
        builder: (context, _InterviewEditModel viewModel) {
          List<Widget> children = new List<Widget>();

          if (viewModel.error != null) {
            children.add(ErrorCard(
              error: viewModel.error,
            ));
          }

          children.addAll([
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextFormField(
                autofocus: true,
                controller: titleTextEditingController,
                decoration: InputDecoration(
                  labelText: 'Interview title'
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
              padding: const EdgeInsets.all(18.0),
              child: CHButton(
                isLoading: viewModel.isUpdating,
                text: 'Edit Interview',
                onPressed: _handleEdit(viewModel.editInterview),
              ),
            ),
          ]);

          return BackScaffold(
            title: viewModel.interview != null ? viewModel.interview.title : 'Loading...',
            body: ModalProgressHUD(
              inAsyncCall: viewModel.isLoading,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: children,
              ),
            )
          );
        }
      ),
    );
  }
}


class _InterviewEditModel {
  final Interview interview;
  final bool isLoading;
  final bool isUpdating;
  final Function editInterview;
  final error;

  _InterviewEditModel({
    this.interview,
    this.isLoading,
    this.isUpdating,
    this.editInterview,
    this.error,
  });
}