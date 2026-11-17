import 'dart:io';

import 'package:image/image.dart' as img;

/// Original EduSnap mark: an open learning journal with a camera lens.
/// Run from edusnap/: dart run tool/generate_icon.dart
void main() {
  final green = img.ColorRgb8(2, 89, 40);
  final orange = img.ColorRgb8(242, 93, 39);
  final accent = img.ColorRgb8(217, 101, 59);
  final peach = img.ColorRgb8(242, 178, 155);
  final paper = img.ColorRgb8(242, 242, 242);

  img.Image mark({required bool transparent}) {
    final image = img.Image(width: 1024, height: 1024, numChannels: 4);
    img.fill(image, color: transparent ? img.ColorRgba8(0, 0, 0, 0) : green);
    img.fillPolygon(
      image,
      vertices: [
        img.Point(228, 310),
        img.Point(450, 332),
        img.Point(512, 375),
        img.Point(574, 332),
        img.Point(796, 310),
        img.Point(796, 700),
        img.Point(574, 722),
        img.Point(512, 760),
        img.Point(450, 722),
        img.Point(228, 700),
      ],
      color: peach,
    );
    img.fillPolygon(
      image,
      vertices: [
        img.Point(252, 282),
        img.Point(452, 306),
        img.Point(500, 344),
        img.Point(500, 700),
        img.Point(452, 670),
        img.Point(252, 646),
      ],
      color: paper,
    );
    img.fillPolygon(
      image,
      vertices: [
        img.Point(524, 344),
        img.Point(572, 306),
        img.Point(772, 282),
        img.Point(772, 646),
        img.Point(572, 670),
        img.Point(524, 700),
      ],
      color: paper,
    );
    img.fillRect(
      image,
      x1: 336,
      y1: 418,
      x2: 688,
      y2: 634,
      radius: 38,
      color: green,
    );
    img.fillRect(
      image,
      x1: 412,
      y1: 386,
      x2: 520,
      y2: 444,
      radius: 16,
      color: green,
    );
    img.fillCircle(image, x: 512, y: 526, radius: 80, color: orange);
    img.fillCircle(image, x: 512, y: 526, radius: 48, color: green);
    img.fillCircle(image, x: 494, y: 508, radius: 16, color: paper);
    img.fillCircle(image, x: 644, y: 458, radius: 12, color: peach);
    img.fillRect(
      image,
      x1: 702,
      y1: 226,
      x2: 724,
      y2: 280,
      radius: 11,
      color: accent,
    );
    img.fillRect(
      image,
      x1: 686,
      y1: 242,
      x2: 740,
      y2: 264,
      radius: 11,
      color: accent,
    );
    return image;
  }

  Directory('assets').createSync(recursive: true);
  // RGB source: explicitly solid, square, and free of an alpha channel.
  final icon = mark(transparent: false).convert(numChannels: 3);
  File('assets/icon.png').writeAsBytesSync(img.encodePng(icon));
  File('assets/icon_foreground.png')
      .writeAsBytesSync(img.encodePng(mark(transparent: true)));

  final result = Process.runSync(Platform.resolvedExecutable, [
    'run',
    'flutter_launcher_icons',
  ]);
  stdout.write(result.stdout);
  stderr.write(result.stderr);
  if (result.exitCode != 0) exit(result.exitCode);

  // flutter_launcher_icons 0.14.4 also matches this newer Flutter Xcode key
  // when replacing APPICON_NAME. Keep the Swift asset setting boolean.
  final project = File('ios/Runner.xcodeproj/project.pbxproj');
  project.writeAsStringSync(
    project.readAsStringSync().replaceAll(
      'ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = AppIcon;',
      'ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES;',
    ),
  );
}
