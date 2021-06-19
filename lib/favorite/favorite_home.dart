import 'package:flutter/material.dart';
import 'package:stock_analysis/favoriteList.dart';
import 'package:stock_analysis/company_id.dart';
import 'package:stock_analysis/individual/individual_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:stock_analysis/service/loading.dart';

class FavoriteHome extends StatefulWidget {

  @override
  _FavoriteHomeState createState() => _FavoriteHomeState();
}

class _FavoriteHomeState extends State<FavoriteHome> {
  List data = [];
  bool _isready = false;

  Color getnumcolor(num t){
    if(t >= 0 ){
      return Color(0xffD0104C);
    }else{
      return Color(0xff90B44B);
    }
  }

  IconData geticon(String id){
    if(favoriteList.contains(id)){
      return Icons.remove_rounded;
    }else{
      return Icons.add_rounded;
    }
  }

  Color getcolor(String id, bool _isicon){
    if(favoriteList.contains(id)){
      if(_isicon){
        return Color(0xff49608A);
      }else{
        return Color(0xfffcfaf2);
      }
    }else{
      if(_isicon){
        return Color(0xfffcfaf2);
      }else{
        return Color(0xff49608A);
      }
    }
  }

  List<SizedBox> getList(){
    List<SizedBox> result = [];
    data.forEach((e){
        result.add(SizedBox(
          height: 71,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 1,
                  child: Container(
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(
                  height: 9,
                ),
                ListTile(
                  leading: SizedBox(
                    width: 70,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          e["id"],
                          style: TextStyle(
                            color: Color(0xff77428d),
                            fontSize: 22,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          e["name"],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18
                          ),
                        ),
                      ],
                    ),
                  ),
                  title: SizedBox(
                    width: 190,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          child: Center(
                            child: Text(
                              e["close"].toString(),
                              style: TextStyle(
                                color: getnumcolor(e["change_rate"]),
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 30),
                        SizedBox(
                          width: 80,
                          child: Center(
                            child: Row(
                              children: [
                                Text(
                                  '${e["change_rate"].toString()}%',
                                  style: TextStyle(
                                    color: getnumcolor(e["change_rate"]),
                                    fontSize: 22,
                                  ),
                                ),
                                Icon(
                                  e['change_rate'] >= 0 ? CupertinoIcons.arrowtriangle_up_fill : CupertinoIcons.arrowtriangle_down_fill,
                                  size: 19,
                                  color: getnumcolor(e['change_rate']),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: ElevatedButton(
                    onPressed: (){
                      setState(() {
                        favoriteList.remove(e["id"]);              
                      });
                    },
                    child: Icon(
                      geticon(e["id"]),
                      color:  getcolor(e["id"], true),
                      size: 28,
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(), 
                      side: BorderSide(
                        width: 2.0,
                        color:  Color(0xff49608A),
                      ),
                      primary: getcolor(e["id"], false),
                    ),
                  ),
                  onTap: (){
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => IndividualHome(id: e["id"], name: e["name"])
                      )
                    );
                  },
                ),
              ],
            ),
          ),
        ));
      }
    );
    return result;
  }

  Future<void> getdata(List list) async{
    try {
      Dio dio = Dio();
      var response = await dio.post('http://10.0.2.2:5000/dailyrate', data: jsonEncode(list));
      final t =  json.decode(response.data);
      setState(() {
        data = t;
        _isready = true;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState(){
    super.initState();
    getdata(favoriteList);
    _isready = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('自選組合'),
        centerTitle: true,
        backgroundColor: Color(0xff77428d),
      ),
      body: _isready == false
      ? Loading()
      : Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                children: [
                  Text(
                    '股名',
                    style: TextStyle(
                      fontSize: 21,
                    ),
                  ),
                  SizedBox(width: 45),
                  Text(
                    '收盤價',
                    style: TextStyle(
                      fontSize: 21,
                    ),
                  ),
                  SizedBox(width: 35),
                  Text(
                    '漲跌幅',
                    style: TextStyle(
                      fontSize: 21,
                    ),
                  )
                ]
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: getList(),
            ),
          ),
        ],
      ),
    );
  }
}