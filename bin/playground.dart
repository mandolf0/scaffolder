// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:io';

//! to compile for windows
// dart compile exe lib/playground.dart -o bin/scafolder.exe

Future<void> scaffoldAppFolders() async {
  List<String> assetsFoldersList = [
    "assets/images",
    "assets/fonts",
    "assets/i18n",
    "assets/html",
  ];

  //files inside lib
  List<String> globalFolders = [
    "common",
    "controllers",
    "endpoints",
    "models",
    "services",
    "themes",
    "utils",
    "widgets"
  ];
  try {
    //create assets folders
    for (var i = 0; i < assetsFoldersList.length; i++) {
      await Directory(assetsFoldersList[i]).create(recursive: true);
    }
    //create global folders
    for (var i = 0; i < globalFolders.length; i++) {
      await Directory("lib/global/${globalFolders[i]}").create(recursive: true);
    }
    //create modules folder
    await Directory("lib/modules").create(recursive: true);
    stdout.write("👍Folders have been created.");
  } catch (e) {
    stdout.write("Error: $e");
  }
  stdout.write("\n 👍Folder scaffolding complete.");
}

Future<void> createModule() async {
  var moduleName = stdin.readLineSync();

  if (moduleName.toString().isEmpty) {
    stdout.write("⚠ No module name given.");
    throw ("No module name given");
  }

  //make the controller files
  File("lib/modules/$moduleName/${moduleName}_controller.dart").create();
  File("lib/modules/$moduleName/${moduleName}_view.dart").create();
  await Directory("lib/modules/$moduleName/widgets").create(recursive: true);
  stdout.write("\n👍 $moduleName created.");
}

Future<void> main(List<String> args) async {
  if (args[0] == "help") {
    stdout.write(
        "This utility creates an Assets folder, /lib/global and lib/modules");
    stdout.write(
        "\nRun the script again to create another module.  If /lib/global exists it will only ask for module creation.");
    stdout.write(
        "\nUsage \n=========== \n dart thisfile.dart path_to_app_before_lib");
    return;
  }

  var inputDir = args[0];
  // stdin.readLineSync();
  if (inputDir.toString().isEmpty) return; //exit if nothing was entered
  var workDir = Uri.parse(inputDir.toString());

  //set working dir
  Directory.current = workDir.path;

  //check if global folder exists
  bool existingApp = await Directory('lib/global/').exists();

  if (existingApp == false) {
    stdout.write("Proceed to create base folders?: ");
    var answer = stdin.readLineSync().toString();
    if (answer.toLowerCase() == "y") {
      stdout.write("ℹ Scaffolding folders...");
      await scaffoldAppFolders();
    }
  } else {
    print("📁 Enter a module name in lowercase: ");
    await createModule().onError((error, stackTrace) => null);
  }
}
