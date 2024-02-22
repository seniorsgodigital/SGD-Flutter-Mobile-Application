import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:seniors_go_digital/AppStrings/utils.dart';
import 'package:seniors_go_digital/Widget/auth/fetch_data.dart';
import 'package:seniors_go_digital/Widget/buton/auth_button.dart';
import 'package:seniors_go_digital/Widget/text_field/country_field.dart';
import 'package:seniors_go_digital/Widget/text_field/gender_field.dart';
import 'package:seniors_go_digital/Widget/text_field/phone_picker.dart';
import 'package:seniors_go_digital/Widget/text_field/profileField.dart';
import 'package:country_picker/country_picker.dart';
import 'package:seniors_go_digital/provider/user_vm.dart';
import 'package:seniors_go_digital/provider/myconsumer.dart';

import '../../models/userDataModel.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String? selectedCountry;
  List<Country> countryList = [];
  final _formKey = GlobalKey<FormState>();

  // Define controllers and focus nodes
  final TextEditingController fullNameController = TextEditingController();
  final FocusNode fullNameFocusNode = FocusNode();

  final TextEditingController userNameController = TextEditingController();
  final FocusNode userNameFocusNode = FocusNode();

  final TextEditingController addressController = TextEditingController();
  final FocusNode addressFocusNode = FocusNode();
  final TextEditingController labelController = TextEditingController();

  final TextEditingController genderController = TextEditingController();
  final FocusNode genderFocusNode = FocusNode();

  final TextEditingController phoneNumberController = TextEditingController();
  final FocusNode phoneNumberFocusNode = FocusNode();

  @override
  void dispose() {
    // Dispose of controllers and focus nodes
    fullNameController.dispose();
    fullNameFocusNode.dispose();
    userNameController.dispose();
    userNameFocusNode.dispose();
    addressController.dispose();
    addressFocusNode.dispose();
    genderController.dispose();
    genderFocusNode.dispose();
    phoneNumberController.dispose();
    phoneNumberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Query<UserProfile> userQuery = FirebaseFirestore.instance
        .collection('userData')
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .withConverter(
          fromFirestore: (snapshot, _) => UserProfile.fromMap(snapshot.data()!),
          toFirestore: (job, _) => job.toMap(),
        );
    String selectedGender = "Male";
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            fontFamily: "Poppins",
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomFirestoreQueryBuilder<UserProfile>(
                query: userQuery,
                pageSize: 2,
                builder: (builder, snapshot) {
                  return ListView.builder(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      shrinkWrap: true,
                      itemCount: snapshot.docs.length,
                      itemBuilder: (itemBuilder, index) {
                        final product = snapshot.docs[index].data();
                        fullNameController.text = product.name ?? "";
                        userNameController.text = product.userName ?? "";
                        labelController.text = product.label ?? "";
                        phoneNumberController.text = product.phone ?? "";
                        addressController.text = product.address ?? "";
                        return Column(
                          children: [
                            ProfileField(
                              hint: "E.g:Urooj Khan",
                              label: "Full Name",
                              controller:
                                  fullNameController, // Assign controller
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: "Name is required"),
                                MinLengthValidator(3,
                                    errorText: "Minimum character required 3")
                              ]),
                            ),
                            ProfileField(
                              hint: "E.g:UroojKhan123",
                              label: "User Name",
                              controller:
                                  userNameController, // Assign controller
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: "Username is required"),
                                MinLengthValidator(3,
                                    errorText: "Minimum 3 character required "),
                                PatternValidator(
                                  r'^(?=.*[a-zA-Z])(?=.*[0-9])',
                                  errorText:
                                      "Username must contain at least one letter and one number",
                                ),
                              ]),
                            ),
                            ProfileField(
                              hint: "E.g:Block 2 North Nazmabad, Karachi.",
                              label: "Label",
                              controller:
                                  addressController, // Assign controller
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: "Label is required"),
                                MinLengthValidator(3,
                                    errorText: "Minimum 6 character required "),
                              ]),
                            ),
                            MyConsumer<UserVM>(builder: (builder, value) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: CountryField(
                                      label: "Country",
                                      hint: "Select a country",
                                      selectedCountry: value.selectedCountry,
                                      onCountryChanged: (Country? country) {
                                        value.updateCountry(
                                            country!.displayName);
                                        // Handle the selected country here
                                      },
                                    ),
                                  ),
                                  MyConsumer<UserVM>(builder: (builder, value) {
                                    return Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: const Color(0xFFC2C2C2)),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child:
                                              DropdownButtonFormField<String>(
                                            value: value.selectedGender,
                                            onChanged: (String? newValue) {
                                              value.updateGender(newValue);
                                            },
                                            items: <String>['Male', 'Female']
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                              labelText: "Select Gender",
                                              labelStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                              hintText: "",
                                              hintStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF212121)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              );
                            }),
                            ProfileField(
                              hint: "E.g:03447271877",
                              label: "Phone Number",
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: "Phone Number is required"),
                                PatternValidator(
                                  r'^\d{4}\d{7}$',
                                  errorText:
                                      "Must Follow this pattern 03047271233",
                                ),
                              ]),
                              controller: phoneNumberController,
                            ),
                            ProfileField(
                              hint: "E.g:Block 2 North Nazmabad, Karachi.",
                              label: "Address",
                              controller: addressController,
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: "Adresss is required"),
                                MinLengthValidator(10,
                                    errorText: "Minimum character required 10")
                              ]),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            MyConsumer<UserVM>(builder: (builder, value) {
                              return AuthButton(
                                  title: "Done",
                                  onPressed: () async {
                                    String displayCountry =
                                        value.selectedCountry ?? "Pakistan";

                                    // Extract and display only the country name
                                    if (displayCountry.contains('(')) {
                                      displayCountry =
                                          displayCountry.split('(')[0].trim();
                                    }
                                    if (_formKey.currentState!.validate()) {
                                      print(phoneNumberController.text
                                          .toString());
                                      print(addressController.text.toString());
                                      try {
                                        await FirebaseFirestore.instance
                                            .collection("userData")
                                            .doc(snapshot.docs[index].id)
                                            .update({
                                          "address":
                                              addressController.text.toString(),
                                          "userName": userNameController.text
                                              .toString(),
                                          "country": displayCountry,
                                          "gender": value.selectedGender,
                                          "name": fullNameController.text
                                              .toString(),
                                          "phone": phoneNumberController.text
                                              .toString(),
                                          "Address":
                                              addressController.text.toString(),
                                          "label":
                                              labelController.text.toString(),
                                        });
                                        // Update successful
                                        Utils.showSuccessMessage(
                                            "Successfully Updated", context);
                                      } catch (e) {
                                        print(
                                            "Error updating Firestore document: $e");
                                        // Handle the error, show an error message, or take appropriate action.
                                      }
                                    } else {
                                      print(value.selectedGender.toString());
                                      print(value.selectedCountry);
                                      print("Not Valid");
                                    }
                                  });
                            })
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
