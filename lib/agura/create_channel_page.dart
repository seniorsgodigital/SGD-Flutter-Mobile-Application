import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:seniors_go_digital/agura/widgets/pre_joining_dialog.dart';

class CreateChannelPage extends StatefulWidget {
  final String? chanelId;
  const CreateChannelPage({super.key, this.chanelId});

  @override
  State<CreateChannelPage> createState() => _CreateChannelPageState();
}

class _CreateChannelPageState extends State<CreateChannelPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _channelNameController;

  bool _isCreatingChannel = false;

  @override
  void initState() {
    super.initState();
    _channelNameController = TextEditingController(text: widget.chanelId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  String? _channelNameValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a channel name';
    } else if (value.length > 64) {
      return 'Channel name must be less than 64 characters';
    }
    return null;
  }

  Future<void> _joinRoom() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isCreatingChannel = true);
    final input = <String, dynamic>{
      'channelName': _channelNameController.text,
      'expiryTime': 3600, // 1 hour
    };
    try {
      final response = await FirebaseFunctions.instance
          .httpsCallable('generateToken')
          .call(input);
      final token = response.data as String?;
      if (token != null) {
        if (context.mounted) {
          _showSnackBar(
            context,
            'Token generated successfully!',
          );
        }
        await Future.delayed(
          const Duration(seconds: 1),
        );
        if (context.mounted) {
          await showDialog(
            context: context,
            builder: (context) => PreJoiningDialog(
              channelName: _channelNameController.text,
              token: token,
            ),
          );
        }
      }
    } catch (e) {
      _showSnackBar(
        context,
        'Error generating token: $e',
      );
    } finally {
      setState(() => _isCreatingChannel = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      width: screenSize.width,
      constraints: const BoxConstraints(maxWidth: 600),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                  0.0,
                  30.0,
                  0.0,
                  8.0,
                ),
                child: Text(
                  'Join Meeting',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsetsDirectional.only(bottom: 15.0),
                child: Text(
                  "By clicking 'Join Now' you can join the meeting.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  autofocus: true,
                  controller: _channelNameController,
                  enabled: false,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Channel ID',
                    labelStyle: const TextStyle(
                      color: Colors.blue,
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                    ),
                    hintText: 'Enter your channel name...',
                    hintStyle: const TextStyle(
                      color: Color(0xFF57636C),
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                  ),
                  keyboardType: TextInputType.text,
                  validator: _channelNameValidator,
                ),
              ),
              const SizedBox(height: 24.0),
              _isCreatingChannel
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [CircularProgressIndicator()],
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: _joinRoom,
                        child: const Text('Join Now'),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
