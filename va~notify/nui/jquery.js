$(document).ready(function() {

    window.addEventListener( 'message', (event) => {
        const notify = event.data
        let id = $(`.notification`).lenght + 1;

        let $notification = $(
            `<div class="notification ${notify.type} unfold id="${id}">
                <div class="message">${notify.message}</div>
             </div>
            `
        ).appendTo(`.main`);

        setTimeout( ( ) => {
            $notification.addClass('fold').fadeOut(700);
        }, 10000);
    });
});