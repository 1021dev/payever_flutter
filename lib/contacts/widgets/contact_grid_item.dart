import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/contacts/models/model.dart';
import 'package:payever/contacts/widgets/contact_item_image_view.dart';

class ContactGridItem extends StatelessWidget {
  final Function onTap;
  final Function onOpen;
  final ContactModel contact;

  ContactGridItem({
    this.onTap,
    this.onOpen,
    this.contact,
  });

  final String groupPlaceholder = 'https://payeverstage.azureedge.net/placeholders/group-placeholder.png';
  final String contactPlaceholder = 'https://payeverstage.azureedge.net/placeholders/contact-placeholder.png';


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap(contact),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          color: Color.fromRGBO(0, 0, 0, 0.3),
        ),
        child: Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: ContactItemImageView(
                    contactPlaceholder,
                  ),
                ),
                Container(
                  height: 116,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 12,
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 25,
                                alignment: Alignment.topLeft,
                                child: Text(
                                  Language.getConnectStrings('connectModel.integration.displayOptions.title'),
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'Roboto-Medium'
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  Language.getConnectStrings('connectModel.integration.installationOptions.price'),
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontFamily: 'Roboto'
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 44,
                        color: Color.fromRGBO(0, 0, 0, 0.3),
                        alignment: Alignment.center,
                        child: SizedBox.expand(
                          child: MaterialButton(
                            child: Text(
                              'Open',
                            ),
                            onPressed: onOpen(contact),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.all(10),
              height: 24,
              width: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromRGBO(0, 0, 0, 0.3),
              ),
              child: contact.isChecked ? Icon(
                Icons.check_circle_outline,
                color: Colors.white60,
                size: 24,
              ) : Icon(
                Icons.radio_button_unchecked,
                color: Colors.white60,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}