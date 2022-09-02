import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bs_flutter_modal/bs_flutter_modal.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter/foundation.dart';

import 'Login.dart';
import 'NewWO.dart';
import 'WOoutward.dart';



var PNO;
var cat;
var INo;


class CurrentStock extends StatefulWidget {
  const CurrentStock({Key? key}) : super(key: key);

  @override
  State<CurrentStock> createState() => _CurrentStockState();
}

class _CurrentStockState extends State<CurrentStock> {


  var items;
  var tablelength;
  final dataPagerHeight = 60.0;
  var rowsperpage = 15.0;
  GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();


  Future<StockDataGridSource> getStockDataSource() async {
    var StockList = await generateStockList();
    return StockDataGridSource(StockList,context);
  }

  List<GridColumn> getColumn() {
    return <GridColumn>[
      GridColumn(
          columnName: 'PartNo',
          width: 100,
          label: Container(
              padding: EdgeInsets.all(6),
              alignment: Alignment.center,
              child: Text('PartNo',
                  overflow: TextOverflow.clip, softWrap: true)),
          allowSorting: true),
      GridColumn(
          columnName: 'Category',
          width: 120,
          label: Container(
              padding: EdgeInsets.all(7),
              alignment: Alignment.center,
              child: Text('Category',
                  overflow: TextOverflow.clip, softWrap: true)),
          allowSorting: true),
      GridColumn(
          columnName: 'CurrentStock',
          width: 100,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              child: Text('CurrentStock',
                  overflow: TextOverflow.clip, softWrap: true)),
          allowSorting: true),
      GridColumn(
          columnName: 'UOM',
          width: 80,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              child: Text('UOM',
                  overflow: TextOverflow.clip, softWrap: true)),
          allowSorting: true),
    ];
  }


  Future<List<Stock>> generateStockList() async {
    var url;
    url = "https://apiaspl.larch.in/Home/FetchCurrentStock";
    var response = await http.get(Uri.parse(url));
    items = json.decode(response.body).cast<Map<String , dynamic>>();
    tablelength = items.length;
    List<Stock> StockList =await items.map<Stock>((json)=>Stock.fromJson(json)).toList();
    return StockList;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStockDataSource();
    generateStockList();
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        title: Text('Accurate'),
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.green,
                ),
                child: Align(alignment: Alignment.center,child: Text('Accurate',style: TextStyle(fontSize: 30.0),),)
            ),
            ListTile(
              title: Row(
                children: const [
                  Icon(Icons.task_outlined),
                  SizedBox(width: 10.0,),
                  Text('New WO'),
                ],
              ),
              onTap: ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>NewWO()));
              },
            ),
            ListTile(
              title: Row(
                children: const [
                  Icon(Icons.task_outlined),
                  SizedBox(width: 10.0,),
                  Text('WO Against Outward'),
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>WOoutward()));
              },
            ),
            ListTile(
              title: Row(
                children: const [
                  Icon(Icons.task_outlined),
                  SizedBox(width: 10.0,),
                  Text('Current Stock'),
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>CurrentStock()));
              },
            ),
            ListTile(
              title: Row(
                children: const [
                  Icon(Icons.logout_rounded),
                  SizedBox(width: 10.0,),
                  Text('Logout'),
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
              },
            ),
            SizedBox(height: 280.0,),
            Divider(
              height: 1,
              thickness: 1,
            ),
            // SizedBox(height: 120.0,),
            Container(
              padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
              child: Center(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Column(
                    children: [
                      ListTile(
                        title: Row(
                          children: [
                            Image(image: AssetImage('LarchTREE.png')),
                            // Icon(Icons.terrain_rounded),
                            SizedBox(width: 2.0,),
                            Text('  ERP - v 1.0.1',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10.0,),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(width: 5,color: Colors.greenAccent),
                  borderRadius: BorderRadius.circular(2)
              ),
              padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
              child: Row(
                children: [
                  Icon(Icons.keyboard_double_arrow_right),
                  Text(
                    'Current Stock',style: TextStyle(
                    color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15.0,
                  ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.0,),
            FutureBuilder(future: getStockDataSource(),builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot){
              return snapshot.hasData ?
              Column(
                children: [
                  SingleChildScrollView(
                    child: SfDataGridTheme(data: SfDataGridThemeData(headerColor: const Color(0xff009889)),
                      child: SfDataGrid(onQueryRowHeight: (details) {
                        // Set the row height as 70 to the column header row.
                        return details.rowIndex == 0 ? 50.0 : 60.0;
                      },selectionMode: SelectionMode.single,columnWidthMode: ColumnWidthMode.auto,allowColumnsResizing: true,
                        onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
                          return true;
                        },
                        key: key,
                        allowPullToRefresh: true,source: snapshot.data,
                        columns: getColumn(),
                        gridLinesVisibility: GridLinesVisibility.both,
                        headerGridLinesVisibility: GridLinesVisibility.both,
                        allowSorting: true,
                        sortingGestureType: SortingGestureType.tap,
                      ),
                    ),
                  ),
                  tablelength > 5 ?
                  Container(
                    padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                    height: dataPagerHeight,
                    child: SfDataPagerTheme(
                      data: SfDataPagerThemeData(
                        itemColor: Colors.white,
                        selectedItemColor: Colors.green,
                        itemBorderRadius: BorderRadius.circular(5),
                        backgroundColor: Color(0xff009889),
                      ),
                      child: SfDataPager(
                        delegate: snapshot.data,
                        direction: Axis.horizontal,
                        pageCount: tablelength/rowsperpage,
                      ),
                    ),):SizedBox(),
                ],
              ): Center(child: Text('No data to display',style:  TextStyle(fontSize: 15.0),));
            }),
            SizedBox(height: 50.0,),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(backgroundColor: Colors.blueGrey),
                      onPressed: ()  {
                        GRID_PDF();
                      },
                      child: Text('Export',style: TextStyle(color: Colors.white,fontSize: 15.0),)),
                ],
              ),
            )
          ],
        ),
      ),

    ), onWillPop: () async => true);
  }
}


