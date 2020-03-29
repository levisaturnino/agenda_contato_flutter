import 'dart:io';

import 'package:agenda_contatos/helper/contact_helper.dart';
import 'package:agenda_contatos/ui/contact_page.dart';
import 'package:agenda_contatos/widget/app_alert_dialog.dart';
import 'package:agenda_contatos/widget/app_listtile.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions {orderaz, orderza}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  List<Contact> contacts = List();

  @override
  void initState() {
    super.initState();
    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                  child: Text("Ordenar de A-Z"),
                  value:OrderOptions.orderaz,
                  ),
             const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de Z-A"),
                value:OrderOptions.orderza,
              ),
            ],
            onSelected: _orderList,
          )
        ],
        title: Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: _showContactPage,
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: contacts.length > 0
          ? ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                Contact contact = contacts[index];
                return _contactCard(context, contact);
              })
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage("images/person.png")),
                    ),
                  ),
                  Text(
                    "Nenhum Contato",
                    style: TextStyle(fontSize: 22.0),
                  ),
                ],
              ),
            ),
    );
  }

  _contactCard(BuildContext context, Contact contact) {
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
                      image: contact.img != null
                          ? FileImage(File(contact.img))
                          : AssetImage("images/person.png")),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contact.name ?? "",
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      contact.email ?? "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      contact.phone ?? "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () => {_showOptions(context, contact)},
    );
  }

  void _showOptions(BuildContext context, Contact contact) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AppListTile("Ligar",
                        onTap: () => {
                              launch("tel:${contact.phone}"),
                              Navigator.pop(context)
                            },
                        icon: Icons.phone),
                    AppListTile("Editar",
                        onTap: () => {
                              Navigator.pop(context),
                              _showContactPage(contact: contact)
                            },
                        icon: Icons.edit),
                    AppListTile("Excluir",
                        onTap: () => {
                        Navigator.pop(context),

                        showDialog(context: context,
                        builder: (context){
                        return AppAlertDialog(
                                "Remove",
                                "Sim",
                                "Não",
                                body:
                                    "Deseja realmente apagar esse contato: ${contact.name}",
                                onPressedNo: () => {Navigator.pop(context)},
                                onPressedYes: () => {
                                  helper.deleteContact(contact.id),
                                  setState(() {
                                    contacts.remove(contact);
                                    Navigator.pop(context);
                                  })
                                },
                              );
                        })
                            },
                        icon: Icons.restore_from_trash),
                  ],
                ),
              );
            },
          );
        });
  }

  void _showContactPage({Contact contact}) async {
    final recContact = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ContactPage(contact: contact)));
    if (recContact != null) {
      if (contact != null) {
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  void _orderList(OrderOptions result){
    switch(result){
      case OrderOptions.orderaz:
        contacts.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        contacts.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {
    });
  }

}
