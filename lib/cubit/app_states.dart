abstract class AppStates{}
 class AppInitialState extends AppStates{}
 class AppGetDateFromUserState extends AppStates{}
 class AppGetTimeFromUserState extends AppStates{}
 class AppGetRemindFromUserState extends AppStates{}
 class AppGetRepeatFromUserState extends AppStates{}
class AppCreateDatabaseSuccessState extends AppStates{}
class AppCreateDatabaseErrorState extends AppStates{}

class AppInsertSuccessState extends AppStates{}
class AppInsertErrorState extends AppStates{}
class AppGetDataSuccessState extends AppStates{}
class AppGetDataErrorState extends AppStates{}
class AppChangeTaskState extends AppStates{}
class AppMakeTaskCompleteState extends AppStates{}
class AppTaskUnCompleteState extends AppStates{}
class AppTaskFavouriteState extends AppStates{}
class AppTaskCompleteFilterState extends AppStates{}
class AppTaskFavouriteFilterState extends AppStates{}
class AppUpdateTaskSuccessState extends AppStates{}
class AppDeleteTaskSuccessState extends AppStates{}
class AppUpdateTaskErrorState extends AppStates{}
class AppDeleteTaskErrorState extends AppStates{}

class AppSelectedDateTimeState extends AppStates{}