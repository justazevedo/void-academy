function execute( event ) {
    if (event == "register") {
        const username = document.getElementById("username");
        const password = document.getElementById("password");
        if (username.value == "" || password.value == "") {
            return
        };
        mta.triggerEvent( "va.javaCode", "register", username.value, password.value );
    } else if (event == "join") {
        const username = document.getElementById("username");
        const password = document.getElementById("password");
        if (username.value == "" || password.value == "") {
            return
        };
        mta.triggerEvent( "va.javaCode", "logIn", username.value, password.value );
    };
};

$(document).ready(function() {

    window.addEventListener( "message", (event) => {
        if (event.data.hide == 1) {
            const login = document.getElementById('login');
            login.classList.add("hide");
        };
        if (event.data.hide == 0) {
            const login = document.getElementById('login');
            login.classList.remove('hide')
        };
    });

});