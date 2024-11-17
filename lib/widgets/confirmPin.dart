import 'package:flutter/material.dart';

class ConfirmPinDialog extends StatefulWidget {
  final String correctPin;

  ConfirmPinDialog({required this.correctPin});

  @override
  _ConfirmPinDialogState createState() => _ConfirmPinDialogState();
}

class _ConfirmPinDialogState extends State<ConfirmPinDialog> {
  final TextEditingController _pinController = TextEditingController();
  String _errorMessage = '';

  void _authenticatePin() {
    if (_pinController.text == widget.correctPin) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _errorMessage = 'Incorrect PIN. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 2, 18, 46),
      title: Text(
        'Enter Screen PIN',
        style: TextStyle(color: Colors.white),
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: false,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'PIN',
                  labelStyle: TextStyle(color: Colors.white),
                  errorText: _errorMessage.isEmpty ? null : _errorMessage,
                  errorStyle: TextStyle(color: Colors.redAccent),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: _authenticatePin,
          style: TextButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 2, 18, 46),
          ),
          child: Text('Confirm', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class NoScreenPin extends StatelessWidget {
  const NoScreenPin({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 2, 18, 46),
      title: Text(
        'Screen Pin Not Found',
        style: TextStyle(color: Colors.white),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "You haven't set any screen pin",
              style: TextStyle(color: Colors.white),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text("Close"))
          ],
        ),
      ),
    );
  }
}

Future<bool?> showConfirmPinDialog(BuildContext context, String correctPin) {
  return showDialog<bool>(
      context: context,
      builder: (context) => correctPin.isEmpty
          ? NoScreenPin()
          : ConfirmPinDialog(correctPin: correctPin));
}
