$(document).ready( function( ) {
    window.addEventListener('message', ( event ) =>  {
        const item = event.data
        if (item.id) {
            addGroup( item.id, item.name, item.vagas )
            groups()
            $("#players"+ item.name).html(item.players + "/" + item.vagas)
        };
        if (item.editID) {
            editPlayers( item.editID, item.editName, item.editPlayers, item.editVagas )
        }
    });
});

gangs = []

const addGroup = (id, name, vagas) => {
    gangs.push( { id : id, name : name, vagas : vagas } )
}

const editPlayers = ( id, name, players, vagas ) => {
    $('#players' + name).remove()
    $('#group' + name).html(`
        <div id="players${name}" class="players">${players}/${vagas}</div>
        <button onclick='enterSkin( ${id}, "${name}", ${players} )' class="joingroup">Entrar</button>
    `)
}

const groups = () => {
    let i = 0;
    const nameList = gangs.sort( ( a, b ) => ( a.id > b.id ) ? 1: -1 );
    $('.groups').html( `
    ${ nameList.map(( gangs ) => (`<div id="group${gangs.name}" class="group ${gangs.name}">
        <div id="players${gangs.name}" class="players">0/${gangs.vagas}</div>
        <button onclick='enterSkin( ${gangs.id}, "${gangs.name}", ${gangs.players} )' class="joingroup">Entrar</button>
    </div>`)).join('')}
    `);
};

var gangsID = 0
var skinSelected = 0

const enterSkin = ( id, name, players ) => {
    if (players > 29) {
        return mta.triggerEvent( 'va.errorGroups', "lotado" )
    }
    gangsID = id
    const groupsMenu = document.getElementById('groups');
    const skinMenu = document.getElementById('skins');
    const textSkin = document.getElementById('textSkin');

    textSkin.innerHTML = name.replace("_", " ");
    document.getElementsByTagName('body')[0].style = 'margin: auto; padding: auto; overflow-y: hidden; overflow-x: hidden; background: transparent !important;';
    groupsMenu.style.marginTop = "200%";
    setTimeout( () => {
        groupsMenu.style.display = "none";
        skinMenu.style.display = "block";
    }, 1000 );
    setTimeout( () => {
        skinMenu.style.marginTop = "10%"
    }, 1100 );
    setTimeout( () => {
        document.getElementsByTagName('body')[0].style = 'margin: auto; padding: auto; overflow-y: auto; overflow-x: hidden; background: transparent !important;';
    }, 2000 );
};

const backSkin = () => {
    gangsID = 0
    skinSelected = 0
    const groupsMenu = document.getElementById('groups');
    const skinMenu = document.getElementById('skins');

    skinMenu.style.marginTop = "200%";
    document.getElementsByTagName('body')[0].style = 'margin: auto; padding: auto; overflow-y: hidden; overflow-x: hidden; background: transparent !important;';
    setTimeout( () => {
        skinMenu.style.display = "none";
        groupsMenu.style.display = "grid";
    }, 1000 );
    setTimeout( () => {
        groupsMenu.style.marginTop = "5%"
    }, 1100 );
    setTimeout( () => {
        document.getElementsByTagName('body')[0].style = 'margin: auto; padding: auto; overflow-y: auto; overflow-x: hidden; background: transparent !important;';
    }, 2000 );
};

const setSkin = ( id ) => {
    skinSelected = id
    mta.triggerEvent( 'va.setSkin', gangsID, id )
}

const selectedSkin = () => {
    mta.triggerEvent( 'va.selectedSkin', gangsID, skinSelected )
}