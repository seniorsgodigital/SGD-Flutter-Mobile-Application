import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seniors_go_digital/constants/firebase_Collection.dart';
import 'package:seniors_go_digital/constants/providers.dart';
import 'package:seniors_go_digital/utils/zbtoast.dart';

class AddQuestionAdmin extends StatefulWidget {
  const AddQuestionAdmin({super.key});

  @override
  State<AddQuestionAdmin> createState() => _AddQuestionAdminState();
}

class _AddQuestionAdminState extends State<AddQuestionAdmin> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Question'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            ZBotToast.loadingShow();
            MainVM.userVM(context).userLogout();
          }, icon: const Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _questionController,
              decoration: const InputDecoration(labelText: 'Enter Question'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _answerController,
              decoration: const InputDecoration(labelText: 'Enter Answer'),
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
              onPressed: () {
                if (_questionController.text.isEmpty) {
                  ZBotToast.showToast("Question Missing");
                } else if (_answerController.text.isEmpty) {
                  ZBotToast.showToast("Answer Missing");
                } else {
                  ZBotToast.loadingShow();
                  String id = Timestamp.now().millisecondsSinceEpoch.toString();
                  FBCollections.qa.doc(id).set({
                    "qus": _questionController.text,
                    "ans": _answerController.text,
                    "id": id
                  }).then((value) {
                    ZBotToast.loadingClose();
                    _questionController.clear();
                    _answerController.clear();
                  });
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.2),
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
