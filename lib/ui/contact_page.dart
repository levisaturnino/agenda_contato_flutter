import 'dart:io';

import 'package:agenda_contatos/helper/contact_helper.dart';
import 'package:agenda_contatos/widget/app_listtile.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();

  bool _userEdited = false;

  Contact _editedContact;

  @override
  void initState() {
    super.initState();
    if(widget.contact == null){
      _editedContact = Contact();
    }else{
      _editedContact = Contact.fromMap(widget.contact.toMap());

      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editedContact.name?? "Novo Contato"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image:_editedContact.img != null ? FileImage(File(_editedContact.img)) :
                        AssetImage("images/person.png")
                    ),
                  ),
                ),
                onTap: (){
                  _showOptions(context, _editedContact);
                },
              ),
              TextField(
                focusNode: _nameFocus,
                controller: _nameController,
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text){
                  _userEdited = true;
                  setState(() {
                    _editedContact.name = text;
                  });
                },
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                onChanged: (text){
                  _userEdited = true;
                  setState(() {
                    _editedContact.email = text;
                  });

                },
                  keyboardType:TextInputType.emailAddress ,
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Phone"),
                onChanged: (text){
                  _userEdited = true;
                  setState(() {
                    _editedContact.phone = text;
                  });
                },
                keyboardType:TextInputType.phone ,

              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            if(_editedContact.name != null && _editedContact.name.isNotEmpty){
              Navigator.pop(context, _editedContact);
            }else{
                FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red,

        ),
      ),
    );
  }

 Future<bool> _requestPop() {
    if(_userEdited){
      showDialog(context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Descartar Alterações?"),
          content: Text("Se sair as alterações serão perdidas"),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancelar"),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Sim"),
              onPressed: (){
                Navigator.pop(context);
                Navigator.pop(context);

              },
            ),
          ],

        );
      });
      return Future.value(false);

    }else{
      return Future.value(true);
    }
  }

  getImageReturn(file){
    if(file == null) return;
    setState(() {
      _editedContact.img = file.path;
    });
  }

  void _showOptions(BuildContext context, Contact contact){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return BottomSheet(
            onClosing: (){},
            builder: (context){
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AppListTile("Camera",onTap:() =>_getCameraGallery(true),icon:Icons.camera),
                    AppListTile("Galeria",onTap:() =>_getCameraGallery(false),icon:Icons.photo_library),
                    AppListTile("Cancelar",onTap:() =>Navigator.pop(context),icon:Icons.cancel),
                  ],
                ),
              );
            },
          );
        }
    );
  }
  void _getCameraGallery(isCamera) {
    if(isCamera){
      ImagePicker.pickImage(source: ImageSource.camera).then((file){
        getImageReturn(file);
      });
    }else{
      ImagePicker.pickImage(source: ImageSource.gallery).then((file){
        getImageReturn(file);
      });
    }
    Navigator.pop(context);
  }
}


























