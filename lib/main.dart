import 'package:flutter/material.dart';
import 'package:stock_analysis/favorite/favorite_home.dart';
import 'package:stock_analysis/search/searchhome.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      routes: <String, WidgetBuilder> {
        '/home' : (BuildContext context) => Home(),
        '/search' : (BuildContext context) => SearchHome(),
        '/favorite' : (BuildContext context) => FavoriteHome(),
      },
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffcfaf2),
      appBar: AppBar(
        title: Text('股票分析'),
        centerTitle: true,
        backgroundColor: Color(0xff77428d),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 140,
              height: 140,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: Color(0xfffcfaf2),
                  shape: CircleBorder(), 
                  side: BorderSide(
                    width: 5.0,
                    color:  Color(0xff4a225d),
                  ),
                ),
                onPressed: (){
                  Navigator.of(context).pushNamed('/search');
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 45,
                      child: FittedBox(
                        child: Icon(
                          Icons.search_rounded,
                          color:Color(0xff4a225d),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 27,
                      child: FittedBox(
                        child: Text(
                          '股票查詢',
                          style: TextStyle(
                            color:Color(0xff4a225d),
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 140,
              height: 140,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: Color(0xfffcfaf2),
                  shape: CircleBorder(), 
                  side: BorderSide(
                    width: 5.0,
                    color:  Color(0xff4a225d),
                  ),
                ),
                onPressed: (){
                  Navigator.of(context).pushNamed('/favorite');
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 45,
                      child: FittedBox(
                        child: Icon(
                          Icons.list_alt_rounded,
                          color:Color(0xff4a225d),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 27,
                      child: FittedBox(
                        child: Text(
                          '自選清單',
                          style: TextStyle(
                            color: Color(0xff4a225d),
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ),
            ),
          ],
        ),
      ),
      // bottomSheet: SizedBox(
      //   height: 90,
      //   child: Container(
      //     color: Color(0xff4a225d),
      //     child: Row(
      //       children: [
      //         Spacer(flex: 10),
      //         SizedBox(
      //           width: 120,
      //           child:Column(
      //             children: [
      //               SizedBox(height: 10),
      //               ElevatedButton(
      //                 style: ElevatedButton.styleFrom(
      //                   minimumSize: Size(120.0,70.0),
      //                   elevation: 0,
      //                   primary: Color(0xff4a225d)
      //                 ),
      //                 onPressed: (){
      //                   Navigator.of(context).pushNamed('/search');
      //                 },
      //                 child: Column(
      //                   mainAxisAlignment: MainAxisAlignment.end,
      //                   children: [
      //                     SizedBox(
      //                       height: 40,
      //                       child: FittedBox(
      //                         child: Icon(
      //                           Icons.search_rounded,
      //                           color: Color(0xfffcfaf2),
      //                         ),
      //                       ),
      //                     ),
      //                     SizedBox(
      //                       height: 25,
      //                       child: FittedBox(
      //                         child: Text(
      //                           '股票查詢',
      //                           style: TextStyle(
      //                             color: Color(0xfffcfaf2),
      //                           ),
      //                         ),
      //                       ),
      //                     )
      //                   ],
      //                 )
      //               ),
      //               SizedBox(height: 10),
      //             ],
      //           ),
      //         ),
      //         Spacer(flex: 13),
      //         SizedBox(
      //           width: 120,
      //           child:Column(
      //             children: [
      //               SizedBox(height: 10),
      //               ElevatedButton(
      //                 style: ElevatedButton.styleFrom(
      //                   minimumSize: Size(120.0,70.0),
      //                   elevation: 0,
      //                   primary: Color(0xff4a225d)
      //                 ),
      //                 onPressed: (){
      //                   Navigator.of(context).pushNamed('/favorite');
      //                 },
      //                 child: Column(
      //                   mainAxisAlignment: MainAxisAlignment.end,
      //                   children: [
      //                     SizedBox(
      //                       height: 40,
      //                       child: FittedBox(
      //                         child: Icon(
      //                           Icons.view_list_rounded,
      //                           color: Color(0xfffcfaf2),
      //                         ),
      //                       ),
      //                     ),
      //                     SizedBox(
      //                       height: 25,
      //                       child: FittedBox(
      //                         child: Text(
      //                           '自選清單',
      //                           style: TextStyle(
      //                             color: Color(0xfffcfaf2),
      //                           ),
      //                         ),
      //                       ),
      //                     )
      //                   ],
      //                 )
      //               ),
      //               SizedBox(height: 10),
      //             ],
      //           ),
      //         ),
      //         Spacer(flex: 10),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
