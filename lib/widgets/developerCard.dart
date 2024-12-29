import 'package:cryptkey/widgets/customIcon.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperCard extends StatelessWidget {
  DeveloperCard();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage("assets/images/devprofile.png"),
                fit: BoxFit.contain,
              ),
            ),
            width: 150,
            height: 150,
          ),
          SizedBox(height: 10),
          Text(
            "Rohan Karn",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  _launchUrl("https://github.com/rohankarn35");
                },
                child: CustomIcon().customIcon("github", 30),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  // Add your onTap code here for Instagram
                  _launchUrl("https://www.instagram.com/rohankarn487/");
                },
                child: CustomIcon().customIcon("instagram", 30),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  _launchUrl("https://www.linkedin.com/in/rohankarn35/");
                },
                child: CustomIcon().customIcon("linkedin", 30),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  _launchUrl("https://www.rohankarn.com.np/");
                },
                child: CustomIcon().customIcon("others", 30),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri _url = Uri.parse(urlString);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}

void showDeveloperCard(
  BuildContext context,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return DeveloperCard();
    },
  );
}
