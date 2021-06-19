# 股票快選App

## 前言
1. **目的** : 透過API彙整所有公司的股票相關數據，去分析各公司的基本面資料。
2. **API資料來源** : 
    * FinTechSpace數位沙盒服務之<font color="#005CAF">「台灣各股近五年每日開高收低資料API」</font>
    * 爬取「Goodinfo!台灣股市資料網」之<font color="#005CAF">「各公司基本資料與績效表」</font>
    * 爬取「公開資訊觀測站」之<font color="#005CAF">「各公司之現金流量表、資產負債表與損益表」</font>
3. **App撰寫工具** : **<font color="red">Flutter</font>**
4. **App架構** : 
    <p align="center">  
        <img height="50%" width="50%" src="https://i.imgur.com/1c5R6L0.png">
    </p>
---
## App首頁
* 利用了Flutter中的Route(路由)與Navigator(導航)功能，來實施頁面之跳轉
* 實作程式碼如下 : 
    ```dart=
    Widget build(BuildContext context) {
      return MaterialApp(
        home: Home(),   //設置主頁為Home()
        routes: <String, WidgetBuilder> {  //設置其他分頁
          '/home' : (BuildContext context) => Home(),
          '/search' : (BuildContext context) => SearchHome(),
          '/favorite' : (BuildContext context) => FavoriteHome(),
        },
      );
    }
    ```
* 頁面展示 : 
    <p align="center">  
        <img height="50%" width="50%" src="https://i.imgur.com/h6AGYx8.png">
    </p>

    > * 透過畫面中的兩個按鈕，可以各自前往「查詢股票」與「自選清單」頁面
    > * 而一般股票快選App的首頁通常會放近期的股市新聞，但由於此專案的重點並非在那部分，所以這邊的首頁我就做得比較簡易。

