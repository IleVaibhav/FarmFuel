import 'package:user/common_widget.dart';
import 'package:flutter/material.dart';
import 'animal_Products.dart';

final animalName = [
  "Cow", "Buffalo", "Camel",
  "Horse",  "Donkey", "Pig",
  "Goat",  "Sheep", "Fishery",
  "Dog", "Cat", "Rabbit",
  "Poultry", "Parrot", "Pigeon",
  "Bee"
];

final animalImg = [
  "assets/logo/cow.png", "assets/logo/buffalo.png", "assets/logo/camel.png",
  "assets/logo/horse.png", "assets/logo/donkey.png", "assets/logo/pig.png",
  "assets/logo/goat.png", "assets/logo/sheep.png", "assets/logo/fish.png",
  "assets/logo/dog.png", "assets/logo/cat.png", "assets/logo/rabbit.png",
  "assets/logo/hen.png", "assets/logo/parrot.png", "assets/logo/pigeon.png",
  "assets/logo/bee.png"
];

final animalPage = [
  const AnimalProducts(type: "Cow"),
  const AnimalProducts(type: "Buffalo"),
  const AnimalProducts(type: "Camel"),

  const AnimalProducts(type: "Horse"),
  const AnimalProducts(type: "Donkey"),
  const AnimalProducts(type: "Pig"),

  const AnimalProducts(type: "Goat"),
  const AnimalProducts(type: "Sheep"),
  const AnimalProducts(type: "Fish"),

  const AnimalProducts(type: "Dog"),
  const AnimalProducts(type: "Cat"),
  const AnimalProducts(type: "Rabbit"),

  const AnimalProducts(type: "Poultry"),
  const AnimalProducts(type: "Parrot"),
  const AnimalProducts(type: "Pigeon"),

  const AnimalProducts(type: "Bee")
];

class AnimalsHome extends StatelessWidget {
  const AnimalsHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: backGroundTheme(
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.only(top: 8.0),
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: animalName.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: (MediaQuery.of(context).size.width / 9) / (MediaQuery.of(context).size.height / 16),
            ),
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => animalPage[index]));
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 100,
                        child: Image.asset(animalImg[index])
                    ),
                    Expanded(child: Container()),
                    const Divider(color: Colors.black12, thickness: 0.3, height: 10),
                    Text(animalName[index], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color.fromARGB(255, 5, 49, 6)))
                  ]
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
