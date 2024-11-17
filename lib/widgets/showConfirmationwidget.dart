import 'package:flutter/material.dart';

class ShowConfirmationWidget {
  static showConfirmationDialog(
      BuildContext context, String content, String message) async {
    return showDialog(
        useRootNavigator: true,
        anchorPoint: const Offset(-10.0, 0.0),
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 2, 18, 46),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color.fromARGB(255, 2, 18, 46),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20.0, left: 20.0, right: 20.0, bottom: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      content,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      message,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: message.length > 20 ? 13 : 15,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text(
                            'No',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: const Text(
                            'Yes',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
