import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seniors_go_digital/AppStrings/Textstyle.dart';
import 'package:seniors_go_digital/Screens/BookAppointment/profile_detail.dart';

import '../../AppStrings/asset_images.dart';
import '../../Widget/auth/fetch_data.dart';
import '../../models/userDataModel.dart';
import 'message.dart';
class AllStudents extends StatefulWidget {
  const AllStudents({super.key});

  @override
  State<AllStudents> createState() => _AllStudentsState();
}

class _AllStudentsState extends State<AllStudents> {
  @override
  Widget build(BuildContext context) {

    final Query<UserProfile> doctorQuery = FirebaseFirestore.instance.collection('userData')
        .where("role",isEqualTo: "User")
        .withConverter(
      fromFirestore: (snapshot, _) => UserProfile.fromMap(snapshot.data()!),
      toFirestore: (job, _) => job.toMap(),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
backgroundColor: Colors.white,
        elevation: 0,
        title: Text("All Students",style: CustomTextStyles.customTextStyle600,),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios,color: Colors.black,),
        ),
      ),
      body:               CustomFirestoreQueryBuilder<UserProfile>(pageSize: 2,
          query: doctorQuery, builder: (builder,snapshot){
            return             ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: snapshot.docs.length,
              itemBuilder: (context, index) {
                final product=snapshot.docs[index].data();
                return Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (builder)=>
                          ProfileDetail(image: product.imageUrl??"",
                              appointment: product.dateTime ?? Timestamp.fromDate(DateTime.now()),
                              domain: product.domain??"",
                              specialization: product.specialization??"",
                              experience: product.experience??"",
                              name: product.name??"", userProfile: product,)
                      ));
                    },
                    leading: CircleAvatar(
                      child: Text(product.name!.substring(0,1).toUpperCase()),
                      backgroundImage: AssetImage(AssetImages.personIcon), // Replace with your image asset
                    ),
                    title: Text(product.name??"",style: CustomTextStyles.customTextStyle700,),
                    subtitle: Divider(
                      height: 8.0,
                      color: Color(0xFFEEEEEE),
                      thickness: 1.0,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                            onTap: (){

                            },
                            child: Image.asset(AssetImages.videoIcon)),
                        SizedBox(width: 8.0),
                        InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (builder)=>MessageRoom(name: product.name??"",
                                  assetImage:product.imageUrl??"")));
                            },
                            child: Image.asset(AssetImages.message1Icon)),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
