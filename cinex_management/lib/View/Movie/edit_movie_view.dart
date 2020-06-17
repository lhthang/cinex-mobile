import 'package:cinex_management/Controller/GenreController/genre_controller.dart';
import 'package:cinex_management/Controller/MovieController/movie_controller.dart';
import 'package:cinex_management/Controller/RateController/rate_controller.dart';
import 'package:cinex_management/Controller/ScreenTypeController/screentype_controller.dart';
import 'package:cinex_management/Model/Genre/genre.dart';
import 'package:cinex_management/Model/Movie/movie.dart';
import 'package:cinex_management/Model/Movie/movie_req.dart';
import 'package:cinex_management/Model/Rate/rate.dart';
import 'package:cinex_management/Model/ScreenType/screentype.dart';
import 'package:cinex_management/View/custom_checkbox_group.dart';
import 'package:cinex_management/View/custom_selection_group.dart';
import 'package:cinex_management/utils/func.dart';
import 'package:cinex_management/utils/theme.dart';
import 'package:cinex_management/dialog/dialog.dart' as dialog;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EditMovieView extends StatefulWidget {
  final Movie movie;

  EditMovieView({Key key, @required this.movie}): super(key: key);
  @override
  _EditMovieViewState createState() => _EditMovieViewState();
}

class _EditMovieViewState extends State<EditMovieView> {

  TextEditingController _idController = new TextEditingController();
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _wallpaperController = new TextEditingController();

  Future<List<ScreenType>> screenTypesList = ScreenTypeController.instance.getAllScreenTypes();
  Future<List<Rate>> ratesList = RateController.instance.getAllRates();
  Future<List<Genre>> genresList = GenreController.instance.getAllGenres();

  Rate selectedRate =new Rate();
  DateTime selectedDate;

