import 'package:flutter/material.dart';
import 'package:payever/commons/utils/app_style.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:provider/provider.dart';

import '../../checkout_process.dart';

class CheckoutStepper extends StatelessWidget {
  final List<Widget> bodies;
  final List<String> headers;
  CheckoutProcessStateModel checkoutProcessStateModel;
  CheckoutStepper({@required this.headers, @required this.bodies,this.checkoutProcessStateModel});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StepperController>(
      builder: (BuildContext context) {
        StepperController stepperController = StepperController();
        stepperController.setIndex(0,checkoutProcessStateModel);
        return stepperController;
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ListView.builder(
          itemCount: bodies.length,
          itemBuilder: (BuildContext context, int index) {
            return CheckoutSectionStep(
              headers[index],
              bodies[index],
              index,
              () {},
            );
          },
        ),
      ),
    );
  }
}

class CheckoutSectionStep extends StatefulWidget {
  final int index;
  final Widget _body;
  final String _headerTitle;
  final String headerMiddle;
  final VoidCallback action;
  CheckoutSectionStep(this._headerTitle, this._body, this.index, this.action,
      {this.headerMiddle = ""});
  @override
  _CheckoutSectionStepState createState() => _CheckoutSectionStepState();
}

class _CheckoutSectionStepState extends State<CheckoutSectionStep> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    StepperController controller = Provider.of<StepperController>(context);
    CheckoutProcessStateModel checkoutProcessStateModel =
        Provider.of<CheckoutProcessStateModel>(context);
    Provider.of<CheckoutProcessStateModel>(context)
        .setTabController(controller);
    return Container(
      child: Column(
        children: <Widget>[
          Header(widget._headerTitle, widget.index,checkoutProcessStateModel, mid: widget.headerMiddle),
          CustomBody(
            body: Body(
              widget._body,
              () {},
              secondButtom: widget._headerTitle == "send_to_device",
            ),
            index: widget.index,
            openIndex: controller._openIndex,
          ),
          Divider(
            height: 1,
            color: AppStyle.colorCheckoutDivider(),
          ),
        ],
      ),
    );
  }
}

class Header extends StatefulWidget {
  int index;
  final String title;
  final String mid;
  CheckoutProcessStateModel checkoutProcessStateModel;
  Header(this.title, this.index, this.checkoutProcessStateModel,{this.mid});
  
  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    StepperController controller = Provider.of<StepperController>(context);
    return InkWell(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          vertical: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Text(
                Language.getCheckoutStrings(
                        "layout.panel.${widget.title}.title")
                    .toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: AppStyle.fontSizeCheckoutTitle(),
                  color: AppStyle.colorCheckoutDivider(),
                ),
              ),
            ),
            (widget.index > controller.openIndex)
                ? Expanded(
                    flex: 2,
                    child: Text(
                      Language.getCheckoutStrings(
                        "layout.panel.${widget.title}.description",
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: AppStyle.fontSizeCheckoutTitle(),
                        color: AppStyle.colorCheckoutDivider(),
                      ),
                    ),
                  )
                : (widget.index != controller.openIndex)?Expanded(
                    flex: 2,
                    child: Text(
                      widget.checkoutProcessStateModel.getHeaderString(widget.title, widget.checkoutProcessStateModel.checkoutUser),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: AppStyle.fontSizeCheckoutTitle(),
                        color: AppStyle.colorCheckoutDivider(),
                      ),
                    ),
                  ):Container(),
            widget.index > controller.openIndex
                ? Container(
                    width: 24,
                  )
                : CustomExpandIcon(
                    isExpanded: widget.index == controller.openIndex,
                    onPressed: (bool value) {},
                  ),
          ],
        ),
      ),
      onTap: () {
        if (widget.index < controller.openIndex) {
          controller.setIndex(widget.index,widget.checkoutProcessStateModel);
        }
      },
    );
  }
}

class Body extends StatefulWidget {
  final Widget _section;
  VoidCallback sectionAction;
  bool secondButtom = false;
  Body(this._section, this.sectionAction, {this.secondButtom});
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: widget._section,
          ),
        ],
      ),
    );
  }
}

class CustomExpandIcon extends StatefulWidget {
  const CustomExpandIcon({
    Key key,
    this.isExpanded = false,
    this.size = 24.0,
    @required this.onPressed,
    this.padding = const EdgeInsets.all(8.0),
    this.color,
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
  createState() => _CustomExpandIconState();
}

class _CustomExpandIconState extends State<CustomExpandIcon>
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
  void didUpdateWidget(CustomExpandIcon oldWidget) {
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
      child: Icon(
        !widget.isExpanded
            ? Icons.keyboard_arrow_down
            : Icons.keyboard_arrow_up,
        color: AppStyle.colorCheckoutDivider(),
        size: widget.size,
      ),
    );
  }
}

class CustomBody extends StatefulWidget {
  final int index;
  final int openIndex;
  final Widget body;
  CustomBody({this.body, this.index, this.openIndex});
  @override
  _CustomBodyState createState() => _CustomBodyState();
}

class _CustomBodyState extends State<CustomBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimatedCrossFade(
        firstChild: Container(
          height: 0,
        ),
        secondChild: Container(
          color: Colors.white,
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

class StepperController extends ChangeNotifier {
  int _openIndex = 0;
  int get openIndex => _openIndex;

  setIndex(int nopenIndex,CheckoutProcessStateModel checkoutProcessStateModel) {
    _openIndex = nopenIndex;
    notifyListeners();
    if(openIndex>0)checkoutProcessStateModel.notifyListeners();
  }
  
}
