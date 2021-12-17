import 'package:ss_golf/shared/models/benchmark.dart';
import 'package:ss_golf/shared/models/physical/attribute.dart';
import 'package:ss_golf/shared/models/golf/skill_element.dart';

class Skill {
  String name, id, iconName;
  int index;
  List<SkillElement> elements;
  List<Attribute> attributes;
  Benchmark benchmarks;

  Skill([data, id]) {
    if (data != null) {
      this.name = data['name'];
      this.iconName = data['iconName'];
      this.id = id;
      this.index = data['index'] != null ? data['index'] : 0;
      this.elements = data['elements'] != null
          ? data['elements']
              .map<SkillElement>((element) => SkillElement(element))
              .toList()
          : [];
      this.attributes = data['attributes'] != null
          ? data['attributes']
              .map<Attribute>((attribute) => Attribute(attribute))
              .toList()
          : [];
      this.benchmarks = data['benchmarks'] != null
          ? Benchmark(data['benchmarks'])
          : Benchmark.init();
    }
  }
}