  var future ;
  List<Genre> selectedGenres = new List();
  List<ScreenType> selectedScreenTypes = new List();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
    //print(selectedDate.toIso8601String());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _idController.text=widget.movie.id;
    _titleController.text=widget.movie.title;
    selectedRate=widget.movie.rate;
    selectedScreenTypes=widget.movie.screenTypes;
    selectedGenres=widget.movie.genres;
    _wallpaperController.text=widget.movie.wallpaper;
    selectedDate = DateTime.tryParse(widget.movie.endAt);
    future = Future.wait([screenTypesList,ratesList,genresList]);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Movie"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
            future: future,
            builder: (context,snapshot){
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                List<Rate> rateList= snapshot.data[1];
                List<ScreenType> screenTypesList= snapshot.data[0];
                List<Genre> genreList= snapshot.data[2];
                return Container(
                  padding: EdgeInsets.all(10),
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      _buildID(),
                      _buildTitle(),
                      _createButtonSelectRate(rateList),
                      _createButtonSelectScreenType(screenTypesList),
                      _createEndAtButton(),
                      _createButtonSelectGenre(genreList),
                      _createWallpaper(),
                      _createWallpaperImage(),
                      _createButton(),
                    ],
                  ),
                );
              }
              return Center(child: CircularProgressIndicator());
            }
        ),
      ),
    );
  }

  _buildID(){
    return new TextField(
      controller: _idController,
      enabled: false,
      style: itemStyle,
      decoration: new InputDecoration(labelText: 'ID:', labelStyle: itemStyle2),
    );
  }

  _buildTitle() {
    return new TextField(
      controller: _titleController,
      style: itemStyle,
      decoration: new InputDecoration(labelText: 'Title:', labelStyle: itemStyle2),
    );
  }

  _createButtonSelectRate(List<Rate> ratesList){
    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Container(
              height: 30,
              child: Material(
                elevation: 1.25,
                borderRadius:  BorderRadius.circular(3),
                color: Colors.greenAccent,
                child: InkWell(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Icon(
                            Icons.arrow_drop_down
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text("Rate",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500) ,
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    _showRatesDialog(ratesList);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 6,
            child: Container(
              margin: const EdgeInsets.all(3.0),
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                border: Border.all(color: accentColor),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(selectedRate.name,style: TextStyle(fontWeight: FontWeight.w700),)),
            ),
          )
        ],
      ),
    );
  }

  _showRatesDialog(List<Rate> list){
    List<CustomCheckboxItem> options = list.map((item) {
      return CustomCheckboxItem(value: item.id, label: item.name);
    }).toList();

    String selectedItem= selectedRate.id;

    Rate _getSelectedRate() {
      return list.firstWhere((item) => item.id==selectedItem);
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Align(
              alignment: Alignment.center,
              child: Text("Select rate"),
            ),
            contentPadding: EdgeInsets.only(top: 12.0),
            content: StatefulBuilder(
              builder: (context,StateSetter stateSetter){
                return CustomCheckbox(
                  options: options,
                  initSelectedValue: selectedItem,
                  onChanged: (newSelectedId){
                    selectedItem = newSelectedId;
                  },
                );
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('CANCEL'),
                onPressed: (){
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('OK'),
                onPressed: (){
                  setState(() {
                    selectedRate=_getSelectedRate();
                  });
                  Navigator.of(context).pop(true);
                },
              )
            ],
          );
        });
  }

  _createButtonSelectScreenType(List<ScreenType> list){
    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Container(
              height: 30,
              child: Material(
                elevation: 1.25,
                borderRadius:  BorderRadius.circular(3),
                color: Colors.greenAccent,
                child: InkWell(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Icon(
                            Icons.arrow_drop_down
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text("Screen type",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500) ,
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    _showScreenTypesDialog(list);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 6,
            child: Wrap(
              direction: Axis.horizontal,
              children:  _buildScreenTypesOfMovie(selectedScreenTypes),
            ),
          )
        ],
      ),
    );
  }

  _showScreenTypesDialog(List<ScreenType> list){
    List<CustomSelectionItem> options = list.map((item) {
      return CustomSelectionItem(value: item.id, label: item.name);
    }).toList();

    List<String> selectedScreenTypeIds = selectedScreenTypes.map((item) {
      return item.id;
    }).toList();

    List<ScreenType> _getSelectedScreenTypes() {
      return list.where((item) => selectedScreenTypeIds.contains(item.id)).toList();
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Align(
              alignment: Alignment.center,
              child: Text("Select your screen type"),
            ),
            contentPadding: EdgeInsets.only(top: 12.0),
            content: CustomSelectionGroup(
              options: options,
              initialSelectedValues: selectedScreenTypeIds,
              onChanged: (newSelectedIds) {
                print(newSelectedIds);
                selectedScreenTypeIds = List.from(newSelectedIds);
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('CANCEL'),
                onPressed: (){
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('OK'),
                onPressed: (){
                  setState(() {
                    //previousValues= new Map.from(values);
                    selectedScreenTypes=_getSelectedScreenTypes();
                  });
                  Navigator.of(context).pop(true);
                },
              )
            ],
          );
        });
  }

  _buildScreenTypesOfMovie(List<ScreenType> screenTypesList){
    List<Widget> list = new List();
    if (screenTypesList.length>3){
      for(int i=0;i<3;i++){
        list.add(_buildScreenType(screenTypesList[i]));
      }
      list.add(_buildScreenType(new ScreenType(name: "...")));
      return list;
    }
    for (var screenType in screenTypesList){
      list.add(_buildScreenType(screenType));
    }
    return list;
  }

  _buildScreenType(ScreenType screenType){
    return Container(
      margin: const EdgeInsets.all(3.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(color: accentColor),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(screenType.name),
    );
  }

  _createWallpaper() {
    return TextField(
      controller: _wallpaperController,
      style: TextStyle(
          color: fontColor, fontFamily: 'Dosis', fontSize: 16.0, fontWeight: FontWeight.w500),
      decoration: new InputDecoration(hintText:"http:/..",labelText: 'Wallpaper:', labelStyle: TextStyle(
          color: accentColor, fontFamily: 'Dosis', fontSize: 18.0, fontWeight: FontWeight.w500)),
      onChanged: (text){
        setState(() {
          _wallpaperController.text=text;
        });
      },
    );
  }

  _createWallpaperImage() {
    return Container(
      padding: EdgeInsets.only(top:15,left: 20,right: 20),
      child: Image.network(_wallpaperController.text,fit: BoxFit.cover,
        loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            padding: EdgeInsets.only(top: 10),
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null ?
                loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }

  _createEndAtButton() {
    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Container(
              height: 30,
              child: Material(
                elevation: 1.25,
                borderRadius:  BorderRadius.circular(3),
                color: Colors.greenAccent,
                child: InkWell(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Icon(
                            Icons.calendar_today
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text("End at",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500) ,
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    _selectDate(context);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 6,
            child: _buildDate(selectedDate),
          )
        ],
      ),
    );
  }

  _buildDate(DateTime dateTime){
    return Container(
      margin: const EdgeInsets.all(3.0),
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        border: Border.all(width:2,color: Colors.redAccent),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Text(formatDateFromString(selectedDate.toIso8601String())),
    );
  }

  _createButtonSelectGenre(List<Genre> list){
    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Container(
              height: 30,
              child: Material(
                elevation: 1.25,
                borderRadius:  BorderRadius.circular(3),
                color: Colors.greenAccent,
                child: InkWell(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Icon(
                            Icons.arrow_drop_down
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text("Genre",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500) ,
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    _showGenresDialog(list);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 6,
            child: Wrap(
              direction: Axis.horizontal,
              children:  _buildGenresOfMovie(selectedGenres),
            ),
          )
        ],
      ),
    );
  }

  _buildGenresOfMovie(List<Genre> genresList){
    List<Widget> list = new List();
    if (genresList.length>=3){
      for(int i=0;i<2;i++){
        list.add(_buildGenre(genresList[i]));
      }
      list.add(_buildGenre(new Genre(name: "...")));
      return list;
    }
    for (var genre in genresList){
      list.add(_buildGenre(genre));
    }
    return list;
  }

  _buildGenre(Genre screenType){
    return Container(
      margin: const EdgeInsets.all(3.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(color: accentColor),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(screenType.name),
    );
  }

  _showGenresDialog(List<Genre> list){
    List<CustomSelectionItem> options = list.map((item) {
      return CustomSelectionItem(value: item.id, label: item.name);
    }).toList();

    List<String> selectedScreenTypeIds = selectedGenres.map((item) {
      return item.id;
    }).toList();

    List<Genre> _getSelectedGenres() {
      return list.where((item) => selectedScreenTypeIds.contains(item.id)).toList();
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Align(
              alignment: Alignment.center,
              child: Text("Select genre"),
            ),
            contentPadding: EdgeInsets.only(top: 12.0),
            content: CustomSelectionGroup(
              options: options,
              initialSelectedValues: selectedScreenTypeIds,
              onChanged: (newSelectedIds) {
                print(newSelectedIds);
                selectedScreenTypeIds = List.from(newSelectedIds);
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('CANCEL'),
                onPressed: (){
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('OK'),
                onPressed: (){
                  setState(() {
                    //previousGenreValues= new Map.from(genreValues);
                    selectedGenres=_getSelectedGenres();
                  });
                  Navigator.of(context).pop(true);
                },
              )
            ],
          );
        });
  }

  _createButton(){
    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      child: SizedBox(
        width: double.infinity,
        child: new RaisedButton(
          color: Colors.greenAccent,
          child: new Text(
            'Save Change',
            style: TextStyle(
                color: fontColor, fontFamily: 'Dosis', fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
          onPressed: () {
            _updateMovie();
          },
        ),
      ),
    );
  }

  _updateMovie(){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Confirm', style: titleStyle),
            content: new Text('Do you want to update this movie ?', style: contentStyle),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Ok', style: okButtonStyle),
                onPressed: () async {
                  MovieRequest movieRequest = new MovieRequest(
                    title: _titleController.text,
                    poster: widget.movie.poster,
                    endAt: selectedDate.toIso8601String(),
                    wallpaper: _wallpaperController.text,
                    screenTypeIds: [],
                    genreIds: [],
                    rateId: selectedRate.id,

                  );
                  for (var screenType in selectedScreenTypes)
                    movieRequest.screenTypeIds.add(screenType.id);
                  for (var genre in selectedGenres)
                    movieRequest.genreIds.add(genre.id);
                  Navigator.of(context).pop();
                  if (movieRequest.imdbID != '' &&movieRequest.screenTypeIds.length>0
                      &&movieRequest.endAt!='') {
                    if (await MovieController.instance.updateMovie(widget.movie.id, movieRequest)) {
                      dialog.showSuccessMessage(
                          this.context, "Success", "Updated successfully!").show();
                    } else
                      dialog.showErrorMessage(this.context,"Error", 'Updated failed.' + '\nPlease try again!').show();
                    return;
                  }
                  dialog.showErrorMessage(this.context,"Error", 'Invalid name.' + '\nPlease try again!').show();
                },
              ),
              new FlatButton(
                child: new Text('Cancel', style: cancelButtonStyle),
                onPressed: ()  {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
