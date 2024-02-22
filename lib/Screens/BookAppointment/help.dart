import 'package:flutter/material.dart';
import 'package:seniors_go_digital/AppStrings/Textstyle.dart';
class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Help",style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 22,
          fontFamily: "Poppins",
          color: Colors.black,
        ),),
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
        ),
      ),
      body:const SingleChildScrollView(
        child:  Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "1. Stay Engaged Through Discussions:",
                style: TextStyle(
                  color: Color(0xFF000000), // Color: var(--light-gray-11, #000);
                  fontFamily: 'Poppins',
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                "To make the most of your experience on the \"Seniors Go Digital\" platform, actively participate in discussions. Engaging in conversations, asking questions, and sharing your thoughts can lead to meaningful connections and knowledge-sharing. Whether it's a topic you're passionate about or something you want to learn more about, discussions are a great way to connect with others in the community and expand your horizons. Don't be shy—join the conversation and enjoy the benefits of social engagement and learning!",
                style: TextStyle(
                  color: Color(0xFF000000), // Color: var(--light-gray-11, #000);
                  fontFamily: 'Roboto',
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0.25,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                "2. Explore Mentorship Opportunities:",
                style: TextStyle(
                  color: Color(0xFF000000), // Color: var(--light-gray-11, #000);
                  fontFamily: 'Poppins',
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                "If you have expertise in a particular area, consider offering mentorship. It's a fantastic way to share your knowledge and make a positive impact on others.",
                style: TextStyle(
                  color: Color(0xFF000000), // Color: var(--light-gray-11, #000);
                  fontFamily: 'Roboto',
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0.25,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                "3. Use ChatGpt3 Wisely:",
                style: TextStyle(
                  color: Color(0xFF000000), // Color: var(--light-gray-11, #000);
                  fontFamily: 'Poppins',
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                " ChatGpt3, the AI chatbot, is here to assist you. Whether you need information about upcoming events, want to find users with similar interests, or have general inquiries, ChatGpt3 can help. When chatting with the bot, try to be specific in your questions for more accurate responses.",
                style: TextStyle(
                  color: Color(0xFF000000), // Color: var(--light-gray-11, #000);
                  fontFamily: 'Roboto',
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0.25,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                "4. Respect Privacy and Security:",
                style: TextStyle(
                  color: Color(0xFF000000), // Color: var(--light-gray-11, #000);
                  fontFamily: 'Poppins',
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                "While the platform is designed with safety in mind, it's essential to be cautious. Avoid sharing personal information like your home address or phone number with strangers. Report any suspicious behavior to platform administrators promptly.",
                style: TextStyle(
                  color: Color(0xFF000000), // Color: var(--light-gray-11, #000);
                  fontFamily: 'Roboto',
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0.25,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                "5. Give Feedback:",
                style: TextStyle(
                  color: Color(0xFF000000), // Color: var(--light-gray-11, #000);
                  fontFamily: 'Poppins',
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                "If you encounter any issues or have suggestions for improvement, provide feedback to the platform administrators. Your input can help enhance the user experience.",
                style: TextStyle(
                  color: Color(0xFF000000), // Color: var(--light-gray-11, #000);
                  fontFamily: 'Roboto',
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0.25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
