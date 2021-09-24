$(document).ready(
    function( ) {
        window.addEventListener( 'message', ( event ) => {
            const item = event.data
            if (item.close == false) {
                pushItems( true, false, item.name, item.description, item.price, item.itemID )
                pushItems( false, false, item.name, item.description, item.price, item.itemID )
            } else {
                pushItems( false, true )
            }
        });
    }
)

shopItens = []

const pushItems = ( push, reload, name, description, price, itemID ) => {
    if (push) {
        shopItens.push( { id : shopItens.length + 1, name : name, description : description, price : price, itemID : itemID } )
    } else {
        const itemList = shopItens.sort( ( a, b ) => ( a.id > b.id ) ? 1 : -1 );
        $('.shop').html( `
            ${ itemList.map( ( item ) => (`<div class="theItem">
                <img src="http://mta/va~inventory/files/items/${item.itemID}.png" alt="Item Image" class="item">
                <div class="name">${item.name}</div>
                <div class="price">V$${item.price},00</div>
                <div class="description">${item.description}</div>
                <input type="text" style="text-align:center;" maxlength="3" onkeypress="return event.charCode >= 48 && event.charCode <= 57" id="${item.itemID}" class="amount" placeholder="Quantidade">
                <button onclick="buyItem( ${item.itemID}, ${item.price} )" class="buy">COMPRAR</button>
            </div>`) ).join('')}
        `);
    };
    if (reload) {
        document.location.reload(true);
    };
};

const buyItem = ( itemID, itemPrice ) => {
    const amount = document.getElementById(itemID).value;
    mta.triggerEvent( 'va.requestBuy', itemID, itemPrice * amount, amount );
};