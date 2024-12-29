import 'package:first_app/Components/profile_component/personal_component/personal_content_view.dart';
import 'package:first_app/Components/profile_component/personal_component/personal_header_view.dart';
import 'package:flutter/material.dart';

class PersonalProfilePage extends StatefulWidget {
  const PersonalProfilePage({super.key});

  @override
  State<PersonalProfilePage> createState() => _PersonalProfilePageState();
}

class _PersonalProfilePageState extends State<PersonalProfilePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(child: const PersonalHeaderView()),
              Container(
                width: width * 0.88,
                height: height * 0.88,
                // color: Colors.amber,
                child: const PersonalContentView(),
              )
            ],
          ),
        ),
      )),
    );
  }
}
