const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.deleteUserAccount = functions.https.onCall(async (data, context) => {
  console.log("Received data:", data); // Add this line to debug incoming data

  if (!data || !data.uid) {
    console.error("No UID provided");
    throw new functions.https.HttpsError("invalid-argument", "No UID provided");
  }

  const uid = data.uid;
  try {
    await admin.firestore().collection("Users").doc(uid).delete();
    console.log(`✅ Firestore document deleted: ${uid}`);

    await admin.auth().deleteUser(uid);
    console.log(`✅ User deleted from Authentication: ${uid}`);

    return {success: true, message: "User deleted successfully"};
  } catch (error) {
    console.error("❌ Error deleting user:", error);
    throw new functions.https.HttpsError("internal", "User deletion failed");
  }
});

