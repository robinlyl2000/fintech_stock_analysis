import 'package:flutter/material.dart';
import 'package:stock_analysis/individual/report/balance.dart';
import 'package:stock_analysis/individual/report/income.dart';
import 'package:dio/dio.dart';
import 'package:stock_analysis/individual/report/money.dart';
import 'dart:convert';
import 'package:stock_analysis/service/loading.dart';

class ReportHome extends StatefulWidget {
  final String id;
  ReportHome({this.id});
  @override
  _ReportHomeState createState() => _ReportHomeState();
}

class _ReportHomeState extends State<ReportHome> with SingleTickerProviderStateMixin{
  Map data = {};
  TabController _tabController;
  int _activeTabIndex = 0;
  bool _isready = false;
  double getheight(){
    if(_activeTabIndex == 0){
      return 500;
    }else if(_activeTabIndex == 1){
      return 730;
    }
    return 730;
  }

  Future<void> getdata(String id) async{
    try {
      Dio dio = Dio();
      final response = await dio.get('http://10.0.2.2:5000/stock_info/$id');
      setState(() {
        data = json.decode(response.data);
      });
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      _isready = true;      
    });
  }


  @override
  void initState(){
    super.initState();
    getdata(widget.id);
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_setActiveTabIndex);
  }

  void _setActiveTabIndex() {
    setState(() {
      _activeTabIndex = _tabController.index;
    });
  }

  @override  Widget build(BuildContext context) {
    return _isready == false
    ? Loading()
    : SizedBox(
      height: getheight(),
      child: Column(
        children: [
          SizedBox(
            height: 30,
            child: Container(
              color: Color(0xff3A8FB7).withOpacity(0.65),
              child: TabBar(
                controller: _tabController,
                unselectedLabelColor: Color(0xfffcfaf2),
                labelColor: Color(0xff08192D),
                indicatorColor: Color(0xff08192D),
                labelStyle: TextStyle(
                  fontSize: 16
                ),
                tabs: [
                  Tab(
                    child: Text(
                      '損益表',
                    ),
                  ),
                  Tab(text: '資產負債表'),
                  Tab(text: '現金流量表')
                ],
              ),
            ),
          ),
          Flexible(
            child: TabBarView(
              controller: _tabController,
              children: [
                Income(id: widget.id, data: data),
                Balance(id: widget.id, data: data),
                Money(id: widget.id, data: data),
              ],
            )
          )
        ],
      ),
    );
  }
}