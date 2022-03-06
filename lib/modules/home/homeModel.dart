import '../../constants/key_prefs.dart';
import '../../models/user.dart';
import '../../utils/asyncStorage.dart';
import '../../core/locales/i18nKey.dart';
import '../../core/routes/routeName.dart';
import '../../modules/base/baseModel.dart';

class HomeModel extends BaseModel {
  final String module;
  HomeModel(this.module);
  int currentIndex = 0;
  String currentRoute;
  String currentTitle;
  User currentUser;

  void navigate(int value) {
    if (value == currentIndex) return;
    currentIndex = value;
    _updateCurrentRoute();
    _updateCurrentTitle();
    notifyListeners();
  }

  Future<void> init() async {
    String strUser = await AsyncStorage.get(KeyPrefs.USER_PROFILE);
    currentUser = userFromJson(strUser);
    notifyListeners();
  }

  void _updateCurrentRoute() {
    switch (module) {
      case RouteName.home:
        switch (currentIndex) {
          case 0:
            currentRoute = RouteName.home;
            break;
          case 1:
            currentRoute = RouteName.notification;
            break;
          case 2:
            currentRoute = RouteName.setting;
            break;
          default:
            currentRoute = RouteName.home;
            break;
        }
        break;
      case RouteName.smartMeeting:
        switch (currentIndex) {
          case 0:
            currentRoute = RouteName.roomMeeting;
            break;
          case 1:
            currentRoute = RouteName.myMeeting;
            break;
          case 2:
            currentRoute = RouteName.addMeeting;
            break;
          case 3:
            currentRoute = RouteName.roomListControl;
            break;
          default:
            currentRoute = RouteName.roomMeeting;
            break;
        }
        break;
      default:
        switch (currentIndex) {
          case 0:
            currentRoute = RouteName.home;
            break;
          case 1:
            currentRoute = RouteName.notification;
            break;
          case 2:
            currentRoute = RouteName.setting;
            break;
          default:
            currentRoute = RouteName.home;
            break;
        }
        break;
    }
  }

  void _updateCurrentTitle() {
    switch (module) {
      case RouteName.home:
        switch (currentIndex) {
          case 0:
            currentTitle = I18nKey.masterApp;
            break;
          case 1:
            currentTitle = I18nKey.notification;
            break;
          case 2:
            currentTitle = I18nKey.setting;
            break;
          default:
            currentTitle = I18nKey.masterApp;
            break;
        }
        break;
      case RouteName.smartMeeting:
        switch (currentIndex) {
          case 0:
            currentTitle = I18nKey.meetingRoom;
            break;
          case 1:
            currentTitle = I18nKey.myMeeting;
            break;
          case 2:
            currentTitle = I18nKey.orderRoom;
            break;
          case 3:
            currentTitle = I18nKey.adminControl;
            break;
          default:
            currentTitle = I18nKey.meetingRoom;
            break;
        }
        break;
      default:
        switch (currentIndex) {
          case 0:
            currentTitle = I18nKey.masterApp;
            break;
          case 1:
            currentTitle = I18nKey.notification;
            break;
          case 2:
            currentTitle = I18nKey.setting;
            break;
          default:
            currentTitle = I18nKey.masterApp;
            break;
        }
        break;
    }
  }
}
