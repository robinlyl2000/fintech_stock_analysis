import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stock_analysis/individual/days.dart';
import 'package:stock_analysis/individual/weeks.dart';
import 'package:stock_analysis/individual/months.dart';
import 'package:stock_analysis/service/model.dart';
import 'package:intl/intl.dart';

class CandlestickHome extends StatefulWidget {
  final String id;
  final Map data;
  CandlestickHome({this.id, this.data});
  @override
  _CandlestickHomeState createState() => _CandlestickHomeState();
}

class _CandlestickHomeState extends State<CandlestickHome> {
  List<bool> isSelected = [true, false, false];

  ChartSampleData _showdata =ChartSampleData(
    x : DateTime.now(),
    open: 1.0,
    high: 1.0,
    low: 1.0,
    close: 1.0,
    volume: 1.0,
    id: 1,
    change: 1.0,
  );

  Color getcolor(double num){
    if(num < 0){
      return Color(0xff90B44B);
    }
    return Color(0xffD0104C);
  }

  List cleanlist(List list){
    int temp = list.length - 39;
    list = list.where((e) => e['id'] >= temp).toList();
    return list;
  }

  void callback(int input, String unit){
    List cleaned = cleanlist(widget.data[unit]);
    int id = cleaned.first['id'].toInt() + input;
    var e = cleaned.firstWhere((e) => e['id'].toInt() == id);
    String datetime = e['date'].substring(0,10);
    ChartSampleData t = ChartSampleData(
      x : DateFormat("yyyy-MM-dd").parse(datetime),
      open: e['open'].toDouble(),
      high: e['high'].toDouble(),
      low: e['low'].toDouble(),
      close: e['close'].toDouble(),
      volume: e['volume'].toDouble(),
      id: e['id'].toInt(),
      change: e['change'].toDouble(),
      ma5: e['ma5'].toDouble() ?? 0.0,
      ma10: e['ma10'].toDouble() ?? 0.0,
      ma20: e['ma20'].toDouble() ?? 0.0,
    );
    setState(() {
      _showdata = t;
    });
  }

  ChartSampleData _search(List list){
    var e = list.last;
        String datetime = e['date'].substring(0,10);
        ChartSampleData result = ChartSampleData(
          x : DateFormat("yyyy-MM-dd").parse(datetime),
          open: e['open'].toDouble() ?? 0.0,
          high: e['high'].toDouble() ?? 0.0,
          low: e['low'].toDouble() ?? 0.0,
          close: e['close'].toDouble() ?? 0.0,
          volume: e['volume'].toDouble() ?? 0.0,
          id: e['id'].toInt() ?? 0,
          change: e['change'].toDouble() ?? 0.0,
          ma5: e['ma5'].toDouble() ?? 0.0,
          ma10: e['ma10'].toDouble() ?? 0.0,
          ma20: e['ma20'].toDouble() ?? 0.0,
          volma5: e['volma5'].toDouble() ?? 0.0,
          volma10: e['volma10'].toDouble() ?? 0.0,
        );
        return result;
  }

  Widget checkselection(){
    if(isSelected[0]){ //日K
      return Days(data: widget.data['days'], callback: callback);
    }
    if(isSelected[1]){ //日K
      return Weeks(data: widget.data['weeks'], callback: callback);
    }
    return Months(data: widget.data['months'], callback: callback);
  }

  @override
  void initState(){
    super.initState();
    setState(() {
      isSelected = [true, false, false];
      _showdata = _search(widget.data['days']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
          SizedBox(
            height: 100,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 25,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        DateFormat("yyyy/MM/dd").format(_showdata.x),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700]
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '開 ${_showdata.open.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          '高 ${_showdata.high.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          '低 ${_showdata.low.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '收 ${_showdata.close.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          '量 ${_showdata.volume.toInt().toString()}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          '漲跌 ${_showdata.change.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text: 'MA5 ',
                                style: TextStyle(
                                  color: Color(0xff005CAF),
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              TextSpan(
                                text: _showdata.ma5.toStringAsFixed(2),
                              )
                            ]
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text: 'MA10 ',
                                style: TextStyle(
                                  color: Color(0xffED784A),
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              TextSpan(
                                text: _showdata.ma10.toStringAsFixed(2),
                              )
                            ]
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text: 'MA20 ',
                                style: TextStyle(
                                  color: Color(0xffE87A90),
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              TextSpan(
                                text: _showdata.ma20.toStringAsFixed(2),
                              )
                            ]
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ToggleButtons(
              borderWidth: 2,
              color: Color(0xff77428d),
              selectedColor: Color(0xfffcfaf2),
              selectedBorderColor: Color(0xff77428d),
              fillColor: Color(0xff77428d),
              disabledBorderColor   : Color(0xff77428d),
              constraints: BoxConstraints(minHeight: 30.0),
              isSelected: isSelected,
              onPressed: (index) {
                  setState(() {
                    for(int i = 0; i < 3; i++){
                      if (i == index) {
                        isSelected[i] = true;
                      } else {
                        isSelected[i] = false;
                      }
                    }
                  });
              },
              children: [
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        '日K',
                        style: TextStyle(
                          fontSize: 16
                        ),
                      ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        '週K',
                        style: TextStyle(
                          fontSize: 16
                        ),
                      ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        '月K',
                        style: TextStyle(
                          fontSize: 16
                        ),
                      ),
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 300,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: checkselection(),
            ),
          ),
          SizedBox(
            height: 50,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: TableBorder.all(
                    color: Color(0xff8F77B5).withOpacity(0.7),
                    width: 2
                  ),
                  children: [
                    TableRow(
                      children: [
                        SizedBox(
                          height: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                                child: Text(
                                  '當日',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[700]
                                  ),
                                ),
                              ),
                              SizedBox(height: 2),
                              SizedBox(
                                height: 20,
                                child: Text(
                                  '${widget.data["change"]["today"].toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: getcolor(widget.data["change"]["today"])
                                  ),
                                ),
                              ),
                            ],
                          )
                        ),
                        SizedBox(
                          height: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                                child: Text(
                                  '一個月',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[700]
                                  ),
                                ),
                              ),
                              SizedBox(height: 2),
                              SizedBox(
                                height: 20,
                                child: Text(
                                  '${widget.data["change"]["one"].toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: getcolor(widget.data["change"]["one"])
                                  ),
                                ),
                              ),
                            ],
                          )
                        ),
                        SizedBox(
                          height: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                                child: Text(
                                  '三個月',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[700]
                                  ),
                                ),
                              ),
                              SizedBox(height: 2),
                              SizedBox(
                                height: 20,
                                child: Text(
                                  '${widget.data["change"]["three"].toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: getcolor(widget.data["change"]["three"])
                                  ),
                                ),
                              ),
                            ],
                          )
                        ),
                        SizedBox(
                          height: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                                child: Text(
                                  '六個月',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[700]
                                  ),
                                ),
                              ),
                              SizedBox(height: 2),
                              SizedBox(
                                height: 20,
                                child: Text(
                                  '${widget.data["change"]["six"].toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: getcolor(widget.data["change"]["six"])
                                  ),
                                ),
                              ),
                            ],
                          )
                        ),
                      ]
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
    );
  }
}
