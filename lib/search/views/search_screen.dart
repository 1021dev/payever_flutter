import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/search/search_bloc.dart';
import 'package:payever/blocs/search/search_event.dart';
import 'package:payever/commons/utils/utils.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/blur_effect_view.dart';
import 'package:payever/commons/views/screens/login/login_page.dart';
import 'package:payever/search/widgets/search_result_business_view.dart';
import 'package:payever/search/widgets/search_result_transaction_view.dart';

bool _isPortrait;
bool _isTablet;

class SearchScreen extends StatefulWidget {
  final String businessId;
  final String searchQuery;

  SearchScreen({
    this.businessId,
    this.searchQuery,
  });

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  SearchScreenBloc screenBloc = SearchScreenBloc();
  TextEditingController searchController = TextEditingController();
  String searchString = '';

  @override
  void initState() {
    if (widget.searchQuery != '') {
      searchString = widget.searchQuery;
      searchController.text = widget.searchQuery;
      screenBloc.add(SearchEvent(businessId: widget.businessId, key: widget.searchQuery));
    }
    super.initState();
  }

  @override
  void dispose() {
    screenBloc.close();
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

    return BlocListener(
      bloc: screenBloc,
      listener: (BuildContext context, SearchScreenState state) async {
        if (state is PosScreenFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<SearchScreenBloc, SearchScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, SearchScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _body(SearchScreenState state) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: BackgroundBase(
          true,
          body: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topRight,
                padding: EdgeInsets.only(top: 16, right: 16),
                child: IconButton(
                  constraints: BoxConstraints(
                      maxHeight: 32,
                      maxWidth: 32,
                      minHeight: 32,
                      minWidth: 32
                  ),
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              _searchBar(state),
              Expanded(
                child: _searchResultLsit(state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchBar(SearchScreenState state) {
    return Padding(
      padding: EdgeInsets.only(
        top: 44,
        left: 16,
        right: 16,
      ),
      child: BlurEffectView(
        radius: 12,
        color: Color.fromRGBO(100, 100, 100, 0.2),
        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Container(
          height: 40,
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          isDense: true,
                          border: InputBorder.none,
                          hintText: 'Search',
                          hintStyle: TextStyle(
                              color: Colors.white
                          ),
                        ),
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white
                        ),
                        onChanged: (val) {
                          searchString = val;
                          Future.delayed(
                              Duration(milliseconds: 300))
                              .then((value) async {
                            if (!state.isLoading) {
                              screenBloc.add(SearchEvent(businessId: widget.businessId, key: searchString));
                            }
                          }
                          );
                        },
                        onSubmitted: (val) {
                          screenBloc.add(SearchEvent(businessId: widget.businessId, key: searchString));
                        },
                      ),
                    ),
                    state.isLoading ?
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: CircularProgressIndicator(),
                        ),
                    ) : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchResultLsit(SearchScreenState state) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            state.searchBusinesses.length > 0 ?
            BlurEffectView(
              blur: 1,
              color: Colors.transparent,
              radius: 12,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 36,
                    padding: EdgeInsets.only(left: 8),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Business',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  BlurEffectView(
                    blur: 15,
                    color: Color.fromRGBO(50, 50, 50, 0.2),
                    radius: 0,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return SearchResultBusinessView(
                          business: state.searchBusinesses[index],
                        );
                      },
                      separatorBuilder: (ctx, index) {
                        return Divider(height: 0, thickness: 1,);
                      },
                      itemCount: state.searchBusinesses.length,
                    ),
                  ),
                ],
              ),
            ): Container(),
            state.searchTransactions.length > 0 ?
            BlurEffectView(
              blur: 1,
              color: Colors.transparent,
              radius: 12,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 36,
                    padding: EdgeInsets.only(left: 8),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Transactions',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  BlurEffectView(
                    blur: 15,
                    color: Color.fromRGBO(50, 50, 50, 0.2),
                    radius: 0,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return SearchResultTransactionView(
                          collection: state.searchTransactions[index],
                        );
                      },
                      separatorBuilder: (ctx, index) {
                        return Divider(height: 0, thickness: 1,);
                      },
                      itemCount: state.searchTransactions.length,
                    ),
                  ),
                ],
              ),
            ): Container(),
          ],
        ),
      ),
    );
  }
}