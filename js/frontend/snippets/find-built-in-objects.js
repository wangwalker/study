var set = new Set();
var objects = [
    eval,
    isFinite,
    isNaN,
    parseFloat,
    parseInt,
    decodeURI,
    decodeURIComponent,
    encodeURI,
    encodeURIComponent,
    Array,
    Date,
    RegExp,
    Promise,
    Proxy,
    Map,
    WeakMap,
    Set,
    WeakSet,
    Function,
    Boolean,
    String,
    Number,
    Symbol,
    Object,
    Error,
    EvalError,
    RangeError,
    ReferenceError,
    SyntaxError,
    TypeError,
    URIError,
    ArrayBuffer,
    SharedArrayBuffer,
    DataView,
    Float32Array,
    Float64Array,
    Int8Array,
    Int16Array,
    Int32Array,
    Uint8Array,
    Uint16Array,
    Uint32Array,
    Uint8ClampedArray,
    Atomics,
    JSON,
    Math,
    Reflect];

var rowObjects = [
    eval,
    isFinite,
    isNaN,
    parseFloat,
    parseInt,
    decodeURI,
    decodeURIComponent,
    encodeURI,
    encodeURIComponent,
    Array,
    Date,
    RegExp,
    Promise,
    Proxy,
    Map,
    WeakMap,
    Set,
    WeakSet,
    Function,
    Boolean,
    String,
    Number,
    Symbol,
    Object,
    Error,
    EvalError,
    RangeError,
    ReferenceError,
    SyntaxError,
    TypeError,
    URIError,
    ArrayBuffer,
    SharedArrayBuffer,
    DataView,
    Float32Array,
    Float64Array,
    Int8Array,
    Int16Array,
    Int32Array,
    Uint8Array,
    Uint16Array,
    Uint32Array,
    Uint8ClampedArray,
    Atomics,
    JSON,
    Math,
    Reflect];

function findObjects() {
    objects.forEach(o => set.add(o));

    for (var i = 0; i < objects.length; i++) {
        var o = objects[i]
        for (var p of Object.getOwnPropertyNames(o)) {
            var d = Object.getOwnPropertyDescriptor(o, p)
            if ((d.value !== null && typeof d.value === "object") || (typeof d.value === "function"))
                if (!set.has(d.value))
                    set.add(d.value), objects.push(d.value);
            if (d.get)
                if (!set.has(d.get))
                    set.add(d.get), objects.push(d.get);
            if (d.set)
                if (!set.has(d.set))
                    set.add(d.set), objects.push(d.set);
        }
    }

    var htmlString1 = '<div>',
        htmlString2 = '<div>';

    htmlString1 += "Objects Defined by JavaScript: <hr>";
    rowObjects.forEach(function (o) {
        if (o instanceof Function) {
            htmlString1 += o.name;
            htmlString1 += ", "
        } else {
            htmlString1 += o + ", ";
        }
    })
    htmlString1 += '</div>'
    document.getElementById("defined-objects").innerHTML = htmlString1;

    console.log('built-in')
    htmlString2 += "All Built-in Objects: <hr>";
    set.forEach(function (o) {
        if (o instanceof Function) {
            htmlString2 += o.name;
            htmlString2 += ", "
        } else if (o instanceof Object) {
            htmlString2 += ', '
            console.log('object:', o)
        } else {
            console.log(o)
        }
    })

    htmlString2 += '</div>'
    document.getElementById("found-objects").innerHTML = htmlString2;
}

window.onload = function () {
    let btn = document.getElementById("btn");
    btn.addEventListener('click', findObjects);
}