class StockDataGridSource extends DataGridSource {
  StockDataGridSource(this.StockList,this.context) {
    buildDataGridRow();
  }
  BuildContext context;
  var data;
  var tablelength_1;
  final dataPagerHeight_1 = 60.0;
  var rowsperpage_1 = 4.0;


  // <--------------------------GRID POPUP--------------------------------->

  List<GridColumn> getColumn_cs() {
    return <GridColumn>[
      GridColumn(
        columnName: 'CoilNo',
        width: 100,
        label: Container(
            padding: EdgeInsets.all(6),
            alignment: Alignment.center,
            child: Text('Coil No',
                overflow: TextOverflow.clip, softWrap: true)),),
      GridColumn(
        columnName: 'Quantity',
        width: 100,
        label: Container(
            padding: EdgeInsets.all(6),
            alignment: Alignment.center,
            child: Text('Quantity',
                overflow: TextOverflow.clip, softWrap: true)),),
      // allowSorting: true
      GridColumn(
        columnName: 'UOM',
        width: 120,
        label: Container(
            padding: EdgeInsets.all(7),
            alignment: Alignment.center,
            child: Text('UOM',
                overflow: TextOverflow.clip, softWrap: true)),),
    ];
  }

  Future<List<Stock_1>> generateStockList_1() async {
    var url2;
    url2 = "https://apiaspl.larch.in/Home/FetchCurrentStock_PopUp?ItemId=${INo}";
    var response = await http.get(Uri.parse(url2));
    data = json.decode(response.body).cast<Map<String , dynamic>>();
    tablelength_1 = data.length;
    List<Stock_1> StockList_1 =await data.map<Stock_1>((json)=>Stock_1.fromJson(json)).toList();
    return StockList_1;
  }


  // <--------------------------GRID POPUP--------------------------------->




