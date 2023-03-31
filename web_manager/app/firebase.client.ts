import { initializeApp } from "firebase/app";
import { getAuth, inMemoryPersistence, setPersistence } from "firebase/auth";

const app = initializeApp({
  apiKey: "AIzaSyBTdAfvj0iv28JlnvCN77JJ5X-s6tUzcYw",
  authDomain: "kyoungmin-b211b.firebaseapp.com",
  databaseURL: "https://kyoungmin-b211b-default-rtdb.firebaseio.com",
  projectId: "kyoungmin-b211b",
  storageBucket: "kyoungmin-b211b.appspot.com",
  messagingSenderId: "175614738346",
  appId: "1:175614738346:web:a80010a0b8a5697985f5d3",
});

const auth = getAuth(app);
setPersistence(auth, inMemoryPersistence);

export { auth };
