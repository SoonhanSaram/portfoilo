import 'package:flutter/material.dart';
import 'package:regist/viewmodel/login_view_model.dart';

class BookedViewModel with ChangeNotifier {
  late LoginViewModel loginViewModel;

  BookedViewModel(this.loginViewModel);
}
