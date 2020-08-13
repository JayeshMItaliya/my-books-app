import 'package:byebye_flutter_app/bloc/people_filter_bloc.dart';
import 'package:byebye_flutter_app/constants/strings.dart';
import 'package:byebye_flutter_app/model/book_lover.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'book_lover_helper.dart';

List selectedGenderUser = [];
List selectedAgeUser = [];
List selectedInventoryUser = [];
List selectedActivityUser = [];
DateTime currentTime = DateTime.now();

class PeopleFilterHelper {
  PeopleFilterHelper(
      {dynamic parsedUserResponse,
      String genderValue,
      String ageValue,
      String inventoryVal,
      String activityVal}) {
    genderFilterHandler(
        parsedUserResponse, genderValue, ageValue, inventoryVal, activityVal);
  }

  // GENDER FILTER

  Future<dynamic> genderFilterHandler(parsedUserResponse, genderValue, ageValue,
      inventoryVal, activityVal) async {
    selectedGenderUser = [];
    if (parsedUserResponse.isNotEmpty) {
      for (dynamic user in parsedUserResponse) {
        if (user.data['uid'] != prefsObject.getString('uid')) {
          if (user['gender'] != '') {
            genderSwitchcase(
                BookLover(
                    parsedUserData: user,
                    bookCount: user['totalBooksVolume'] ?? 0,
                    fanCount: user['fans'].length ?? 0,
                    userStatus: userPresence(user),
                    color: badgeColorSetter(user)),
                genderValue);
          }
        }
      }
    }
    if (ageValue != null || inventoryVal != null || activityVal != null) {
      await ageFilterHandler(
          genderValue != null && selectedGenderUser.isEmpty
              ? []
              : selectedGenderUser.isNotEmpty
                  ? selectedGenderUser
                  : parsedUserResponse,
          ageValue,
          inventoryVal,
          activityVal);
    } else {
      await peopleFilterBloc.updateSelectedFilterData(selectedGenderUser);
    }
  }

  dynamic genderSwitchcase(user, genderValue) {
    switch (genderValue) {
      case Strings.peopleFilterByGender:
        {
          selectedGenderUser.add(user);
        }
        break;
      case Strings.peopleFilterByAllGender:
        {
          selectedGenderUser.add(user);
        }
        break;
      case Strings.peopleFilterByMale:
        {
          filterByMale(user, genderValue);
        }
        break;
      case Strings.peopleFilterByFemale:
        {
          filterByFemale(user, genderValue);
        }
        break;
      case Strings.peopleFilterByOther:
        {
          filterByOther(user, genderValue);
        }
        break;
    }
  }

  dynamic filterByMale(user, genderValue) {
    if (user.gender == genderValue) {
      selectedGenderUser.add(user);
    }
  }

  dynamic filterByFemale(user, genderValue) {
    if (user.gender == genderValue) {
      selectedGenderUser.add(user);
    }
  }

  dynamic filterByOther(user, genderValue) {
    if (user.gender == genderValue) {
      selectedGenderUser.add(user);
    }
  }

  // AGE FILTER

  Future<dynamic> ageFilterHandler(
      parsedUserResponse, ageValue, inventoryVal, activityVal) async {
    selectedAgeUser = [];
    if (parsedUserResponse.isNotEmpty) {
      for (dynamic user in parsedUserResponse) {
        if (selectedGenderUser.isNotEmpty) {
          if (user.age != '') {
            ageSwitchcase(user, ageValue);
          }
        } else {
          if (user.data['uid'] != prefsObject.getString('uid')) {
            if (selectedAgeUser.contains(BookLover(
                    bookCount: user['totalBooksVolume'] ?? 0,
                    fanCount: user['fans'].length ?? 0,
                    parsedUserData: user,
                    userStatus: userPresence(user),
                    color: badgeColorSetter(user))) !=
                true) {
              if (user.data['age'] != '') {
                ageSwitchcase(
                    BookLover(
                        parsedUserData: user,
                        bookCount: user['totalBooksVolume'] ?? 0,
                        fanCount: user['fans'].length ?? 0,
                        userStatus: userPresence(user),
                        color: badgeColorSetter(user)),
                    ageValue);
              }
            }
          }
        }
      }
    }
    if (inventoryVal != null || activityVal != null) {
      await inventoryFilterHandler(
          ageValue != null && selectedAgeUser.isEmpty
              ? []
              : selectedAgeUser.isNotEmpty
                  ? selectedAgeUser
                  : parsedUserResponse,
          inventoryVal,
          activityVal);
    } else {
      await peopleFilterBloc.updateSelectedFilterData(selectedAgeUser);
    }
  }

