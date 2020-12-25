import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/models/template_size_state_model.dart';
import 'package:payever/shop/views/edit/appbar/add_object_appbar.dart';
import 'package:payever/shop/views/edit/table_category_view.dart';
import 'package:shape_of_view/shape_of_view.dart';
import '../../../theme.dart';

class AddObjectScreen extends StatefulWidget {
  final ShopEditScreenBloc screenBloc;
  final TemplateSizeStateModel templateSizeStateModel;

  const AddObjectScreen({this.screenBloc, this.templateSizeStateModel});

  @override
  _AddObjectScreenState createState() => _AddObjectScreenState(screenBloc);
}

class _AddObjectScreenState extends State<AddObjectScreen> {
  bool isPortrait;
  bool isTablet;
  int selectedItemIndex = 0;
  int selectedCategory = 0;
  final ShopEditScreenBloc screenBloc;

  List<String> objectTitles = [
    'Product',
    'Basic',
    'Media',
    'Cart',
    'Social',
    'Objects',
    'Animals',
    'Nature',
    'Food',
    'Symbols',
    'Education',
    'Arts',
    'Science',
    'People',
    'Places',
    'Activities',
    'Transportation',
    'Work',
    'Ornaments'
  ];

  List<Map<String, dynamic>> productsItems = [
    {
      'name': 'Product',
      'type': 'shop-products',
      'icon': 'assets/images/productsicon.svg'
    },
    {
      'name': 'Product Detail',
      'type': 'shop-product-details',
      'icon': 'assets/images/product_detail.svg'
    },
    {
      'name': 'Catalog',
      'type': 'shop-category',
      'icon': 'assets/images/catalog.svg'
    }
  ];

  List<Map<String, dynamic>> mediaItems = [
    {
      'name': 'Image',
      'type': 'image',
      'icon': 'assets/images/no_image.svg'
    },
    {
      'name': 'Video',
      'type': 'video',
      'icon': 'assets/images/no_video.svg'
    }
  ];

  List<String> socialIcons = [
    'instagram',
    'facebook',
    'youtube',
    'linkedin',
    'google',
    'twitter',
    'telegram',
    'messenger',
    'pinterest',
    'dribble',
    'tiktok',
    'whatsapp',
    'mail'
  ];

  List<String> shopCarts = [
    'square-cart',
    'angular-cart',
    'flat-cart',
    'square-cart--empty',
    'angular-cart--empty',
    'flat-cart--empty',
  ];

  _AddObjectScreenState(this.screenBloc);

  @override
  Widget build(BuildContext context) {
    isPortrait = GlobalUtils.isPortrait(context);
    isTablet = GlobalUtils.isTablet(context);

    return BlocBuilder(
      bloc: screenBloc,
      builder: (BuildContext context, state) {
        return Scaffold(
            appBar: AddObjectAppbar(onSelected: (index) {
              setState(() {
                selectedCategory = index;
              });
            }),
            backgroundColor: Colors.grey[800],
            body: SafeArea(bottom: false, child: _body()));
      },
    );
  }

  Widget _body() {
    switch (selectedCategory) {
      case 0:
        return TableCategoryView(onCreateTable: (type, index) {
          ShopObject shopObject = ShopObject(name: '$type-$index', type: 'table');
          Navigator.pop(context, shopObject);
        },);
      case 1:
        return _objectView();
      default:
        return _objectView();
    }
  }

