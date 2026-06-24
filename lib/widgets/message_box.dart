// lib/widgets/message_box.dart
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class MessageBox extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final VoidCallback? onVoicePressed;
  final VoidCallback? onVoicePressedStop;
  final VoidCallback? onVoicePressedPlay;
  final VoidCallback? onVoicePressedDelete;
  final bool isPaused;
  final bool isResumed;
  final bool isStoped;
  final bool isPlayed;
  final bool isRecording;
  final String? filePath;
  final String? recordingDuration;

  const MessageBox({
    Key? key,
    required this.controller,
    this.hintText,
    this.onVoicePressed,
    this.onVoicePressedStop,
    this.onVoicePressedPlay,
    this.onVoicePressedDelete,
    required this.isPaused,
    required this.isResumed,
    required this.isPlayed,
    required this.isStoped,
    required this.isRecording,
    required this.filePath,
    this.recordingDuration,
  }) : super(key: key);

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  @override
  Widget build(BuildContext context) {

    void _showDeleteConfirmationDialog1(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Delete Voice Note'),
          content: const Text(
              'Are you sure you want to delete this Voice Note?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // controller.removeFromCart(itemId);
                widget.onVoicePressedDelete;
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Message',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Let\'s know your shopping preference through our messaging or voice note options below.',
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Roboto',
            color: Color(0xff2D2D2D),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Stack(
            children: [
              // TextField(
              //   controller: controller,
              //   maxLines: 5,
              //   decoration: InputDecoration(
              //     hintText: hintText,
              //     border: InputBorder.none,
              //     contentPadding: const EdgeInsets.all(16),
              //   ),
              // ),
               // Animated hintText (only if empty)
    if (widget.controller.text.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: AnimatedTextKit(
                              repeatForever: true,
                              animatedTexts: [
                                FadeAnimatedText(
                                  duration: Duration(milliseconds: 5000),
                                  fadeOutBegin: 0.8,
                                  'Add a message...',
                                  textStyle: TextStyle(color: Colors.blueGrey),
                                ),
                                FadeAnimatedText(
                                  duration: Duration(milliseconds: 5000),
                                  fadeOutBegin: 0.8,
                                  'You can give a description of what you want',
                                  textStyle: TextStyle(color: Colors.blueGrey),
                                ),
                                 FadeAnimatedText(
                                  duration: Duration(milliseconds: 5000),
                                  fadeOutBegin: 0.8,
                                  'Need to specific type of ingredient?',
                                  textStyle: TextStyle(color: Colors.blueGrey),
                                ),
                                FadeAnimatedText(
                                  duration: Duration(milliseconds: 5000),
                                  fadeOutBegin: 0.8,
                                  'You can tell us about!!!',
                                  textStyle: TextStyle(color: Colors.blueGrey),
                                ),
                                FadeAnimatedText(
                                  duration: Duration(milliseconds: 5000),
                                  fadeOutBegin: 0.8,
                                  'Or better still leave a voice Note for us.',
                                  textStyle: TextStyle(color: Colors.blueGrey),
                                ),
                                FadeAnimatedText(
                                  duration: Duration(milliseconds: 5000),
                                  fadeOutBegin: 0.8,
                                  'Thank you, Happy shopping in advance.',
                                  textStyle: TextStyle(color: Colors.blueGrey),
                                ),
                              ],
                            ),
                          ),
                        TextField(
                          onChanged: (value) {
                            setState((){});
                          },
                          controller: widget.controller,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                          ),
                        ),
                    
                    
              (widget.filePath != null && widget.filePath!.isNotEmpty)
                  ? Positioned(
                      bottom: 8,
                      left: 8,
                      child: Row(
                        children: [
                          IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade200,
                              ),
                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                            onPressed: widget.onVoicePressedPlay,
                          ),
                          IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade200,
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                            onPressed: (){
                              _showDeleteConfirmationDialog1(context);
                            }   //widget.onVoicePressedDelete,
                          ),
                          widget.isRecording
                              ? Row(
                                  children: [
                                    AnimatedOpacity(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      opacity: widget.isRecording ? 1.0 : 0.0,
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width:5),
                                    Text(
                                      widget.recordingDuration ??
                                          '00:00', // <- Replace with actual timer text from parent widget
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                )
                              : SizedBox.shrink()
                        ],
                      ))
                  : SizedBox.shrink(),
              Positioned(
                right: 8,
                bottom: 8,
                child: Row(
                  children: [
                    widget.isRecording
                        ? IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade200,
                              ),
                              child: const Icon(
                                Icons.stop,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                            onPressed: widget.onVoicePressedStop,
                          )
                        : SizedBox.shrink(),
                    widget.isRecording
                        ? IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade200,
                              ),
                              child: Icon(
                                widget.isPaused ? Icons.play_circle : Icons.pause,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                            onPressed: widget.onVoicePressed,
                          )
                        : IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade200,
                              ),
                              child: const Icon(
                                Icons.mic,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                            onPressed: widget.onVoicePressed,
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
