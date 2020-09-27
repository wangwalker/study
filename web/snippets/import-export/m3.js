import {num, increaseNum} from "./m1.js"
import MyUser from "./m2.js"

window.onload = function(){
    console.log("window loaded.")

    let user = new MyUser("Walker")
    user.greet("Hi")

    console.log(num)
    increaseNum()
    console.log(num)
}