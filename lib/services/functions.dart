import 'package:flutter/services.dart';
import 'package:voting_app/utils/constants.dart';
import 'package:web3dart/web3dart.dart'; 

Future<DeployedContract> loadcontract() async {
  String abi = await rootBundle.loadString('assets/abi.json') ;
  String contractAddress = contractaddress1 ;
  final contract = DeployedContract(ContractAbi.fromJson(abi, 'Election'), EthereumAddress.fromHex(contractAddress)) ;

  return contract ;
}


Future<String> callFunction(String funcname, List<dynamic>args,Web3Client ethClient , String privatekey)async
{
EthPrivateKey credentials = EthPrivateKey.fromHex(privatekey);
DeployedContract contract = await loadcontract() ;

final ethFunction = contract.function(funcname) ;
final result = await ethClient.sendTransaction(credentials, Transaction.callContract(contract: contract, function: ethFunction, parameters: args),
chainId: null ,
fetchChainIdFromNetworkId: true 
);

return result ;
}

Future<String> startElection(String name , Web3Client ethClient) async{

var response = await callFunction('startElection',[name] , ethClient, owner_private_key) ;
print('Election Started Succesfully') ;

return response ;

}

Future<String> addCandidate(String name , Web3Client ethClient) async{

var response = await callFunction('addCandidate',[name] , ethClient, owner_private_key) ;
print('Candidate added Succesfully') ;

return response ;

}

Future<String> authorizeVoter(String address , Web3Client ethClient) async{

var response = await callFunction('authorizeVoter',[EthereumAddress.fromHex(address)] , ethClient, owner_private_key) ;
print('Voter Authorized Succesfully') ;

return response ;

}

Future<List>getCandidateNum(Web3Client ethClient)async{

  List<dynamic> result = await ask('getNumCandidates',[],ethClient) ;
  return result ;
}

Future<List<dynamic>>ask(String funcname , List<dynamic>args , Web3Client ethClient)async{

  final contract = await loadcontract() ;
  final ethFunction = contract.function(funcname) ;
  final result = ethClient.call(contract: contract, function: ethFunction, params: args) ;
  return result ;

}

Future<String> vote(int CandidateIndex , Web3Client ethClient )async{

  var response = await callFunction("vote", [BigInt.from(CandidateIndex)], ethClient, voter_private_key) ;
  print("Vote counted successfully") ;
  return response ;
}

Future<List>getTotalvotes(Web3Client ethClient)async{

  List<dynamic> result = await ask('getTotalVotes',[],ethClient) ;
  return result ;
}

Future<List> candidateInfo(int index, Web3Client ethClient) async {
  List<dynamic> result =
      await ask('candidateInfo', [BigInt.from(index)], ethClient);
  return result;
}