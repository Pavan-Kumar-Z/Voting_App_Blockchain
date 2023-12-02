import 'package:flutter/material.dart';
import 'package:voting_app/services/functions.dart';
import 'package:web3dart/web3dart.dart'; 

class ElectionInfo1 extends StatefulWidget {

  final Web3Client ethClient ;
  final String electionName ;
  const ElectionInfo1({Key? key,required this.ethClient, required this.electionName}):super(key: key) ; 

  @override
  State<ElectionInfo1> createState() => _ElectionInfoState();
}

class _ElectionInfoState extends State<ElectionInfo1> {
  TextEditingController addCandidateController = TextEditingController() ;
  TextEditingController authorizevoterController = TextEditingController() ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.electionName),
      ),body:Container(
        padding: EdgeInsets.all(14),
        child: Column(
          children: [
            SizedBox(height :20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    FutureBuilder<List>(
                      future: getCandidateNum(widget.ethClient),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting)
                        {
                          return Center(
                            child:  CircularProgressIndicator(),
                          );
                        }
                        return Text(
                        snapshot.data![0].toString(),
                        style: TextStyle(
                          fontSize: 50 ,
                          fontWeight: FontWeight.bold
                        ),);
                      }
                    ),
                    Text('Total Candidates')
                  ],
                ),
                Column(
                  children: [
                    FutureBuilder<List>(
                      future: getTotalvotes(widget.ethClient),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting)
                        {
                          return Center(
                            child:  CircularProgressIndicator(),
                          );
                        }
                        return Text(
                        snapshot.data![0].toString(),
                        style: TextStyle(
                          fontSize: 50 ,
                          fontWeight: FontWeight.bold
                        ),);
                      }
                    ),
                    Text('Total votes')
                  ],
                )
              ],
            ),

            // SizedBox(height: 20,),
            // Row(
            //   children: [
            //     Expanded(
            //       child: TextField(
            //         controller: addCandidateController ,
            //         decoration: InputDecoration(hintText: 'Enter Candidate Name') ,
            //       ),
            //     ),
            //     ElevatedButton(onPressed: (){addCandidate(addCandidateController.text, widget.ethClient);},
            //      child: Text('Add Candidate'))
            //   ],
            // ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: TextField(
            //         controller: authorizevoterController ,
            //         decoration: InputDecoration(hintText: 'Enter voter address') ,
            //       ),
            //     ),
            //     ElevatedButton(onPressed: (){authorizeVoter(authorizevoterController.text, widget.ethClient);},
            //      child: Text('Authorize voter'))
            //   ],
            // ),

            Divider(),
            FutureBuilder<List>(future: getCandidateNum(widget.ethClient),
            builder: (context, snapshot) 
            {
              if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
              }
              else{
                return Column(
                  children: [
                    for(int i =0 ; i<snapshot.data![0].toInt();i++)
                    FutureBuilder<List>(future: candidateInfo(i, widget.ethClient),
                    builder: (context , candidatesnapshot){
                      if (candidatesnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                     else {
                                return ListTile(
                                  title: Text('Name: ' +
                                      candidatesnapshot.data![0][0].toString()),
                                  subtitle: Text('Votes: ' +
                                      candidatesnapshot.data![0][1].toString()),
                                  trailing: ElevatedButton(
                                      onPressed: () {
                                        vote(i, widget.ethClient);
                                      },
                                      child: Text('Vote')),
                                );
                              }
                    }
                    )
                  ],
                );
              }
              
            
            }
            )
          ],
        ),
      ) ,
    );
  }
}