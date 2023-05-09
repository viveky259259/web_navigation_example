import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About us')),
      floatingActionButton: FloatingActionButton(onPressed: (){
        GoRouter.of(context).push('/feedback');
      },),
    );
  }
}