  late List<DataGridRow> dataGridRows;
  late List<Stock> StockList;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {

    // <--------------------------GRID POPUP--------------------------------->

    Future<StockDataGridSource_1> getStockDataSource_1() async {
      var StockList_1 = await generateStockList_1();
      // print(StockList_1);
      return StockDataGridSource_1(StockList_1,context);
    }

    // <--------------------------GRID POPUP--------------------------------->

    return DataGridRowAdapter(cells: [
      Container(
        child: Text(
          row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[1].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: TextButton(
          child: Text(
            row.getCells()[2].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
          onPressed: () {
            PNO = row.getCells()[0].value.toString();
            cat = row.getCells()[1].value.toString();
            INo = row.getCells()[4].value.toString();
            // print(INo);
            getStockDataSource_1();
            generateStockList_1();
            if(row.getCells()[2].value.toString() == '0.00')
            {
              Widget okbutton = TextButton(
                  style: OutlinedButton.styleFrom(backgroundColor: Colors.greenAccent),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK',style: TextStyle(color: Colors.white,fontSize: 15.0),));
              AlertDialog dialog = AlertDialog(
                title: Row(
                  children: [
                    Icon(Icons.insert_comment_outlined),
                    SizedBox(width: 5.0,),
                    Text('Information',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                  ],
                ),
                content: Text('Current Stock is Zero'),
                actions: [okbutton],
              );
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return dialog;
                  });
            }
            else
            {
              showDialog(context: context, builder: (context) => BsModal(context: context, dialog: BsModalDialog(
                size: BsModalSize.xxl,
                child: BsModalContent(
                    children: [
                      BsModalContainer(
                        title: Text('CurrentStock',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                        closeButton: true,
                      ),
                      BsModalContainer(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('PartNo : ',style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.bold),),
                                  Text('$PNO',style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                ],
                              ),
                              SizedBox(height: 10.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Category : ',style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.bold),),
                                  Text('$cat',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                ],
                              ),
                              SizedBox(height: 30.0,),
                              FutureBuilder(future: getStockDataSource_1(),builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot){
                                // print(snapshot.hasData);
                                return snapshot.hasData ?
                                Column(
                                  children: [
                                    SingleChildScrollView(
                                      child: SfDataGridTheme(data: SfDataGridThemeData(headerColor: const Color(0xff009889)),
                                        child: SfDataGrid(onQueryRowHeight: (details) {
                                          // Set the row height as 70 to the column header row.
                                          return details.rowIndex == 0 ? 50.0 : 60.0;
                                        },selectionMode: SelectionMode.single,columnWidthMode: ColumnWidthMode.auto,allowColumnsResizing: true,
                                          onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
                                            // setState(() {
                                            //   columnWidths[details.column.columnName] = details.width;
                                            // });
                                            return true;
                                          },
                                          allowPullToRefresh: true,source: snapshot.data,
                                          columns: getColumn_cs(),
                                          gridLinesVisibility: GridLinesVisibility.both,
                                          headerGridLinesVisibility: GridLinesVisibility.both,
                                          allowSorting: true,
                                          sortingGestureType: SortingGestureType.tap,
                                        ),
                                      ),
                                    ),
                                    tablelength_1 > 5 ?
                                    Container(
                                      padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                                      height: dataPagerHeight_1,
                                      child: SfDataPagerTheme(
                                        data: SfDataPagerThemeData(
                                          itemColor: Colors.white,
                                          selectedItemColor: Colors.green,
                                          itemBorderRadius: BorderRadius.circular(5),
                                          backgroundColor: Color(0xff009889),
                                        ),
                                        child: SfDataPager(
                                          delegate: snapshot.data,
                                          direction: Axis.horizontal,
                                          pageCount: tablelength_1/rowsperpage_1,
                                        ),
                                      ),):SizedBox(),
                                  ],
                                ): Center(child: Text('No data to display',style:  TextStyle(fontSize: 15.0),));
                              }),
                              SizedBox(height: 10.0,),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    OutlinedButton(
                                        style: OutlinedButton.styleFrom(backgroundColor: Colors.blueGrey),
                                        onPressed: ()  {
                                          GRID_POPUP_PDF();
                                        },
                                        child: Text('Export',style: TextStyle(color: Colors.white,fontSize: 15.0),)),
                                  ],
                                ),
                              )
                            ]
                        ),
                      ),
                    ]
                ),
              ),
              )
              );
            }
          },
        ),
      ),
      Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[3].value.toString(),
            overflow: TextOverflow.ellipsis,
          ))
    ]);
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRow() {
    dataGridRows = StockList.map<DataGridRow>((dataGridRow) {
      // print(dataGridRow);
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'PartNo', value: dataGridRow.PartNo),
        DataGridCell<String>(
            columnName: 'Category', value: dataGridRow.Category),
        DataGridCell<String>(columnName: 'CurrentStock', value: dataGridRow.CurrentStock),
        DataGridCell<String>(
            columnName: 'UOM', value: dataGridRow.UOM),
        DataGridCell<String>(
            columnName: 'Item', value: dataGridRow.Item)
      ]);
    }).toList(growable: false);
  }
}

