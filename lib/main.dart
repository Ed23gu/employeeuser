import 'package:flutter/material.dart';
void main(){
  runApp(new MaterialApp(
    home: new myApp(),
  ));
}
class myApp extends StatefulWidget{
  @override
  _State createState()=>new _State();
}
class _State extends State<myApp>{
  Choice _selectedOption=choices[0];
  void _select(Choice choice){
    setState(() {
      _selectedOption=choice;
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Hello"),
        actions: [
          PopupMenuButton(
            onSelected: _select,
            itemBuilder: (BuildContext context){
              return choices.skip(0).map((Choice choice){
                return PopupMenuItem<Choice>(child: Text(choice.name),value: choice,);
              }).toList();
            },
          ),
        ],

      ),body: Padding(
      padding: EdgeInsets.all(15.0),
      child: ChoiceCard(
        choice: _selectedOption,
      ),
    ),

    );
  }
}
class Choice{
  const Choice({this.name,this.icon});
  final String name;
  final IconData icon;
}
const List<Choice>choices=const <Choice>[
  const Choice(name: "Wifi",icon: Icons.wifi),
  const Choice(name:"Bluetooth",icon:Icons.bluetooth),
  const Choice(name:"Storage",icon:Icons.storage),
];
class ChoiceCard extends StatelessWidget{
  final Choice choice;
  const ChoiceCard({Key key,this.choice}):super(key: key);
  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle=Theme.of(context).textTheme.headline;
    return Card(
      color: Colors.blue,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              choice.icon,size: 114.0,
            ),Text(choice.name),
          ],
        ),
      ),
    );

  }

}