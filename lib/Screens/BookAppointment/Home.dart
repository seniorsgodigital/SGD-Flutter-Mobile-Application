import 'package:flutter/material.dart';
import 'package:seniors_go_digital/AppStrings/Textstyle.dart';
import 'package:seniors_go_digital/AppStrings/asset_images.dart';
class HomeNav extends StatefulWidget {
  const HomeNav({super.key});

  @override
  State<HomeNav> createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(AssetImages.askIcon),
        actions: [
          IconButton(onPressed: (){}, icon: Image.asset(AssetImages.messageIcon)),
          IconButton(onPressed: (){}, icon: Image.asset(AssetImages.messageIcon))
        ],
      ),
      body: Column(
        children: [
          Text("Welcome urooj khan",style: CustomTextStyles.customTextStyle600,),
          Container(
            color:  Color(0xFFE8F3FB),
            width: 192,height: 63,
            child:Center(child: Text("Book appointment",style: CustomTextStyles.customTextStyle600,)) ,),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(AssetImages.main1), // Replace with your image
            ),
            title: Text('Name'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  height: 8.0, // Adjust the height of the divider
                  color: Colors.black, // Divider color
                  thickness: 1.0, // Divider thickness
                ),
                Text('Subtitle goes here'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
             Image.asset(AssetImages.messageIcon), // Replace 'icon1' with the first icon
                SizedBox(width: 8.0), // Adjust the spacing between icons
                Image.asset(AssetImages.askIcon), // Replace 'icon2' with the second icon
              ],
            ),
          )

        ],
      ),
    );
  }
}
