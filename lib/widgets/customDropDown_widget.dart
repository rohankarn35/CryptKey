import 'package:cryptkey/provider/widgetProvider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDropDown {
  final List<String> items = [
    'Facebook',
    'Instagram',
    'X',
    'LinkedIn',
    'Github',
    'Snapchat',
    'TikTok',
    'Google',
    'Bank',
    'Others',
  ];
  Widget customDropDown(BuildContext context) {
    return Consumer<WidgetProvider>(
      builder: (context, provider, child) {
        return DropdownButtonHideUnderline(
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              hint: Row(
                children: [
                  Text(
                    'Select Platform',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              items: items
                  .map((String item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                  .toList(),
              value: provider.selectedValue,
              onChanged: (value) {
                Provider.of<WidgetProvider>(context, listen: false)
                    .setSelectedValue(value!);
                if (value == 'Others') {
                  Provider.of<WidgetProvider>(context, listen: false)
                      .setPlatformNameVisible(true);
                } else {
                  Provider.of<WidgetProvider>(context, listen: false)
                      .setPlatformNameVisible(false);
                }
              },
              buttonStyleData: ButtonStyleData(
                height: 60,
                padding: const EdgeInsets.only(left: 14, right: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                  ),
                  color: const Color.fromARGB(255, 2, 18, 46),
                ),
                elevation: 2,
              ),
              iconStyleData: IconStyleData(
                  icon: const Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                  iconSize: 14,
                  iconEnabledColor: Colors.white.withOpacity(0.3),
                  iconDisabledColor: Colors.white),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: const Color.fromARGB(255, 2, 18, 46),
                ),
                offset: const Offset(0, 0),
                scrollbarTheme: ScrollbarThemeData(
                  radius: const Radius.circular(20),
                  thickness: WidgetStateProperty.all(1),
                  thumbVisibility: WidgetStateProperty.all(false),
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
                padding: EdgeInsets.only(left: 14, right: 14),
              ),
            ),
          ),
        );
      },
    );
  }
}
