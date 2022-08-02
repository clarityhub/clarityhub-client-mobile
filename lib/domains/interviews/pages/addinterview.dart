import 'package:clarityhub/domains/app/redux/store/appState.dart';
import 'package:clarityhub/domains/app/widgets/backScaffold.dart';
import 'package:clarityhub/domains/interviews/models/interview.dart';
import 'package:clarityhub/domains/interviews/pages/interview.dart';
import 'package:clarityhub/domains/interviews/redux/actions/actions.dart';
import 'package:clarityhub/theme.dart';
import 'package:clarityhub/widgets/button.dart';
import 'package:clarityhub/widgets/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

class AddInterview extends StatefulWidget {
  @override
  _InterviewState createState() => _InterviewState();
}

class _InterviewState extends State<AddInterview> {
  TextEditingController titleTextEditingController;

  _InterviewState() {
    // 'April 20, 2020'
    var date = new DateFormat.yMMMMd('en_US').format(new DateTime.now());
    
    titleTextEditingController = new TextEditingController(
      text: 'Notebook – $date'
    );
  }

  @override
  void dispose() {
    if (titleTextEditingController != null) {
      titleTextEditingController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MyTheme.init(context);

    return SafeArea(
      child: BackScaffold(
        title: 'Create a Notebook',
        body: new StoreConnector(
          converter: (Store<AppState> store) {
            return _AddInterviewViewModel(
              isCreating: store.state.interviewState.isCreating,
              error: store.state.interviewState.error,
              createInterview: (title) => store.dispatch(createInterview(title)),
              setCurrentInterview: (interviewId) => store.dispatch(setCurrentInterview(interviewId)),
            );
          },
          builder: (context, _AddInterviewViewModel viewModel) {
            List<Widget> listItems = new List();

            if (viewModel.error != null) {
              listItems.add(
                Padding(
                  padding: const EdgeInsets.all(18.0),
                    child: ErrorCard(error: viewModel.error),
                )
              );
            }

            listItems.add(
              Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextFormField(
                    autofocus: true,
                    controller: titleTextEditingController,
                    decoration: InputDecoration(
                      labelText: 'Notebook title'
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                )
            );
            listItems.add(
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: CHButton(
                    isLoading: viewModel.isCreating,
                    text: 'Create Notebook',
                    onPressed: () async {
                      if (titleTextEditingController.text == "") {
                        Fluttertoast.showToast(
                          msg: "Please enter a title",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 3,
                          backgroundColor: MyTheme.error,
                          textColor: Colors.white,
                          fontSize: 16.0
                        );
                      } else {
                        Interview interview = await viewModel.createInterview(
                          titleTextEditingController.text,
                        );

                        if (interview != null) {
                          await viewModel.setCurrentInterview(interview.id);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => new InterviewPage(),
                            ),
                          );

                        }
                      }
                    },
                  ),
                )
            );

            // TODO error state
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: listItems
            );
          }
        )
      ),
    );
  }
}

class _AddInterviewViewModel {
  final bool isCreating;
  final Function createInterview;
  final Function setCurrentInterview;
  final error;

  _AddInterviewViewModel({
    this.isCreating,
    this.createInterview,
    this.setCurrentInterview,
    this.error,
  });
}
