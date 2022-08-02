import 'dart:io';

import 'package:clarityhub/domains/app/redux/store/appState.dart';
import 'package:clarityhub/domains/app/widgets/backScaffold.dart';
import 'package:clarityhub/domains/interviews/pages/editinterview.dart';
import 'package:clarityhub/domains/interviews/redux/actions/actions.dart';
import 'package:clarityhub/domains/interviews/widgets/viewInterviewEmptyGretting.dart';
import 'package:clarityhub/domains/medias/pages/addAudio.dart';
import 'package:clarityhub/domains/medias/pages/addPhoto.dart';
import 'package:clarityhub/domains/medias/redux/actions/actions.dart';
import 'package:clarityhub/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth0/flutter_auth0.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';
import 'package:clarityhub/domains/interviews/models/interview.dart';

class InterviewPage extends StatefulWidget {
  @override
  _InterviewState createState() => _InterviewState();
}

class _InterviewState extends State<InterviewPage> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  _handleRefresh(getInterview) async {
    try {
        await getInterview();

        _refreshController.refreshCompleted();
      } catch (e) {
        _refreshController.refreshFailed();
      }
  }

  _onRefresh(getInterview) {
    return () async {
      _handleRefresh(getInterview);
    };
  }

  handleTapPhoto(context, _InterviewViewModel viewModel) async {
    final result = await Navigator.of(context).push(new MaterialPageRoute(
      builder: (BuildContext context) => new AddPhoto()));

    _addResultToInterview(result, viewModel);
  }

  handleTapAudio(context, _InterviewViewModel viewModel) async {
    final result = await Navigator.of(context).push(new MaterialPageRoute(
      builder: (BuildContext context) => new AddAudio()));

    _addResultToInterview(result, viewModel, 'transcribe');
  }

  _addResultToInterview(result, viewModel, [action]) {
    if (result is Map) {
      String fileType = result['fileType'];
      String path = result['path'];

      viewModel.addMediaToInterview(
        fileType: fileType,
        localPath: path,
        action: action,
      );
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MyTheme.init(context);

    return SafeArea(
      child: new StoreConnector(
        onInit: (Store<AppState> store) => store.dispatch(getInterview(store.state.interviewState.currentInterviewId)),
        converter: (Store<AppState> store) {
          Function callback = () => store.dispatch(getInterview(store.state.interviewState.currentInterviewId));
          Function addCallback = ({ fileType, localPath, action }) => store.dispatch(addMediaToInterview(
            store.state.interviewState.currentInterviewId,
            fileType: fileType,
            localPath: localPath,
            action: action,
          ));
          String id = store.state.interviewState.currentInterviewId;
          List<Interview> interviews = store.state.interviewState.interviews ?? [];

          Interview interview = interviews.firstWhere((Interview interview) => interview.id == id);

          if (interview != null) {
            return _InterviewViewModel(
              interview: interview,
              isLoading: false,
              getInterview: callback,
              addMediaToInterview: addCallback,
              isActive: store.state.authState.workspaceStatus,
            );
          } else {
            return _InterviewViewModel(
              interview: null,
              isLoading: true,
              getInterview: callback,
              addMediaToInterview: addCallback,
            );
          }
        },
        builder: (context, _InterviewViewModel viewModel) {
            return BackScaffold(
              title: viewModel.interview != null ? viewModel.interview.title : 'Loading...',
              actions: !viewModel.isActive ? null : <Widget>[
                new IconButton(
                  icon: new Icon(Icons.edit),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new EditInterview()));
                  },
                ),
              ],
              body: ModalProgressHUD(
                inAsyncCall: viewModel.isLoading,
                child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: false,
                  header: Platform.isIOS ? WaterDropHeader() : WaterDropMaterialHeader(
                    backgroundColor: MyTheme.primary,
                  ),
                  controller: _refreshController,
                  onRefresh: _onRefresh(viewModel.getInterview),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        // TODO Error

                        // TODO Date

                        viewModel.interview.slateContent.isEmpty() ?
                          ViewInterviewEmptyGreeting() :
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: viewModel.interview.slateContent.render(context),
                          ),
                      ]
                    ),
                  )
                )
              ),
              floatingActionButton: !viewModel.isActive ? null : SpeedDial(
                animatedIcon: AnimatedIcons.menu_close,
                animatedIconTheme: IconThemeData(size: 22.0),
                closeManually: false,
                curve: Curves.bounceIn,
                overlayColor: Colors.black,
                overlayOpacity: 0.5,
                backgroundColor: MyTheme.primary,
                foregroundColor: Colors.white,
                elevation: 8.0,
                shape: CircleBorder(),
                children: [
                  SpeedDialChild(
                    child: Icon(Icons.photo_camera),
                    backgroundColor: Colors.green,
                    label: 'Add a Photo',
                    labelStyle: TextStyle(fontSize: 16.0),
                    onTap: () => handleTapPhoto(context, viewModel),
                  ),
                  SpeedDialChild(
                    child: Icon(Icons.keyboard_voice),
                    backgroundColor: Colors.blue,
                    label: 'Add a Recording',
                    labelStyle: TextStyle(fontSize: 16.0),
                    onTap: () => handleTapAudio(context, viewModel),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }
}

class _InterviewViewModel {
  final Interview interview;
  final bool isLoading;
  final Function getInterview;
  final Function addMediaToInterview;
  final bool isActive;

  _InterviewViewModel({
    this.interview,
    this.isActive,
    this.isLoading,
    this.getInterview,
    @required this.addMediaToInterview
  });
}