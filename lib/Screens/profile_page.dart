import 'package:concepts/Controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Controller controller = Get.put(Controller());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getCompanyData();
    controller.getCompanyImage();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(
          () =>  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: controller.imageLoader.value == false?SizedBox(
                    height: Get.width/5,
                    width: Get.width/5,
                    child: CircularProgressIndicator()):Container(
                  height: Get.width/1.5,
                  width: Get.width/1.5,
                  color: Colors.transparent,
                  child: controller.companyData.value.companyLogo == null || controller.companyData.value.companyLogo!.isEmpty?Image.network(controller.noCompanyImage.value):Image.network("${controller.companyImage.value}${controller.companyData.value.companyLogo}",fit: BoxFit.contain),
                ),
              ),
              Center(child: Text(controller.companyData.value.companyName??"---",style: TextStyle(color: Color(0xff121212),fontSize: 18,fontWeight: FontWeight.w500),)),
              SizedBox(height: Get.width/20,),
              Padding(
                padding: const EdgeInsets.only(right: 100,left: 100),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset("assets/profile/call.svg",height: Get.width/15,width: Get.width/15,fit: BoxFit.contain,color: Color(0xff2F5D7C),),
                        SizedBox(width: Get.width/50,),
                        Flexible(child: Text(controller.companyData.value.companyMobileNo??"",style: TextStyle(color: Color(0xff121212),fontWeight: FontWeight.w400,fontSize: 16),))
                      ],
                    ),
                    SizedBox(height: Get.width/15,),
                    Row(
                      children: [
                        SvgPicture.asset("assets/profile/email.svg",height: Get.width/15,width: Get.width/15,fit: BoxFit.contain,color: Color(0xff2F5D7C),),
                        SizedBox(width: Get.width/50,),
                        Flexible(child: Text(controller.companyData.value.companyEmail??"",style: TextStyle(color: Color(0xff121212),fontWeight: FontWeight.w400,fontSize: 16),))
                      ],
                    ),
                    SizedBox(height: Get.width/15,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset("assets/area.svg",height: Get.width/15,width: Get.width/15,fit: BoxFit.contain,color: Color(0xff2F5D7C),),
                        SizedBox(width: Get.width/50,),
                        Flexible(child: Text(controller.companyData.value.companyPlace??"",style: TextStyle(color: Color(0xff121212),fontWeight: FontWeight.w400,fontSize: 16),))
                      ],
                    ),
                    SizedBox(height: Get.width/15,),
                  ],
                ),
              ),
              SizedBox(height: Get.width/15,),
            ],
          ),
        ),
      ),
    );
  }
}
