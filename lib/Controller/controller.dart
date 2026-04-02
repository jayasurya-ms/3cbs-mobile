import 'package:concepts/Model/company_model.dart';
import 'package:concepts/Model/profile_model.dart';
import 'package:concepts/Model/sites_model.dart';
import 'package:concepts/Model/trip_model.dart';
import 'package:concepts/Utils/api_helper.dart';
import 'package:concepts/Utils/shared_pref.dart';
import 'package:get/get.dart';

class Controller extends GetxController{
  RxString loginToken = "".obs;
  Rx<TripDataModel> recentTripData = TripDataModel().obs;
  Rx<ProfileDataModel> profileData = ProfileDataModel().obs;
  RxString noImagePath = "".obs;
  RxString imagePath = "".obs;
  RxList<TripDataModel> tripHistoryDataList = <TripDataModel>[].obs;
  RxList<SitesDataModel> siteDataList = <SitesDataModel>[].obs;
  Rx<SitesDataModel> selectFromSite = SitesDataModel().obs;
  Rx<SitesDataModel> selectToSite = SitesDataModel().obs;
  RxString selectDate = "".obs;
  RxString selectTime = "".obs;
  Rx<CompanyDataModel> companyData = CompanyDataModel().obs;
  RxString noCompanyImage = "".obs;
  RxString companyImage = "".obs;
  RxBool imageLoader = false.obs;


  Future getLoginToken()
  async{
    loginToken.value = await SharedPref.isLoggedToken()??"";
    // print("TTTTTTTTTT222222222 ${loginToken.value.length}");
  }

  Future getRecentTrip()
  async{
    ApiHelper.apiHelper.fetchRecentTrip(token: loginToken.value).then((recentTrip) {
      recentTripData.value = TripDataModel.fromJson(recentTrip["data"]);
    },);
  }

  Future getProfile()
  async{
    final profile = await ApiHelper.apiHelper.fetchProfile(
      token: loginToken.value,
    );

    noImagePath.value = profile["image_url"][0]["image_url"] ?? "";
    imagePath.value = profile["image_url"][1]["image_url"] ?? "";

    profileData.value = ProfileDataModel.fromJson(profile["data"]);
  }

  Future getTripHistory()
  async{
    ApiHelper.apiHelper.fetchTripHistory(token: loginToken.value).then((tripHistory) {
      List filterData = tripHistory["data"];
      tripHistoryDataList.value = filterData.map((e) => TripDataModel.fromJson(e)).toList();
      print("LLLLLLLL ${tripHistoryDataList.length}");
    },);
  }

  Future getSites()
  async{
    ApiHelper.apiHelper.fetchSites(token: loginToken.value).then((sites) {
      List filterData = sites["data"];
      siteDataList.value = filterData.map((e) => SitesDataModel.fromJson(e)).toList();
      print("SSSSSSSSSS ${siteDataList.length}");
    },);
  }

  Future getCompanyData()
  async{
    companyData.value =await SharedPref.getCompanyData()??CompanyDataModel();
  }

  Future getCompanyImage()
  async{
    noCompanyImage.value =await SharedPref.getNoImagePath()??"";
    companyImage.value =await SharedPref.getImagePath()??"";
    imageLoader.value = true;
  }

}