class Stock {
  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      PartNo: json['PartNo'],
      Category: json['Category'],
      CurrentStock: json['CurrentStock'],
      UOM: json['UOM'],
      Item: json['Item'],
    );
  }
  Stock(
      { required this.PartNo,
        required this.Category,
        required this.CurrentStock,
        required this.UOM,
        required this.Item,
      });
  final String? PartNo;
  final String? Category;
  final String? CurrentStock;
  final String? UOM;
  final String? Item;

}

class StockDataSource extends DataGridSource {
  StockDataSource({required List StockData}) {
    _StockData = StockData
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'PartNo', value: "${e.PartNo}"),
      DataGridCell<String>(columnName: 'Category', value: "${e.Category}"),
      DataGridCell<String>(columnName: 'CurrentStock', value: "${e.CurrentStock}"),
      DataGridCell<String>(columnName: 'UOM', value: "${e.UOM}"),
      DataGridCell<String>(columnName: 'Item', value: "${e.Item}"),
    ]))
        .toList();
  }

  List<DataGridRow> _StockData = [];

  @override
  List<DataGridRow> get rows => _StockData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10.0),
            child: Text(e.value.toString()),
          );
        }).toList());
  }
}


// <--------------------------GRID POPUP--------------------------------->


class StockDataGridSource_1 extends DataGridSource {
  StockDataGridSource_1(this.StockList,this.context) {
    buildDataGridRow();
  }
  BuildContext context;

  late List<DataGridRow> dataGridRows;
  late List<Stock_1> StockList;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
        child: Text(
          row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Text(
          row.getCells()[1].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Text(
          row.getCells()[2].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
    ]);
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRow() {
    dataGridRows = StockList.map<DataGridRow>((dataGridRow) {
      // print(dataGridRow);
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'CoilNo', value: dataGridRow.CoilNo),
        DataGridCell<String>(columnName: 'Quantity', value: dataGridRow.Quantity),
        DataGridCell<String>(
            columnName: 'UOM', value: dataGridRow.UOM),
      ]);
    }).toList(growable: false);
  }
}

class Stock_1 {
  factory Stock_1.fromJson(Map<String, dynamic> json) {
    return Stock_1(
      CoilNo: json['CoilNo'],
      Quantity: json['Qty'],
      UOM: json['UOM'],
    );

  }

  Stock_1(
      { required this.CoilNo,
        required this.Quantity,
        required this.UOM,
      });
  final String? CoilNo;
  final String? Quantity;
  final String? UOM;
}

class StockDataSource_1 extends DataGridSource {
  StockDataSource_1({required List StockData}) {
    print("DataGridSource");
    _StockData = StockData
        .map<DataGridRow>((s) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'CoilNo', value: "${s.CoilNo}"),
      DataGridCell<String>(columnName: 'Quantity', value: "${int.parse(s.Qty)}"),
      DataGridCell<String>(columnName: 'UOM', value: "${s.UOM}"),
    ]))
        .toList();
  }

  List<DataGridRow> _StockData = [];

  @override
  List<DataGridRow> get rows => _StockData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((s) {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10.0),
            child: Text(s.value.toString()),
          );
        }).toList());
  }
}


// <--------------------------GRID PDF--------------------------------->

