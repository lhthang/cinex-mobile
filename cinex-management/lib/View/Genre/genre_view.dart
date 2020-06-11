import 'package:cinex_management/Controller/GenreController/genre_controller.dart';
import 'package:cinex_management/Model/Genre/genre.dart';
import 'package:flutter/material.dart';
import 'package:cinex_management/route/route_path.dart' as routes;
import 'package:cinex_management/utils/theme.dart' as theme;
import 'package:cinex_management/dialog/dialog.dart' as dialog;

class GenreView extends StatefulWidget {
  @override
  _GenreViewState createState() => _GenreViewState();
}

class _GenreViewState extends State<GenreView> {

  String searchKey = "";
  Future<List<Genre>> genresList = GenreController.instance.getAllGenres();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _buildSearchBar(),
          SizedBox(
            height: 10,
          ),
          Expanded(child: _buildData(genresList)),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
              color: Color.fromARGB(180, 38, 54, 70).withOpacity(0.2))),
      margin: EdgeInsets.only(top: 10.0, bottom: 2.0, left: 7.0, right: 7.0),
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            child: new TextField(
              onChanged: (text) {
                setState(() {
                  searchKey = text;
                  genresList =
                      GenreController.instance.searchGenre(searchKey);
                });
              },
              onSubmitted: null,
              decoration: InputDecoration.collapsed(
                  hintText: "Enter name for search..."),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          RaisedButton(
            color: Colors.greenAccent,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Icon(
                  Icons.add,
                  color: Color.fromARGB(180, 38, 54, 70),
                  size: 19.0,
                ),
                new Text(
                  'Add',
                  style: TextStyle(
                      color: Color.fromARGB(180, 38, 54, 70),
                      fontFamily: 'Dosis',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
            onPressed: () async {
              await Navigator.of(context).pushNamed(routes.add_genre);
              setState(() {
                genresList= GenreController.instance.getAllGenres();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildData(Future<List<Genre>> genresList) {
    return FutureBuilder(
      future: genresList,
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            padding: EdgeInsets.only(left: 5, right: 5),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return _renderGenre(snapshot.data[index]);
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  _renderGenre(Genre genre){
    return Card(
      elevation: 1.25,
      child: ListTile(
        leading: Icon(
          Icons.view_comfy,
          size: 24,
        ),
        title: Text(genre.name,
          style: theme.mainTitle),
        subtitle: Text(genre.id,style: TextStyle(fontSize: 12),),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            InkWell(
              onTap: () async{
                await Navigator.pushNamed(context,routes.edit_genre,arguments: genre);
                setState(() {
                  genresList=GenreController.instance.getAllGenres();
                });
              },
              child: new Icon(
                Icons.edit,
                color: Colors.blueAccent,
                size: 24.0,
              ),
              borderRadius: BorderRadius.circular(17),
            ),
            SizedBox(width: 10,),
            InkWell(
              onTap: (){
                _deleteGenre(genre);
              },
              child: new Icon(
                Icons.delete,
                color: Colors.redAccent,
                size: 24.0,
              ),
              borderRadius: BorderRadius.circular(17),
            ),
          ],
        ),
      ),
    );
  }

  _deleteGenre(Genre genre){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Confirm', style: theme.titleStyle),
            content: new Text('Do you want to delete this screen type: ' + genre.name + '?',
                style: theme.contentStyle),
            actions: <Widget>[
              new FlatButton(
                  child: new Text('Ok', style: theme.okButtonStyle),
                  onPressed: () async {
                    /* Pop screens */
                    Navigator.of(context).pop();
                    if (await GenreController.instance.deleteGenre(genre.id)) {
                      setState(() {
                        genresList = GenreController.instance.getAllGenres();
                      });
                      dialog.showSuccessMessage(
                          this.context, "Success", "Deleted "+ genre.name+ " successfully!").show();
                    } else
                      dialog.showErrorMessage(this.context,"Error", 'Deleted failed.' + '\nPlease try again!').show();
                  }),
              new FlatButton(
                child: new Text('Cancel', style: theme.cancelButtonStyle),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
