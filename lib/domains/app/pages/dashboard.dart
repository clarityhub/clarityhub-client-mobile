import 'package:clarityhub/domains/app/pages/onboarding.dart';
import 'package:clarityhub/domains/app/redux/store/appState.dart';
import 'package:clarityhub/domains/app/widgets/mainScaffold.dart';
import 'package:clarityhub/domains/interviews/models/interview.dart';
import 'package:clarityhub/domains/interviews/pages/addinterview.dart';
import 'package:clarityhub/domains/interviews/pages/interview.dart';
import 'package:clarityhub/domains/interviews/redux/actions/actions.dart';
import 'package:clarityhub/domains/interviews/widgets/interviewItem.dart';
import 'package:clarityhub/domains/interviews/widgets/interviewsEmptyGreeting.dart';
import 'package:clarityhub/preferences.dart';
import 'package:clarityhub/theme.dart';
import 'package:clarityhub/widgets/error.dart';
import 'package:clarityhub/widgets/headerText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);

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
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MyTheme.init(context);
  
    return SafeArea(
      child: new StoreConnector(
          onInit: (store) async {
            store.dispatch(getInterviews());

            bool hasOnboarded = await Preferences.hasOnboarded();
            print('has onboarded: $hasOnboarded');
            if (!hasOnboarded) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => new Onboarding(),
                ),
              );
            }
          },
          converter: (Store<AppState> store) {
            List<Interview> interviews = new List<Interview>()..addAll(store.state.interviewState.interviews ?? []);
            interviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));

            return _InterviewsViewModel(
              hasLoaded: store.state.interviewState.hasLoaded,
              isLoading: store.state.interviewState.isLoading,
              interviews: interviews,
              error: store.state.interviewState.error,
              getInterviews: () => store.dispatch(getInterviews()),
              setCurrentInterview: (String interviewId) => store.dispatch(setCurrentInterview(interviewId)),
              isActive: store.state.authState.workspaceStatus,
            );
          },
          builder: (context, _InterviewsViewModel viewModel) {
            return MainScaffold(
              body:  ModalProgressHUD(
                inAsyncCall: viewModel.isLoading,
                child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: false,
                  header: WaterDropHeader(),
                  controller: _refreshController,
                  onRefresh: _onRefresh(viewModel.getInterviews),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: getListItems(viewModel.interviews, viewModel.isLoading, viewModel.error, viewModel.setCurrentInterview),
                    ),
                  )
                )
              ),
                
              floatingActionButton: !viewModel.isActive ? null : FloatingActionButton(
                child: Icon(Icons.add),
                backgroundColor: Colors.indigo,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => new AddInterview(),
                    ),
                  );
                },
              ),
            );
          }
      )
    );
  }

  getListItems(List<Interview> interviews, isLoading, error, setCurrentInterview) {
    List<Widget> listItems = new List();

    listItems.add(
      Padding(
        padding: const EdgeInsets.all(18.0),
        child: HeaderText('All Notebooks'),
      ),
    );

    if (error != null) {
      listItems.add(
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: ErrorCard(error: error),
        ),
      );
    }

    if (isLoading) {
      // nothing
    } else if (interviews != null && interviews.length == 0) {
      listItems.add(
        InterviewsEmptyGreeting()
      );
    } else if (interviews != null) {
      listItems.addAll(interviews.map((interview) {
        return Padding(
          child: InterviewItem(
            interview: interview,
            onView: () async {
              await setCurrentInterview(interview.id);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => new InterviewPage(),
                ),
              );
            },
          ),
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 9),
        );
      }));
    }

    return listItems;
  }
}

class _InterviewsViewModel {
  final hasLoaded;
  final isLoading;
  final interviews;
  final error;
  final bool isActive;
  final getInterviews;
  final setCurrentInterview;

  _InterviewsViewModel({
    this.hasLoaded,
    this.isLoading,
    this.interviews,
    this.isActive,
    this.error,
    this.getInterviews,
    this.setCurrentInterview,
  });
}