  Widget _objectView() {
    return Column(
      children: [
        _secondAppbar(),
        _gridViewBody(),
      ],
    );
  }
  Widget _secondAppbar() {
    return Container(
      height: 50,
      color: overlaySecondAppBar(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: <Widget>[
            SizedBox(width: 8),
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.all(8),
                child: SvgPicture.asset(
                  'assets/images/searchicon.svg',
                  width: 20,
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(width: 16),
            Row(
              children: objectTitles.map((e) {
                int idx = objectTitles.indexOf(e);
                return _secondAppBarItem(e, idx);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gridViewBody() {
    int count = 0;
    switch (selectedItemIndex) {
      case 0:
        count = productsItems.length;
        break;
      case 1:
        count = 8;
        break;
      case 2:
        count = mediaItems.length;
        break;
      case 3:
        count = shopCarts.length;
        break;
      case 4:
        count = socialIcons.length;
        break;
      default:
        count = 8;
        break;
    }

    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: GridView.count(
          crossAxisCount: isTablet ? 5 : (isPortrait ? 3 : 5),
          crossAxisSpacing: isTablet ? 60 : (isPortrait ? 50 : 60),
          mainAxisSpacing: isTablet ? 60 : (isPortrait ? 50 : 60),
          children: List.generate(
            count,
            (index) {
              switch (selectedItemIndex) {
                case 0:
                  return _productGridItem(index);
                case 1:
                  return _objectGridItem(index);
                case 2:
                  return _mediaGridItem(index);
                case 3:
                  return _cartGridItem(index);
                case 4:
                  return _socialGridItem(index);
                default:
                  return _objectGridItem(index);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _secondAppBarItem(String title, int index) {
    bool isSelected = selectedItemIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          selectedItemIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: isSelected
            ? BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              )
            : null,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.blue,
          ),
        ),
      ),
    );
  }

  Widget _productGridItem(int index) {
    Map<String, dynamic>productItem = productsItems[index];
    return InkWell(
        onTap: () {
          Navigator.pop(context, ShopObject(name: shopCarts[index], type: productItem['type']));
        },
        child: Container(
          child: Column(
            children: [
              Expanded(child: Container(child: SvgPicture.asset(productItem['icon'], width: double.infinity,))),
              SizedBox(height: 10,),
              Text(
                productItem['name'],
                style: TextStyle(color: Colors.white, fontSize: 14),
                maxLines: 1,
              )
            ],
          ),
        ));
  }

  Widget _objectGridItem(int index) {
    ShopObject shopObject;
    Widget item;
    switch (index) {
      case 0:
        shopObject = ShopObject(name: 'text', type: 'text');
        item = Container(
          alignment: Alignment.center,
          child: Text(
            'Text',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
        );
        break;
      case 1:
        shopObject = ShopObject(name: 'square', type: 'shape');
        item = Container(
          color: Colors.grey[300],
        );
        break;
      case 2:
        shopObject = ShopObject(name: 'circle', type: 'shape');
        item = Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
          ),
        );
        break;
      case 3:
        shopObject = ShopObject(name: 'triangle', type: 'shape');
        item = Transform.rotate(
          angle: pi,
          child: ShapeOfView(
              shape: TriangleShape(
                  percentBottom: 0.5, percentLeft: 0, percentRight: 0),
              child: Transform.rotate(
                angle: pi,
                child: Container(
                  color: Colors.grey[300],
                ),
              )),
        );
        break;
      case 4:
        shopObject = ShopObject(name: 'button', type: 'button');
        item = Container(
          alignment: Alignment.center,
          child: AspectRatio(
            aspectRatio: 1 / 0.6,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
              child: Text(
                'Button',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
        );
        break;
      case 5:
        shopObject = ShopObject(name: 'button--rounded', type: 'button');
        item = Container(
          alignment: Alignment.center,
          child: AspectRatio(
            aspectRatio: 1 / 0.6,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8)),
              child: Text(
                'Button',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
        );
        break;
      case 6:
        shopObject = ShopObject(name: 'menu', type: 'menu');
        item = Container(
          alignment: Alignment.center,
          child: Text(
            'Menu',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
        );
        break;
      case 7:
        shopObject = ShopObject(name: 'logo', type: 'logo');
        item = Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[300],),
          child: Text(
            'LOGO',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
        );
        break;
    }
    return InkWell(
        onTap: () {
          Navigator.pop(context, shopObject);
        },
        child: item);
  }

  Widget _mediaGridItem(int index) {
    Map<String, dynamic>mediaItem = mediaItems[index];
    return InkWell(
        onTap: () {
          Navigator.pop(context, ShopObject(name: shopCarts[index], type: mediaItem['type']));
        },
        child: Container(
          padding: EdgeInsets.all(10),
          child:
          SvgPicture.asset(mediaItem['icon'], color: Colors.white,),
        ));
  }

  Widget _cartGridItem(int index) {
    ShopObject shopObject = ShopObject(name: shopCarts[index], type: 'shop-cart');
    return InkWell(
        onTap: () {
          Navigator.pop(context, shopObject);
        },
        child: Container(
          padding: EdgeInsets.all(10),
          child:
              SvgPicture.asset('assets/images/shop-edit-cart${index + 1}.svg'),
        ));
  }

  Widget _socialGridItem(int index) {
    ShopObject shopObject = ShopObject(name: socialIcons[index], type: 'social-icon');
    return InkWell(
        onTap: () {
          Navigator.pop(context, shopObject);
        },
        child: Container(
          padding: EdgeInsets.all(10),
          child: SvgPicture.asset('assets/images/social-icon-${socialIcons[index]}.svg', color: Colors.white,),
        ));
  }
}
