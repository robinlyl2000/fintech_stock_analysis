import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:stock_analysis/service/model.dart';

class Weeks extends StatefulWidget {
  final List data;
  final Function(int, String) callback;
  Weeks({this.data, this.callback});
  @override
  _WeeksState createState() => _WeeksState();
}

class _WeeksState extends State<Weeks> {
  List<ChartSampleData> _chartData;

  TrackballBehavior _trackballBehavior1; 
  TrackballBehavior _trackballBehavior2;

  

  double _volumehighest = 0.0;
  List cleanlist(List list){
    int temp = list.length - 39;
    list = list.where((e) => e['id'] >= temp).toList();
    return list;
  }

  List<ChartSampleData> setuplist(){
    List<ChartSampleData> result = <ChartSampleData>[];
    
    final cleaned = cleanlist(widget.data);
    cleaned.forEach((e){

      if(e['volume'] > _volumehighest){
        _volumehighest = e['volume'].toDouble();
      }

      String datetime = e['date'].substring(0,10);
      var t = ChartSampleData(
        x: DateFormat("yyyy-MM-dd").parse(datetime),
        open: e['open'].toDouble(),
        high: e['high'].toDouble(),
        low: e['low'].toDouble(),
        close: e['close'].toDouble(),
        volume: e['volume'].toDouble(),
        id: e['id'].toInt(),
        change: e['change'].toDouble() ?? 0.0,
        ma5: e['ma5'].toDouble() ?? 0.0,
        ma10: e['ma10'].toDouble() ?? 0.0,
        ma20: e['ma20'].toDouble() ?? 0.0,
        volma5: e['volma5'].toDouble() ?? 0.0,
        volma10: e['volma10'].toDouble() ?? 0.0,
      );
      result.add(t);
    });
    return result.toList();
  }

  Future<void> set() async{
    _chartData = setuplist();
    setState(() {
      _trackballBehavior1 = TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        shouldAlwaysShow: true,
        tooltipDisplayMode: TrackballDisplayMode.none,
      );
      _trackballBehavior2 = TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        shouldAlwaysShow: true,
        tooltipDisplayMode: TrackballDisplayMode.none,
      );
    });
  }


  @override
  void initState(){
    super.initState();
    set();
  }

  @override
  
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: SfCartesianChart(
            trackballBehavior: _trackballBehavior1,
            onTrackballPositionChanging: (TrackballArgs args) {
              int r = args.chartPointInfo.dataPointIndex;
              widget.callback(r, "weeks");
              _trackballBehavior2.show(args.chartPointInfo.xPosition,args.chartPointInfo.yPosition, 'pixel');
            },
            primaryXAxis: DateTimeCategoryAxis(
              dateFormat: DateFormat('MM/dd'),
              intervalType: DateTimeIntervalType.days,
              interval: 10,
              isVisible: false
            ),
            primaryYAxis: NumericAxis(
              rangePadding: ChartRangePadding.additional,
              isVisible: true
            ),
            series: <CartesianSeries>[
              CandleSeries<ChartSampleData, DateTime>(
                bullColor: Color(0xff90B44B),
                bearColor: Color(0xffD0104C),
                dataSource: _chartData,
                xValueMapper: (ChartSampleData sales, _) => sales.x,
                lowValueMapper: (ChartSampleData sales, _) => sales.low,
                highValueMapper: (ChartSampleData sales, _) => sales.high,
                openValueMapper: (ChartSampleData sales, _) => sales.open,
                closeValueMapper: (ChartSampleData sales, _) => sales.close
              ),
              LineSeries<ChartSampleData, DateTime>(
                dataSource: _chartData,
                xValueMapper: (ChartSampleData sales, _) => sales.x,
                yValueMapper: (ChartSampleData sales, _) => sales.ma5,
                color: Color(0xff005CAF),
                width: 2
              ),
              LineSeries<ChartSampleData, DateTime>(
                dataSource: _chartData,
                xValueMapper: (ChartSampleData sales, _) => sales.x,
                yValueMapper: (ChartSampleData sales, _) => sales.ma10,
                color: Color(0xffED784A),
                width: 2
              ),
              LineSeries<ChartSampleData, DateTime>(
                dataSource: _chartData,
                xValueMapper: (ChartSampleData sales, _) => sales.x,
                yValueMapper: (ChartSampleData sales, _) => sales.ma20,
                color: Color(0xffE87A90),
                width: 2
              )
            ],
          ),
        ),
        SizedBox(
          height: 100,
          child: SfCartesianChart(
            trackballBehavior: _trackballBehavior2,
            series: <CartesianSeries>[
              ColumnSeries<ChartSampleData, DateTime>(
                color: Color(0xff8F77B5).withOpacity(0.7),
                dataSource: _chartData,
                xValueMapper: (ChartSampleData sales, _) => sales.x,
                yValueMapper: (ChartSampleData sales, _) => sales.volume
              ),
              LineSeries<ChartSampleData, DateTime>(
                dataSource: _chartData,
                xValueMapper: (ChartSampleData sales, _) => sales.x,
                yValueMapper: (ChartSampleData sales, _) => sales.volma5,
                color: Color(0xff005CAF),
                width: 2
              ),
              LineSeries<ChartSampleData, DateTime>(
                dataSource: _chartData,
                xValueMapper: (ChartSampleData sales, _) => sales.x,
                yValueMapper: (ChartSampleData sales, _) => sales.volma10,
                color: Color(0xffED784A),
                width: 2
              ),
            ],
            primaryXAxis: DateTimeCategoryAxis(
              dateFormat: DateFormat('MM/dd'),
              intervalType: DateTimeIntervalType.days,
              interval: 10
            ),
            primaryYAxis: NumericAxis(
              maximum: _volumehighest,
              minimum: 0,
              isVisible: true,
              labelFormat: '100',
              labelStyle: TextStyle(
                color: Color(0xfffcfaf2)
              )
            ),
          ),
        ),
      ],
    );
  }
}


