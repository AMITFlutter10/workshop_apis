import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workshop_apis/cubits/cubit/main_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    MainCubit.get(context).getAllCategories();
    super.initState();
  }

  var categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var cubit = MainCubit.get(context);
    // cubit.getAllCategories();
    print(cubit.model!.token);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      floatingActionButton: BlocListener<MainCubit, MainState>(
        listener: (context, state) {
          if (state is SuccessCreateCategory) {
            categoryController.text = "";
            Navigator.pop(context);
          }
        },
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  width: MediaQuery.of(context).size.width * .7,
                  height: MediaQuery.of(context).size.height * .5,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: categoryController,
                      ),
                      MaterialButton(
                        onPressed: () {
                          cubit.addCategory(categoryController.text);
                        },
                        child: const Text("Create Category"),
                      )
                    ],
                  ),
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: SearchBar(
                hintText: "Categories",
                onChanged: (value) {
                  cubit.searchCategories(value);
                },
                trailing: [
                  IconButton(
                      onPressed: () {
                        // cubit.searchCategories(text)
                      },
                      icon: const Icon(Icons.search))
                ],
              ),
            ),
            BlocBuilder<MainCubit, MainState>(
              builder: (context, state) {
                return state is LoadingGetCategories
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cubit.searchItem!.length,
                        itemBuilder: (context, index) {
                          var item = cubit.searchItem![index];
                          return ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.deepOrange,
                            ),
                            title: Text(item.name!),
                          );
                        },
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
