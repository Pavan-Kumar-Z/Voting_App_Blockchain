import 'package:flutter/material.dart';
import 'package:http/http.dart';
//import 'package:voting_app/pages/electioninfo.dart';
import 'package:voting_app/pages/electioninfo1.dart';
import 'package:voting_app/services/functions.dart';
import 'package:voting_app/utils/constants.dart';
import 'package:web3dart/web3dart.dart';

class Home1 extends StatefulWidget {
  const Home1({super.key});

 // @override
  Widget build (BuildContext context)
  {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
    );
  }
  State<Home1> createState() => _HomeState();
}

class _HomeState extends State<Home1> {
  Client? httpClient  ;
  Web3Client? ethClient ;
  TextEditingController controller = TextEditingController() ;
  @override
  void initState() {
    // TODO: implement initState
    httpClient = Client() ;
    ethClient = Web3Client(infura_url, httpClient!) ; 
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Election'),
      ),
      body: Container(
        padding: EdgeInsets.all(14) ,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                filled: true,
                hintText: 'Enter election name' 
              ),
            ),
            SizedBox(height :10,) ,
            Container(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(onPressed: () async{
                if(controller.text.length > 0){
                  await startElection(controller.text, ethClient!) ;
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ElectionInfo1(ethClient: ethClient!, electionName: controller.text)));
                }
              },child: Text('Enter'),),
              )
          ],
        )
      ),
    );
  }
}