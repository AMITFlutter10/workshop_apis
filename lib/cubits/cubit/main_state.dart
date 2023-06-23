part of 'main_cubit.dart';

@immutable
abstract class MainState {}

class MainInitial extends MainState {}

//! ---------------------------------------------
class LoadingLogin extends MainState {}

class SuccessLogin extends MainState {}

class ErrorLogin extends MainState {
  String? message;
  ErrorLogin({this.message});
}

//! ---------------------------------------------
class LoadingRegister extends MainState {}

class SuccessRegister extends MainState {}

class ErrorRegister extends MainState {
  String? message;
  ErrorRegister({this.message});
}

//! ---------------------------------------------
class LoadingGetCategories extends MainState {}

class SuccessGetCategories extends MainState {}

class ErrorGetCategories extends MainState {
  String? message;
  ErrorGetCategories({this.message});
}

//! ---------------------------------------------
class LoadingCreateCategory extends MainState {}

class SuccessCreateCategory extends MainState {}

class ErrorCreateCategory extends MainState {
  String? message;
  ErrorCreateCategory({this.message});
}

//! ---------------------------------------------
class SearchCategories extends MainState {}
