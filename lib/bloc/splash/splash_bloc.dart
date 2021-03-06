import 'package:bloc/bloc.dart';
import 'package:sevenclass/helpers/constant_helper.dart';

import '../../app.dart';
import 'bloc.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  int introCurrentPage = 0;

  @override
  // TODO: implement initialState
  SplashState get initialState => InitialSplashState();

  @override
  Stream<SplashState> mapEventToState(SplashEvent event) async* {
    if (event is CheckUserConditionEvent) {
      yield* _checkUserCondition();
    } else if (event is ClearFirstTimeConditionEvent) {
      yield* _clearFirstTimeCondition();
    } else if (event is SetIntroCurrentPageEvent) {
      yield* _changeIntroCurrentPage(event);
    }
  }

  Stream<SplashState> _checkUserCondition() async* {
    yield InitialSplashState();

    bool isAppFirstTimeLaunch = App().sharedPreferences
        .getBool(ConstantHelper.IS_FIRST_TIME_LAUNCH_PREF) ?? true;
    bool isLoggedIn = App().sharedPreferences
        .getBool(ConstantHelper.IS_USER_LOGGED_IN_PREF) ?? false;

    if (isAppFirstTimeLaunch) {
      yield LaunchedFirstTime();
    } else if (isLoggedIn) {
      yield Authenticated();
    } else if (!isLoggedIn) {
      yield NotAuthenticated();
    }
  }

  Stream<SplashState> _clearFirstTimeCondition() async* {
    yield InitialSplashState();
    App().sharedPreferences.setBool(ConstantHelper.IS_FIRST_TIME_LAUNCH_PREF, false);
    yield ClearFirstTimeConditionState();
  }

  Stream<SplashState> _changeIntroCurrentPage(SetIntroCurrentPageEvent event) async* {
    yield InitialSplashState();
    this.introCurrentPage = event.page;
    print(event.page);
    yield SetIntroCurrentPageState(event.page);
  }
}