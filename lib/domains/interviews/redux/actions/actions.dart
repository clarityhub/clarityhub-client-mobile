import 'dart:convert';

import 'package:clarityhub/domains/app/redux/store/appState.dart';
import 'package:clarityhub/domains/interviews/models/interview.dart';
import 'package:clarityhub/domains/interviews/utilities/networking.dart';
import 'package:clarityhub/domains/medias/models/media.dart';
import 'package:clarityhub/domains/slate/0_47_8/addons.dart';
import 'package:clarityhub/domains/slate/0_47_8/empty.dart';
import 'package:clarityhub/domains/slate/0_47_8/parser.dart';
import 'package:redux/redux.dart';

class GetInterviewsLoading {}
class GetInterviewsSuccess {
  final List<Interview> interviews;

  GetInterviewsSuccess({ this.interviews });
}
class GetInterviewsFailure {
  final error;

  GetInterviewsFailure({ this.error });
}

Future<List<Interview>> Function(Store<AppState>) getInterviews() {
  return (Store<AppState> store) async {
    try {
      store.dispatch(new GetInterviewsLoading());

      List<Interview> interviews = await InterviewsNetworkHelper.getInterviews();

      store.dispatch(new GetInterviewsSuccess(interviews: interviews));

      return interviews;
    } catch (e) {
      print(e);

      store.dispatch(new GetInterviewsFailure(error: e));

      return null;
    }
  };
}

class GetInterviewLoading {}
class GetInterviewSuccess {
  final Interview interview;

  GetInterviewSuccess({ this.interview });
}
class GetInterviewFailure {
  final error;

  GetInterviewFailure({ this.error });
}

Future<Interview> Function(Store<AppState>) getInterview(String interviewId) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(new GetInterviewLoading());
      
      Interview interview = await InterviewsNetworkHelper.getInterview(interviewId);

      store.dispatch(new GetInterviewSuccess(interview: interview));

      return interview;
    } catch (e) {
      print(e);

      store.dispatch(new GetInterviewFailure(error: e));

      return null;
    }
  };
}

class CreateInterviewLoading {}
class CreateInterviewSuccess {
  final Interview interview;

  CreateInterviewSuccess({ this.interview });
}
class CreateInterviewFailure {
  final error;

  CreateInterviewFailure({ this.error });
}

Future<Interview> Function(Store<AppState>) createInterview(String title) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(new CreateInterviewLoading());
      
      Interview interview = await InterviewsNetworkHelper.createInterview(
        title,
        content: jsonEncode(emptySlate().toJson()),
      );

      store.dispatch(new CreateInterviewSuccess(interview: interview));

      return interview;
    } catch (e) {
      print(e);

      store.dispatch(new CreateInterviewFailure(error: e));

      return null;
    }
  };
}

class EditInterviewLoading {}
class EditInterviewSuccess {
  final Interview interview;

  EditInterviewSuccess({ this.interview });
}
class EditInterviewFailure {
  final error;

  EditInterviewFailure({ this.error });
}
Future<Interview> Function(Store<AppState>) editInterview(String id, String title) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(new EditInterviewLoading());
      
      Interview interview = await InterviewsNetworkHelper.editInterview(id, title);

      store.dispatch(new EditInterviewSuccess(interview: interview));

      return interview;
    } catch (e) {
      print(e);

      store.dispatch(new EditInterviewFailure(error: e));

      throw e;
    }
  };
}

Future<Interview> Function(Store<AppState>) updateInterviewContentMedia(String id, Media media) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(new EditInterviewLoading());
      
      Interview i = store.state.interviewState.interviews.firstWhere((item) => item.id == id);

      if (i != null) {
        // Cache miss, get interview
        i = await InterviewsNetworkHelper.getInterview(id);
      }

      i.slateContent.addBlock(new MediaNode(
          type: 'media',
          object: 'block',
          data: {
            'id': media.id,
          },
          nodes: [],
        ));

        Interview interview = await InterviewsNetworkHelper.updateInterviewContent(
          id,
          jsonEncode(i.slateContent.toJson()),
        );

        store.dispatch(new EditInterviewSuccess(interview: interview));

        return interview;
    } catch (e) {
      print(e);

      store.dispatch(new EditInterviewFailure(error: e));

      return null;
    }
  };
}

class SetCurrentInterview {
  final String interviewId;

  SetCurrentInterview({ this.interviewId });
}

Future<void> Function(Store<AppState>) setCurrentInterview(String interviewId) {
  return (Store<AppState> store) async {
    store.dispatch(new SetCurrentInterview(interviewId: interviewId));
  };
}



