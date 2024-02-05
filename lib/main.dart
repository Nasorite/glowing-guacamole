import 'package:flutter/material.dart';
import 'package:flutter_application_1/form.dart';
import 'package:flutter_application_1/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:searchable_listview/searchable_listview.dart';

import 'ProfileClass.dart';

void main() {
  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(routes: [
  GoRoute(
      name: 'home',
      path: '/',
      pageBuilder: (context, state) {
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: const MainPage(),
          barrierDismissible: true,
          barrierColor: Colors.black38,
          opaque: false,
          transitionDuration: Duration.zero,
          transitionsBuilder: (_, __, ___, Widget child) => child,
        );
      },
      routes: []),
  GoRoute(
      name: 'form',
      path: '/form',
      pageBuilder: (context, state) {
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: const FormPage(),
          barrierDismissible: true,
          barrierColor: Colors.black38,
          opaque: false,
          transitionDuration: Duration.zero,
          transitionsBuilder: (_, __, ___, Widget child) => child,
        );
      },
      routes: []),
]);

class MainPage extends StatelessWidget {
  const MainPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).pushNamed('form');
              },
              child: const Text("Go to Form"),
            ),
            ProfileList()
          ],
        ),
      ),
    );
  }
}

class ProfileList extends ConsumerStatefulWidget {
  const ProfileList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileListState();
}

class _ProfileListState extends ConsumerState<ProfileList> {
  late List<Person> list;

  @override
  Widget build(BuildContext context) {
    final list = ref.watch(getProfileListProvider);
    print("building list");

    return list.when(
        data: (value) {
          return SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.3,
              child: SearchableList<Person>(
                initialList: value,
                builder: (list, index, item) {
                  return PersonItem(item: item);
                },
                emptyWidget: const Text("Empty"),
                inputDecoration: InputDecoration(
                  labelText: "Search Persons",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ));
        },
        error: (error, stacktrace) {
          return Text(stacktrace.toString());
        },
        loading: () => CircularProgressIndicator());
  }
}

class PersonItem extends StatelessWidget {
  final Person item;
  const PersonItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Icon(
              Icons.star,
              color: Colors.yellow[700],
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Name: ${item.name}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Occupation: ${item.occupation}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Age: ${item.age}',
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
