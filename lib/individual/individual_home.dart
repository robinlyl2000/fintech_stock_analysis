import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:stock_analysis/individual/candlestick_home.dart';
import 'package:stock_analysis/individual/fundamental.dart';
import 'package:stock_analysis/individual/rate/ratehome.dart';
import 'package:stock_analysis/individual/report/reporthome.dart';
import 'package:stock_analysis/service/loading.dart';

class IndividualHome extends StatefulWidget {
  final String id;
  final String name;
  IndividualHome({this.id, this.name});
  @override
  _IndividualHomeState createState() => _IndividualHomeState();
}

class _IndividualHomeState extends State<IndividualHome> with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool _isready = false;
  Map dailydata = {};
  Map fundamental = {};
  int _activeTabIndex = 0;
  Map basic = {
    'high' : 0.0,
    'low' : 0.0,
    'open' : 0.0,
    'close' : 0.0,
    'volume' : 0.0,
    'lastday' : 0.0,
    'change' : 0.0,
    'change_rate' : 0.0
  };

  Color getcolor(double num){
    if(num < 0){
      return Color(0xff90B44B);
    }
    return Color(0xffD0104C);
  }


  Future<void> getfundamental(String id) async{
    try {
      Dio dio = Dio();
      var response = await dio.get('http://10.0.2.2:5000/company_info/$id');
      setState(() {
        fundamental = json.decode(response.data);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> setbasic() async{
    List list = dailydata['days'];
    DateTime current = DateFormat("yyyy-MM-dd").parse("2021-06-01");
    int tempid = 0;
    list.forEach((detail) {
      String datetime = detail['date'].substring(0,10);
      DateTime temp = DateFormat("yyyy-MM-dd").parse(datetime);
      if(temp.isAfter(current)){
        setState(() {
          basic['high'] = detail['high'] != null ? detail['high'].toDouble() : 0;
          basic['low'] = detail['low'] != null ? detail['low'].toDouble() : 0;
          basic['open'] =  detail['open'] != null ? detail['open'].toDouble() : 0;
          basic['close'] = detail['close'] != null ? detail['close'].toDouble() : 0;
          basic['volume'] =  detail['volume'] != null ? detail['volume'].toDouble() : 0; 
          basic['change'] =  detail['change'] != null ? detail['change'].toDouble() : 0;
          basic['change_rate'] =  detail['change_rate'] != null ? detail['change_rate'].toDouble() : 0;
          tempid = detail['id'] - 1;
        });
        current = temp;
      }
    });
    list.forEach((detail) {
      if(detail['id'] == tempid){
        setState(() {
          basic['lastday'] = detail['close'] != null ? detail['close'].toDouble() : 0;       
        });
      }
    });
    setState(() {
      _isready = true;      
    });
  }

  Future<void> getdailydata(String id) async{
    try {
      Dio dio = Dio();
      var response = await dio.get('http://10.0.2.2:5000/dailydata/$id');
      setState(() {
        dailydata = json.decode(response.data);
      });
      await setbasic();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> setalldata() async{
    await getdailydata(widget.id);
    await getfundamental(widget.id);
  }

  double getheight(){
    if(_activeTabIndex == 0){
      return 565;
    }else if(_activeTabIndex == 1){
      return 500;
    }
    return 700;
  }

  @override
  void initState(){
    super.initState();
    setalldata();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_setActiveTabIndex);
  }

  void _setActiveTabIndex() {
    setState(() {
      _activeTabIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffcfaf2),
      appBar: AppBar(
        title: Text('${widget.name}  ${widget.id}'),
        centerTitle: true,
        backgroundColor: Color(0xff77428d),
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: 90),
        child: _isready == false
        ? Loading()
        : Scrollbar(
          thickness: 6,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 130,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 20,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  basic['close'].toStringAsFixed(2),
                                  style: TextStyle(
                                    color: _isready ? Colors.purple : Colors.white,
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                                Text(
                                  "${fundamental['上市/上櫃']} — ${fundamental['產業別']}",
                                  style: TextStyle(
                                    fontSize: 16,
                                  )
                                ),
                                SizedBox(height: 10),
                                Flexible(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        basic['change'] >= 0 ? basic['change'].toStringAsFixed(2) : (basic['change']*(-1)).toStringAsFixed(2),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19,
                                          color: getcolor(basic['change'])
                                        )
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "${basic['change_rate'].toStringAsFixed(2)}%",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19,
                                          color: getcolor(basic['change_rate'])
                                        )
                                      ),
                                      Icon(
                                        basic['change_rate'] >= 0 ? CupertinoIcons.arrowtriangle_up_fill : CupertinoIcons.arrowtriangle_down_fill,
                                        size: 19,
                                        color: getcolor(basic['change_rate']),
                                      )

                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 25,
                          child:  Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        flex: 8,
                                        child: Text(
                                          '最高 ${basic['high'].toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 17
                                          ),
                                        ),
                                      ),
                                      Spacer(flex: 1),
                                      Flexible(
                                        flex: 8,
                                        child: Text(
                                          '開盤 ${basic['open'].toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 17
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        flex: 8,
                                        child: Text(
                                          '最低 ${basic['low'].toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 17
                                          ),
                                        ),
                                      ),
                                      Spacer(flex: 1),
                                      Flexible(
                                        flex: 8,
                                        child: Text(
                                          '昨收 ${basic['lastday'].toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 17
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        flex: 8,
                                        child: Text(
                                          '總量 ${basic['volume'].toInt().toString()}',
                                          style: TextStyle(
                                            fontSize: 17
                                          ),
                                        ),
                                      ),
                                      Spacer(flex: 9),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ),
                SizedBox(
                  height: getheight(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 45,
                        child: Container(
                          color: Color(0xff8F77B5).withOpacity(0.7),
                          child: TabBar(
                            controller: _tabController,
                            unselectedLabelColor: Color(0xfffcfaf2),
                            labelColor: Color(0xff77428d),
                            indicatorColor: Color(0xff4a225d),
                            labelStyle: TextStyle(
                              fontSize: 20
                            ),
                            tabs: [
                              Tab(text: 'K線'),
                              Tab(text: '績效'),
                              Tab(text: '財報'),
                              Tab(text: '基本')
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            CandlestickHome(id: widget.id, data: dailydata),
                            RateHome(id: widget.id,),
                            ReportHome(id: widget.id),
                            Fundamental(id: widget.id, data: fundamental),
                          ],
                        )
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomSheet: SizedBox(
        height: 90,
        child: Container(
          color: Color(0xff4a225d),
          child: Row(
            children: [
              Spacer(flex: 10),
              SizedBox(
                width: 120,
                child:Column(
                  children: [
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(120.0,70.0),
                        elevation: 0,
                        primary: Color(0xff4a225d)
                      ),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 40,
                            child: FittedBox(
                              child: Icon(
                                Icons.home_rounded,
                                color: Color(0xfffcfaf2),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                            child: FittedBox(
                              child: Text(
                                '回到首頁',
                                style: TextStyle(
                                  color: Color(0xfffcfaf2),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Spacer(flex: 13),
              SizedBox(
                width: 120,
                child:Column(
                  children: [
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(120.0,70.0),
                        elevation: 0,
                        primary: Color(0xff4a225d)
                      ),
                      onPressed: (){},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 40,
                            child: FittedBox(
                              child: Icon(
                                Icons.view_list_rounded,
                                color: Color(0xfffcfaf2),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                            child: FittedBox(
                              child: Text(
                                '自選清單',
                                style: TextStyle(
                                  color: Color(0xfffcfaf2),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Spacer(flex: 10),
            ],
          ),
        ),
      ),
    );
  }
}