import 'dart:io';
import 'package:contact_list/helpers/contact_helper.dart';
import 'package:contact_list/ui/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOperations{orderaz, orderza}

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();
  List<Contact> contacts = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOperations>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOperations>>[
              const PopupMenuItem<OrderOperations>(
                child: Text("Ordenar de A - Z"),
                value: OrderOperations.orderaz,
              ),
              const PopupMenuItem<OrderOperations>(
                child: Text("Ordenar de Z - A"),
                value: OrderOperations.orderza,
              ),
            ],
            onSelected: _orderList,
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () { 
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: contacts.length,
        itemBuilder: (context, index){
          return _contactCard(context, index);
        }
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index){
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: contacts[index].img != null ? FileImage(File(contacts[index].img!)) :
                      AssetImage("assets/images/person.png") as ImageProvider,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(contacts[index].name ?? "",
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),),
                    Text(contacts[index].email ?? "",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),),
                    Text(contacts[index].phone ?? "",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: (){
        _showOptions(context, index);
      },
    );
  }

  _showOptions(BuildContext context, int index){
    showModalBottomSheet(
      context: context, 
      builder: (context){
        return BottomSheet(
          onClosing: (){

          }, 
          builder: (context){
            return Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                      onPressed: (){
                        launch("tel::${contacts[index].phone}");
                        Navigator.pop(context);
                      }, 
                      child: Text("Ligar",
                      style: TextStyle(color: Colors.red, fontSize: 20.0),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                        _showContactPage(contact: contacts[index]);
                      }, 
                      child: Text("Editar",
                      style: TextStyle(color: Colors.red, fontSize: 20.0),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                      onPressed: (){
                        helper.deleteContact(contacts[index].id!);
                        setState(() {
                          contacts.removeAt(index);
                          Navigator.pop(context);
                        });
                      }, 
                      child: Text("Excluir",
                      style: TextStyle(color: Colors.red, fontSize: 20.0),),
                    ),
                  ),
                ],
              ),
            );
          }
        );
      }
    );
  }

  void _showContactPage({Contact? contact}) async{
    final recContact = await Navigator.push(context, 
      MaterialPageRoute(builder: (context)=> ContactPage(contact: contact,))
    );
    if(recContact!=null){
      if(contact != null){
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    } 
  }
  void _getAllContacts(){
    helper.getAllContacts().then((list){
      setState(() {
        contacts = list as List<Contact>;
      });
    });
  }

  void _orderList(OrderOperations result){
    switch(result){
      case OrderOperations.orderaz:
        contacts.sort((a, b){
          return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
        });
        break;
      case OrderOperations.orderza:
        contacts.sort((a, b){
          return b.name!.toLowerCase().compareTo(a.name!.toLowerCase());
        });
        break;
    }
    setState(() {
      
    });
  }
}