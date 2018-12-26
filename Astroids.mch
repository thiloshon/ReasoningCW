/* ***********************************************
** 6SENG001W Reasoning About Programs Coursework
** Spaceship & Asteroids
**
** Component: Astroids
** Author:    Thiloshon
** Created:   24-Dec-18
** Modified:  26-Dec-18
*********************************************** */
MACHINE
    Astroids
    
SEES
    Space
    
VARIABLES
    asteroids
    
INVARIANT
    asteroids : xRegion <-> yRegion & 
    card(asteroids) = 11
    
INITIALISATION
    asteroids := {   
        (3 |-> 2), 
        (3 |-> 5), 
        (5 |-> 4), 
        (6 |-> 7),  
        (7 |-> 1),  
        (7 |-> 5),  
        (7 |-> 7),  
        (8 |-> 3),  
        (10 |-> 6),  
        (11 |-> 2),  
        (12 |-> 5)}
    
DEFINITIONS     
    has_asteroid(x, y) == ( y : ran({x} <| asteroids) )
    
OPERATIONS
    
    ans <-- hits_astroid(xNew, yNew) = 
    PRE
        xNew : NATURAL1 & yNew : NATURAL1 
    THEN        
        IF (has_asteroid(xNew, yNew))
        THEN
            ans := TRUE
        ELSE
            ans := FALSE
        END        
    END
    
END
