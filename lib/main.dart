import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() {
  runApp(MyApp());
}

class PageData {
  final String title;
  final IconData icon;

  PageData(this.title, this.icon);
}

class HomeController extends GetxController {
  var currentIndex = 0.obs;

  var storedData = "".obs;
  void changePage(int index) {
    currentIndex.value = index;
  }

  void saveData(String text) async {
    storedData.value = text;
    GetStorage().write("data", storedData.value);
    update();
  }

  void loadData() async {
    storedData.value =
        GetStorage().read("data") ?? "There is no data saved in local storage";
    update();
  }

  void deleteData() async {
    GetStorage().remove("data");
    storedData.value = "";
    loadData();
    update();
  }

  @override
  void onInit() {
    loadData();
    super.onInit();
  }
}

class MyApp extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Local Storage',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePageView());
  }
}

class HomePageView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final List<PageData> pages = [
    PageData("data", Icons.home),
    PageData("update", Icons.update),
    PageData("delete", Icons.delete),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(pages[controller.currentIndex.value].title)),
      ),
      body: Center(
        child: Obx(() => _getPage(context)),
      ),
      bottomNavigationBar: Obx(() => _buildBottomNavigationBar(context)),
    );
  }

  Widget _getPage(BuildContext context) {
    switch (controller.currentIndex.value) {
      case 0:
        return Container(
          child: Center(
            child: Text(controller.storedData.value),
          ),
        );
      case 1:
        return Container(
          child: Center(
            child: TextButton(
                onPressed: () {
                  controller.saveData("data is exist");
                  controller.loadData();
                },
                child: Text("update data")),
          ),
        );
      case 2:
        return Container(
          child: Center(
            child: TextButton(
                onPressed: () {
                  controller.deleteData();
                },
                child: Text("deleteData")),
          ),
        );
      default:
        return Container();
    }
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: controller.currentIndex.value,
      onTap: (index) {
        controller.changePage(index);
      },
      items: pages.map((page) {
        return BottomNavigationBarItem(
          icon: Icon(page.icon),
          label: page.title,
        );
      }).toList(),
    );
  }
}
