import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';

import 'CurrentStock.dart';
import 'Login.dart';
import 'WOoutward.dart';


class NewWO extends StatefulWidget {
  const NewWO({Key? key}) : super(key: key);

  @override
  State<NewWO> createState() => _NewWOState();
}

class _NewWOState extends State<NewWO> {

  var date = TextEditingController();
  var formatter = DateFormat('dd/MM/yyyy');
  var pqty=TextEditingController();
  var aspl=TextEditingController();

  BsSelectBoxController Item = BsSelectBoxController(
      options: [
        BsSelectBoxOption(value: 1, text: Text('1')),
        BsSelectBoxOption(value: 2, text: Text('2')),
        BsSelectBoxOption(value: 3, text: Text('3')),
      ]
  );

  BsSelectBoxController Operator = BsSelectBoxController(
      options: [
        BsSelectBoxOption(value: 1, text: Text('1')),
        BsSelectBoxOption(value: 2, text: Text('2')),
        BsSelectBoxOption(value: 3, text: Text('3')),
      ]
  );

  BsSelectBoxController Machine = BsSelectBoxController(
      options: [
        BsSelectBoxOption(value: 1, text: Text('1')),
        BsSelectBoxOption(value: 2, text: Text('2')),
        BsSelectBoxOption(value: 3, text: Text('3')),
      ]
  );

  @override
  void initState() {
    // TODO: implement initState
    date.text = formatter.format(DateTime.now()).toString();
    super.initState();
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
                    'New Work Order',style: TextStyle(
                    color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15.0,
                  ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50.0,),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        child: Text('Date : '),
                        alignment: Alignment.topLeft,
                      ), Flexible(child: TextFormField(
                        controller: date,
                        readOnly: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder()
                        ),
                      )),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        child: Text('Item : '),
                        alignment: Alignment.topLeft,
                      ),
                      Flexible(child: BsSelectBox(
                        hintText: 'select Item',
                        searchable: true,
                        controller: Item,
                      ),),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        child: Text('Operator : '),
                        alignment: Alignment.topLeft,
                      ),
                      Flexible(child: BsSelectBox(
                        hintText: 'select Operator',
                        searchable: true,
                        controller: Operator,
                      ),),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        child: Text('Machine : '),
                        alignment: Alignment.topLeft,
                      ),
                      Flexible(child: BsSelectBox(
                        hintText: 'select Machine',
                        searchable: true,
                        controller: Machine,
                      ),),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        child: Text('Plan Qty : '),
                        alignment: Alignment.topLeft,
                      ),
                      Flexible(child: TextFormField(
                        controller: pqty,
                        decoration: InputDecoration(
                            border: OutlineInputBorder()
                        ),
                      )),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        child: Text('ASPL MIR No : '),
                        alignment: Alignment.topLeft,
                      ),
                      Flexible(child: TextFormField(
                        controller: aspl,
                        decoration: InputDecoration(
                            border: OutlineInputBorder()
                        ),
                      )),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 40.0,),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(onPressed: (){}, child: Text('Save')),
                  SizedBox(width: 5.0,),
                  OutlinedButton(onPressed: (){}, child: Text('Clear'))
                ],
              ),
            )
          ],
        ),
      ),
    ), onWillPop: () async => true);
  }
}
