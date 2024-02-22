import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:shimmer/shimmer.dart';

class CustomFirestoreQueryBuilder<T> extends StatelessWidget {
  final int pageSize;
  final Query<T> query;
  final Widget? widget;
  final Widget Function(BuildContext context, FirestoreQueryBuilderSnapshot<T> snapshot) builder;

  const CustomFirestoreQueryBuilder({super.key,
   required  this.pageSize,
    required this.query,
    required this.builder, this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder<T>(
      query: query,
      pageSize: pageSize,
      builder: (BuildContext context, FirestoreQueryBuilderSnapshot<T> snapshot, _) {
        if (snapshot.isFetching) {
          return widget?? ListView.builder(
            shrinkWrap: true,
            itemCount:5, // Change the itemCount as needed
            itemBuilder: (context, index) {

                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: ListTile(
                    leading: const CircleAvatar(
                      radius: 30.0,
                      backgroundColor: Colors.white,
                    ),
                    title: Container(
                      width: double.infinity,
                      height: 16.0,
                      color: Colors.white,
                    ),
                    subtitle: Container(
                      width: double.infinity,
                      height: 12.0,
                      color: Colors.white,
                    ),
                  ),
                );
            },
          )
          ;
        } else if (snapshot.isFetchingMore) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle errors, such as socket errors
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.docs.isEmpty){
          // Handle the case when there's no data
          return const Text('No data');
        } else {
          // Call the custom builder function to build the UI
          return builder(context, snapshot);
        }
      },
    );
  }
}
