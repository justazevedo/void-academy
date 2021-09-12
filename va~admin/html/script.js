$(document).ready( function( ) {
    window.addEventListener('message', ( event ) =>  {
        const item = event.data
        if (item.close == false) {
            addCommands( item.name, item.description )
            commands()
        } else {
            close()
        };
    });
});

comandos = []

const addCommands = ( name, description ) => {
    comandos.push( { id : comandos.length + 1, name : name, description : description } )
}

const commands = () => {
    const commandList = comandos.sort( ( a, b ) => ( a.id > b.id ) ? 1: -1 );
    $('.box').html( `
    ${ commandList.map(( comandos ) => (`<div class="lista listaMargin"><h1 class="commandName">/${comandos.name}</h1><h1 class="description">${comandos.description}</h1></div>`)).join('')}
    `);
}

const close = () => {
    document.location.reload(true)
}