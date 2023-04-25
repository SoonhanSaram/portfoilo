import { useState } from "react";
import "../css/login.css"

export default function login() {
    const [email, setEmail] = useState();
    const [password, setPassword] = useState();
    const [capslockCheck, setCapslockCheck] = useState(false);

    const checkCapslock = e => {
        let capsLock = e.getModifierState("CapsLock");
        setCapslockCheck(capsLock);
        console.log(capslockCheck);
    }
    const loginButton = e => {
        if (e.keyCode == 13 && email != null && password != null) {
            console.log(e.keyCode);
            console.log("로그인");
        }
    }


    return (<form onKeyDown={loginButton}>
        <legend>로그인 정보
        <div>
                <input className="eamil" value={email} onKeyDown={(e)=>checkCapslock(e)} onChange={(e)=>{setEmail(e.target.value)}} placeholder="아이디 입력"></input>
        </div>
        <div>
            <input className="password" value={password} type="password" onKeyDown={(e)=>checkCapslock(e)} onChange={(e)=>{setPassword(e.target.value)}} placeholder="비밀번호 입력"></input>
            </div>
            <div>
                <label>비밀번호 표시</label>
                <input type="checkbox"/>
                <span className={capslockCheck ? "caps-lock-on" : "caps-lock-off"}>CapsLock</span>
            </div>
            
        </legend>
    </form>)
}