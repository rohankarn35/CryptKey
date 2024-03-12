import 'package:cryptkey/data/boxes.dart';
import 'package:cryptkey/data/platformData.dart';
import 'package:cryptkey/provider/screenProvider.dart';
import 'package:cryptkey/utils/toastMessage.dart';
import 'package:cryptkey/widgets/customIcon.dart';
import 'package:cryptkey/widgets/editAccountDialog.dart';
import 'package:cryptkey/widgets/showConfirmationwidget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class PasswordDetailsScreen extends StatefulWidget {
  final String platformName;
  const PasswordDetailsScreen({
    super.key,
    required this.platformName,
  });

  @override
  State<PasswordDetailsScreen> createState() => _PasswordDetailsScreenState();
}

class _PasswordDetailsScreenState extends State<PasswordDetailsScreen> {
  late List<int> platformIndex;
  bool isVisible = false;
  late List<bool> isVisibleList;
  late int numberofAccounts;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    numberofAccounts = ScreenProvider().numberOfAccounts(widget.platformName);
    isVisibleList = List.generate(numberofAccounts, (index) => false);

    platformIndex = platformData().getPlatformData(widget.platformName);
    print(platformIndex);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 7, 12, 20),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 2, 18, 46),
          leading: IconButton(
            onPressed: () {
              final screenProvider =
                  Provider.of<ScreenProvider>(context, listen: false);
              screenProvider.setPlatforms();
              Navigator.pop(context);
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
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: CustomIcon()
                          .customIcon(widget.platformName.toLowerCase(), 60),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.platformName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          numberofAccounts.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: platformIndex.length,
                  itemBuilder: (context, index) {
                    final box = Boxes.getData();
                    final data = box.getAt(platformIndex[index]);
                    // Replace this with your list item widget
                    return Slidable(
                      endActionPane: ActionPane(
                          extentRatio: 1,
                          motion: const StretchMotion(),
                          children: [
                            SlidableAction(
                              backgroundColor: Colors.white,
                              onPressed: (context) {
                                EditAccountWidget().editAccountWidget(
                                    context,
                                    platformIndex[index],
                                    data!.platform,
                                    data.platformName,
                                    data.username,
                                    data.password);
                              },
                              icon: Icons.edit,
                            ),
                            SlidableAction(
                              backgroundColor: Colors.red,
                              onPressed: (context) async {
                                if (await ShowConfirmationWidget
                                    .showConfirmationDialog(
                                        context,
                                        "Delete User",
                                        "Are you sure you want to delete this user?")) {
                                  box.deleteAt(platformIndex[index]);
                                  ToastMessage.showToast("User Deleted");

                                  numberofAccounts = ScreenProvider()
                                      .numberOfAccounts(widget.platformName);
                                  if (numberofAccounts == 0) {
                                    final screenProvider =
                                        Provider.of<ScreenProvider>(context,
                                            listen: false);
                                    screenProvider.setPlatforms();
                                    Navigator.pop(context);
                                  }

                                  isVisibleList = List.generate(
                                      numberofAccounts, (index) => false);

                                  platformIndex = platformData()
                                      .getPlatformData(widget.platformName);

                                  provider.updateui();

                                  ToastMessage.showToast("User Deleted");
                                }
                              },
                              icon: Icons.delete,
                              label: "Delete",
                            )
                          ]),
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 2, 27, 70),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Text(
                                data!.username,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: data.username.length > 25 ? 18 : 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                              ),
                              margin:
                                  const EdgeInsets.only(left: 20, right: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
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
                                        fontSize:
                                            data.password.length > 25 ? 15 : 13,
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
                                    onPressed: () {
                                      isVisibleList =
                                          provider.updatePasswordVisibility(
                                              isVisibleList, index);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.copy,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(
                                              text: data.password))
                                          .then((value) =>
                                              ToastMessage.showToast(
                                                  "Copied to clipboard"))
                                          .onError((error, stackTrace) =>
                                              ToastMessage.showToast(
                                                  "Failed to copy"));
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }));
  }
}
