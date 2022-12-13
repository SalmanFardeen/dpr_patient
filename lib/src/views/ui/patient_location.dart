import 'package:dpr_patient/src/views/widgets/shadow_container.dart';
import 'package:flutter/material.dart';

class PatientLocation extends StatelessWidget {
  final String? location;

  const PatientLocation({Key? key, required this.location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return location != null
        ? Column(
            children: [
              SizedBox(
                height: 30,
                child: ShadowContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.place, size: 18.0),
                        const SizedBox(width: 4),
                        Expanded(
                            child: Text(location!,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left)),
                        PopupMenuButton(
                            padding: EdgeInsets.zero,
                            itemBuilder: (context) =>
                                [PopupMenuItem(child: Text(location!))],
                            child: const Icon(Icons.keyboard_arrow_down))
                      ],
                    ),
                    radius: 16.0),
              ),
            ],
          )
        : Container();
  }
}
