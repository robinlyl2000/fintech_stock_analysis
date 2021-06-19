import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Balance extends StatefulWidget {
  final String id;
  final Map data;
  Balance({this.id, this.data});
  @override
  _BalanceState createState() => _BalanceState();
}

class _BalanceState extends State<Balance> {
  List<bool> isSelected = [true, false, false];
  List<LineChartData> _chartdata = [];
  List<LineChartData02> _chartdata2 = [];

  Widget choosepage(){
    if(isSelected[0]){
      return chart();
    }else if(isSelected[1]){
      return compare();
    }
    return form();
  }

  String quickmath(String quarter){
    int t1 = int.parse(cleannumber(widget.data[quarter]["balance_sheet_statement"]["1170"]));
    int t2 = int.parse(cleannumber(widget.data[quarter]["balance_sheet_statement"]["1180"]));
    int t3 = int.parse(cleannumber(widget.data[quarter]["balance_sheet_statement"]["1210"]));
    return (t1+t2+t3).toString();
  }

  String cleannumber(String input){
    String result = '';
    final t = input.split(',');
    t.forEach((element) {
      result += element;
    });
    String temp = (double.parse(result)/1000.0).toStringAsFixed(0);
    return temp;
  }

  List<TableRow> settablerow(){
    List<TableRow> _tablerow = [];
    _tablerow.add(TableRow(
      children: <Widget>[
        SizedBox(
          height: 40,
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
              '股東權益',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff3A8FB7).withOpacity(0.65),
              ),
            ),
          )
        ),
        SizedBox(
          height: 30,
          child: Center(
            child: Text(
              '負債',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff90B44B)
              ),
            ),
          )
        ),
        SizedBox(
          height: 30,
          child: Center(
            child: Text(
              '資產',
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
              '流動資產',
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
              '流動負債',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xffDB4D6D),
              ),
            ),
          )
        ),
      ],
    ));
    List<TableRow> temp = widget.data.entries.map((e){
      final key = e.key.toString();
      Map t = e.value["balance_sheet_statement"];
      return TableRow(
        children: <Widget>[
          SizedBox(
            height: 35,
            child: Center(
              child: Text(
                '${key.substring(5,6)}Q${key.substring(2,4)}'
              ),
            ),
          ),
          SizedBox(
            height: 27,
            child: Center(
              child: FittedBox(
                child: Text(
                  cleannumber((int.parse(cleannumber(t["1XXX"])) - int.parse(cleannumber(t["2XXX"]))).toString()).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')
                ),
              ),
            ),
          ),
          SizedBox(
            height: 27,
            child: Center(
              child: Text(
                cleannumber(t["2XXX"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')
              ),
            ),
          ),
          SizedBox(
            height: 27,
            child: Center(
              child: Text(
                cleannumber(t["1XXX"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')
              ),
            ),
          ),
          SizedBox(
            height: 27,
            child: Center(
              child: Text(
                cleannumber(t["11XX"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')
              ),
            ),
          ),
          SizedBox(
            height: 27,
            child: Center(
              child: Text(
                cleannumber(t["21XX"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')
              ),
            ),
          ),
        ],
      );
    }).toList();
    _tablerow.addAll(temp);
    return _tablerow;
  }

  List<TableRow> settablerow02(){
    List<TableRow> _tablerow = [];
    _tablerow.add(TableRow(
      children: <Widget>[
        SizedBox(
          height: 40,
          child: Center(
            child: Text(
              '季別',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15
              ),
            ),
          )
        ),
        SizedBox(
          height: 30,
          child: Center(
            child: Text(
              '現金佔流動資產比',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color:  Color(0xffED784A),
                fontSize: 15
              ),
            ),
          )
        ),
        SizedBox(
          height: 30,
          child: Center(
            child: Text(
              '應收票據及帳款佔比',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff005CAF),
                fontSize: 15
              ),
            ),
          )
        ),
      ],
    ));
    List<TableRow> temp = _chartdata2.map((e){
      return TableRow(
        children: <Widget>[
          SizedBox(
            height: 35,
            child: Center(
              child: Text(
                '${e.quarter.substring(5,6)}Q${e.quarter.substring(2,4)}',
                style: TextStyle(
                  fontSize: 17
                ),
              ),
            ),
          ),
          SizedBox(
            height: 27,
            child: Center(
              child: FittedBox(
                child: Text(
                  e.A.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                e.B.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                style: TextStyle(
                  fontSize: 17
                ),
              ),
            ),
          ),
        ],
      );
    }).toList();
    _tablerow.addAll(temp);
    return _tablerow;
  }


  List<LineChartData> _setuplist(){
    List<LineChartData> result = [];
    widget.data.entries.forEach((e){
      final quarter = e.key.toString();
      final t = e.value["balance_sheet_statement"];
      result.add(LineChartData(
        quarter: quarter,
        A: int.parse(cleannumber(t["1XXX"])),
        L: int.parse(cleannumber(t["2XXX"])),
        E: int.parse(cleannumber(t["1XXX"])) - int.parse(cleannumber(t["2XXX"])),
        flowA: int.parse(cleannumber(t["11XX"])),
        flowL: int.parse(cleannumber(t["21XX"])),
      ));
    });
    return result;
  }

  List<LineChartData02> _setuplist02(){
    List<LineChartData02> result = [];
    widget.data.entries.forEach((e){
      final quarter = e.key.toString();
      final t = e.value["balance_sheet_statement"];
      result.add(LineChartData02(
        quarter: quarter,
        A: int.parse(cleannumber(t["1100"])),
        l1170: int.parse(cleannumber(t["1170"])),
        l1180: int.parse(cleannumber(t["1180"])),
        l1210: int.parse(cleannumber(t["1210"])),
      ));
    });
    return result;
  }

  @override
  void initState(){
    super.initState();
    _chartdata = _setuplist();
    _chartdata2 = _setuplist02();
    setState(() {
      isSelected = [true, false, false];
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        SizedBox(
          height: 40,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 225,
                  child: Center(
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
                                '變現比',
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
                ),
                SizedBox(
                  width: 78,
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
        choosepage(),
      ],
    );
  }

  Widget chart(){
    return SizedBox(
      height: 500,
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
                StackedColumnSeries<LineChartData, String>(
                  dataSource: _chartdata,
                  xValueMapper: (LineChartData sales, _) => sales.quarter,
                  yValueMapper: (LineChartData sales, _) => sales.E/10000,
                  color: Color(0xff3A8FB7).withOpacity(0.65),
                ),
                StackedColumnSeries<LineChartData, String>(
                  dataSource: _chartdata,
                  xValueMapper: (LineChartData sales, _) => sales.quarter,
                  yValueMapper: (LineChartData sales, _) => sales.L/10000,
                  color: Color(0xff90B44B),
                ),
                LineSeries<LineChartData, String>(
                  dataSource: _chartdata,
                  xValueMapper: (LineChartData sales, _) => sales.quarter,
                  yValueMapper: (LineChartData sales, _) => sales.A/10000,
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
                  yValueMapper: (LineChartData sales, _) => sales.flowA/10000,
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
                  yValueMapper: (LineChartData sales, _) => sales.flowL/10000,
                  color: Color(0xffDB4D6D),
                  width: 2,
                  markerSettings: MarkerSettings(
                    isVisible: true,
                    shape: DataMarkerType.circle,
                    color: Color(0xffDB4D6D),
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
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(3),
                  2: FlexColumnWidth(3),
                  3: FlexColumnWidth(3),
                  4: FlexColumnWidth(3),
                  5: FlexColumnWidth(3),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                //設定表格樣式
                border: TableBorder.all(
                    color: Colors.black, width: 1.0),
                children: settablerow()
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget compare(){
    return SizedBox(
      height: 500,
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
                LineSeries<LineChartData02, String>(
                  dataSource: _chartdata2,
                  xValueMapper: (LineChartData02 sales, _) => sales.quarter,
                  yValueMapper: (LineChartData02 sales, _) => sales.A/10000,
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
                LineSeries<LineChartData02, String>(
                  dataSource: _chartdata2,
                  xValueMapper: (LineChartData02 sales, _) => sales.quarter,
                  yValueMapper: (LineChartData02 sales, _) => sales.B/10000,
                  color: Color(0xff005CAF),
                  width: 2,
                  markerSettings: MarkerSettings(
                    isVisible: true,
                    shape: DataMarkerType.circle,
                    color: Color(0xff005CAF),
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
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                //設定表格樣式
                border: TableBorder.all(
                    color: Colors.black, width: 1.0),
                children: settablerow02()
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
                  height: 35,
                  child: Center(
                    child: Text(
                      '資產',
                      style: TextStyle(
                        fontSize: 17
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 27,
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        cleannumber(widget.data["2021Q1"]["balance_sheet_statement"]["1XXX"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                        cleannumber(widget.data["2020Q4"]["balance_sheet_statement"]["1XXX"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                        cleannumber(widget.data["2020Q3"]["balance_sheet_statement"]["1XXX"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                  height: 35,
                  child: Center(
                    child: Text(
                      '流動資產',
                      style: TextStyle(
                        fontSize: 17
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 27,
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        cleannumber(widget.data["2021Q1"]["balance_sheet_statement"]["11XX"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                        cleannumber(widget.data["2020Q4"]["balance_sheet_statement"]["11XX"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                        cleannumber(widget.data["2020Q3"]["balance_sheet_statement"]["11XX"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                  height: 50,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '現金',
                          style: TextStyle(
                            fontSize: 17
                          ),
                        ),
                        Text(
                          '(約當現金)',
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
                        cleannumber(widget.data["2021Q1"]["balance_sheet_statement"]["1100"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                        cleannumber(widget.data["2020Q4"]["balance_sheet_statement"]["1100"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                        cleannumber(widget.data["2020Q3"]["balance_sheet_statement"]["1100"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                  height: 50,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '應收票據',
                          style: TextStyle(
                            fontSize: 17
                          ),
                        ),
                        Text(
                          '及帳款',
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
                        quickmath("2021Q1").replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                        quickmath("2020Q4").replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                        quickmath("2020Q3").replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                  height: 35,
                  child: Center(
                    child: Text(
                      '存貨',
                      style: TextStyle(
                        fontSize: 17
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 27,
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        cleannumber(widget.data["2021Q1"]["balance_sheet_statement"]["130X"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                        cleannumber(widget.data["2020Q4"]["balance_sheet_statement"]["130X"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                        cleannumber(widget.data["2020Q3"]["balance_sheet_statement"]["130X"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                  height: 35,
                  child: Center(
                    child: Text(
                      '基金及投資',
                      style: TextStyle(
                        fontSize: 17
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 27,
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        cleannumber(widget.data["2021Q1"]["balance_sheet_statement"]["1550"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                        cleannumber(widget.data["2020Q4"]["balance_sheet_statement"]["1550"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                        cleannumber(widget.data["2020Q3"]["balance_sheet_statement"]["1550"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                  height: 35,
                  child: Center(
                    child: Text(
                      '固定資產',
                      style: TextStyle(
                        fontSize: 17
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 27,
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        cleannumber(widget.data["2021Q1"]["balance_sheet_statement"]["1600"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                        cleannumber(widget.data["2020Q4"]["balance_sheet_statement"]["1600"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                        cleannumber(widget.data["2020Q3"]["balance_sheet_statement"]["1600"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                  height: 35,
                  child: Center(
                    child: Text(
                      '無形資產',
                      style: TextStyle(
                        fontSize: 17
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 27,
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        cleannumber(widget.data["2021Q1"]["balance_sheet_statement"]["1780"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                        cleannumber(widget.data["2020Q4"]["balance_sheet_statement"]["1780"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                        cleannumber(widget.data["2020Q3"]["balance_sheet_statement"]["1780"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                  height: 50,
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          '遞延所得稅',
                          style: TextStyle(
                            fontSize: 17
                          ),
                        ),
                        Text(
                          '資產',
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
                        cleannumber(widget.data["2021Q1"]["balance_sheet_statement"]["1840"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                        cleannumber(widget.data["2020Q4"]["balance_sheet_statement"]["1840"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                        cleannumber(widget.data["2020Q3"]["balance_sheet_statement"]["1840"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                  height: 35,
                  child: Center(
                    child: Text(
                      '其他資產',
                      style: TextStyle(
                        fontSize: 17
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 27,
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        cleannumber(widget.data["2021Q1"]["balance_sheet_statement"]["1900"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                        cleannumber(widget.data["2020Q4"]["balance_sheet_statement"]["1900"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                        cleannumber(widget.data["2020Q3"]["balance_sheet_statement"]["1900"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                  height: 35,
                  child: Center(
                    child: Text(
                      '負債',
                      style: TextStyle(
                        fontSize: 17
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 27,
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        cleannumber(widget.data["2021Q1"]["balance_sheet_statement"]["2XXX"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                        cleannumber(widget.data["2020Q4"]["balance_sheet_statement"]["2XXX"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                        cleannumber(widget.data["2020Q3"]["balance_sheet_statement"]["2XXX"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                  height: 35,
                  child: Center(
                    child: Text(
                      '流動負債',
                      style: TextStyle(
                        fontSize: 17
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 27,
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        cleannumber(widget.data["2021Q1"]["balance_sheet_statement"]["21XX"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                        cleannumber(widget.data["2020Q4"]["balance_sheet_statement"]["21XX"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                        cleannumber(widget.data["2020Q3"]["balance_sheet_statement"]["21XX"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                  height: 50,
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          '遞延所得稅',
                          style: TextStyle(
                            fontSize: 17
                          ),
                        ),
                        Text(
                          '負債',
                          style: TextStyle(
                            fontSize: 17
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 27,
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        cleannumber(widget.data["2021Q1"]["balance_sheet_statement"]["2570"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                        cleannumber(widget.data["2020Q4"]["balance_sheet_statement"]["2570"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                        cleannumber(widget.data["2020Q3"]["balance_sheet_statement"]["2570"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
  final int L; 
  final int A; 
  final int flowA;
  final int flowL;

  LineChartData({this.quarter, this.A, this.L, this.E, this.flowA, this.flowL});
}

class LineChartData02{
  final String quarter;
  final int A; 
  final int l1170; 
  final int l1180; 
  final int l1210;
  
  int get B{
    return l1170+l1180+l1210;
  }

  LineChartData02({this.quarter, this.A, this.l1170, this.l1180, this.l1210});
}

class TableRowData03{
  final String quarter;
  final Map data;

  TableRowData03({this.quarter, this.data});
}