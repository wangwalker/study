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

    console.log('scope at "findObjects()":', this)

    var string1 = '<div>',
        string2 = '<div>';
    var errs = '';

    string1 += "Objects Defined by JavaScript: <hr>";
    rowObjects.forEach(function (o) {
        if (o instanceof Function) {
            string1 += o.name;
            string1 += ", "
        } else {
            string1 += o + ", ";
        }
    })
    string1 += '</div>'
    document.getElementById("defined-objects").innerHTML = string1;

    string2 += "All Built-in Objects: <hr>";
    set.forEach(function (o) {
        if (o instanceof Function) {
            string2 += o.name;
            string2 += ", "
        } else if (o instanceof Object) {
            try {
                string2 += o+', '
            } catch (e) {
                errs += e+''
                errs += '<hr>'
                console.log("object error:", e)
            }
        } else {
            console.log(o)
        }
    })

    string2 += '<hr>'
    string2 += errs
    string2 += '</div>'
    document.getElementById("found-objects").innerHTML = string2;
}

window.onload = function () {
    console.log('scope at "window.onload()"', this)
    let btn = document.getElementById("btn");
    btn.addEventListener('click', findObjects.bind(this));
}