import 'package:contact_list/helpers/contact_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();
  @override
  void initState() {
    super.initState();
    Contact c = Contact();
    c.name="Fred";
    c.email="beckmann2@gmail";
    c.phone="12234";
    c.img="imgText";
    helper.saveContact(c);

    helper.getAllContacts().then((list) => print(list));
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}