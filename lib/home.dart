import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final scrollController=ScrollController();
  bool isLoading= false;
  List posts=[];
  int page=1;
  @override
  void initState(){
    super.initState();
    scrollController.addListener(_scrollListener);
    fetchPosts();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('pagination'),
        centerTitle: true,
      ),
      body: ListView.builder(
        controller: scrollController,
        itemCount: isLoading? posts.length+1 : posts.length,
          itemBuilder: (context,index){
         if(index < posts.length){
           final post=posts[index];
           final title=post['title']['rendered'];
           final author= post['author'];
           return ListTile(
             leading: CircleAvatar(child: Text('${index + 1}'),),
             title: Text('$title'),
             subtitle: Text('$author'),
           );
         }else{
           return Center(child:  CircularProgressIndicator(),);
         }
      }
      ),
    );
  }

  Future<void> fetchPosts()async{
    final url= 'https://techcrunch.com/wp-json/wp/v2/posts?context=embed&per_page=10&page=$page';
print('$url');
    final uri= Uri.parse(url);

    final response=await http.get(uri);

    if(response.statusCode==200){
final json=jsonDecode(response.body) as List;
setState(() {
  posts= posts+json;
});
    }else{

    }
  }
  Future <void> _scrollListener() async{
    if(scrollController.position.pixels==scrollController.position.maxScrollExtent){
      setState(() {
        isLoading=true;
      });
      page = page+1;
      await fetchPosts();
      setState(() {
        isLoading=false;
      });
    }
  }
}
