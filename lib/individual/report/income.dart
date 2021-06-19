import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Income extends StatefulWidget {
  final String id;
  final Map data;
  Income({this.id, this.data});
  @override
  _IncomeState createState() => _IncomeState();
}

class _IncomeState extends State<Income> {
  List<bool> isSelected = [true, false];
  List<LineChartData> _chartdata = [];
  List<TableRow> _tablerow = [];

  String cleannumber(String input){
    String result = '';
    final t = input.split(',');
    t.forEach((element) {
      result += element;
    });
    String temp = (double.parse(result)/1000.0).toStringAsFixed(0);
    return temp;
  }

  List<LineChartData> _setuplist(){
    List<LineChartData> result = [];
    widget.data.entries.forEach((e){
      final quarter = e.key.toString();
      final t = e.value["income_statement"];
      result.add(LineChartData(
        quarter: quarter,
        grossMargnin: int.parse(cleannumber(t["5900"])),
        profitRate: int.parse(cleannumber(t["6900"])),
        netInterestRate: int.parse(cleannumber(t["8200"])),
      ));
    });
    return result;
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
              '營業毛利',
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
              '營業淨利',
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
              '稅後淨利',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff90B44B),
              ),
            ),
          )
        ),
      ],
    ));
    List<TableRow> temp = widget.data.entries.map((e){
      final key = e.key.toString();
      Map t = e.value["income_statement"];
      return TableRow(
        children: <Widget>[
          SizedBox(
            height: 27,
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
                cleannumber(t["5900"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')
              ),
            ),
          ),
          SizedBox(
            height: 27,
            child: Center(
              child: Text(
                cleannumber(t["6900"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')
              ),
            ),
          ),
          SizedBox(
            height: 27,
            child: Center(
              child: Text(
                cleannumber(t["8200"]).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')
              ),
            ),
          ),
        ],
      );
    }).toList();
    _tablerow.addAll(temp);
  }


  @override
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

  Widget chart (){
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
                  yValueMapper: (LineChartData sales, _) => sales.grossMargnin/10000,
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
                  yValueMapper: (LineChartData sales, _) => sales.profitRate/10000,
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
                  yValueMapper: (LineChartData sales, _) => sales.netInterestRate/10000,
                  color: Color(0xff90B44B),
                  width: 2,
                  markerSettings: MarkerSettings(
                    isVisible: true,
                    shape: DataMarkerType.circle,
                    color: Color(0xff90B44B),
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
                  3: FlexColumnWidth(2),
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

    return Container(
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
            color: Colors.black, width: 1.0
        ),
        children: [
          TableRow(
            children: <Widget>[
              SizedBox(
                height: 30,
                child: Center(
                  child: Text(
                    '科目(絕對值)',
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
                    '1Q21',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
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
                    ),
                  ),
                )
              ),
            ],
          ),
          TableRow(
            children: <Widget>[
              SizedBox(
                height: 30,
                child: Center(
                  child: Text(
                    '營業收入',
                  ),
                )
              ),
              SizedBox(
                height: 30,
                child: Center(
                  child: Text(
                    widget.data["2021Q1"]["income_statement"]["4000"],
                  ),
                )
              ),
              SizedBox(
                height: 30,
                child: Center(
                  child: Text(
                    widget.data["2020Q4"]["income_statement"]["4000"],
                  ),
                )
              ),
              SizedBox(
                height: 30,
                child: Center(
                  child: Text(
                    widget.data["2020Q3"]["income_statement"]["4000"],
                  ),
                )
              ),
            ],
          ),
          TableRow(
            children: <Widget>[
              SizedBox(
                height: 30,
                child: Center(
                  child: Text(
                    '營業成本',
                  ),
                )
              ),
              SizedBox(
                height: 30,
                child: Center(
                  child: Text(
                    widget.data["2021Q1"]["income_statement"]["5000"],
                  ),
                )
              ),
              SizedBox(
                height: 30,
                child: Center(
                  child: Text(
                    widget.data["2020Q4"]["income_statement"]["5000"],
                  ),
                )
              ),
              SizedBox(
                height: 30,
                child: Center(
                  child: Text(
                    widget.data["2020Q3"]["income_statement"]["5000"],
                  ),
                )
              ),
            ],
          ),
          TableRow(
            children: <Widget>[
              SizedBox(
                height: 30,
                child: Center(
                  child: Text(
                    '營業毛利',
                  ),
                )
              ),
              SizedBox(
                height: 30,
                child: Center(
                  child: Text(
                    widget.data["2021Q1"]["income_statement"]["5900"],
                  ),
                )
              ),
              SizedBox(
                height: 30,
                child: Center(
                  child: Text(
                    widget.data["2020Q4"]["income_statement"]["5900"],
                  ),
                )
              ),
              SizedBox(
                height: 30,
                child: Center(
                  child: Text(
                    widget.data["2020Q3"]["income_statement"]["5900"],
                  ),
                )
              ),
            ],
          ),
          TableRow(
            children: <Widget>[
              SizedBox(
                height: 30,
                child: Center(
                  child: Text(
                    '營業費用',
                  ),
                )
              ),
              SizedBox(
                height: 30,
                child: Center(
                  child: Text(
                    widget.data["2021Q1"]["income_statement"]["6000"],
                  ),
                )
              ),
              SizedBox(
                height: 30,
                child: Center(
                  child: Text(
                    widget.data["2020Q4"]["income_statement"]["6000"],
                  ),
                )
              ),
              SizedBox(
                height: 30,
                child: Center(
                  child: Text(
                    widget.data["2020Q3"]["income_statement"]["6000"],
                  ),
                )
              ),
            ],
          ),
          TableRow(
            children: <Widget>[
              SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    '營業利益\n(損失)',
                  ),
                )
              ),
              SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    widget.data["2021Q1"]["income_statement"]["6900"],
                  ),
                )
              ),
              SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    widget.data["2020Q4"]["income_statement"]["6900"],
                  ),
                )
              ),
              SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    widget.data["2020Q3"]["income_statement"]["6900"],
                  ),
                )
              ),
            ],
          ),
          TableRow(
            children: <Widget>[
              SizedBox(
                height: 30,
                child: Center(
                  child: Text(
                    '業外收支',
                  ),
                )
              ),
              SizedBox(
                height: 30,
                child: Center(
                  child: Text(
                    widget.data["2021Q1"]["income_statement"]["7000"],
                  ),
                )
              ),
              SizedBox(
                height: 30,
                child: Center(
                  child: Text(
                    widget.data["2020Q4"]["income_statement"]["7000"],
                  ),
                )
              ),
              SizedBox(
                height: 30,
                child: Center(
                  child: Text(
                    widget.data["2020Q3"]["income_statement"]["7000"],
                  ),
                )
              ),
            ],
          ),
          TableRow(
            children: <Widget>[
              SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    '稅前淨利\n(淨損)',
                  ),
                )
              ),
              SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    widget.data["2021Q1"]["income_statement"]["7900"],
                  ),
                )
              ),
              SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    widget.data["2020Q4"]["income_statement"]["7900"],
                  ),
                )
              ),
              SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    widget.data["2020Q3"]["income_statement"]["7900"],
                  ),
                )
              ),
            ],
          ),
          TableRow(
            children: <Widget>[
              SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    '所得稅費用\n(利益)',
                  ),
                )
              ),
              SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    widget.data["2021Q1"]["income_statement"]["7950"],
                  ),
                )
              ),
              SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    widget.data["2020Q4"]["income_statement"]["7950"],
                  ),
                )
              ),
              SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    widget.data["2020Q3"]["income_statement"]["7950"],
                  ),
                )
              ),
            ],
          ),
          TableRow(
            children: <Widget>[
              SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    '稅後淨利\n(淨損)',
                  ),
                )
              ),
              SizedBox(
                height: 30,
                child: Center(
                  child: Text(
                    widget.data["2021Q1"]["income_statement"]["8200"],
                  ),
                )
              ),
              SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    widget.data["2020Q4"]["income_statement"]["8200"],
                  ),
                )
              ),
              SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    widget.data["2020Q3"]["income_statement"]["8200"],
                  ),
                )
              ),
            ],
          ),
          TableRow(
            children: <Widget>[
              SizedBox(
                height: 30,
                child: Center(
                  child: Text(
                    'EPS\n(每股盈餘)',
                  ),
                )
              ),
              SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    widget.data["2021Q1"]["income_statement"]["9750"],
                  ),
                )
              ),
              SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    widget.data["2020Q4"]["income_statement"]["9750"],
                  ),
                )
              ),
              SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    widget.data["2020Q3"]["income_statement"]["9750"],
                  ),
                )
              ),
            ],
          )
        ]
      ),
    );
  }

}

class LineChartData{
  final String quarter;
  final int grossMargnin; //營業毛利
  final int profitRate; //營業淨利
  final int netInterestRate; //稅後淨利

  LineChartData({this.quarter, this.grossMargnin, this.netInterestRate, this.profitRate});
}