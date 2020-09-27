class User{
    constructor(name){
        this.name = name
    }

    greet(words){
        console.log(`${this.name} say ${words} to you.`)
    }
}

export {User as default};   