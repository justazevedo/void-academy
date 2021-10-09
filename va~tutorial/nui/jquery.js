var circle = 1
document.getElementById('circulo').onclick = function() {clickCircle()};

function clickCircle() {
    
    var oldCircle = document.getElementById(circle);
    oldCircle.classList.remove("selected");
    if (circle == 6) {
        circle = 1
    } else {
        circle = circle + 1
    }
    var newCircle = document.getElementById(circle);
    newCircle.classList.add('selected');
    return // TEMP
    switchT(circle)
};