import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/products/models/models.dart';

class EditVariantScreen extends StatefulWidget {

  final Variants variants;

  EditVariantScreen({this.variants});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EditVariantScreenState();
  }
}

class _EditVariantScreenState extends State<EditVariantScreen> {

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      appBar: _appBar(),
      body: SafeArea(
        child: BackgroundBase(
          true,
          body: Form(
            key: formKey,
            autovalidate: false,
            child: Container(
              color: Color(0xff2c2c2c),
              alignment: Alignment.center,
              child: Container(
                width: Measurements.width,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: _getBody(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Row(
        children: <Widget>[
          Text(
            'Edit Variant',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            height: 32,
            elevation: 0,
            minWidth: 0,
            color: Colors.black,
            child: Text(
              Language.getProductStrings('cancel'),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 8),
        ),
        Container(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            elevation: 0,
            minWidth: 0,
            color: Colors.white24,
            child: isLoading ? Center(
              child: Container(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ) : Text(
              Language.getProductStrings('save'),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 16),
        ),
      ],
    );
  }

  Widget _getBody() {
    String imgUrl = '';
    if (widget.variants.images.length > 0) {
      imgUrl = widget.variants.images.first;
    }
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: BlurEffectView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      imgUrl != '' ? Container(
                        height: Measurements.width * 0.7,
                        child: CachedNetworkImage(
                          imageUrl: '${Env.storage}/products/$imgUrl',
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) =>  Container(
                            height: Measurements.width * 0.7,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset('assets/images/insertimageicon.svg'),
                                Padding(
                                  padding: EdgeInsets.only(top: 16),
                                ),
                                Text(
                                  'Upload images',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ): GestureDetector(
                        onTap: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) => CupertinoActionSheet(
                              title: const Text('Choose Photo'),
                              message: const Text('Your options are '),
                              actions: <Widget>[
                                CupertinoActionSheetAction(
                                  child: const Text('Take a Picture'),
                                  onPressed: () {
                                    Navigator.pop(context, 'Take a Picture');
                                    getImage(0);
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  child: const Text('Camera Roll'),
                                  onPressed: () {
                                    Navigator.pop(context, 'Camera Roll');
                                    getImage(1);
                                  },
                                )
                              ],
                              cancelButton: CupertinoActionSheetAction(
                                child: const Text('Cancel'),
                                isDefaultAction: true,
                                onPressed: () {
                                  Navigator.pop(context, 'Cancel');
                                },
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: Measurements.width * 0.7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          ),
                          alignment: Alignment.center,
                          child: state.isUploading ? Container(
                            child: Center(child: CircularProgressIndicator()),
                          ): Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SvgPicture.asset('assets/images/insertimageicon.svg'),
                              Padding(
                                padding: EdgeInsets.only(top: 16),
                              ),
                              Text(
                                'Upload images',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ListView.separated(
                        padding: EdgeInsets.all(4),
                        itemCount: widget.variants.options.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return _buildOptionItems(context, index);
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            height: 0,
                            color: Colors.transparent,
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItems(BuildContext context, int index) {
    VariantOption option = widget.variants.options[index];
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.only(
        left: 8,
        right: 8,
        bottom: 8,
        top: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0x80111111),
      ),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextFormField(
              onTap: () {
//                if (isShownColorPicker)
//                  Navigator.pop(context);
//                setState(() {
//                  isShownColorPicker = false;
//                });
              },
              onChanged: (val) {

              },
              initialValue: option.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                  fillColor: Color(0x80111111),
                  labelText: Language.getProductStrings('Option name'),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w200,
                  ),
                  border: InputBorder.none
              ),
            ),
          ),
          Flexible(
            child: TextFormField(
              onTap: () {
//                if (isShownColorPicker)
//                  Navigator.pop(context);
//                setState(() {
//                  isShownColorPicker = false;
//                });
              },
              onChanged: (val) {

              },
              initialValue: option.value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                  fillColor: Color(0x80111111),
                  labelText: Language.getProductStrings('Option value'),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w200,
                  ),
                  border: InputBorder.none
              ),
            ),
          ),
        ],
      ),
    );
  }

}