  dynamic ageSwitchcase(user, ageValue) {
    switch (ageValue) {
      case Strings.peopleFilterByAge:
        {
          selectedAgeUser.add(user);
        }
        break;
      case Strings.peopleFilterByAllAge:
        {
          selectedAgeUser.add(user);
        }
        break;
      case Strings.peopleFilterByUnderTwenty:
        {
          underTwenty(user);
        }
        break;
      case Strings.peopleFilterByTwentyToThirty:
        {
          twentyToThirty(user);
        }
        break;
      case Strings.peopleFilterByThirtyToFourty:
        {
          thirtyToFourty(user);
        }
        break;
      case Strings.peopleFilterByFourtyPlus:
        {
          fourtyPlus(user);
        }
        break;
    }
  }

  dynamic underTwenty(user) {
    final int age = int.parse(user.age);
    if (age < 21) {
      selectedAgeUser.add(user);
    }
  }

  dynamic twentyToThirty(user) {
    final int age = int.parse(user.age);
    if (age > 20 && age < 31) {
      selectedAgeUser.add(user);
    }
  }

  dynamic thirtyToFourty(user) {
    final int age = int.parse(user.age);
    if (age > 30 && age < 41) {
      selectedAgeUser.add(user);
    }
  }

  dynamic fourtyPlus(user) {
    final int age = int.parse(user.age);
    if (age > 40) {
      selectedAgeUser.add(user);
    }
  }

  // INVENTORY FILTER

  Future<dynamic> inventoryFilterHandler(
      parsedUserResponse, inventoryVal, activityVal) async {
    selectedInventoryUser = [];
    if (parsedUserResponse.isNotEmpty) {
      for (dynamic user in parsedUserResponse) {
        if (selectedGenderUser.isNotEmpty) {
          if (user.booksCount != '') {
            inventorySwitchcase(user, inventoryVal);
          }
        } else if (selectedAgeUser.isNotEmpty) {
          if (user.booksCount != '') {
            if (selectedInventoryUser.contains(user) != true) {
              inventorySwitchcase(user, inventoryVal);
            }
          }
        } else {
          if (user.data['uid'] != prefsObject.getString('uid')) {
            if (selectedInventoryUser.contains(BookLover(
                    bookCount: user['totalBooksVolume'] ?? 0,
                    fanCount: user['fans'].length ?? 0,
                    parsedUserData: user,
                    userStatus: userPresence(user),
                    color: badgeColorSetter(user))) !=
                true) {
              inventorySwitchcase(
                  BookLover(
                      parsedUserData: user,
                      bookCount: user['totalBooksVolume'] ?? 0,
                      fanCount: user['fans'].length ?? 0,
                      userStatus: userPresence(user),
                      color: badgeColorSetter(user)),
                  inventoryVal);
            }
          }
        }
      }
    }
    if (activityVal != null) {
      await activityFilterHandler(
          inventoryVal != null && selectedInventoryUser.isEmpty
              ? []
              : selectedInventoryUser.isNotEmpty
                  ? selectedInventoryUser
                  : parsedUserResponse,
          activityVal);
    } else {
      await peopleFilterBloc.updateSelectedFilterData(selectedInventoryUser);
    }
  }

