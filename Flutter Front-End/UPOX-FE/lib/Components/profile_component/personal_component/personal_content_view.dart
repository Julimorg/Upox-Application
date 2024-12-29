import 'package:first_app/Components/Alert_Component/warning_alert/position_error_alert.dart';
import 'package:first_app/Components/CommonComponent/textbutton_imageicon_left.dart';
import 'package:first_app/Components/CommonComponent/title_text.dart';
import 'package:first_app/Components/profile_component/personal_component/personal_edit_selection.dart';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalContentView extends StatefulWidget {
  const PersonalContentView({super.key});

  @override
  State<PersonalContentView> createState() => _PersonalContentViewState();
}

class _PersonalContentViewState extends State<PersonalContentView> {
  String _username = '';
  String _location = 'Xác định vị trí của bạn';
  List<Placemark>? placemarks;
  Position? currentLoctaion;
  @override
  void initState() {
    super.initState();
    _loadUsername(); // Load username từ SharedPreferences khi widget khởi tạo
  }

  // Hàm để load tên người dùng đã lưu trong SharedPreferences
  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username =
          prefs.getString('username') ?? 'Guest'; // --> Set default cho tên
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationErrorDialog(
          "Vị trí không thể truy cập", "Vui lòng bật dịch vụ định vị.");
      throw Exception("Location services are disabled");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showLocationErrorDialog(
            "Quyền truy cập bị từ chối", "Vui lòng cấp quyền truy cập vị trí.");
        throw Exception("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showLocationErrorDialog("Quyền truy cập bị từ chối vĩnh viễn",
          "Vui lòng cấp quyền truy cập vị trí trong cài đặt.");
      throw Exception("Location permission denied forever");
    }

    return await Geolocator.getCurrentPosition();
  }

