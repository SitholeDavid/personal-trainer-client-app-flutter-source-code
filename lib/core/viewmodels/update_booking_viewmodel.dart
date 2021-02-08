import 'package:stacked/stacked.dart';

class UpdateBookingViewModel extends BaseViewModel {
  final updateOptions = <String>[
    'Reserve session',
    'Cancel session',
    'Make session unavailable'
  ];

  bool disableKeyboard;
  String selectedOption;

  void initialise() {
    selectedOption = updateOptions[0];
    disableKeyboard = false;
    notifyListeners();
  }

  void updateSelectedOption(String option) {
    selectedOption = option;
    disableKeyboard = updateOptions.indexOf(option) != 0 ? true : false;
    notifyListeners();
  }
}
