import 'package:flutter/material.dart';
import 'package:schedulex/pages/model/event.dart';
import 'package:intl/intl.dart';

class ViewEvent extends StatelessWidget {
  Event? appointment;

  ViewEvent({super.key, this.appointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Event"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name",
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .inverseSurface
                    .withOpacity(.7),
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                appointment!.title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inverseSurface,
                  fontWeight: FontWeight.w400,
                  fontSize: 30,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "From",
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .inverseSurface
                    .withOpacity(.7),
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                DateFormat('MMMM yyyy,hh:mm a')
                    .format(
                      appointment!.from,
                    )
                    .toString(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inverseSurface,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "To",
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .inverseSurface
                    .withOpacity(.7),
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                DateFormat('MMMM yyyy,hh:mm a')
                    .format(
                      appointment!.to,
                    )
                    .toString(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inverseSurface,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              "Description",
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .inverseSurface
                    .withOpacity(.7),
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                appointment!.description.toString(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inverseSurface,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
