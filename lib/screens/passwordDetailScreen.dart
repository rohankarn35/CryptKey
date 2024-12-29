import 'package:cryptkey/Firebase/cloudstore.dart';
import 'package:cryptkey/data/boxes.dart';
import 'package:cryptkey/data/platformData.dart';
import 'package:cryptkey/data/uploadToCloud.dart';
import 'package:cryptkey/provider/screenProvider.dart';
import 'package:cryptkey/utils/mobileAuth.dart';
import 'package:cryptkey/utils/toastMessage.dart';
import 'package:cryptkey/widgets/customIcon.dart';
import 'package:cryptkey/widgets/editAccountDialog.dart';
import 'package:cryptkey/widgets/showConfirmationwidget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasswordDetailsScreen extends StatefulWidget {
  final String platformName;
  final int index;
  const PasswordDetailsScreen({
    super.key,
    required this.platformName,
    required this.index,
  });

  @override
  State<PasswordDetailsScreen> createState() => _PasswordDetailsScreenState();
}

class _PasswordDetailsScreenState extends State<PasswordDetailsScreen> {
  late List<int> platformIndex;
  bool isVisible = false;
  late List<bool> isVisibleList;
  late int numberofAccounts;

  Future<bool> isFirst() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isFirst') ?? true;
  }

  Future<void> updateWhileInternetConnection() async {
    if (!await isFirst() && await InternetConnectionChecker().hasConnection) {
      CloudFirestoreService().updateWhileInternetConnection();
    }
  }

  late BuildContext parentContext;

  @override
  void initState() {
    updateWhileInternetConnection();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      parentContext = context;
    });
    numberofAccounts = ScreenProvider().numberOfAccounts(widget.platformName);
    isVisibleList = List.generate(numberofAccounts, (index) => false);

    platformIndex = platformData().getPlatformData(widget.platformName);
    super.initState();
  }

  pop() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 18, 46),
        leading: IconButton(
          onPressed: () {
            final screenProvider =
                Provider.of<ScreenProvider>(context, listen: false);
            screenProvider.setPlatforms();
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Consumer<ScreenProvider>(
        builder: (context, ScreenProvider provider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: const Color.fromARGB(255, 2, 18, 46),
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: widget.platformName,
                      child: Container(
                        width: screenWidth * 0.25,
                        height: screenWidth * 0.25,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.125),
                        ),
                        child: CustomIcon().customIcon(
                            widget.platformName.toLowerCase(),
                            screenWidth * 0.15),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.platformName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.075,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            "$numberofAccounts Accounts",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.0375,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: platformIndex.length,
                  itemBuilder: (context, index) {
                    final box = Boxes.getData();
                    final data = box.getAt(platformIndex[index]);
                    return Slidable(
                      endActionPane: ActionPane(
                        extentRatio: 0.5,
                        motion: const StretchMotion(),
                        children: [
                          SlidableAction(
                            backgroundColor: Colors.white,
                            onPressed: (context) async {
                              if (await MobileAuth.authenticate(
                                  "Authenticate to Edit Password")) {
                                showDialog(
                                  context: parentContext,
                                  builder: (context) {
                                    return EditAccountWidget()
                                        .editAccountWidget(
                                      context,
                                      platformIndex[index],
                                      data!.platform,
                                      data.platformName,
                                      data.username,
                                      data.password,
                                    );
                                  },
                                );
                                UploadToCloud().uploadToCloud();
                              }
                            },
                            icon: Icons.edit,
                          ),
                          SlidableAction(
                            backgroundColor: Colors.red,
                            onPressed: (context) async {
                              if (await MobileAuth.authenticate(
                                  "Authenticate to Delete Account")) {
                                if (mounted) {
                                  final shouldDelete =
                                      await ShowConfirmationWidget
                                          .showConfirmationDialog(
                                    parentContext,
                                    "Delete User",
                                    "Are you sure you want to delete this user?",
                                  );

                                  if (shouldDelete && mounted) {
                                    box.deleteAt(platformIndex[index]);
                                    ToastMessage.showToast("User Deleted");

                                    numberofAccounts = provider
                                        .numberOfAccounts(widget.platformName);

                                    if (numberofAccounts == 0) {
                                      provider.setPlatforms();
                                      pop();
                                    }

                                    isVisibleList = List.generate(
                                        numberofAccounts, (index) => false);
                                    platformIndex = platformData()
                                        .getPlatformData(widget.platformName);

                                    provider.updateui();
                                    ToastMessage.showToast("User Deleted");
                                  }
                                }
                              }
                            },
                            icon: Icons.delete,
                            // label: "Delete",
                          ),
                        ],
                      ),
                      child: Container(
                        margin: EdgeInsets.all(screenWidth * 0.025),
                        padding: EdgeInsets.all(screenWidth * 0.025),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 2, 27, 70),
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.05),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.05),
                              child: InkWell(
                                onTap: () {
                                  Clipboard.setData(
                                          ClipboardData(text: data.username))
                                      .then((value) {
                                    ToastMessage.showToast(
                                        "Username copied to clipboard");
                                  }).onError((error, stackTrace) {
                                    ToastMessage.showToast(
                                        "Failed to copy username");
                                  });
                                },
                                child: Text(
                                  data!.username,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.05),
                              margin: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.05),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 0.05),
                                color: Colors.white.withOpacity(0.1),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      isVisibleList[index]
                                          ? data.password
                                          : data.password
                                              .replaceAll(RegExp(r"."), "*"),
                                      style: TextStyle(
                                        fontSize: data.password.length > 25
                                            ? screenWidth * 0.0375
                                            : screenWidth * 0.0325,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      isVisibleList[index]
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.white,
                                    ),
                                    onPressed: () async {
                                      if (!isVisibleList[index]) {
                                        if (await MobileAuth.authenticate(
                                            "Authenticate to See Password")) {
                                          isVisibleList =
                                              provider.updatePasswordVisibility(
                                                  isVisibleList, index);
                                        }
                                      } else {
                                        isVisibleList =
                                            provider.updatePasswordVisibility(
                                                isVisibleList, index);
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.copy,
                                      color: Colors.white,
                                    ),
                                    onPressed: () async {
                                      if (await MobileAuth.authenticate(
                                          "Authenticate to Copy Password")) {
                                        Clipboard.setData(ClipboardData(
                                                text: data.password))
                                            .then((value) {
                                          ToastMessage.showToast(
                                              "Copied to clipboard");
                                        }).onError((error, stackTrace) {
                                          ToastMessage.showToast(
                                              "Failed to copy");
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
