import 'package:flutter/material.dart';
import 'package:foodhub/provider/foods.dart';
import 'package:foodhub/screens/edit_food_screen.dart';
import 'package:provider/provider.dart';

class UserFoodList extends StatelessWidget {
  const UserFoodList(
      {Key? key, required this.imageUrl, required this.title, required this.id})
      : super(key: key);
  final String id;
  final String imageUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(title),
        trailing: SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.routeName, arguments: id);
                },
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              IconButton(
                onPressed: () async {
                  try {
                    await Provider.of<Foods>(context, listen: false)
                        .deleteProduct(id);
                  } catch (error) {
                    // Of context method doesnot works in the future
                    scaffoldMessenger.removeCurrentSnackBar();
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Deleting failed.',
                          textAlign: TextAlign.center,
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
