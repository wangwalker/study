function tokenize() {
    var content = document.getElementById("html-content").innerText
    if (content === "") {
        alert("Please input some html content!")
        return
    }


}

window.onload = function() {
    let tokenizeBtn = document.getElementById("tokenize-btn")
    tokenizeBtn.addEventListener("click", tokenize.bind(this))
}