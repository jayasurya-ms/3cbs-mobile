import 'package:concepts/Controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Controller controller = Get.put(Controller());
  RxBool isLoading = true.obs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  Future<void> initData() async {
    isLoading.value = true;

    await controller.getLoginToken();
    await controller.getRecentTrip();
    await controller.getTripHistory();

    isLoading.value = false;

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Get.width/10,),
            // Center(child: SvgPicture.asset("assets/map.svg",fit: BoxFit.contain,width: Get.width/2.5,height: Get.width/2.5,)),
            // SizedBox(height: Get.width/10,),
            // Center(child: Text("No trip records found",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 18),)),
            // SizedBox(height: Get.width/50,),
            // Center(child: Text("Tap + Add Trip to get started",style: TextStyle(color: Color(0xff7C7C7C),fontWeight: FontWeight.w400,fontSize: 16),))
            Text("Recent Trip",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Color(0xff121212)),),
            SizedBox(height: Get.width/30,),
            Container(
              decoration: BoxDecoration(
                  color: Color(0xffF4F6FA),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(
                      () {
                        if (isLoading.value) {
                          return Center(child: CircularProgressIndicator());
                        }

                        // final trip = controller.recentTripData.value;
                        //
                        // if (trip == null) {
                        //   return Text("No Data Found");
                        // }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Date",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w400),),
                                    Text(DateFormat("dd/MM/yyyy").format(controller.recentTripData.value.tripsDate??DateTime.now()),style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w400),),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Time",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w400),),
                                    Text(controller.recentTripData.value.tripsTime??"",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w400),),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: Get.width/40,),
                            Row(
                              children: [
                                Icon(Icons.location_on, color: Colors.green),
                                SizedBox(width: Get.width/50),
                                Text("From: ${controller.recentTripData.value.fromsite == null?"":controller.recentTripData.value.fromsite!.siteName}",style: TextStyle(color: Color(0xff121212),fontWeight: FontWeight.w400,fontSize: 14),),
                              ],
                            ),
                            SizedBox(height: Get.width/40,),
                            Row(
                              children: [
                                Icon(Icons.location_on, color: Colors.red),
                                SizedBox(width: Get.width/50),
                                Text("To: ${controller.recentTripData.value.tosite == null?"":controller.recentTripData.value.tosite!.siteName??""}",style: TextStyle(color: Color(0xff121212),fontWeight: FontWeight.w400,fontSize: 14),),
                              ],
                            ),
                            SizedBox(height: Get.width/40,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Distance: ${controller.recentTripData.value.tripsKm??""} km"),
                                Text(
                                  "₹ ${controller.recentTripData.value.tripsPrice??""}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff2F5D7C),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                ),
              ),
            ),
            SizedBox(height: Get.width/20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("History",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Color(0xff121212)),),
                TextButton(onPressed: () {

                }, child: Text("View all",style: TextStyle(color: Color(0xff7C7C7C),fontSize: 16,fontWeight: FontWeight.w400),))
              ],
            ),
            Expanded(
              child: Obx(
                () =>  ListView.builder(
                  itemCount: controller.tripHistoryDataList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10,bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xffF4F6FA),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Date",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w400),),
                                      Text(DateFormat("dd/MM/yyyy").format(controller.tripHistoryDataList[index].tripsDate!),style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w400),),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Time",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w400),),
                                      Text(controller.tripHistoryDataList[index].tripsTime??"",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w400),),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: Get.width/40,),
                              Row(
                                children: [
                                  Icon(Icons.location_on, color: Colors.green),
                                  SizedBox(width: Get.width/50),
                                  Text("From: ${controller.tripHistoryDataList[index].fromsite!.siteName??""}",style: TextStyle(color: Color(0xff121212),fontWeight: FontWeight.w400,fontSize: 14),),
                                ],
                              ),
                              SizedBox(height: Get.width/40,),
                              Row(
                                children: [
                                  Icon(Icons.location_on, color: Colors.red),
                                  SizedBox(width: Get.width/50),
                                  Text("To: ${controller.tripHistoryDataList[index].tosite!.siteName??""}",style: TextStyle(color: Color(0xff121212),fontWeight: FontWeight.w400,fontSize: 14),),
                                ],
                              ),
                              SizedBox(height: Get.width/40,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Distance: ${controller.tripHistoryDataList[index].tripsKm??""} km"),
                                  Text(
                                    "₹ ${controller.tripHistoryDataList[index].tripsPrice??""}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff2F5D7C),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },),
              ),
            )
          ],
        ),
      ),
    );
  }
}
