/* SpaceShip
* Author: Thiloshon
* Creation date: 06-Dec-18
*/

MACHINE         SpaceShip
    
SETS            GRIDS;
    ALERT = { Exceeding_Boundry, Astroid_Strike, No_Power, Moved_Up, Ready }
    
CONSTANTS       maxX,
    maxY, 
    normalPower, 
    warpPower, 
    crashPower
    
PROPERTIES      maxX = 12  & 
    maxY = 7 & 
    normalPower = 5 & 
    warpPower = 20  & 
    crashPower = 10
    
DEFINITIONS     hits_astroid(x, y) == ( y : ran({x} <| astroids) );
    has_power == (currentPower - normalPower >= 0);
    strikes_boundry(x, y) == ( x < 1 or x > maxX or y < 1 or y > maxY )
    
VARIABLES       shipXPosition, 
    shipYPosition, 
    currentPower, 
    astroids,
    alert
    
    
INVARIANT       shipXPosition : NAT1 & 
    shipYPosition : NAT1 & 
    currentPower : NAT1 & 
    astroids : NAT1 <-> NAT1 &
    alert : ALERT
    
INITIALISATION  shipXPosition := 1 || 
    shipYPosition := 1 || 
    astroids := {   
        (3 |-> 2), 
        (3,5), 
        (5,4), 
        (6,4),  
        (6,7),  
        (7,1),  
        (7,5),  
        (7,7),  
        (8,3),  
        (10,6),  
        (11,2),  
        (12,5)} ||  
    currentPower := 30 ||
    alert := Ready
    
    
OPERATIONS
    
moveUp =
IF ( has_power)
THEN
    IF ( strikes_boundry(shipXPosition, shipYPosition+1))
    THEN
        alert := Exceeding_Boundry
    ELSE
        IF ( hits_astroid(shipXPosition, shipYPosition + 1))
        THEN
            currentPower :=  currentPower - 10 ||
            alert := Astroid_Strike
        ELSE
            shipYPosition := shipYPosition + 1
            || currentPower :=  currentPower - 5
            || alert := Moved_Up
        END
    END
ELSE
    alert := No_Power
END;




moveDown =
PRE shipYPosition - 1 <= maxY 
THEN
    IF (hits_astroid(shipXPosition, shipYPosition - 1))
    THEN
        currentPower :=  currentPower - 10
    ELSE
        shipYPosition := shipYPosition - 1 
        || currentPower :=  currentPower - 5
    END
END ;

moveRight =
PRE shipXPosition + 1 <= maxX 
THEN
    IF ( hits_astroid(shipXPosition + 1, shipYPosition)  )
    THEN
        currentPower :=  currentPower - 10
    ELSE
        shipXPosition := shipXPosition + 1 
        || currentPower :=  currentPower - 5
    END
END ;

moveLeft =
PRE shipXPosition - 1 <= maxY 
THEN
    IF (hits_astroid(shipXPosition - 1, shipYPosition) )
    THEN
        currentPower :=  currentPower - 10
    ELSE
        shipXPosition := shipXPosition - 1 
        || currentPower :=  currentPower - 5
    END
END 

END
