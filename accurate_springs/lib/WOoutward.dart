import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;

import 'CurrentStock.dart';
import 'Login.dart';
import 'NewWO.dart';

class WOoutward extends StatefulWidget {
  const WOoutward({Key? key}) : super(key: key);

  @override
  State<WOoutward> createState() => _WOoutwardState();
}

class _WOoutwardState extends State<WOoutward> {

  var bar=TextEditingController();
  var s;
  var WODate  ;
  var PNo ;
  var Mac ;
  var Op ;
  var Rkg ;
  var Ikg ;
  var IId ;
  var result;
  var r;
  var LSB;
  var RMD;
  var Quan;
  var sup;
  var TCN;
  var HNO;
  var LNO;

  BsSelectBoxController WorkOrderNo = BsSelectBoxController();

  void WorkOrderNo_1 () async {
    var url="https://apiaspl.larch.in/Home/FetchWorkOrder";
    var response=await http.get(Uri.parse(url));
    var data= jsonDecode(response.body);
    WorkOrderNo.setOptions([
      for(int i=0;i<data.length;i++)
        BsSelectBoxOption(value: data[i]['Id'], text: Text('${data[i]['Value']}'))
    ]);
  }

  void WODetails () async {
    result = WorkOrderNo.getSelected()!.getValue().substring(0, WorkOrderNo.getSelected()!.getValue().indexOf('/'));
    var url2="https://apiaspl.larch.in/Home/FetchWoDetails?WoNo=${result}";
    var response=await http.get(Uri.parse(url2));
    var data_1= jsonDecode(response.body);
    // print(response.body);
    for(int i=0;i<data_1.length;i++) {
      setState(() {
        WODate = '${data_1[i]['WODT']}';
        PNo = '${data_1[i]['PartNo']}';
        Mac = '${data_1[i]['Machine']}';
        Op = '${data_1[i]['Operator']}';
        Rkg = '${data_1[i]['RequestKG']}';
        Ikg = '${data_1[i]['IssuedKG']}';
        IId = '${data_1[i]['ItemId']}';
      });
    }
    RM_1();
  }

  BsSelectBoxController RM = BsSelectBoxController();

  void RM_1() async {
    var url3="https://apiaspl.larch.in/Home/FetchRM?ItemId=${IId}";
    var response=await http.get(Uri.parse(url3));
    var data_2= jsonDecode(response.body);
    RM.setOptions([
      for(int i=0;i<data_2.length;i++)
        BsSelectBoxOption(value: data_2[i]['Id'], text: Text('${data_2[i]['Value']}'))
    ]);
    setState(() {
      r = RM.getSelected()!.getValue();
    });
  }

  void ScanRes() async {
    var url3 = "https://apiaspl.larch.in/Home/FetchBarcodeDetails?Barcode=${bar.text}&ItemId=$IId";
    var response = await http.get(Uri.parse(url3));
    // print(response.body);
    var data_3 = jsonDecode(response.body);
    for (int j=0;j<data_3.length;j++)
    {
      setState(() {
        LSB = '${data_3[j]['UniqueBarcode']}';
        RMD = '${data_3[j]['PartNo']}';
        Quan = '${data_3[j]['Qty']}';
        sup = '${data_3[j]['Supplier']}';
        TCN = '${data_3[j]['TCNo']}';
        HNO = '${data_3[j]['HeatNo']}';
        LNO = '${data_3[j]['LotNo']}';
      });
    }
    Outward();
  }

