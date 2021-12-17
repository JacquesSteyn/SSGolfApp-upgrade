import 'package:ss_golf/shared/models/golf/skill_element.dart';
import 'package:ss_golf/shared/models/physical/attribute.dart';
import 'package:ss_golf/shared/models/golf/skill.dart';

class Stat {
  String day, name;
  double golfValue, physicalValue;
  List<SkillStat> skillStats;
  List<AttributeStat> attributeStats;

  Stat([data, dayId, List<Skill> skills, List<Attribute> attributes]) {
    if (data != null) {
      // print('STAT DATA: ' + data.toString());
      this.day = dayId;

      // *** Golf
      var rawGolfData = data['golf'];
      if (rawGolfData != null) {
        this.golfValue = rawGolfData['value'].toDouble();
        var skillIdKeys = (rawGolfData.keys).toList();
        skillIdKeys.remove('value');
        this.skillStats = skillIdKeys.map<SkillStat>((skillId) {
          int skillIndex = skills?.indexWhere((skill) => skill.id == skillId);
          return SkillStat(rawGolfData[skillId], skillId,
              (skills != null && skillIndex > -1) ? skills[skillIndex] : null);
        }).toList();
      } else {
        this.skillStats = [];
      }
      // *** Physical
      var rawPhysicalData = data['physical'];
      if (rawPhysicalData != null) {
        this.physicalValue = rawPhysicalData['value'].toDouble();
        var attributeIdKeys = (rawPhysicalData.keys).toList();
        attributeIdKeys.remove('value');
        this.attributeStats = attributeIdKeys.map<AttributeStat>((attributeId) {
          int attributeIndex =
              attributes?.indexWhere((attribute) => attribute.id == attributeId);
          return AttributeStat(
              rawPhysicalData[attributeId],
              (attributes != null && attributeIndex > -1)
                  ? attributes[attributeIndex]
                  : null);
        }).toList();
      } else {
        this.attributeStats = [];
      }
    } else {
      this.skillStats = [];
      this.attributeStats = [];
    }
  }

  int findSkillIndex(String skillId) {
    return this.skillStats.indexWhere((skillStat) => skillStat.id == skillId);
  }

  int findSkillIndexByName(String skillName) {
    return this.skillStats.indexWhere((skillStat) => skillStat.name == skillName);
  }

  int findAttributeIndex(String attributeId) {
    return this
        .attributeStats
        .indexWhere((attributeStat) => attributeStat.id == attributeId);
  }

  getJson() {
    Map<String, Map<String, dynamic>> jsonObject = {
      'golf': {
        'value': this.golfValue,
      },
      'physical': {
        'value': this.physicalValue,
      },
    };
    // *** Skills & Elements
    this.skillStats.forEach((skillStat) {
      // print('SKILL STAT: ' + skillStat.toString());
      var elementsJsonObject = {};
      skillStat.elementStats.forEach((elementStat) {
        // print('ELEMENT STAT: ' + elementStat.toString());
        elementsJsonObject[elementStat.id] = {
          'id': elementStat.id,
          'value': elementStat.value
        };
      });
      jsonObject['golf']
          [skillStat.id] = {'value': skillStat.value, 'elements': elementsJsonObject};
    });

    // *** Attributes
    this.attributeStats.forEach((attributeStat) {
      jsonObject['physical'][attributeStat.id] = {
        'value': attributeStat.value,
      };
    });

    return jsonObject;
  }
}

class SkillStat {
  String id, name;
  double value;
  List<ElementStat> elementStats;

  SkillStat([data, skillId, Skill skill]) {
    if (data != null) {
      // print('SKILL DATA: ' + skill.elements.length.toString());

      this.id = skillId;
      this.name = skill?.name;
      this.value = data['value'].toDouble();

      // TODO - why the fuck is there a random null coming through!?
      var rawElementsData = data['elements'] != null
          ? data['elements'].where((element) => element != null)
          : [];
      this.elementStats = rawElementsData.map<ElementStat>((element) {
        if (element != null && skill != null) {
          int elementIndex = skill.elements
              .indexWhere((skillElement) => skillElement.id == element['id']);

          return ElementStat(element, skill.elements[elementIndex]);
        }
      }).toList();
    } else {
      this.elementStats = [];
    }
  }

  int findElementIndex(String elementId) {
    return this.elementStats.indexWhere((elementStat) => elementStat.id == elementId);
  }
}

class ElementStat {
  String id, name;
  double value;

  ElementStat([data, SkillElement element]) {
    // print('ELEMENT DATA: ' + element.toString());

    if (data != null) {
      this.id = data['id'].toString();
      this.value = data['value'].toDouble();
      this.name = element?.name;
    }
  }

  getJson() {
    return {
      'id': this.id,
      'value': this.value,
      'name': this.name,
    };
  }
}

class AttributeStat {
  String id, name;
  double value;

  AttributeStat([data, Attribute attribute]) {
    if (data != null) {
      this.id = data['id'] ?? attribute?.id;
      this.value = data['value'].toDouble();
      this.name = attribute?.name;
    }
  }
}
