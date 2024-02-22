import 'package:flutter/material.dart';
import 'package:seniors_go_digital/AppStrings/app_routes.dart';
import 'package:seniors_go_digital/AppStrings/asset_images.dart';
import 'package:seniors_go_digital/AppStrings/media_querie_extention.dart';
import 'package:seniors_go_digital/Screens/auth/login.dart';
import 'package:seniors_go_digital/Widget/AppBar/customAppBar.dart';

import '../../Widget/auth/grid_til.dart';
class AuthMain extends StatefulWidget {
  const AuthMain({super.key});

  @override
  State<AuthMain> createState() => _AuthMainState();
}
class GridItem {
  final String title;
  final String image;

  GridItem({required this.title, required this.image});
}
class _AuthMainState extends State<AuthMain> {

  final List<GridItem> items = [
    GridItem(
      title: "Learner",
      image: AssetImages.main1,
    ),
    GridItem(
      title: "Senior Citizen",
      image: AssetImages.main2,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SizedBox(height: context.height*0.03,),
            Image.asset(AssetImages.logoMain,height: 280,),
            SizedBox(height: context.height*0.05,),
            FittedBox(
              child: Text("Empowering seniors, Connecting Generations!\n"
                  "Join Seniors Go Digital Today.",style: TextStyle(
                fontSize: 19,color: Color(0xFF2C5678),fontWeight: FontWeight.bold
              ),),
            ),
            SizedBox(height: context.height*0.03,),
            GridView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.0, // Adjust the aspect ratio as needed
              ),
              itemBuilder: (context, index) {
                return CurvedGridTile(
                  title: items[index].title,
                  imagePath: items[index].image,
onPressed: (){
                    if(index==0){
                      Navigator.push(context,MaterialPageRoute(builder: (builder)=>
                      Login(role: "User",)
                      ));
                    }
                    else if(index==1){
                      Navigator.push(context,MaterialPageRoute(builder: (builder)=>
                          Login(role: "senior",)
                      ));
                    }
},
                );
                },
            ),
            SizedBox(height: context.height*0.07,),
          ],
        ),
      ),
    );
  }
}
