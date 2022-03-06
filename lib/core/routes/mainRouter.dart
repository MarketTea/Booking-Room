import '../../modules/feedback/feedbackScreen.dart';

import '../../modules/editPassword/editPasswordScreen.dart';

import '../../modules/userInfo/editInfoScreen.dart';
import '../../modules/userInfo/userInfoScreen.dart';
import '../../models/control/room.dart';
import '../../modules/addMeeting/addMeetingView.dart';
import '../../modules/addMeeting/selectParticipant/selectParticipantView.dart';
import '../../modules/addMeeting/selectRepeat/selectRepeatView.dart';
import '../../modules/addMeeting/selectRoom/selectRoomView.dart';
import '../../modules/adminControl/deviceListControl/deviceListControlView.dart';
import '../../modules/adminControl/roomListControl/roomListControlView.dart';
import '../../modules/forgotPassword/forgotPasswordView.dart';
import '../../modules/home/homeView.dart';
import '../../modules/meetingCalendar/meetingCalendarView.dart';
import '../../modules/meetingDetails/meetingDetailsView.dart';
import '../../modules/signIn/signInView.dart';
import '../../modules/splash/splashView.dart';
import 'package:flutter/material.dart';

import 'dialogPageRoute.dart';
import 'routeName.dart';

class MainRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.initial:
        return MaterialPageRoute<dynamic>(
          builder: (_) => SplashView(),
        );
      case RouteName.signIn:
        return MaterialPageRoute<dynamic>(
          builder: (_) => SignInView(),
        );
      case RouteName.forgotPassword:
        return MaterialPageRoute<dynamic>(
          builder: (_) => ForgotPasswordView(),
        );
      case RouteName.home:
        return MaterialPageRoute<dynamic>(
          builder: (_) => HomeView(RouteName.home),
        );
      case RouteName.smartMeeting:
        return DialogPageRoute<dynamic>(
          builder: (_) => HomeView(RouteName.smartMeeting),
        );
      case RouteName.addMeeting:
        return DialogPageRoute<dynamic>(
          builder: (_) => AddMeetingView(),
        );
      case RouteName.selectRoom:
        return MaterialPageRoute<dynamic>(
          builder: (_) => SelectRoomView(),
        );
      case RouteName.selectParticipant:
        return MaterialPageRoute<dynamic>(
          builder: (_) => SelectParticipantView(),
        );
      case RouteName.selectRepeat:
        return MaterialPageRoute<dynamic>(
          builder: (_) => SelectRepeatView(),
        );
      case RouteName.meetingDetails:
        return MaterialPageRoute<dynamic>(
          builder: (_) => MeetingDetailsView(),
        );
      case RouteName.meetingCalendar:
        return MaterialPageRoute<dynamic>(
          builder: (_) => MeetingCalendarView(),
        );
      case RouteName.roomListControl:
        return MaterialPageRoute<dynamic>(
          builder: (_) => RoomListControlView(),
        );
      case RouteName.deviceListControl:
        return MaterialPageRoute<dynamic>(
          builder: (_) => DeviceListControlView(settings.arguments as Room),
        );
      case RouteName.userInfo:
        return MaterialPageRoute<dynamic>(
          builder: (_) => UserInfoScreen(),
        );
      case RouteName.editInfo:
        return MaterialPageRoute<dynamic>(
          builder: (_) => EditInfoScreen(),
        );
      case RouteName.editPassword:
        return MaterialPageRoute<dynamic>(
          builder: (_) => EditPasswordScreen(),
        );
      case RouteName.feedback:
        return MaterialPageRoute<dynamic>(
          builder: (_) => FeedbackScreen(),
        );
      default:
        return MaterialPageRoute<dynamic>(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text(
                'No route defined for ${settings.name}',
              ),
            ),
          );
        });
    }
  }
}
