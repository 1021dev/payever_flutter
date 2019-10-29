import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:payever/checkout_process/models/models.dart';
import 'package:payever/checkout_process/views/custom_elements/custom_elements.dart';
import 'package:payever/settings/utils/utils.dart';
import 'package:provider/provider.dart';

import '../../checkout_process.dart';

class PaymentFrame extends StatefulWidget {
  List<CheckoutPaymentOption> pms = List();
  PaymentFrame(this.pms);
  @override
  _PaymentFrameState createState() => _PaymentFrameState();
}

class _PaymentFrameState extends State<PaymentFrame> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.pms.length,
        itemBuilder: (BuildContext context, int index) {
          PaymentHeader header = PaymentHeader(
            widget.pms[index].payment_method,
            widget.pms[index].image_primary_filename,
            index,
          );
          PaymentBody body = PaymentBody(
            index: index,
            openIndex: Provider.of<PaymentSelection>(context).openIndex,
            body: Provider.of<CheckoutProcessStateModel>(context)
                .paymentMap[widget.pms[index].slug],
          );
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border(
                  top: BorderSide(
                    color: Colors.black.withOpacity(0.3),
                  ),
                  bottom: BorderSide(
                    color: Colors.black.withOpacity(0.3),
                  ),
                  left: BorderSide(
                    color: Colors.black.withOpacity(0.3),
                  ),
                  right: BorderSide(
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
              ),
              child: PaymentBuilder(
                header,
                body,
                index,
              ),
            ),
          );
        },
      ),
    );
  }
}

class PaymentBuilder extends StatefulWidget {
  PaymentHeader header;
  PaymentBody body;
  int index;
  PaymentBuilder(this.header, this.body, this.index);
  @override
  _PaymentBuilderState createState() => _PaymentBuilderState();
}

class _PaymentBuilderState extends State<PaymentBuilder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          widget.header,
          widget.body,
        ],
      ),
    );
  }
}

class MyCustomExpandIcon extends StatefulWidget {
  const MyCustomExpandIcon({
    Key key,
    this.isExpanded = false,
    this.size = 24.0,
    @required this.onPressed,
    this.padding = const EdgeInsets.all(8.0),
    this.color = Colors.black,
    this.disabledColor,
    this.expandedColor,
  })  : assert(isExpanded != null),
        assert(size != null),
        assert(padding != null),
        super(key: key);

  final bool isExpanded;
  final double size;
  final ValueChanged<bool> onPressed;
  final EdgeInsetsGeometry padding;
  final Color color;
  final Color disabledColor;
  final Color expandedColor;

  @override
  createState() => _MyCustomExpandIconState();
}

class _MyCustomExpandIconState extends State<MyCustomExpandIcon>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(MyCustomExpandIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void _handlePressed() {
    if (widget.onPressed != null) widget.onPressed(widget.isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final String onTapHint = widget.isExpanded
        ? localizations.expandedIconTapHint
        : localizations.collapsedIconTapHint;

    return Semantics(
      onTapHint: widget.onPressed == null ? null : onTapHint,
      child: IconButton(
        color: widget.isExpanded ? widget.color : widget.color.withOpacity(0.3),
        disabledColor: widget.disabledColor,
        onPressed: widget.onPressed == null ? null : _handlePressed,
        icon: widget.isExpanded
            ? Icon(Icons.check_circle)
            : Icon(Icons.radio_button_unchecked),
      ),
    );
  }
}

class PaymentBody extends StatefulWidget {
  final int index;
  final int openIndex;
  final Widget body;
  PaymentBody({this.body, this.index, this.openIndex});
  @override
  _PaymentBodyState createState() => _PaymentBodyState();
}

class _PaymentBodyState extends State<PaymentBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimatedCrossFade(
        firstChild: Container(
          height: 0,
        ),
        secondChild: Container(
          // padding: EdgeInsets.symmetric(vertical: widget.body==null?0:10),
          // color: Colors.white,
          child: widget.body,
        ),
        firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
        secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
        sizeCurve: Curves.fastOutSlowIn,
        crossFadeState: widget.index == widget.openIndex
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: Duration(milliseconds: 100),
      ),
    );
  }
}

class PaymentHeader extends StatefulWidget {
  int index;
  String title;
  String imageUrl;
  PaymentHeader(this.title, this.imageUrl, this.index);
  @override
  _PaymentHeaderState createState() => _PaymentHeaderState();
}

class _PaymentHeaderState extends State<PaymentHeader> {
  @override
  Widget build(BuildContext context) {
    PaymentSelection provider = Provider.of<PaymentSelection>(context);    
    return InkWell(
      child: Container(
        child: Row(
          children: <Widget>[
            MyCustomExpandIcon(
              isExpanded: provider.openIndex == widget.index,
              onPressed: (bool value) {
                // if (provider.openIndex != widget.index) {
                //   provider.setIndex(widget.index,checkoutProcessStateModel);
                // }
              },
            ),
            Expanded(
              flex: 3,
              child: Text(
                Language.getCheckoutStrings("payment_methods.${widget.title}"),
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: AppStyle.fontSizeCheckoutEditTextContent(),
                  color: AppStyle.colorCheckoutDivider(),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                height: 25,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        PaymentSelection provider = Provider.of<PaymentSelection>(context);
        if (provider.openIndex != widget.index) {
          provider.setIndex(widget.index,Provider.of<CheckoutProcessStateModel>(context));
        }
      },
    );
  }
}

class PaymentSelection extends ChangeNotifier {
  int _openIndex = 0;
  int get openIndex => _openIndex;
  setIndex(int nopenIndex,CheckoutProcessStateModel checkoutProcessStateModel) {
    _openIndex = nopenIndex;
    checkoutProcessStateModel.setPaymentActionText(_openIndex);
    notifyListeners();
  }
}
