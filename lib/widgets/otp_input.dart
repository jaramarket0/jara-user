import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpInput extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onCompleted;

  const OtpInput({
    Key? key,
    required this.controller,
    required this.onCompleted,
  }) : super(key: key);

  @override
  _OtpInputState createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());

  // Track the previous text values to detect backspace
  final List<String> _previousValues = List.generate(4, (index) => '');

  @override
  void initState() {
    super.initState();

    // Initialize controllers with any existing value
    if (widget.controller.text.isNotEmpty) {
      for (int i = 0; i < widget.controller.text.length && i < 4; i++) {
        _controllers[i].text = widget.controller.text[i];
        _previousValues[i] = widget.controller.text[i];
      }
    }

    // Add listeners to individual controllers
    for (int i = 0; i < 4; i++) {
      _controllers[i].addListener(() {
        _updateMainController();
      });
    }

    // Add listener to main controller
    widget.controller.addListener(() {
      if (widget.controller.text.length == 4) {
        widget.onCompleted(widget.controller.text);
      }
    });
  }

  void _updateMainController() {
    final String text = _controllers.map((controller) => controller.text).join();
    if (text != widget.controller.text) {
      widget.controller.text = text;
    }
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        4,
            (index) => SizedBox(
          width: 64,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: _controllers[index].text.isNotEmpty
                      ? Colors.amber
                      : Colors.grey,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.green,
                  width: 2,
                ),
              ),
            ),
            onChanged: (value) {
              // Detect backspace by comparing current and previous values
              if (value.isEmpty && _previousValues[index].isNotEmpty && index > 0) {
                // This is likely a backspace on a now-empty field
                _focusNodes[index - 1].requestFocus();
              }
              // Move to next field if a digit is entered
              else if (value.length == 1 && index < 3) {
                _focusNodes[index + 1].requestFocus();
              }

              // Update previous value
              _previousValues[index] = value;
            },
          ),
        ),
      ),
    );
  }
}