  dynamic inventorySwitchcase(user, inventoryVal) {
    switch (inventoryVal) {
      case Strings.peopleFilterByInventory:
        {
          selectedInventoryUser.add(user);
        }
        break;
      case Strings.peopleFilterByAllInventory:
        {
          selectedInventoryUser.add(user);
        }
        break;
      case Strings.peopleFilterByMoreThanTwentyFive:
        {
          twentyFivePlus(user);
        }
        break;
      case Strings.peopleFilterByMoreThanFifty:
        {
          fiftyPlus(user);
        }
        break;
      case Strings.peopleFilterByMoreThanHundred:
        {
          hundredPlus(user);
        }
        break;
      case Strings.peopleFilterByMoreThanTwoHundred:
        {
          twoHundredPlus(user);
        }
        break;
    }
  }

  dynamic twentyFivePlus(user) {
    if (user.booksCount > 25) {
      selectedInventoryUser.add(user);
    }
  }

  dynamic fiftyPlus(user) {
    if (user.booksCount > 50) {
      selectedInventoryUser.add(user);
    }
  }

  dynamic hundredPlus(user) {
    if (user.booksCount > 100) {
      selectedInventoryUser.add(user);
    }
  }

  dynamic twoHundredPlus(user) {
    if (user.booksCount > 200) {
      selectedInventoryUser.add(user);
    }
  }

  // ACTIVITY FILTER

  Future<dynamic> activityFilterHandler(parsedUserResponse, activityVal) async {
    selectedActivityUser = [];
    if (parsedUserResponse.isNotEmpty) {
      for (dynamic user in parsedUserResponse) {
        if (selectedGenderUser.isNotEmpty) {
          if (user.status != null) {
            activitySwitchcase(user, activityVal);
          }
        } else if (selectedAgeUser.isNotEmpty) {
          if (user.status != null) {
            if (selectedActivityUser.contains(user) != true) {
              activitySwitchcase(user, activityVal);
            }
          }
        } else if (selectedInventoryUser.isNotEmpty) {
          if (user.status != null) {
            if (selectedActivityUser.contains(user) != true) {
              activitySwitchcase(user, activityVal);
            }
          }
        } else {
          if (user.data['activeTime'] != null) {
            if (user.data['uid'] != prefsObject.getString('uid')) {
              if (selectedActivityUser.contains(BookLover(
                      bookCount: user['totalBooksVolume'] ?? 0,
                      fanCount: user['fans'].length ?? 0,
                      parsedUserData: user,
                      userStatus: userPresence(user),
                      color: badgeColorSetter(user))) !=
                  true) {
                activitySwitchcase(
                    BookLover(
                        bookCount: user['totalBooksVolume'] ?? 0,
                        fanCount: user['fans'].length ?? 0,
                        parsedUserData: user,
                        userStatus: userPresence(user),
                        color: badgeColorSetter(user)),
                    activityVal);
              }
            }
          }
        }
      }
    }
    activityVal != null && selectedActivityUser.isEmpty
        ? await peopleFilterBloc.updateSelectedFilterData(selectedActivityUser)
        : await peopleFilterBloc.updateSelectedFilterData(selectedActivityUser);
    return;
  }

  dynamic activitySwitchcase(user, activityVal) {
    switch (activityVal) {
      case Strings.peopleFilterByActivity:
        {
          selectedActivityUser.add(user);
        }
        break;
      case Strings.peopleFilterByAllActivity:
        {
          selectedActivityUser.add(user);
        }
        break;
      case Strings.peopleFilterByCurrentDay:
        {
          activeToday(user);
        }
        break;
      case Strings.peopleFilterByActiveNow:
        {
          activeNow(user);
        }
        break;
    }
  }

  dynamic activeToday(user) {
    if (user.status.contains(Strings.peopleFilterByCurrentDay) ||
        user.status.contains(Strings.peopleFilterByActiveNow)) {
      selectedActivityUser.add(user);
    }
  }

  dynamic activeNow(user) {
    if (user.status.contains(Strings.peopleFilterByActiveNow)) {
      selectedActivityUser.add(user);
    }
  }
}
