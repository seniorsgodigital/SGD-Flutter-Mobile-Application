import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy',style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,color: Colors.black,
        ),),
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios,color: Colors.black,)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body:const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Welcome to Seniors Go Digital',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'A platform designed to empower senior citizens and connect communities.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'At Seniors Go Digital, we are committed to protecting your privacy and ensuring the security of your personal information. This Privacy Policy explains how we collect, use, and safeguard your data. By using Seniors Go Digital, you consent to the practices described in this policy.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Data Collection',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '1. User Registration Information:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'To create an account, we collect personal information such as your name and email address. This information is used for user authentication and profile creation.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '2. User-Generated Content:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Any content you create or post on Seniors Go Digital, such as forum posts or comments, will be displayed on the platform for other users to see.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '3. Usage Data:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'We collect data about your interactions with Seniors Go Digital, including logs and analytics. This data helps us improve the platform\'s performance and user experience.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Data Usage',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '1. User Authentication:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Your registration information is used to create and manage your account on Seniors Go Digital.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '2. Display of User-Generated Content:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Content you create, such as forum posts, is displayed publicly on the platform to foster knowledge sharing and community interaction.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '3. Improvement of Services:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Usage data is analyzed to enhance our services, identify issues, and optimize the user experience.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Data Sharing',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '1. Service Providers:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'We may share data with third-party service providers (e.g., hosting or analytics services) to maintain and improve Seniors Go Digital.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '2. Legal Compliance:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'We may disclose data as required by applicable laws or legal authorities.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Data Security',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'We take the security of your data seriously:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '- Data is encrypted to protect sensitive information.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              '- Access controls are in place to restrict unauthorized access.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              '- Regular security assessments are conducted to ensure data security.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Cookies and Tracking',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Seniors Go Digital may use cookies and tracking technologies for various purposes, including improving user experience and gathering analytics. By using the platform, you consent to the use of these technologies.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'User Rights',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'You have the right to:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '- Access your data.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              '- Request deletion of your data.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              '- Update or correct your data.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Data Retention',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'We retain user data for as long as necessary to provide our services. When data is no longer needed, it will be securely deleted.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Policy Changes',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'We may update this Privacy Policy from time to time. You will be notified of any significant changes. Please review this policy periodically to stay informed.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Wrap(
              children: [
                Text(
                  'If you have questions or concerns about this Privacy Policy or our data practices, please contact us at ',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  'seniorgodigital.pk@gmail.com',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.blue, // Change the text color to blue
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.0),
            Text(
              'Thank you for choosing Seniors Go Digital.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
