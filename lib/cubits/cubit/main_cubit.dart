import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:workshop_apis/models/category_response_model.dart';

import '../../models/login_response_model.dart';
import '../../utils/dio_helper.dart';
import '../../utils/end_points.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial());

  static MainCubit get(context) => BlocProvider.of(context);
  LoginResponseModel? model;
  login(String? email, String? password) async {
    emit(LoadingLogin());

    await DioHelper.dio.post(
      loginEndPoint,
      data: {"email": email, "password": password},
    ).then((value) {
      if (value.statusCode == 200 && value.data["status"]) {
        model = LoginResponseModel.fromJson(value.data);
        print(model!.token);

        emit(SuccessLogin());
      } else {
        print(value.data["massage"]);
        emit(ErrorLogin(message: value.data["massage"]));
      }
    }).catchError((error) {
      print(error.toString());
      emit(ErrorLogin(message: error.toString()));
    });
  }

  register(String? email, String? pass, String? phone, String? name) async {
    emit(LoadingRegister());
    await DioHelper.dio
        .post(
      registerEndPoint,
      data: FormData.fromMap(
        {
          "name": name,
          "email": email,
          "password": pass,
          "mobile": phone,
        },
      ),
    )
        .then((value) {
      if (value.statusCode == 200) {
        emit(SuccessRegister());
      } else {
        emit(ErrorRegister(message: "All Fields required, or email is taken"));
      }
    }).catchError((error) {
      print(error.toString());
      emit(ErrorRegister(message: error.toString()));
    });
  }

  CategoriesReponseModel? categoriesReponseModel;

  getAllCategories() async {
    emit(LoadingGetCategories());
    await DioHelper.dio
        .get(getAllCategoriesEndPoint,
            options: Options(headers: {
              "Authorization": "Bearer ${model!.token}",
            }))
        .then((value) {
      if (value.statusCode == 200) {
        categoriesReponseModel = CategoriesReponseModel.fromJson(value.data);
        searchItem = categoriesReponseModel!.data;
        emit(SuccessGetCategories());
      } else {
        emit(ErrorGetCategories(message: "Error Please try again later"));
      }
    }).catchError((error) {
      print(error.toString());
      emit(ErrorGetCategories(message: "Error Please try again later"));
    });
  }

  addCategory(String? name) async {
    emit(LoadingCreateCategory());
    await DioHelper.dio
        .post(createCategoryEndPoint,
            data: FormData.fromMap({"name": name}),
            options: Options(headers: {
              "Authorization": "Bearer ${model!.token}",
            }))
        .then((value) {
      if (value.statusCode == 200) {
        emit(SuccessCreateCategory());
        getAllCategories();
      } else {
        emit(ErrorCreateCategory(message: "Error Please try again"));
      }
    }).catchError((error) {
      emit(ErrorCreateCategory(message: "Error Please try again"));

      print(error.toString());
    });
  }

  List<Data>? searchItem;
  searchCategories(String text) {
    searchItem = categoriesReponseModel!.data!
        .where((element) =>
            element.name!.toLowerCase().contains(text.toLowerCase()))
        .toList();

    emit(SearchCategories());
  }
}
