import 'package:flutter/material.dart';
import 'package:my_lib/models/models.dart';

class BookWidget extends StatefulWidget {
  final Book? book;
  final VoidCallback onTap;
  const BookWidget({Key? key,
    required this.onTap,
    required this.book})
      : super(key: key);

  @override
  State<BookWidget> createState() => _BookWidgetState();
}

class _BookWidgetState extends State<BookWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          widget.book!.title.toString(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        child: Divider(
                          thickness: 1,
                        ),
                      ),
                      Text(
                        widget.book!.plAuthor!.name.toString(),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                        //maxLines: 3,
                      ),
                      const Padding(
                        padding:
                        EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        child: Divider(
                          thickness: 1,
                        ),
                      ),
                      Text(
                        widget.book!.plGenre!.name.toString(),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                        //maxLines: 3,
                      ),

                    ],
                  ),
                ),
                Checkbox(
                    value: widget.book!.isInactive,
                    onChanged: (bool? value ) {
                  setState(() {
                    widget.book!.isInactive = value!;
                    widget.book!.save();
                  });
                }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
