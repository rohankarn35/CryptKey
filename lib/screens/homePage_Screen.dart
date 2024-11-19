import 'package:cached_network_image/cached_network_image.dart';
import 'package:cryptkey/data/uploadToCloud.dart';
import 'package:cryptkey/data/uploadToHive.dart';
import 'package:cryptkey/provider/screenProvider.dart';
import 'package:cryptkey/screens/passwordDetailScreen.dart';
import 'package:cryptkey/screens/userPage.dart';
import 'package:cryptkey/utils/isGuestUser.dart';
import 'package:cryptkey/utils/toastMessage.dart';
import 'package:cryptkey/widgets/customDialog_widget.dart';
import 'package:cryptkey/widgets/customIcon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<bool> isFirst() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirst = prefs.getBool('isFirst') ?? true;
    return isFirst;
  }

  Future<void> upload() async {
    if (await isFirst()) {
      await UploadToHive().uploadDataToHive();
    }
  }

  Future<void> updateWhileInternetConnection() async {
    if (await InternetConnectionChecker().hasConnection) {
      await UploadToCloud().uploadToCloud();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bool isGuesUser = isGuestUser();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!isGuesUser) {
        await upload();
        await updateWhileInternetConnection();
      }
      Provider.of<ScreenProvider>(context, listen: false).setPlatforms();
      Provider.of<ScreenProvider>(context, listen: false).setPin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 80,
          backgroundColor: const Color.fromARGB(255, 2, 18, 46),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const UserPage()));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Hero(
                  tag: 'user',
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: ClipOval(
                      child: !isGuestUser()
                          ? CachedNetworkImage(
                              width: 40,
                              height: 40,
                              imageUrl:
                                  FirebaseAuth.instance.currentUser!.photoURL!,
                              progressIndicatorBuilder: (context, url,
                                      downloadProgress) =>
                                  SvgPicture.asset("assets/icons/others.svg"),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )
                          : SvgPicture.asset(
                              "assets/icons/others.svg",
                              height: 40,
                              width: 40,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
              ),
            )
          ],
          title: const Text(
            'CryptKey',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.5,
            ),
          ),
        ),
        body: Consumer<ScreenProvider>(
          builder: (context, value, child) {
            return value.platformsList.isEmpty
                ? const Center(
                    child: Text(
                      "Tap on + icon to add data",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    itemCount: value.platformsList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 8.0, right: 8.0),
                        child: Card(
                          color: const Color.fromARGB(255, 2, 27, 70),
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: value.numberOfAccounts(
                                      value.platformsList[index]) ==
                                  0
                              ? Container()
                              : ListTile(
                                  leading: Hero(
                                    tag: value.platformsList[index].toString(),
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: CustomIcon().customIcon(
                                          value.platformsList[index]
                                              .toLowerCase(),
                                          35),
                                    ),
                                  ),
                                  title: Text(
                                    value.platformsList[index],
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 23),
                                  ),
                                  subtitle: Text(
                                    "${value.numberOfAccounts(value.platformsList[index])} accounts",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 13),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PasswordDetailsScreen(
                                                  platformName: value
                                                      .platformsList[index],
                                                  index: index,
                                                )));
                                  },
                                ),
                        ),
                      );
                    });
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white.withAlpha(200),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          onPressed: () {
            try {
              CustomDialog().showCustomDialog(context);
            } catch (e) {
              ToastMessage.showToast("Error Occured");
            }
          },
          child: const Icon(
            Icons.add,
            color: Color.fromARGB(255, 2, 18, 46),
          ),
        ));
  }
}
