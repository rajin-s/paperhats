document.addEventListener('keydown', (event) => {
        const keyName = event.key;
        if (keyName == null) { return; }
        // console.log(`${keyName} down`);
        keyPressed[keyName.toLowerCase()] = true;
    }, false
    );
    
    document.addEventListener('keyup', (event) => {
        const keyName = event.key;
        if (keyName == null) { return; }
        // console.log(`${keyName} up`);
        keyPressed[keyName.toLowerCase()] = false;
    }, false
);

var keyPressed = {}