import 'package:concepts/Controller/controller.dart';
import 'package:concepts/Model/sites_model.dart';
import 'package:concepts/Screens/home_page.dart';
import 'package:concepts/Screens/profile_page.dart';
import 'package:concepts/Utils/api_helper.dart';
import 'package:concepts/Utils/const_helper.dart';
import 'package:concepts/Utils/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  RxInt bottomIndex = 0.obs;
  Controller controller = Get.put(Controller());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bottomIndex.value = 0;

    initData();
  }

  Future<void> initData() async {
    await controller.getLoginToken();
    await controller.getProfile();
    await controller.getSites();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2F5D7C),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8,right: 8,top: 50,bottom: 10),
            child: Row(
              children: [
                Container(
                  height: Get.width/7,
                  width: Get.width/7,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle
                  ),
                  child: Obx(() {
                    final image = controller.profileData.value.userImage;
                    final baseUrl = controller.imagePath.value;

                    final fullUrl = (image != null &&
                        image.isNotEmpty &&
                        baseUrl.isNotEmpty)
                        ? "$baseUrl$image"
                        : null;

                    if (fullUrl == null) {
                      return const CircleAvatar(
                        radius: 40,
                        child: Icon(Icons.person),
                      );
                    }

                    return ClipOval(
                      child: Image.network(
                        fullUrl,
                        fit: BoxFit.cover,
                        width: 80,
                        height: 80,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error);
                        },
                      ),
                    );
                  }),
                ),
                SizedBox(width: Get.width/50,),
                Obx(
                  () =>  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Welcome to",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w400,),),
                      Text(controller.profileData.value.name??"",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w400,),)
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: Get.width/30,),
          Expanded(
            child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                ),
                child: Obx(() => bottomIndex.value == 0?HomePage():ProfilePage(),)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(side: BorderSide(color: Colors.white,width: 3)),
        backgroundColor: Color(0xff2F5D7C),
        onPressed: () {
          controller.selectFromSite.value.id = 1;
          controller.selectToSite.value.id = 1;
          controller.selectDate.value = DateFormat('dd/MM/yyyy').format(DateTime.now());
          controller.selectTime.value = DateFormat('hh:mm').format(DateTime.now());
          showModalBottomSheet(context: ConstHelper.navigatorKey.currentContext!, builder: (context) {
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15))
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(child: Text("Add Trip",style: TextStyle(fontWeight: FontWeight.w500,color: Color(0xff121212),fontSize: 20),)),
                    SizedBox(height: Get.width/30,),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Date",style: TextStyle(fontSize: 18,color: Color(0xff121212),fontWeight: FontWeight.w400),),
                              SizedBox(height: Get.width/50,),
                              Obx(
                                () =>  TextField(
                                  readOnly: true,
                                  textAlign: TextAlign.center,
                                  controller: TextEditingController(text: controller.selectDate.value),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xffF4F6FA),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide.none,
                                    ),
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.all(12), // adjust spacing
                                      child: SvgPicture.asset(
                                        "assets/calendar.svg",
                                        width: Get.width / 15,
                                        height: Get.width / 15,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  onTap: () async {

                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2100),
                                    );

                                    if (pickedDate != null) {
                                      String formattedDate =
                                      DateFormat("dd/MM/yyyy").format(pickedDate);

                                      controller.selectDate.value = formattedDate;
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: Get.width/50,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Time",style: TextStyle(fontSize: 18,color: Color(0xff121212),fontWeight: FontWeight.w400),),
                              SizedBox(height: Get.width/50,),
                              Obx(
                                    () =>  TextField(
                                  readOnly: true,
                                  textAlign: TextAlign.center,
                                  controller: TextEditingController(text: controller.selectTime.value),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xffF4F6FA),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide.none,
                                    ),
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.all(12), // adjust spacing
                                      child: SvgPicture.asset(
                                        "assets/clock.svg",
                                        width: Get.width / 15,
                                        height: Get.width / 15,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  onTap: () async {

                                    TimeOfDay? pickedTime = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );

                                    final hour = (pickedTime!.hourOfPeriod == 0 ? 12 : pickedTime.hourOfPeriod)
                                        .toString()
                                        .padLeft(2, '0');

                                    final minute = pickedTime.minute.toString().padLeft(2, '0');

                                    controller.selectTime.value = "$hour:$minute";
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: Get.width/30,),
                    Text("From",style: TextStyle(fontSize: 18,color: Color(0xff121212),fontWeight: FontWeight.w400),),
                    SizedBox(height: Get.width/50,),
                    Obx(
                () =>  DropdownButtonFormField<SitesDataModel>(
                  dropdownColor: Colors.white,
                  value: controller.selectFromSite.value.id == 0
                      ? null
                      : controller.siteDataList.firstWhereOrNull(
                        (e) => e.id == controller.selectFromSite.value.id,
                  ),
                  hint: Text("Select From Site"),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xffF4F6FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: controller.siteDataList.map((site) {
                    return DropdownMenuItem<SitesDataModel>(
                      value: site,
                      child: Text(site.siteName!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    controller.selectFromSite.value = value!;
                    print("SSSSSSSSS ${controller.selectFromSite.value.siteName}");
                  },
                ),
              ),
                    SizedBox(height: Get.width/30,),
                    Text("To",style: TextStyle(fontSize: 18,color: Color(0xff121212),fontWeight: FontWeight.w400),),
                    SizedBox(height: Get.width/50,),
                    Obx(
                          () =>  DropdownButtonFormField<SitesDataModel>(
                        dropdownColor: Colors.white,
                        value: controller.selectToSite.value.id == 0
                            ? null
                            : controller.siteDataList.firstWhereOrNull(
                              (e) => e.id == controller.selectToSite.value.id,
                        ),

                            hint: Text("Select To Site"),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xffF4F6FA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: controller.siteDataList.map((toSite) {
                          return DropdownMenuItem<SitesDataModel>(
                            value: toSite,
                            child: Text(toSite.siteName!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          controller.selectToSite.value = value!;
                          print("SSSSSSSSS ${controller.selectToSite.value.siteName}");
                        },
                      ),
                    ),
                    SizedBox(height: Get.width/10,),
                    InkWell(
                      onTap: () {
                        DateTime date = DateFormat("dd/MM/yyyy").parse(controller.selectDate.value);
                        DateTime time = DateFormat("hh:mm").parse(controller.selectTime.value);
                        Loader.showLoader(ConstHelper.navigatorKey.currentContext!, "Please wait...");
                        ApiHelper.apiHelper.createTrip(
                            token: controller.loginToken.value,
                            tripDate: DateFormat("yyyy-MM-dd").format(date),
                            tripTime: DateFormat("hh:mm").format(time),
                            tripFromID: controller.selectFromSite.value.id!,
                            tripToID: controller.selectToSite.value.id!).then((createTrip) async {

                              if(createTrip["code"] == 200)
                                {
                                  Loader.hideLoader(ConstHelper.navigatorKey.currentContext!);
                                  Get.back();
                                  await controller.getRecentTrip();
                                  await controller.getTripHistory();
                                  bottomIndex.value == 0;
                                  ScaffoldMessenger.of(ConstHelper.navigatorKey.currentContext!).showSnackBar(SnackBar(content: Text(createTrip["message"],style: TextStyle(color: Colors.white),),backgroundColor: Colors.green,duration: Duration(seconds: 2),));
                                }
                              else
                                {
                                  Loader.hideLoader(ConstHelper.navigatorKey.currentContext!);
                                  Get.back();
                                  ScaffoldMessenger.of(ConstHelper.navigatorKey.currentContext!).showSnackBar(SnackBar(content: Text(createTrip["message"],style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,duration: Duration(seconds: 2),));
                                }
                            },);

                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xff2F5D7C),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Center(child: Text("Create",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 18),)),
                        ),
                      ),
                    ),
                    SizedBox(height: Get.width/30,),
                  ],
                ),
              ),
            );
          },);
      },
      child: Icon(Icons.add,color: Colors.white,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15,right: 15,left: 15),
          child: Container(
            height: Get.width/6,
            decoration: BoxDecoration(
              color: Color(0xff2F5D7C),
              borderRadius: BorderRadius.circular(20)
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      bottomIndex.value = 0;
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/home.svg",height: Get.width/15,width: Get.width/15,fit: BoxFit.cover,),
                        Text("Home",style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.w400),)
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      bottomIndex.value = 1;
                    },
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/profile.svg",height: Get.width/15,width: Get.width/15,fit: BoxFit.cover,),
                        Text("Profile",style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.w400),)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