//* Cant Catch Location Alet
  void _showLocationErrorDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleAlertDialog(
          title: title,
          content: content,
          buttonText: "OK",
          onPressed: () {
            Navigator.of(context).pop(); // Đóng Dialog khi người dùng nhấn OK
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Container(
      child: Column(
        children: [
          // First Char username
          Container(
            width: width * 0.3,
            height: height * 0.2,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff58639C),
            ),
            child: Center(
              child: Text(
                _username.isNotEmpty ? _username[0].toUpperCase() : 'G',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.18,
                  letterSpacing: 0.5,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                  color: const Color(0xffFFFFFF),
                ),
              ),
            ),
          ),
          // FullName user
          Container(
            child: TitleText(
              titleName: "$_username ",
              fontFam: "Inter",
              fontWeight: FontWeight.w600,
              fontSize: 30,
              textColor: Colors.blue,
            ),
          ),
          // Location
          Container(
            // padding: const EdgeInsets.symmetric(horizontal: 8.0),
            width: width * 0.4,
            height: height * 0.04,
            child: TextbuttonImageiconLeft(
              onPressed: () async {
                currentLoctaion = await _determinePosition();
                placemarks = await placemarkFromCoordinates(
                    currentLoctaion?.latitude ?? 10.9104269,
                    currentLoctaion?.longitude ?? 106.7012909);

                if (placemarks != null && placemarks!.isNotEmpty) {
                  setState(() {
                    _location = placemarks![0].locality ?? 'Unknown location';
                  });
                } else {
                  setState(() {
                    _location = 'Location not found';
                  });
                }
              },
              backgroundColor: Colors.white,
              filterName: _location,
              fontSize: 10,
              fontFamily: "inter",
              fontWeight: FontWeight.w600,
              // widthFactor: 0.3,
              heightFactor: 0.05,
              iconImage: "assets/location_icon.png",
              iconHeight: 10,
              iconWidth: 10,
            ),
          ),
          const SizedBox(height: 5),
          // Self - Product // Achievement
          Container(
            width: width * 0.7,
            height: height * 0.1,
            // color: Colors.blueGrey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: const Column(
                    children: [
                      TitleText(
                        titleName: "25",
                        fontFam: "inter",
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        textColor: Color(0xff002454),
                      ),
                      TitleText(
                        titleName: "Sản Phẩm",
                        fontFam: "inter",
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        textColor: Color(0xff18A0FB),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: const Column(
                    children: [
                      TitleText(
                        titleName: "3",
                        fontFam: "inter",
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        textColor: Color(0xff002454),
                      ),
                      TitleText(
                        titleName: "Thành Tựu",
                        fontFam: "inter",
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        textColor: Color(0xff18A0FB),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Self - Informations
          Container(
            // color: Colors.amber,
            width: width * 1,
            height: height * 0.35,
            // color: Colors.blueGrey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TitleText(
                  titleName: "Thông tin cá nhân",
                  fontFam: "Inter",
                  fontWeight: FontWeight.w700,
                  textColor: Color(0xff58639C),
                  fontSize: 20,
                ),
                const SizedBox(height: 10),
                //! Default Option do not the widget
                Container(
                  child: PersonalEditSelection(
                    labelText: "$_username ",
                    weightText: "",
                    fontSize: 13,
                    gradientStartColor: Colors.white,
                    gradientEndColor: Colors.white,
                    width: width * 0.9,
                    height: height * 0.8,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: 10),
                //! Default Option do not the widget
                Container(
                  child: PersonalEditSelection(
                    labelText: "Nam ",
                    weightText: "",
                    fontSize: 13,
                    gradientStartColor: Colors.white,
                    gradientEndColor: Colors.white,
                    width: width * 0.9,
                    height: height * 0.8,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: 10),
                //? Edit DATE OF BIRTH
                Container(
                  child: PersonalEditSelection(
                    labelText: "Ngày Sinh ",
                    weightText: "",
                    fontSize: 13,
                    gradientStartColor: const Color(0xffB0E0E6),
                    gradientEndColor: Colors.white,
                    dotColor: Colors.blue,
                    width: width * 0.9,
                    height: height * 0.8,
                    fontWeight: FontWeight.w300,
                    textColor: const Color(0xff6A6A6A),
                    fontStyle: FontStyle.italic,
                    iconImage: "assets/edit_button.png",
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: 10),
                //! Default Option do not the widget
                Container(
                  child: PersonalEditSelection(
                    labelText: "kienphongtran2003@gmail.com",
                    weightText: "",
                    fontSize: 13,
                    gradientStartColor: Colors.white,
                    gradientEndColor: Colors.white,
                    width: width * 0.9,
                    height: height * 0.8,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: 10),
                //? Edit Phone number
                Container(
                  child: PersonalEditSelection(
                    labelText: "Số điện thoại ",
                    weightText: "",
                    fontSize: 13,
                    gradientStartColor: const Color(0xffB0E0E6),
                    gradientEndColor: Colors.white,
                    dotColor: Colors.blue,
                    width: width * 0.9,
                    height: height * 0.8,
                    fontWeight: FontWeight.w300,
                    textColor: const Color(0xff6A6A6A),
                    fontStyle: FontStyle.italic,
                    iconImage: "assets/edit_button.png",
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: 10),
                //? Edit OTP
                Container(
                  child: PersonalEditSelection(
                    labelText: "Smart OTP ",
                    weightText: "",
                    fontSize: 13,
                    gradientStartColor: const Color(0xffB0E0E6),
                    gradientEndColor: Colors.white,
                    dotColor: Colors.blue,
                    width: width * 0.9,
                    height: height * 0.8,
                    fontWeight: FontWeight.w300,
                    textColor: const Color(0xff6A6A6A),
                    fontStyle: FontStyle.italic,
                    iconImage: "assets/edit_button.png",
                    onPressed: () {
                      print("xin chao");
                    },
                  ),
                ),
              ],
            ),
          ),
          // Footer Text
          Container(
            child: Column(
              children: [
                const TitleText(
                  titleName:
                      "*Ban hãy kiểm tra thông tin cá nhân đã cung cấp để\nnhận được sự hỗ trợ tốt nhất từ UPOX nhé",
                  textColor: Color(0xff18A0FB),
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                TextbuttonImageiconLeft(
                  onPressed: () {},
                  widthFactor: 0.55,
                  heightFactor: 0.01,
                  textColor: Colors.blue,
                  fontSize: 13,
                  iconWidth: 16,
                  iconHeight: 16,
                  backgroundColor: const Color(0xffE6F1FD),
                  filterName: "Chăm sóc khách hàng",
                  iconImage: "assets/chamsockhachhang_icon.png",
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
