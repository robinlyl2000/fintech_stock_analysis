import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Money extends StatefulWidget {
  final String id;
  final Map data;
  Money({this.id, this.data});
  @override
  _MoneyState createState() => _MoneyState();
}

class _MoneyState extends State<Money> {

  List<LineChartData> _chartdata = [];
  List<TableRow> _tablerow = [];
  List<bool> isSelected = [true, false];

  String cleannumber(String input){
    String result = '';
    final t = input.split(',');
    t.forEach((m) {
      result += m;
    });
    String temp = (double.parse(result)/1000.0).toStringAsFixed(0);
    return temp;
  }

  String specialset(String str){
    String result = '';
    final t = str.split(',');
    t.forEach((m) {
      result += m;
    });
    String temp = (double.parse(result)/1000.0).toStringAsFixed(0);
    if(int.parse(temp) >= 0){
      return temp.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    }else{
      final m = temp.split('-');
      m[1] = m[1].replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
      return '-${m[1]}';
    }
  }

  String specialset02(String str){
    String result = '';
    final t = str.split(',');
    t.forEach((m) {
      result += m;
    });
    String temp = (double.parse(result)/1000.0).toStringAsFixed(0);
    if(int.parse(temp) >= 0){
      return temp.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    }else{
      final m = temp.split('-');
      return m[1].replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    }
  }

