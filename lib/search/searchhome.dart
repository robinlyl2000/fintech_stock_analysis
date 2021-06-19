import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'dart:async' show Future;
import 'package:stock_analysis/individual/individual_home.dart';
import 'package:stock_analysis/favoriteList.dart';
import 'package:stock_analysis/company_id.dart';

class SearchHome extends StatefulWidget {
  @override
  _SearchHomeState createState() => _SearchHomeState();
}

class _SearchHomeState extends State<SearchHome> {
  static const historyLength = 5;
  List<String> _searchHistory = [
    "台積電",
    "23"
  ];
  List<String> filteredSearchHistory;
  String selectedTerm;
  List<String> filterSearchTerms({
    @required String filter,
  }){
    if(filter != null && filter .isNotEmpty){
      return _searchHistory.reversed.where((term) => term.startsWith(filter)).toList();
    }else{
      return _searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term){
    if(_searchHistory.contains(term)){
      putSearchTermFirst(term);
      return;
    }
    _searchHistory.add(term);
    if(_searchHistory.length > historyLength){
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void deleteSearchTerm(String term){
    _searchHistory.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void putSearchTermFirst(String term){
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  FloatingSearchBarController controller;

  Map data;

  Future<void> loadJsonData() async {
    try {
      setState((){
        data = companyId;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState(){
    super.initState();
    loadJsonData();
    controller = FloatingSearchBarController();
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfffcfaf2),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            SizedBox(
              height: 140,
              child: Container(
                color: Color(0xff77428d),
              ),
            ),
            FloatingSearchBar(
              margins: EdgeInsets.fromLTRB(10, 80, 10, 0),
              height: 50,
              controller: controller,
              backgroundColor: Color(0xfffcfaf2),
              body: SearchResultListView(
                searchTerm: selectedTerm,
                data: data,
              ),
              transition: CircularFloatingSearchBarTransition(),
              physics: BouncingScrollPhysics(),
              hint: '搜尋股票',
              actions: [
                FloatingSearchBarAction.searchToClear(),
              ],
              onQueryChanged: (query){
                setState(() {
                  filteredSearchHistory = filterSearchTerms(filter: query);              
                });
              },
              onSubmitted: (query){
                setState(() {
                  addSearchTerm(query);           
                  selectedTerm = query;   
                });
                controller.close();
              },
              builder: (context, transition){
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Material(
                    color: Color(0xfffcfaf2),
                    elevation: 4,
                    child: Builder(
                      builder: (context) {
                        if(filteredSearchHistory.isEmpty && controller.query.isEmpty){
                          return Container(
                            height: 56,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Text(
                              '尚無歷史紀錄',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          );
                        }else if( filteredSearchHistory.isEmpty){
                          return ListTile(
                            title: Text(controller.query),
                            leading: const Icon(Icons.search),
                            onTap: (){
                              setState(() {
                                addSearchTerm(controller.query);           
                                selectedTerm = controller.query;   
                              });
                              controller.close();
                            },
                          );
                        }else{
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: filteredSearchHistory.map(
                              (term) => ListTile(
                                title: Text(
                                  term,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                leading: const Icon(Icons.history),
                                trailing: IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: (){
                                    setState(() {
                                      deleteSearchTerm(term);         
                                    });
                                  },
                                ),
                                onTap: (){
                                  setState(() {
                                    putSearchTermFirst(term);
                                    selectedTerm = term;                                
                                  });
                                  controller.close();
                                },
                              )
                            ).toList(),
                          );
                        }
                      }
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
  }
}

class SearchResultListView extends StatefulWidget {
  final String searchTerm;
  final Map data;
  const SearchResultListView({
    Key key,
    @required this.searchTerm,
    @required this.data,
  }) : super(key: key);

  @override
  _SearchResultListViewState createState() => _SearchResultListViewState();
}

class _SearchResultListViewState extends State<SearchResultListView> {


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

  IconData geticon(String id){
    if(favoriteList.contains(id)){
      return Icons.remove_rounded;
    }else{
      return Icons.add_rounded;
    }
  }

  List<ListTile> getList(){
    List<ListTile> result = [];
    widget.data.forEach((id, name) {
      if(id.contains(widget.searchTerm) || name.contains(widget.searchTerm)){
        result.add(
          ListTile(
            title: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18
                ),
                children: [
                  TextSpan(
                    text: id,
                    style: TextStyle(
                      color: Color(0xff77428d)
                    )
                  ),
                  TextSpan(text: '\t'),
                  TextSpan(text: name)
                ]
              ),
            ),
            trailing: ElevatedButton(
              onPressed: (){
                if(favoriteList.contains(id)){
                  setState(() {
                    favoriteList.remove(id);              
                  });
                }else{
                  setState(() {
                    favoriteList.add(id);              
                  });
                }
              },
              child: Icon(
                geticon(id),
                color: getcolor(id, true),
                size: 28,
              ),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(), 
                side: BorderSide(
                  width: 2.0,
                  color:  Color(0xff49608A),
                ),
                primary: getcolor(id, false),
              ),
            ),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => IndividualHome(id: id, name: name)
                )
              );
            },
          )
        );
      }
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 140),
              Flexible(
                child: widget.searchTerm == null 
                ? Container()
                : ListView(
                  children: getList(),
                ),
              ),
            ],
          ),
          Positioned(
            top: 140,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 65,
              child: Container(
                color: Color(0xfffcfaf2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 19,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                          ),
                          children: [
                            TextSpan(text: '與'),
                            TextSpan(
                              text: widget.searchTerm == null ? ' ' :  widget.searchTerm,
                              style: TextStyle(
                                color: Color(0xff77428D)
                              ),
                            ),
                            TextSpan(text: '有關的股票'),
                          ]
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    SizedBox(
                      height: 0.5,
                      child: Container(
                        color: Color(0xff8F77B5),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          
          SizedBox(
            height: 140,
            child: Container(
              color: Color(0xff77428d),
            ),
          ),
        ],
      ),
    );
  }
}