  void Outward () async {
    var url4 = "https://apiaspl.larch.in/Home/Outward?Coil=${bar.text}&ItemId=$IId&WONo=${result}&CreatedBy=$um_id";
    var response = await http.get(Uri.parse(url4));
    var data_4 = jsonDecode(response.body);
    for(int i=0;i<data_4.length;i++)
    {
      if(data_4[i]['Success'] != '')
      {
        Widget okbutton = OutlinedButton(
            style: OutlinedButton.styleFrom(backgroundColor: Colors.greenAccent),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK',style: TextStyle(color: Colors.white,fontSize: 15.0),));
        AlertDialog dialog = AlertDialog(
          title: Text('outward'),
          content: Text('${data_4[i]['Success']}'),
          actions: [okbutton],
        );
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return dialog;
            });
      }
      else{

        Widget okbutton = OutlinedButton(
            style: OutlinedButton.styleFrom(backgroundColor: Colors.greenAccent),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK',style: TextStyle(color: Colors.white,fontSize: 15.0),));
        AlertDialog dialog = AlertDialog(
          title: Text('Error'),
          content: Text('${data_4[i]['Errors']}'),
          actions: [okbutton],
        );
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return dialog;
            });
      }
    }
  }

  @override
  void initState() {
    WODate = '';
    PNo = '' ;
    Mac = '';
    Op = '';
    Rkg = '';
    Ikg = '';
    IId = '';
    LSB = '';
    RMD = '';
    Quan = '';
    sup ='';
    TCN = '';
    HNO = '';
    LNO = '';
    WorkOrderNo_1 ();
    super.initState();
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
    }
    on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    setState(() {
      bar.text = barcodeScanRes;
    });
    ScanRes();
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
              onTap: () {
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
                    'Work Order Outward',style: TextStyle(
                    color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15.0,
                  ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.0,),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        child: Text('Work Oreder No : '),
                        alignment: Alignment.topLeft,
                      ),
                      Flexible(child:  BsSelectBox(
                        hintText: 'select work oder no',
                        // searchable: true,
                        controller: WorkOrderNo,
                        onClose: () => WODetails (),
                      ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 30.0,),
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Align(
                        child: Text('WO Date : ',style: TextStyle(color: Colors.green,fontSize: 15.0,fontWeight: FontWeight.bold),),
                        alignment: Alignment.topLeft,
                      ),
                      Text('$WODate'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.0,),
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Align(
                        child: Text('Part No : ',style: TextStyle(color: Colors.green,fontSize: 15.0,fontWeight: FontWeight.bold),),
                        alignment: Alignment.topLeft,
                      ),
                      Text('$PNo'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.0,),
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Align(
                        child: Text('Machine : ',style: TextStyle(color: Colors.green,fontSize: 15.0,fontWeight: FontWeight.bold),),
                        alignment: Alignment.topLeft,
                      ),
                      Text('$Mac'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.0,),
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Align(
                        child: Text('Operator : ',style: TextStyle(color: Colors.green,fontSize: 15.0,fontWeight: FontWeight.bold),),
                        alignment: Alignment.topLeft,
                      ),
                      Text('$Op'),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 5.0,),
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Align(
                        child: Text('Requested KG : ',style: TextStyle(color: Colors.green,fontSize: 15.0,fontWeight: FontWeight.bold),),
                        alignment: Alignment.topLeft,
                      ),
                      Text('$Rkg'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.0,),
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Align(
                        child: Text('Issued KG :',style: TextStyle(color: Colors.green,fontSize: 15.0,fontWeight: FontWeight.bold),),
                        alignment: Alignment.topLeft,
                      ),
                      Text('$Ikg'),

                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.0,),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        child: Text('RM : '),
                        alignment: Alignment.topLeft,
                      ), Flexible(child:  BsSelectBox(
                        hintText: 'select RM',
                        // searchable: true,
                        controller: RM,
                      ),),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 30.0,),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 70, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        child: Text('Barcode No : '),
                        alignment: Alignment.topLeft,
                      ),
                      Flexible(child: TextFormField(
                        controller: bar,
                        readOnly: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder()
                        ),
                      )),
                      SizedBox(width: 15.0,),
                      IconButton(onPressed: () => scanQR(),
                          icon: Icon(Icons.camera_alt_outlined)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.0,),
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Align(
                        child: Text('Last Scanned Barcode : ',style: TextStyle(color: Colors.green,fontSize: 12.0,fontWeight: FontWeight.bold),),
                        alignment: Alignment.topLeft,
                      ),
                      Text('$LSB'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.0,),
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: Column(
                children: [
                  Row(children: [
                    Align(
                      child: Text('RM Dia : ',style: TextStyle(color: Colors.green,fontSize: 15.0,fontWeight: FontWeight.bold),),
                      alignment: Alignment.topLeft,
                    ),
                    Text('$RMD'),
                  ],),
                ],
              ),
            ),
            SizedBox(height: 5.0,),
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Align(
                        child: Text('Quantity : ',style: TextStyle(color: Colors.green,fontSize: 15.0,fontWeight: FontWeight.bold),),
                        alignment: Alignment.topLeft,
                      ),
                      Text('$Quan'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.0,),
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Align(
                        child: Text('Supplier : ',style: TextStyle(color: Colors.green,fontSize: 15.0,fontWeight: FontWeight.bold),),
                        alignment: Alignment.topLeft,
                      ),
                      Text('$sup')
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.0,),
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Align(
                        child: Text('TC No : ',style: TextStyle(color: Colors.green,fontSize: 15.0,fontWeight: FontWeight.bold),),
                        alignment: Alignment.topLeft,
                      ),
                      Text('$TCN'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.0,),
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Align(
                        child: Text('Heat No : ',style: TextStyle(color: Colors.green,fontSize: 15.0,fontWeight: FontWeight.bold),),
                        alignment: Alignment.topLeft,
                      ),
                      Text('$HNO'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.0,),
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Align(
                        child: Text('LOT No : ',style: TextStyle(color: Colors.green,fontSize: 15.0,fontWeight: FontWeight.bold),),
                        alignment: Alignment.topLeft,
                      ),
                      Text('$LNO'),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ), onWillPop: () async => true);
  }
}
