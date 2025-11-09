import 'package:otper_mobile/data/models/home_board_model.dart';
import 'package:otper_mobile/data/models/card_model.dart';
import 'package:otper_mobile/data/models/list_model.dart';
import 'package:otper_mobile/data/models/home_team_model.dart';

class AppTexts {
  static const String forgetPasswordText = "Forgot your password? No problem.Just let us\nknow your email address and we will email you\na password reset link that will allow you to\nchoose a new one.";

static HomeBoardModel sampleBoard1 = HomeBoardModel(
  id: "31",
  name: "DLTesting",
  slug: "enN1d3h",
  key: "DL",
);

static HomeBoardModel sampleBoard2 = HomeBoardModel(
  id: "30",
  name: "TLTesting",
  slug: "f2PkQ1c",
  key: "TLS",
);

static HomeBoardModel sampleBoard3 = HomeBoardModel(
  id: "29",
  name: "Testing",
  slug: "JclMkm7",
  key: "TS",
);

static HomeBoardModel sampleBoard4 = HomeBoardModel(
  id: "32",
  name: "VBoard",
  slug: "BJLDEjo",
  key: "VB",
);

static HomeBoardModel sampleBoard5 = HomeBoardModel(
  id: "37",
  name: "Randowm",
  slug: "VlmIcBA",
  key: "RDM",
);

// Sample Teams
static HomeTeamModel sampleTeam1 = HomeTeamModel(
  id: "23",
  name: "tes_Team",
  slug: "RWNZnyB",
  boards: [sampleBoard1, sampleBoard2, sampleBoard3, sampleBoard4],
);

static HomeTeamModel sampleTeam2 = HomeTeamModel(
  id: "25",
  name: "random",
  slug: "h5joMQu",
  boards: [sampleBoard5],
);


}