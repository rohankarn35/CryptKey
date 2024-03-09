import 'package:cryptkey/provider/widgetProvider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


String? platformselected;
class CustomDropDown {
  final List<String> items = [
    'Facebook',
    'Instagram',
    'X',
    'LinkedIn',
    'Snapchat',
    'TikTok',
    'Google',
    'Bank',
    'Others',
  ];
  String? selectedValue;
  Widget customDropDown(BuildContext context) {
    return Consumer(
      builder: (context, WidgetProvider provider, child) {
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
              value: selectedValue,
              onChanged: (value) {
                selectedValue =
                    Provider.of<WidgetProvider>(context, listen: false)
                        .setSelectedValue(value!);
                platformselected = selectedValue;
              },
              buttonStyleData: ButtonStyleData(
                height: 70,
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
                maxHeight: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.black12,
                ),
                offset: const Offset(0, 0),
                scrollbarTheme: ScrollbarThemeData(
                  radius: const Radius.circular(40),
                  thickness: MaterialStateProperty.all(6),
                  thumbVisibility: MaterialStateProperty.all(true),
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
