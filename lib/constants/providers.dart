import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seniors_go_digital/provider/user_vm.dart';

class MainVM
{
  static UserVM userVM(BuildContext context)
  {
    return Provider.of<UserVM>(context,listen: false);
  }
}
