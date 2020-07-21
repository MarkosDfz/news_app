
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:news/src/models/category_model.dart';
import 'package:news/src/models/news_models.dart';

final _urlNews = 'https://newsapi.org/v2';
final _apiKey  = '59a0310fc5264e639ae9ff2eb53c5b56';

class NewsService with ChangeNotifier {

  List<Article> headlines = [];
  String _selectedCategory = 'business';

  List<Category> categories = [
    Category( FontAwesomeIcons.building, 'business' ),
    Category( FontAwesomeIcons.tv, 'entertainment' ),
    Category( FontAwesomeIcons.addressCard, 'general' ),
    Category( FontAwesomeIcons.headSideVirus, 'health' ),
    Category( FontAwesomeIcons.vials, 'science' ),
    Category( FontAwesomeIcons.volleyballBall, 'sports' ),
    Category( FontAwesomeIcons.memory, 'technology' ),
  ];

  Map<String, List<Article>> cartegoryArticle = {};

  NewsService() {

    this.getTopHeadlines();

    categories.forEach( (item) {
      this.cartegoryArticle[item.name] = new List();
    });

  }

  get selectedCategory => this._selectedCategory;

  set selectedCategory( String valor ) {
    this._selectedCategory = valor;
    
    this.getArticlesByCategory( valor );
    notifyListeners();
  }

  List<Article> get getArticulosCategorySelected => this.cartegoryArticle[this.selectedCategory];

  getTopHeadlines() async {
    
    final url = '$_urlNews/top-headlines?apiKey=$_apiKey&country=us';
    final resp = await http.get( url );
    
    final newsRespose = newsResposeFromJson( resp.body );
    
    this.headlines.addAll( newsRespose.articles );

    notifyListeners();
  
  }

  getArticlesByCategory( String category ) async {

    if ( this.cartegoryArticle[category].length > 0 ) {
      return this.cartegoryArticle[category];
    }

    final url = '$_urlNews/top-headlines?apiKey=$_apiKey&country=us&category=$category';
    final resp = await http.get( url );
    
    final newsRespose = newsResposeFromJson( resp.body );

    this.cartegoryArticle[category].addAll( newsRespose.articles );
    notifyListeners();

  }

}