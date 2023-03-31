import { LoaderFunction, redirect } from "react-router";
import { session } from "~/cookies";
import { auth as serverAuth } from "~/firebase.server";

export const loader: LoaderFunction = async ({ request }) => {
  const jwt = await session.parse(request.headers.get("Cookie"));

  if (!jwt) {
    return redirect("/login");
  }

  try {
    const token = serverAuth.verifySessionCookie(jwt);
    const profile = await getUserProfile(token.uid);
    return { profile };
  } catch (error) {
    return redirect("/logout");
  }
};
