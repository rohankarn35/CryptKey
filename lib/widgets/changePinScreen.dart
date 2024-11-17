import 'package:cryptkey/provider/screenProvider.dart';
import 'package:cryptkey/utils/changeEncPin.dart';
import 'package:cryptkey/utils/changeScreenPin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePinScreen extends StatefulWidget {
  final String heading;
  final String oldPin;

  const ChangePinScreen(
      {super.key, required this.heading, required this.oldPin});
  @override
  _ChangePinScreenState createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPinController = TextEditingController();
  final TextEditingController _newPinController = TextEditingController();
  final TextEditingController _confirmNewPinController =
      TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    print("the pin is ${widget.oldPin}");
  }

  @override
  void dispose() {
    _oldPinController.dispose();
    _newPinController.dispose();
    _confirmNewPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 18, 46),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
        title: Text(
          widget.heading,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildPinField('Old PIN', _oldPinController),
                  SizedBox(height: 16.0),
                  _buildPinField('New PIN', _newPinController),
                  SizedBox(height: 16.0),
                  _buildPinField('Confirm New PIN', _confirmNewPinController),
                  SizedBox(height: 32.0),
                  _isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : OutlinedButton(
                          onPressed: () async {
                            await _handleChangePin();
                          },
                          style: OutlinedButton.styleFrom(
                            overlayColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 30.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            side: BorderSide(color: Colors.white),
                          ),
                          child: Text(
                            'Change PIN',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPinField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        hintText: 'Enter $label',
        hintStyle: TextStyle(color: Colors.white54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.green, width: 2.0),
        ),
      ),
      keyboardType: TextInputType.number,
      maxLength: 4,
      obscureText: false,
      style: TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        } else if (value.length != 4) {
          return 'PIN must be 4 digits';
        }
        return null;
      },
    );
  }

  Future<void> _handleChangePin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      if (_oldPinController.text.trim() != widget.oldPin.trim()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text('Old Pin Does Not Match')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      if (_newPinController.text != _confirmNewPinController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text('New PIN and Confirm New PIN do not match')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }
      if (_newPinController.text == _oldPinController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text('Old Pin and New Pin cannot be same')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      if (widget.heading.contains("Encryption")) {
        final bool isCompleted = await ChangeEncPin().changeEncPin(
            _oldPinController.text.trim(), _newPinController.text.trim());
        Provider.of<ScreenProvider>(context, listen: false).setPin();
        if (isCompleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.green,
                content: Text('Pin Changed Successfully')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.red,
                content: Text('Unable to Change Pin')),
          );
        }
      }

      if (widget.heading.contains("Screen")) {
        final bool isCompleted = await Changescreenpin()
            .changeScreenPin(_newPinController.text.trim());
        if (isCompleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.green,
                content: Text('Pin Changed Successfully')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.red,
                content: Text('Unable to Change Pin')),
          );
        }
      }

      setState(() {
        _isLoading = false;
      });
    }
  }
}