  void _settablerow(){
    _tablerow.add(TableRow(
      children: <Widget>[
        SizedBox(
          height: 30,
          child: Center(
            child: Text(
              '季別',
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
          )
        ),
        SizedBox(
          height: 30,
          child: Center(
            child: Text(
              '淨現金流',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff005CAF),
              ),
            ),
          )
        ),
        SizedBox(
          height: 30,
          child: Center(
            child: Text(
              '營業活動',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xffED784A),
              ),
            ),
          )
        ),
        SizedBox(
          height: 30,
          child: Center(
            child: Text(
              '投資活動',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff90B44B),
              ),
            ),
          )
        ),
        SizedBox(
          height: 30,
          child: Center(
            child: Text(
              '融資活動',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xffD0104C),
              ),
            ),
          )
        ),
      ],
    ));
    List<TableRow> temp = widget.data.entries.map((e){
      final key = e.key.toString();
      Map t = e.value["money_flow"];
      return TableRow(
        children: <Widget>[
          SizedBox(
            height: 30,
            child: Center(
              child: Text(
                '${key.substring(5,6)}Q${key.substring(2,4)}'
              ),
            ),
          ),
          SizedBox(
            height: 27,
            child: Center(
              child: Text(
                specialset(t["EEEE"])
              ),
            ),
          ),
          SizedBox(
            height: 27,
            child: Center(
              child: Text(
                specialset(t["AAAA"])
              ),
            ),
          ),
          SizedBox(
            height: 27,
            child: Center(
              child: Text(
                specialset(t["BBBB"])
              ),
            ),
          ),
          SizedBox(
            height: 27,
            child: Center(
              child: Text(
                specialset(t["CCCC"])
              ),
            ),
          ),
        ],
      );
    }).toList();
    _tablerow.addAll(temp);
  }

  List<LineChartData> _setuplist(){
    List<LineChartData> result = [];
    widget.data.entries.forEach((e){
      final quarter = e.key.toString();
      final t = e.value["money_flow"];
      result.add(LineChartData(
        quarter: quarter,
        E: int.parse(cleannumber(t["EEEE"])),
        A: int.parse(cleannumber(t["AAAA"])),
        B: int.parse(cleannumber(t["BBBB"]))*-1,
        C: int.parse(cleannumber(t["CCCC"])),
      ));
    });
    return result;
  }

  void initState(){
    super.initState();
    setState(() {
      isSelected = [true, false];
    });
    _chartdata = _setuplist();
    _settablerow();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 180,
                  child: ToggleButtons(
                    borderWidth: 2,
                    color: Color(0xff08192D),
                    selectedColor: Color(0xfffcfaf2),
                    selectedBorderColor: Color(0xff08192D),
                    fillColor: Color(0xff08192D),
                    disabledBorderColor : Color(0xff08192D),
                    isSelected: isSelected,
                    onPressed: (index) {
                      setState(() {
                        for(int i = 0; i < 2; i++){
                          if (i == index) {
                            isSelected[i] = true;
                          } else {
                            isSelected[i] = false;
                          }
                        }
                      });
                    },
                    children: [
                      SizedBox(
                        width: 70,
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            '走勢圖',
                            style: TextStyle(
                              fontSize: 14
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 70,
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            '資料表',
                            style: TextStyle(
                              fontSize: 14
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '(單位 : 百萬)'
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        isSelected[0] ? chart() : form(),
      ],
    );
  }

  Widget chart(){
    return SizedBox(
      height: 250,
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(
                isInversed: true
              ) ,
              primaryYAxis: NumericAxis(
                rangePadding: ChartRangePadding.round,
                labelFormat: '{value}萬'
              ),
              series: <CartesianSeries>[
                LineSeries<LineChartData, String>(
                  dataSource: _chartdata,
                  xValueMapper: (LineChartData sales, _) => sales.quarter,
                  yValueMapper: (LineChartData sales, _) => sales.E/10000,
                  color: Color(0xff005CAF),
                  width: 2,
                  markerSettings: MarkerSettings(
                    isVisible: true,
                    shape: DataMarkerType.circle,
                    color: Color(0xff005CAF),
                    width: 5,
                    height: 5
                  )
                ),
                LineSeries<LineChartData, String>(
                  dataSource: _chartdata,
                  xValueMapper: (LineChartData sales, _) => sales.quarter,
                  yValueMapper: (LineChartData sales, _) => sales.A/10000,
                  color: Color(0xffED784A),
                  width: 2,
                  markerSettings: MarkerSettings(
                    isVisible: true,
                    shape: DataMarkerType.circle,
                    color: Color(0xffED784A),
                    width: 5,
                    height: 5
                  )
                ),
                LineSeries<LineChartData, String>(
                  dataSource: _chartdata,
                  xValueMapper: (LineChartData sales, _) => sales.quarter,
                  yValueMapper: (LineChartData sales, _) => sales.B/10000,
                  color: Color(0xff90B44B),
                  width: 2,
                  markerSettings: MarkerSettings(
                    isVisible: true,
                    shape: DataMarkerType.circle,
                    color: Color(0xff90B44B),
                    width: 5,
                    height: 5
                  )
                ),
                LineSeries<LineChartData, String>(
                  dataSource: _chartdata,
                  xValueMapper: (LineChartData sales, _) => sales.quarter,
                  yValueMapper: (LineChartData sales, _) => sales.C/10000,
                  color: Color(0xffD0104C),
                  width: 2,
                  markerSettings: MarkerSettings(
                    isVisible: true,
                    shape: DataMarkerType.circle,
                    color: Color(0xffD0104C),
                    width: 5,
                    height: 5
                  )
                )
              ],
            ),
          ),
          SizedBox(
            height: 50,
            child: Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Table(
                columnWidths: {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(1),
                  4: FlexColumnWidth(1),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                //設定表格樣式
                border: TableBorder.all(
                    color: Colors.black, width: 1.0),
                children: _tablerow
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget form(){
    return SizedBox(
      height: 500,
      child: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: Table(
          columnWidths: {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          //設定表格樣式
          border: TableBorder.all(
              color: Colors.black, width: 1.0),
          children: [
            TableRow(
              children: <Widget>[
                SizedBox(
                  height: 40,
                  child: Center(
                    child: Text(
                      '科目(絕對值)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14
                      ),
                    ),
                  )
                ),
                SizedBox(
                  height: 30,
                  child: Center(
                    child: Text(
                      '1Q21',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      ),
                    ),
                  )
                ),
                SizedBox(
                  height: 30,
                  child: Center(
                    child: Text(
                      '4Q20',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      ),
                    ),
                  )
                ),
                SizedBox(
                  height: 30,
                  child: Center(
                    child: Text(
                      '3Q20',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      ),
                    ),
                  )
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                SizedBox(
                  height: 55,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '期初現金及',
                          style: TextStyle(
                            fontSize: 17
                          ),
                        ),
                        Text(
                          '當約現金',
                          style: TextStyle(
                            fontSize: 17
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 27,
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        specialset02(widget.data["2021Q1"]["money_flow"]["E00100"]),
                        style: TextStyle(
                          fontSize: 17
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 27,
                  child: Center(
                    child: Text(
                      specialset02(widget.data["2020Q4"]["money_flow"]["E00100"]),
                      style: TextStyle(
                        fontSize: 17
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 27,
                  child: Center(
                    child: Text(
                        specialset02(widget.data["2020Q3"]["money_flow"]["E00100"]),
                      style: TextStyle(
                        fontSize: 17
                      ),
                    ),
                  ),
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                SizedBox(
                  height: 55,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '本期淨現金',
                          style: TextStyle(
                            fontSize: 17
                          ),
                        ),
                        Text(
                          '流量',
                          style: TextStyle(
                            fontSize: 17
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 27,
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        specialset02(widget.data["2021Q1"]["money_flow"]["EEEE"]),
                        style: TextStyle(
                          fontSize: 17
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 27,
                  child: Center(
                    child: Text(
                      specialset02(widget.data["2020Q4"]["money_flow"]["EEEE"]),
                      style: TextStyle(
                        fontSize: 17
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 27,
                  child: Center(
                    child: Text(
                        specialset02(widget.data["2020Q3"]["money_flow"]["EEEE"]),
                      style: TextStyle(
                        fontSize: 17
                      ),
                    ),
                  ),
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                SizedBox(
                  height: 55,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '營業活動之',
                          style: TextStyle(
                            fontSize: 17
                          ),
                        ),
                        Text(
                          '現金流量',
                          style: TextStyle(
                            fontSize: 17
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 27,
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        specialset02(widget.data["2021Q1"]["money_flow"]["AAAA"]),
                        style: TextStyle(
                          fontSize: 17
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 27,
                  child: Center(
                    child: Text(
                      specialset02(widget.data["2020Q4"]["money_flow"]["AAAA"]),
                      style: TextStyle(
                        fontSize: 17
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 27,
                  child: Center(
                    child: Text(
                        specialset02(widget.data["2020Q3"]["money_flow"]["AAAA"]),
                      style: TextStyle(
                        fontSize: 17
                      ),
                    ),
                  ),
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                SizedBox(
                  height: 55,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '投資活動之',
                          style: TextStyle(
                            fontSize: 17
                          ),
                        ),
                        Text(
                          '現金流量',
                          style: TextStyle(
                            fontSize: 17
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 27,
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        specialset02(widget.data["2021Q1"]["money_flow"]["BBBB"]),
                        style: TextStyle(
                          fontSize: 17
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 27,
                  child: Center(
                    child: Text(
                      specialset02(widget.data["2020Q4"]["money_flow"]["BBBB"]),
                      style: TextStyle(
                        fontSize: 17
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 27,
                  child: Center(
                    child: Text(
                        specialset02(widget.data["2020Q3"]["money_flow"]["BBBB"]),
                      style: TextStyle(
                        fontSize: 17
                      ),
                    ),
                  ),
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                SizedBox(
                  height: 55,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '融資活動之',
                          style: TextStyle(
                            fontSize: 17
                          ),
                        ),
                        Text(
                          '現金流量',
                          style: TextStyle(
                            fontSize: 17
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 27,
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        specialset02(widget.data["2021Q1"]["money_flow"]["CCCC"]),
                        style: TextStyle(
                          fontSize: 17
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 27,
                  child: Center(
                    child: Text(
                      specialset02(widget.data["2020Q4"]["money_flow"]["CCCC"]),
                      style: TextStyle(
                        fontSize: 17
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 27,
                  child: Center(
                    child: Text(
                        specialset02(widget.data["2020Q3"]["money_flow"]["CCCC"]),
                      style: TextStyle(
                        fontSize: 17
                      ),
                    ),
                  ),
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                SizedBox(
                  height: 55,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '期末現金及',
                          style: TextStyle(
                            fontSize: 17
                          ),
                        ),
                        Text(
                          '約當現金',
                          style: TextStyle(
                            fontSize: 17
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 27,
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        specialset02(widget.data["2021Q1"]["money_flow"]["E00200"]),
                        style: TextStyle(
                          fontSize: 17
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 27,
                  child: Center(
                    child: Text(
                      specialset02(widget.data["2020Q4"]["money_flow"]["E00200"]),
                      style: TextStyle(
                        fontSize: 17
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 27,
                  child: Center(
                    child: Text(
                        specialset02(widget.data["2020Q3"]["money_flow"]["E00200"]),
                      style: TextStyle(
                        fontSize: 17
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]
        ),
      ),
    );
  }

}

class LineChartData{
  final String quarter;
  final int E;
  final int A;
  final int B;
  final int C;
  LineChartData({this.quarter, this.E, this.A, this.B, this.C});
}