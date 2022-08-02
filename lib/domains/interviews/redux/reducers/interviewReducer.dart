import 'package:clarityhub/domains/interviews/models/interview.dart';
import 'package:clarityhub/domains/interviews/redux/actions/actions.dart';
import 'package:clarityhub/domains/interviews/redux/store/interviewState.dart';
import 'package:redux/redux.dart';

final interviewReducer = TypedReducer<InterviewState, dynamic>(_interviewReducer);

InterviewState _interviewReducer(InterviewState state, dynamic action) {
  if (action is GetInterviewLoading) {
    return state.copyWith(
      isLoading: true,
      error: null,
    );
  } else if (action is GetInterviewSuccess) {
    List<Interview> interviews = state.interviews ?? new List<Interview>();
    
    int index = interviews.indexWhere((interview) => interview.id == action.interview.id);

    if (index != -1) {
      interviews[index] = action.interview;
    } else {
      interviews.add(action.interview);
    }

    return state.copyWith(
      isLoading: false,
      interviews: interviews,
      error: null,
    );
  } else if (action is GetInterviewFailure) {
    return state.copyWith(
      isLoading: false,
      error: action.error
    );
  } else if (action is GetInterviewsLoading) {
    return state.copyWith(
      isLoading: true,
      error: null
    );
  } else if (action is GetInterviewsSuccess) {
    return state.copyWith(
      hasLoaded: true,
      isLoading: false,
      interviews: action.interviews,
      error: null
    );
  } else if (action is GetInterviewsFailure) {
    return state.copyWith(
      isLoading: false,
      error: action.error,
    );
  } else if (action is CreateInterviewLoading) {
    return state.copyWith(
      isCreating: true,
      error: null,
    );
  } else if (action is CreateInterviewSuccess) {
    List<Interview> interviews = state.interviews ?? new List<Interview>();
    interviews.add(action.interview);

    return state.copyWith(
      isCreating: false,
      interviews: interviews,
      error: null,
    );
  } else if (action is CreateInterviewFailure) {
    return state.copyWith(
      isCreating: false,
      error: action.error,
    );
  } else if (action is EditInterviewLoading) {
    return state.copyWith(
      isUpdating: true,
      error: null,
    );
  } else if (action is EditInterviewSuccess) {
    List<Interview> interviews = List<Interview>.from(state.interviews);
    int i = interviews.indexWhere((interview) => interview.id == action.interview.id);
    interviews[i] = action.interview;
    return state.copyWith(
      isCreating: false,
      isUpdating: false,
      interviews: interviews,
    );
  } else if (action is EditInterviewFailure) {
    return state.copyWith(
      isUpdating: false,
      error: action.error,
    );
  } else if (action is SetCurrentInterview) {
    return state.copyWith(
      currentInterviewId: action.interviewId,
    );
  }

  return state ?? new InterviewState();
}