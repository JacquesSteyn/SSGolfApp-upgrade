import * as admin from "firebase-admin";

admin.initializeApp({
  credential: admin.credential.cert(
    require("./smart-stats-golf-firebase-adminsdk-aprnj-84b202cc4e.json")
  ),
  projectId: "smart-stats-golf",
  databaseURL: "https://smart-stats-golf-default-rtdb.firebaseio.com",
});

const setUserAdminClaim = async () => {
  // await admin.auth().setCustomUserClaims("axBLx1P2kdecMSVijPnwm9opoeP2", {
  //   userType: "Admin",
  //   admin: true,
  // });

  await admin
    .auth()
    .updateUser("axBLx1P2kdecMSVijPnwm9opoeP2", { displayName: "Yoni Fingleson" });
};

// const setUserAdminClaim = async () => {
//   await admin.auth().updateUser()

//   ("zXvNBAQM6kPm4dm44C8yUQcPPvL2", {
//     userType: "Admin",
//     admin: true,
//   });
// };

setUserAdminClaim()
  .then((val) => console.log(`Complete ${val}`))
  .catch((e) => console.log(`ERROR: ${e}`));
