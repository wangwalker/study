import {num, increaseNum} from "./m1.js"
import User from "./m2.js"

window.onload = function(){
    console.log("window loaded.")

    let user = new User("Walker")
    user.greet("Hi")

    console.log(num)
    increaseNum()
    console.log(num)
}