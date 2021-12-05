import 'package:flutter/material.dart';


class HeadearLista extends StatelessWidget {
  final List<String> items;

  HeadearLista({required this.data, required this.totalAmountSpent});
 
  @override
  Widget build(BuildContext context){
    return Container(
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index){
          return ListTile(
            title: Text(items[index]),
          );
        })
      );
    )
  }
}
