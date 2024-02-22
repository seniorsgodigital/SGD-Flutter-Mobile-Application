import 'package:flutter/material.dart';
class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Container(),
        elevation: 0,

      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(0.0), // No curve
    ),
    child: TextFormField(
    decoration: InputDecoration(
    filled: true, // Filled background
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(0.0), // No curve
    ),
    prefixIcon: IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: (){
        Navigator.pop(context);
    }, // Function to pop the screen
    ),
    suffixIcon: IconButton(
    icon: Icon(Icons.search),
    onPressed: (){

    }, // Function to perform the search
    ),
    ),
    ),
    ),
      )
    );
  }
}
