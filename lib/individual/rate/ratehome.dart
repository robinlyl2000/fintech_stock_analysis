import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:stock_analysis/service/loading.dart';

class RateHome extends StatefulWidget {
  final String id;
  RateHome({this.id});
  @override
  _RateHomeState createState() => _RateHomeState();
}

class _RateHomeState extends State<RateHome> {
  Map data = {
    "gross_margnin": "",
    "profit_rate": "",
    "net_interest_rate": "",
    "shareholders_equity": "",
    "earning_after_tax": "",
    "management_capacity": "",
    "solvency": "",
    "quarter": ""
  };
  bool _isready = false;

  Future<void> getdata(String id) async{
    try {
      Dio dio = Dio();
      var response = await dio.get('http://10.0.2.2:5000/rate_info/$id');
      Map t = json.decode(response.data);
      setState(() {
        data["gross_margnin"] = t["profitability"]["gross_margnin"];
        data["profit_rate"] = t["profitability"]["profit_rate"];
        data["net_interest_rate"] = t["profitability"]["net_interest_rate"];
        data["shareholders_equity"] = t["profitability"]["shareholders_equity"];
        data["earning_after_tax"] = t["profitability"]["earning_after_tax"];
        data["management_capacity"] = t["management_capacity"];
        data["solvency"] = t["solvency"];
        data["quarter"] = t["quarter"];
      });
    } catch (e) {
      print(e.toString());
    }
    _isready = true;
  }

  @override
  void initState(){
    super.initState();
    getdata(widget.id);
  }


  @override
  Widget build(BuildContext context) {
    return _isready == false
    ? Loading()
    : Column(
      children: [
        SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 160,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[700]),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '最新一季',
                        style: TextStyle(
                          fontSize: 18
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        data["quarter"],
                        style: TextStyle(
                          fontSize: 18
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              SizedBox(
                width: 160,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[700]),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '資產季成長率',
                        style: TextStyle(
                          fontSize: 18
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        '${data["management_capacity"]}%',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xffD0104C)
                        ),
                      )
                    ],
                  ),
                ),
              ),
              
            ],
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 160,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[700]),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '營業毛利率',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        '${data["gross_margnin"]}%',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xffD0104C)
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              SizedBox(
                width: 160,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[700]),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '營業利益率',
                        style: TextStyle(
                          fontSize: 18
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        '${data["profit_rate"]}%',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xffD0104C)
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 160,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[700]),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '稅後毛利率',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        data["net_interest_rate"],
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xffD0104C)
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              SizedBox(
                width: 160,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[700]),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '負債比率',
                        style: TextStyle(
                          fontSize: 18
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        '${data["solvency"]}%',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 160,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[700]),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ROE',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        '${data["shareholders_equity"]}%',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xffD0104C)
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              SizedBox(
                width: 160,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[700]),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'EPS',
                        style: TextStyle(
                          fontSize: 18
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        '${data["earning_after_tax"]}元',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xffD0104C)
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}