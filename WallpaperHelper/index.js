const maxTime = 1440;

/** @type {HTMLDivElement} */
let boxy;
/** @type {HTMLInputElement} */
let input;

window.onload = () => {
    boxy = document.getElementById("boxy");
    input = document.getElementById("input");
    input.addEventListener("input", (event) => addItems(event.target.value));
    if (input.value > 0) addItems(input.value);
}

/**
 * @param {Number} number the number of items
 */
function addItems(number) {
    while (boxy.firstChild) boxy.removeChild(boxy.lastChild);
    let r = 255;
    let g = 255;
    let b = 255;
    for (let index = 0; index < number; index++) {
        if (index != 0 && index != number) {
            let divider = document.createElement("div");
            divider.style.backgroundColor = "black";
            divider.style.width = "5px";
            divider.style.height = "100px";
            divider.style.cursor = "ew-resize"
            boxy.appendChild(divider);
        }
        let element = document.createElement("div");
        let l_r = r - (r / number * (index + 1));
        let l_g = Math.max(100, (g / number * (index + 1)));
        let l_b = Math.max(100, (b / number * (index + 1)));
        element.style.backgroundColor = `rgb(${l_r}, ${l_g}, ${l_b})`;
        element.style.width = boxy.clientWidth / number + "px";
        boxy.appendChild(element);
    }
}