
import 'package:haber_portal/services/crud.dart';
import 'package:haber_portal/views/create_news.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CrudMethods crudMethods = new CrudMethods();

   QuerySnapshot newsSnapshot;

  @override
  void initState() {
    crudMethods.getData().then((result)
    {
      newsSnapshot = result;
      setState(() {
        
      });
    });
    super.initState();
  }
    Widget newsList() {
      return Container(child: ListView.builder(padding: EdgeInsets.only(top: 24),
      itemCount: newsSnapshot.docs.length,  itemBuilder: (context, index) {
        return NewsTile(
          author: newsSnapshot.docs[index].get('author'),
          title : newsSnapshot.docs[index].get('title'),
          desc: newsSnapshot.docs[index].get('desc'),
          imgUrl: newsSnapshot.docs[index].get('imgUrl'),
        );
      },
      ),
      );
    }



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Spor Haber"),
        ),
        body:  Container( child: newsSnapshot != null ? newsList(): 
        Container(child: Center(child: CircularProgressIndicator()))),
        floatingActionButton: FloatingActionButton(
          child:  Icon(Icons.add),
          onPressed:  () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateNews()));
          },

        ),
        );
  }
}   
 
  class NewsTile extends StatelessWidget {
    final String imgUrl, title, desc, author;
    NewsTile(
      {@required this.author,
      @required this.desc,
      @required this.imgUrl,
      @required this.title});

   @override
   Widget build(BuildContext context) {
     return Container(
       margin: EdgeInsets.only(bottom: 24, right: 16),
       child:  Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Container(child: ClipRRect(
             borderRadius: BorderRadius.all(Radius.circular(8)),
             child: Image.network(
               imgUrl,
               width: MediaQuery.of(context).size.width,
               fit: BoxFit.cover,
               height: 200,
             ),
           ),
           ),
           SizedBox(height: 16),
           Text(
             title,
             style: TextStyle(fontSize: 17),

           ),
           SizedBox(height: 2),
           Text(
             '$desc - By $author',
             style: TextStyle(fontSize: 14),
           )
         ],
       ),
     );
   }
    

  }