import 'package:flutter/material.dart';
class Fundamental extends StatefulWidget {
  final String id;
  final Map data;
  Fundamental({this.id, this.data});
  @override
  _FundamentalState createState() => _FundamentalState();
}

class _FundamentalState extends State<Fundamental> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1000,
      child: Column(
        children: widget.data.entries.where((e) => e.key != "主要業務").map((entry){
          if(entry.key == "公司名稱"){
            return SizedBox(
              height: 40,
              child: Center(
                child: Text(
                  widget.data[entry.key],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                ),
              ),
            );
          }
          return ListTile(
            title: Text(
              entry.key
            ),
            trailing: SizedBox(
              width: 200,
              child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  widget.data[entry.key],
                  style: TextStyle(
                    fontSize: 18
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
      
    );
  }
}