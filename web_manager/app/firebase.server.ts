import { App, initializeApp, getApps, cert, getApp } from "firebase-admin/app";
import { Auth, getAuth } from "firebase-admin/auth";

let app: App;
let auth: Auth;

if (getApps().length === 0) {
  app = initializeApp({
    credential: cert(require("../kyoungmin-b211b-firebase-adminsdk-qs3a9-ca5f1a9e86.json")),
  });
  auth = getAuth(app);
} else {
  app = getApp();
  auth = getAuth(app);
}

export { auth };
