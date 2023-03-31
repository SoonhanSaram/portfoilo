import { signInWithEmailAndPassword } from "firebase/auth";
import { SyntheticEvent, useState } from "react";
import { auth as clientAuth } from "~/firebase.client";
import { ActionFunction } from "@remix-run/node";
import { auth as serverAuth } from "~/firebase.server";
import { useFetcher } from "@remix-run/react";
import { redirect } from "@remix-run/node";
import { session } from "~/cookies";

export const action: ActionFunction = async ({ request }) => {
  const form = await request.formData();
  const idToken = form.get("idToken")?.toString();

  await serverAuth.verifyIdToken(idToken!);

  const jwt = await serverAuth.createSessionCookie(idToken!, {
    expiresIn: 60 * 60 * 24 * 5 * 1000,
  });

  return redirect("/", {
    headers: {
      "Set-Cookie": await session.serialize(jwt),
    },
  });
};

export default async function Login() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const fetcher = useFetcher();
  async function handleSubmit(e: SyntheticEvent) {
    e.preventDefault();
    const target = e.target as typeof e.target & {
      email: { value: string };
      password: { value: string };
    };
    const email = target.email.value;
    const password = target.password.value;

    try {
      const credential = await signInWithEmailAndPassword(
        clientAuth,
        email,
        password
      );
      const idToken = await credential.user.getIdToken();

      fetcher.submit({ idToken }, { method: "post", action: "/login" });
    } catch (error) {
      console.log(error);
    }
  }

  return (
    <form onSubmit={handleSubmit}>
      <label>
        이메일 주소:
        <input
          type="email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />
      </label>
      <br />
      <label>
        비밀번호:
        <input
          type="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
        />
      </label>
      <br />
      <button type="submit">로그인</button>
    </form>
  );
}
