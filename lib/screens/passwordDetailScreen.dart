import 'package:cryptkey/data/boxes.dart';
import 'package:cryptkey/provider/screenProvider.dart';
import 'package:cryptkey/utils/toastMessage.dart';
import 'package:cryptkey/widgets/customIcon.dart';
import 'package:cryptkey/widgets/editAccountDialog.dart';
import 'package:cryptkey/widgets/showConfirmationwidget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PasswordDetailsScreen extends StatefulWidget {
  final int index;
  const PasswordDetailsScreen({
    super.key,
    required this.index,
  });

  @override
  State<PasswordDetailsScreen> createState() => _PasswordDetailsScreenState();
}

class _PasswordDetailsScreenState extends State<PasswordDetailsScreen> {


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ScreenProvider>(context, listen: false);
    provider.getAllFields(widget.index);
    provider.isVisible = false;
    return Consumer<ScreenProvider>(builder: (context, provider, child) {
      return Scaffold(
        backgroundColor: Color.fromARGB(255, 7, 12, 20),
        appBar: AppBar(
          actions: [
            PopupMenuButton(
                iconColor: Colors.white,
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                        child: Text("Edit"),
                        value: "Edit",
                        onTap: () {
                          EditAccountWidget().editAccountWidget(
                            context,
                            widget.index,
                            provider.platform!,
                            provider.platformName!,
                            provider.username!,
                            provider.password!,
                          );
                        }),
                    PopupMenuItem(
                      child: Text("Delete"),
                      value: "Edit",
                      onTap: ()async{
                        final bool result = await ShowConfirmationWidget.showConfirmationDialog(context, "Delete Account", "Do you want to delete it permanently?");
                           if (result) {
                              final box = Boxes.getData();
                        box.deleteAt(widget.index).then((value) =>
                            ToastMessage.showToast("Account Deleted"));
                        Navigator.pop(context);
                             
                           }

                      
                      },
                    ),
                  ];
                })
          ],
          backgroundColor: const Color.fromARGB(255, 2, 18, 46),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: const Color.fromARGB(255, 2, 18, 46),
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: widget.index,
                      child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: CustomIcon()
                              .customIcon(provider.platform!.toLowerCase(), 60)),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                         provider.platformName!.isNotEmpty ? provider.platformName! : provider.platform!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          provider.username ?? "User",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                color: Color.fromARGB(255, 7, 12, 20),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white.withOpacity(0.1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              provider.isVisible
                                  ? provider.password ?? "NA"
                                  : provider.password
                                          ?.replaceAll(RegExp(r"."), "*") ??
                                      "NA",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              provider.isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed: () {
                             provider.updatePasswordVisibility();
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.copy,
                              color: Colors.white,
                            ),
                            onPressed: () {
                            Clipboard.setData(
                                      ClipboardData(text: provider.password!))
                                  .then((value) => ToastMessage.showToast("Copied to clipboard"))
                                  .onError((error, stackTrace) =>
                                      ToastMessage.showToast("Failed to copy"));
                              
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
