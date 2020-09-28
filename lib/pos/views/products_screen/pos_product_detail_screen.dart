import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/env.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/theme.dart';

class PosProductDetailScreen extends StatefulWidget {
  final ProductsModel productsModel;
  final PosScreenBloc posScreenBloc;

  PosProductDetailScreen({this.productsModel, this.posScreenBloc});

  @override
  _PosProductDetailScreenState createState() =>
      _PosProductDetailScreenState(productsModel);
}

class _PosProductDetailScreenState extends State<PosProductDetailScreen> {
  final ProductsModel product;
  bool _isPortrait;
  bool _isTablet;
  _PosProductDetailScreenState(this.product);
  double imageHeight = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);
    _isTablet = Measurements.width < 600 ? false : true;

    if (imageHeight == 0) {
      imageHeight = _isPortrait ? Measurements.width : Measurements.height;
    }

    return BlocListener(
      bloc: widget.posScreenBloc,
      listener: (BuildContext context, PosScreenState state) async {},
      child: BlocBuilder<PosScreenBloc, PosScreenState>(
        bloc: widget.posScreenBloc,
        builder: (BuildContext context, PosScreenState state) {
          return Scaffold(
            resizeToAvoidBottomPadding: true,
            appBar: Appbar(product.title ?? ''),
            body: SafeArea(
              bottom: false,
              child: BackgroundBase(
                true,
                body: _getBody(state),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getBody(PosScreenState state) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              height: imageHeight,
              alignment: Alignment.center,
              child: CachedNetworkImage(
                imageUrl:
                    '${Env.storage}/products/${product.images.isEmpty ? null : product.images.first}',
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                color: Colors.white,
                placeholder: (context, url) => Container(
                  child: Center(
                    child: Container(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/no_image.svg',
                      color: Colors.black54,
                      width: 150,
                      height: 150,
                    ),
                  ),
                ),
              ),
            ),
            Text(
              '${formatter.format(product.price)} ${Measurements.currency(product.currency)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10,),
            Flexible(
              child: Text(
                '${product.description}}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 20,),
            InkWell(
              onTap: () {

              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: overlayBackground(),
                ),
                child: Text('In the Cart'),
              ),
            ),
            SizedBox(height: 40,)
          ],
        ),
      ),
    );
  }
}