Future<void> GRID_PDF() async {
  print('hi');
  PdfDocument document = PdfDocument();
  // final page = document.pages.add();
  //
  // page.graphics.drawString('Welcome to PDF Succinctly!',
  //     PdfStandardFont(PdfFontFamily.helvetica, 30));

  // page.graphics.drawImage(
  //     PdfBitmap(await _readImageData('Pdf_Succinctly.jpg')),
  //     Rect.fromLTWH(0, 100, 440, 550));

  PdfGrid grid = PdfGrid();
  grid.style = PdfGridStyle(
      font: PdfStandardFont(PdfFontFamily.timesRoman, 20),
      cellPadding: PdfPaddings(left: 3, right: 2, top: 2, bottom: 2));

  grid.columns.add(count: 4);
  grid.headers.add(1);

  PdfGridRow header = grid.headers[0];
  header.cells[0].value = 'PartNo';
  header.cells[1].value = 'Category';
  header.cells[2].value = 'CurrentStock';
  header.cells[3].value = 'UOM';

  var url_1;
  url_1 = "https://apiaspl.larch.in/Home/FetchCurrentStock";
  var response = await http.get(Uri.parse(url_1));
  var data_2 = jsonDecode(response.body);
  for(int i=0;i<data_2.length;i++)
  {
    PdfGridRow row = grid.rows.add();
    row.cells[0].value = '${data_2[i]['PartNo']}';
    row.cells[1].value = '${data_2[i]['Category']}';
    row.cells[2].value = '${data_2[i]['CurrentStock']}';
    row.cells[3].value = '${data_2[i]['UOM']}';
  }

  grid.draw(
      page: document.pages.add(), bounds: const Rect.fromLTWH(0, 0, 0, 0));

  List<int> bytes = document.saveSync();
  document.dispose();

  saveAndLaunchFile(bytes, 'Current Stock.pdf');
}


Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  final path = (await getApplicationDocumentsDirectory()).path;
  final file = File('$path/$fileName');
  await file.writeAsBytes(bytes, flush: true);
  OpenFile.open('$path/$fileName');

}


// <--------------------------GRID POPUP PDF--------------------------------->


Future<void> GRID_POPUP_PDF() async {
  print('hi');
  PdfDocument document = PdfDocument();
  // final page = document.pages.add();
  //
  // page.graphics.drawString('Welcome to PDF Succinctly!',
  //     PdfStandardFont(PdfFontFamily.helvetica, 30));

  // page.graphics.drawImage(
  //     PdfBitmap(await _readImageData('Pdf_Succinctly.jpg')),
  //     Rect.fromLTWH(0, 100, 440, 550));

  PdfGrid grid = PdfGrid();
  grid.style = PdfGridStyle(
      font: PdfStandardFont(PdfFontFamily.timesRoman, 20),
      cellPadding: PdfPaddings(left: 3, right: 2, top: 2, bottom: 2));

  grid.columns.add(count: 3);
  grid.headers.add(1);

  PdfGridRow header = grid.headers[0];
  header.cells[0].value = 'CoilNo';
  header.cells[1].value = 'Quantity';
  header.cells[2].value = 'UOM';


  var url_2;
  url_2 = "https://apiaspl.larch.in/Home/FetchCurrentStock_PopUp?ItemId=${INo}";
  var response = await http.get(Uri.parse(url_2));
  var data_2 = jsonDecode(response.body);
  for(int i=0;i<data_2.length;i++)
  {
    PdfGridRow row = grid.rows.add();
    row.cells[0].value = '${data_2[i]['CoilNo']}';
    row.cells[1].value = '${data_2[i]['Qty']}';
    row.cells[2].value = '${data_2[i]['UOM']}';
  }

  grid.draw(
      page: document.pages.add(), bounds: const Rect.fromLTWH(0, 0, 0, 0));

  List<int> bytes = document.saveSync();
  document.dispose();

  saveAndLaunchFile(bytes, 'Current Stock.pdf');
}


Future<void> saveAndLaunchFile_1(List<int> bytes, String fileName) async {
  final path = (await getApplicationDocumentsDirectory()).path;
  final file = File('$path/$fileName');
  await file.writeAsBytes(bytes, flush: true);
  OpenFile.open('$path/$fileName');

}
