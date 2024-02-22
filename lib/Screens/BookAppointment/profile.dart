import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seniors_go_digital/AppStrings/Textstyle.dart';
import 'package:seniors_go_digital/Screens/BookAppointment/SeniorUpload.dart';
import 'package:seniors_go_digital/Screens/BookAppointment/profile_check.dart';
import 'package:seniors_go_digital/Widget/buton/auth_button.dart';
import 'package:seniors_go_digital/Widget/text_field/profileField.dart';

import '../../AppStrings/utils.dart';
import '../../Widget/auth/fetch_data.dart';
import '../../models/userDataModel.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController photoController = TextEditingController();
  TextEditingController domainController = TextEditingController();
  TextEditingController specializationController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController documentController = TextEditingController();
  TextEditingController urlController = TextEditingController();

  // Focus nodes for text fields
  FocusNode usernameFocus = FocusNode();
  FocusNode photoFocus = FocusNode();
  FocusNode domainFocus = FocusNode();
  FocusNode specializationFocus = FocusNode();
  FocusNode experienceFocus = FocusNode();
  FocusNode phoneNumberFocus = FocusNode();
  FocusNode cnicFocus = FocusNode();
  FocusNode documentFocus = FocusNode();
  FocusNode urlFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Query<UserProfile> userQuery = FirebaseFirestore.instance
        .collection('userData')
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .withConverter(
          fromFirestore: (snapshot, _) => UserProfile.fromMap(snapshot.data()!),
          toFirestore: (job, _) => job.toMap(),
        );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "Edit your profile",
                style: CustomTextStyles.customTextStyle26,
              ),
              SizedBox(
                height: 10,
              ),
              FittedBox(
                child: Text(
                  "Don’t worry, you can always change\n\t\t                          "
                  "it later",
                  style: CustomTextStyles.customTextStyle600,
                ),
              ),
              CustomFirestoreQueryBuilder<UserProfile>(
                query: userQuery,
                pageSize: 2,
                builder: (builder, snapshot) {
                  return ListView.builder(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      shrinkWrap: true,
                      itemCount: snapshot.docs.length,
                      physics: ScrollPhysics(),
                      itemBuilder: (itemBuilder, index) {
                        final product = snapshot.docs[index].data();
                        usernameController.text = product.userName ?? "";
                        phoneNumberController.text =
                            product.seniorPhoneNumber ?? "";
                        experienceController.text = product.experience ?? "";
                        domainController.text = product.domain ?? "";
                        specializationController.text =
                            product.specialization ?? "";
                        urlController.text = product.webUrl ?? "";
                        return Column(
                          children: [
                            ProfileField(
                                label: "Enter your username",
                                hint: "E.g:haroon123",
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: "Username is required"),
                                  MinLengthValidator(3,
                                      errorText:
                                          "Minimum 3 character required "),
                                  PatternValidator(
                                    r'^(?=.*[a-zA-Z])(?=.*[0-9])',
                                    errorText:
                                        "Username must contain at least one letter and one number",
                                  ),
                                ]),
                                onFieldSubmitted: (value) {},
                                controller: usernameController),
                            ProfileField(
                                label: "Enter your Domain",
                                hint: "E.g:Domain",
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: "Domain is required"),
                                  MinLengthValidator(3,
                                      errorText:
                                          "Minimum 3 character required "),
                                ]),
                                onFieldSubmitted: (value) {},
                                controller: domainController),
                            ProfileField(
                                label: "Enter Your Specialization field",
                                hint: "E.g:Dermatologist",
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText:
                                          "Specialization field is required"),
                                  MinLengthValidator(3,
                                      errorText:
                                          "Minimum 3 character required "),
                                ]),
                                onFieldSubmitted: (value) {},
                                controller: specializationController),
                            ProfileField(
                                label: "Enter Your Years Of Experience ",
                                hint: "E.g:30 years",
                                onFieldSubmitted: (value) {},
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText:
                                          "Experience field is required"),
                                ]),
                                controller: experienceController),
                            ProfileField(
                                label: "Phone Number",
                                hint: "E.g:03404582956",
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: "Phone Number is required"),
                                  PatternValidator(
                                    r'^\d{4}\d{7}$',
                                    errorText:
                                        "Must Follow this pattern 03047271233",
                                  ),
                                ]),
                                onFieldSubmitted: (value) {},
                                controller: phoneNumberController),
                            ProfileField(
                                label: "Enter URL of your work (IF ANY)",
                                hint: "E.g:www.seniorsgodigital.pk",
                                onFieldSubmitted: (value) {},
                                controller: urlController),
                            SizedBox(
                              height: 15,
                            ),
                            AuthButton(
                                title: "Next",
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      await FirebaseFirestore.instance
                                          .collection("userData")
                                          .doc(snapshot.docs[index].id)
                                          .update({
                                        'userName':
                                            usernameController.text.toString(),
                                        'domain':
                                            domainController.text.toString(),
                                        'specialization':
                                            specializationController.text
                                                .toString(),
                                        'experience': experienceController.text
                                            .toString(),
                                        'seniorPhoneNumber':
                                            phoneNumberController.text
                                                .toString(),
                                        'webUrl': urlController.text.toString(),
                                      });
                                      // Update successful
                                      Utils.showSuccessMessage(
                                          "Successfully Updated", context);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) =>
                                                  SeniorUpload()));
                                    } catch (e) {
                                      print(
                                          "Error updating Firestore document: $e");
                                      // Handle the error, show an error message, or take appropriate action.
                                    }
                                  }
                                }),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        );
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
