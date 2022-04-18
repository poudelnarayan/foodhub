import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:foodhub/models/http_exception.dart';
import 'package:http/http.dart' as http;

import 'food.dart';

class Foods extends ChangeNotifier {
  List<Food> _items = [];
  Foods(this.authToken, this.userId, this._items);

  final String authToken;
  final userId;

  List<Food> get items {
    return [..._items];
  }

  List<Food> get favouriteItems {
    return _items.where((foodItem) => foodItem.isFavorite).toList();
  }

  Future<void> fetchAndSetFood([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = Uri.parse(
        'https://foodhub-fe616-default-rtdb.firebaseio.com/foods.json?auth=$authToken&$filterString');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        return;
      }
      url = Uri.parse(
          'https://foodhub-fe616-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken');
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);

      final List<Food> loadedFood = [];

      extractedData.forEach((foodId, foodData) {
        loadedFood.add(
          Food(
            id: foodId,
            title: foodData['title'],
            description: foodData['description'],
            price: foodData['price'],
            imageUrl: foodData['imageUrl'],
            isFavorite:
                favoriteData == null ? false : favoriteData[foodId] ?? false,
            foodType: foodData['foodType'],
          ),
        );
      });

      _items = loadedFood;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addFood(Food food) async {
    // Using async automatically wrap our code with Future, so we not need to return
    final url = Uri.parse(
        'https://foodhub-fe616-default-rtdb.firebaseio.com/foods.json?auth=$authToken');

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': food.title,
            'description': food.description,
            'price': food.price,
            'imageUrl': food.imageUrl,
            'foodType': food.foodType,
            'creatorId': userId,
          },
        ),
      );
      // In async-await we dont need to use then keyword
      // Below the code will automatically and invisiblely wrap into .then keyword

      final newFood = Food(
        id: json.decode(response.body)['name'],
        title: food.title,
        description: food.description,
        price: food.price,
        imageUrl: food.imageUrl,
        foodType: food.foodType,
      );
      _items.add(newFood);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Food findById(String id) {
    return _items.firstWhere((food) => food.id == id);
  }

  Future<void> updateProduct(String id, Food newFood) async {
    final foodIndex = _items.indexWhere((prod) => prod.id == id);
    final url = Uri.parse(
        'https://foodhub-fe616-default-rtdb.firebaseio.com/foods/$id.json?auth=$authToken');
    await http.patch(url,
        body: json.encode({
          'title': newFood.title,
          'description': newFood.description,
          'imageUrl': newFood.imageUrl,
          'price': newFood.price,
        }));

    _items[foodIndex] = newFood;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://foodhub-fe616-default-rtdb.firebaseio.com/foods/$id?auth=$authToken');
    final existingFoodIndex = _items.indexWhere((food) => food.id == id);
    Food? existingFood = _items[existingFoodIndex];
    _items.removeAt(existingFoodIndex);
    notifyListeners();
    // Here the product is only removed from List But in memory it is still stored!
    final response = await http.delete(url);
    // In delete request http doesnot through an error . It throws the status code .

    if (response.statusCode >= 400) {
      _items.insert(existingFoodIndex, existingFood);
      notifyListeners();
      throw HttpException(message: 'Could not delete product.');
    }
    existingFood = null;
  }
}
