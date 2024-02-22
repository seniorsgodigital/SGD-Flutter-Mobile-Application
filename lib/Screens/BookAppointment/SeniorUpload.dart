import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seniors_go_digital/AppStrings/Textstyle.dart';
import 'package:seniors_go_digital/AppStrings/utils.dart';
import 'package:seniors_go_digital/Screens/BookAppointment/profile_check.dart';
import 'package:seniors_go_digital/provider/cnic.dart';
import 'package:seniors_go_digital/provider/document.dart';
import 'package:seniors_go_digital/provider/image_pick.dart';
import 'package:seniors_go_digital/provider/myconsumer.dart';

import '../../Widget/auth/fetch_data.dart';
import '../../Widget/buton/auth_button.dart';
import '../../Widget/text_field/profileField.dart';
import '../../models/userDataModel.dart';
class SeniorUpload extends StatefulWidget {
  const SeniorUpload({super.key});

  @override
  State<SeniorUpload> createState() => _SeniorUploadState();
}

class _SeniorUploadState extends State<SeniorUpload> {
  // final ImagePicker _picker = ImagePicker();
  //
  // void _pickImageFromGallery() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //
  //   if (pickedFile != null) {
  //     // Display the selected image in the field
  //
  //     // Show a Snackbar to indicate that the image was selected
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Image selected from gallery.'),
  //       ),
  //     );
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    final Query<UserProfile> userQuery = FirebaseFirestore.instance.collection('userData')
        .where("id",isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .withConverter(
      fromFirestore: (snapshot, _) => UserProfile.fromMap(snapshot.data()!),
      toFirestore: (job, _) => job.toMap(),
    );
    return Scaffold(
      appBar: AppBar(

        title: Text("Upload Documents",style: CustomTextStyles.customTextStyle26,),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body:
        CustomFirestoreQueryBuilder<UserProfile>(
    query: userQuery,
    pageSize: 2,
    builder: (builder,snapshot) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.docs.length,

          itemBuilder: (itemBuilder, index) {
            final product=snapshot.docs[index].data();
            return  Padding(
  padding: const EdgeInsets.all(18.0),
  child: Column(
    children: [
      MyConsumer<ImagePickerProvider>(builder: (builder,value){
        return   InkWell(
          onTap:()async{
            print("something");

            await value.pickImageFromGallery();
          },
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              GestureDetector(
                onTap:()async{
                  print("something");
                  await value.pickImageFromGallery();
                } ,
                child: (product.imageUrl == null && value.pickedImage == null)
                    ? ProfileField(
                  hint: "Upload your image",
                  onFieldSubmitted: (value) {},
                  obscure: true,
                )
                    : (product.imageUrl != null && value.pickedImage == null)
                    ? Image.network(
                  product.imageUrl??"",
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return ProfileField(
                      hint: "Upload your image",
                      onFieldSubmitted: (value) {},
                      obscure: true,
                    );
                  },
                )
                    : Image.file(
                  value.pickedImage!,
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                ),
        ),

              Positioned(
                right: 30,
                child: GestureDetector(
                  onTap: ()async{
                    value.pickImageFromGallery();
                  },
                  child: Container(
                    width: 110,
                    color: Color(0xFFD9D9D9),
                    child: Row(
                      children: [
                        Icon(Icons.camera_alt_outlined),
                        Text("Add Image"),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        );
      }),
      SizedBox(height: 15,),
      MyConsumer<CNIC>(builder: (builder,value){
        return   InkWell(
          onTap: ()async{
            value.pickImageFromGallery();
          },
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
          (product.documentUrl == null && value.pickedImage == null)
              ? ProfileField(
            hint: "Upload your image",
            onFieldSubmitted: (value) {},
            obscure: true,
          )
              : (product.documentUrl != null && value.pickedImage == null)
              ? Image.network(
            product.documentUrl??"",
            width: 110,
            height: 110,
            fit: BoxFit.cover,
            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
             return ProfileField(
               hint: "Upload your CNIC",
               onFieldSubmitted: (value) {},
               obscure: true,
             );
            },
          )
              : Image.file(
            value.pickedImage!,
            width: 110,
            height: 110,
            fit: BoxFit.cover,
          ),

              Positioned(
                right: 30,
                child:GestureDetector(
                  onTap: ()async{
                    value.pickImageFromGallery();
                  },
                  child: Container(
                    width: 110,
                    color: Color(0xFFD9D9D9),
                    child: Row(
                      children: [
                        Icon(Icons.camera_alt_outlined),
                        Text("Add Image"),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        );
      }),
      SizedBox(height: 15,),
      MyConsumer<documentPicker>(builder: (builder,value){
        return   InkWell(
          onTap: ()async{
            await value.pickImageFromGallery();
          },
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              (product.cnicUrl == null && value.pickedImage == null)
                  ? ProfileField(
                hint: "Upload your document",
                onFieldSubmitted: (value) {},
                obscure: true,
              )
                  : (product.cnicUrl != null && value.pickedImage == null)
                  ? Image.network(
                product.cnicUrl??"",
                width: 110,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  return ProfileField(
                    hint: "Upload your document",
                    onFieldSubmitted: (value) {},
                    obscure: true,
                  );
                },
              )
                  : Image.file(
                value.pickedImage!,
                width: 110,
                height: 110,
                fit: BoxFit.cover,
              ),
              Positioned(
                right: 30,
                child: GestureDetector(
                  onTap: ()async{
                    value.pickImageFromGallery();
                  },
                  child: Container(
                    width: 110,
                    color: Color(0xFFD9D9D9),
                    child: Row(
                      children: [
                        Icon(Icons.camera_alt_outlined),
                        Text("Add Image"),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        );
      }),
      SizedBox(height: 15,),
      MyConsumer<ImagePickerProvider>(builder: (builder,value){
        return  MyConsumer<CNIC>(builder: (builder,value1){
          return MyConsumer<documentPicker>(builder: (builder,value2){
    return AuthButton(title: "Done", onPressed: () {
      if ((value.pickedImage != null || product.imageUrl != "") &&
          (value1.pickedImage != null || product.cnicUrl != "") &&
          (value2.pickedImage != null || product.documentUrl != "")
      ) {
        print("CNIC URL:${product.cnicUrl}");
        print("Document URL:${product.documentUrl}");
        print("Second Image:${value1.pickedImage}");
        print("Third Image:${value2.pickedImage}");

        Utils.showSuccessMessage(
            "Image is uploading please wait until success message show",
            context);
        value.storeImage();
        value1.storeImage();
        value2.storeImage();
        Utils.showSuccessMessage("Success", context);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => ProfileCheck()),
              (route) => false, // Change this condition to keep the existing routes.
        );

      }
      else{
        Utils.showErrorMessage("Make sure you have upload all documents", context);
      }
    });

          });
        });
      }),

    ],
  ),
);
          });
    })



    );
  }
}
