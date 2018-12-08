/* SpaceShip
* Author: Thiloshon
* Creation date: 06-Dec-18
*/

MACHINE         SpaceShip
    
SETS            GRIDS;
    ALERT = { Exceeding_Boundry, Astroid_Strike, No_Power, Moved_Up, Moved_Right, Moved_Down, Moved_Left, Warped, Won, Ready }
    
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
    has_power == ((currentPower - normalPower) >= 0);
    strikes_boundry(x, y) == ( x < 1 or x > maxX or y < 1 or y > maxY );
    reached_starbase(x, y) == (x = starXPosition & y = starYPosition);
    has_warp_power == ((currentPower - warpPower) >= 0)
    
VARIABLES       shipXPosition, 
    shipYPosition,
    starXPosition, 
    starYPosition, 
    currentPower, 
    astroids,
    alert
    
    
INVARIANT       shipXPosition : NAT1 & 
    shipYPosition : NAT1 & 
    starXPosition : NAT1 & 
    starYPosition : NAT1 & 
    currentPower : NAT1 & 
    currentPower >= 0 &
    shipXPosition <= maxX &
    shipYPosition <= maxY &
    astroids : NAT1 <-> NAT1 &
    alert : ALERT
    
INITIALISATION  shipXPosition := 1 || 
    shipYPosition := 1 || 
    starXPosition := 6 || 
    starYPosition := 4 || 
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
                currentPower :=  currentPower - crashPower ||
                alert := Astroid_Strike
            ELSE
                shipYPosition := shipYPosition + 1
                || currentPower :=  currentPower - normalPower
                || 
                IF (reached_starbase(shipXPosition, shipYPosition))
                THEN
                    alert:= Won
                ELSE
                    alert := Moved_Up
                END
            END
        END
    ELSE
        alert := No_Power
    END;
    
    
    
    
    moveDown =
    IF ( has_power)
    THEN
        IF ( strikes_boundry(shipXPosition, shipYPosition - 1))
        THEN
            alert := Exceeding_Boundry
        ELSE
            IF ( hits_astroid(shipXPosition, shipYPosition - 1))
            THEN
                currentPower :=  currentPower - crashPower ||
                alert := Astroid_Strike
            ELSE
                shipYPosition := shipYPosition - 1
                || currentPower :=  currentPower - normalPower
                || 
                IF (reached_starbase(shipXPosition, shipYPosition))
                THEN
                    alert:= Won
                ELSE
                    alert := Moved_Down
                END
            END
        END
    ELSE
        alert := No_Power
    END;
    
    moveRight =
    IF ( has_power)
    THEN
        IF ( strikes_boundry(shipXPosition + 1, shipYPosition))
        THEN
            alert := Exceeding_Boundry
        ELSE
            IF ( hits_astroid(shipXPosition + 1, shipYPosition))
            THEN
                currentPower :=  currentPower - crashPower ||
                alert := Astroid_Strike
            ELSE
                shipXPosition := shipXPosition + 1
                || currentPower :=  currentPower - normalPower
                || 
                IF (reached_starbase(shipXPosition, shipYPosition))
                THEN
                    alert:= Won
                ELSE
                    alert := Moved_Right
                END
            END
        END
    ELSE
        alert := No_Power
    END;
    
    moveLeft =
    IF ( has_power)
    THEN
        IF ( strikes_boundry(shipXPosition - 1, shipYPosition))
        THEN
            alert := Exceeding_Boundry
        ELSE
            IF ( hits_astroid(shipXPosition - 1, shipYPosition))
            THEN
                currentPower :=  currentPower - crashPower ||
                alert := Astroid_Strike
            ELSE
                shipXPosition := shipXPosition - 1
                || currentPower :=  currentPower - normalPower
                || 
                IF (reached_starbase(shipXPosition, shipYPosition))
                THEN
                    alert:= Won
                ELSE
                    alert := Moved_Left
                END
            END
        END
    ELSE
        alert := No_Power
    END;
    
    EngageWarpDrive(xNew, yNew) =
    PRE 
        xNew :  NAT & yNew :  NAT
    THEN
        IF ( has_warp_power )
        THEN
            IF ( strikes_boundry(xNew, yNew))
            THEN
                alert := Exceeding_Boundry
            ELSE
                IF ( hits_astroid(xNew, yNew))
                THEN
                    currentPower :=  currentPower - crashPower ||
                    alert := Astroid_Strike
                ELSE
                    shipXPosition := xNew
                    || shipYPosition := yNew
                    || currentPower :=  currentPower - warpPower
                    || 
                    IF (reached_starbase(shipXPosition, shipYPosition))
                    THEN
                        alert:= Won
                    ELSE
                        alert := Warped
                    END
                END
            END
        ELSE
            alert := No_Power
        END
    END

END
