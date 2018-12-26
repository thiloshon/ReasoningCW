/* SpaceShip
* Author: Thiloshon
* Creation date: 06-Dec-18
*/

MACHINE         SpaceShip   
    
EXTENDS
    Space, Astroids
    
SETS            
    ALERT = { Exceeding_Boundry, Astroid_Strike, No_Power, Moved_Up, Moved_Right, Moved_Down, Moved_Left, Warped, Ready }
     // game
    
CONSTANTS       
    normalPower,  
    warpPower, 
    crashPower,
    totalPower,
    homebase,
    starbase
    
PROPERTIES     
    normalPower : NATURAL1 & normalPower = 5 & 
    warpPower : NATURAL1 & warpPower = 20  & 
    crashPower : NATURAL1 & crashPower = 10 & 
    totalPower : NATURAL1 & totalPower = 100 &
    homebase = (1 |-> 1) & starbase = (6 |-> 4)
    
DEFINITIONS     
    has_power == ((currentPower - normalPower) >= 0);
    has_warp_power == ((currentPower - warpPower) >= 0);
    strikes_boundry(x, y) == (x /: xMin .. xMax or y /: yMin .. yMax);
    hits_astroid(x, y) == (y : ran({x} <| asteroids));
is_starbase(x, y) == ((x |-> y) = starbase)
    
VARIABLES       
    shipXPosition,
    shipYPosition,
    currentPower,
    collisionsCount,
    visitedSpaceRegions
    
    
INVARIANT       
    shipXPosition : NATURAL1 & shipXPosition : xMin .. xMax & 
    shipYPosition : NATURAL1 & shipYPosition : yMin .. yMax & (shipYPosition |-> shipXPosition) /: asteroids &
    currentPower : NATURAL1 &
    collisionsCount : NATURAL &
    visitedSpaceRegions : seq(NATURAL1 * NATURAL1)
    
INITIALISATION  
    shipXPosition := prj1(NATURAL1, NATURAL1)(homebase)  || 
    shipYPosition := prj2(NATURAL1, NATURAL1)(homebase) || 
    currentPower := totalPower ||
    collisionsCount := 0 ||
    visitedSpaceRegions := []
    
    
OPERATIONS
    
    alert <--  moveUp =
    IF (has_power)
    THEN
        IF (strikes_boundry(shipXPosition, shipYPosition + 1))
        THEN
            alert := Exceeding_Boundry
        ELSE
            IF (hits_astroid(shipXPosition, shipYPosition + 1))
            THEN
                currentPower :=  currentPower - crashPower ||
                alert := Astroid_Strike ||
                collisionsCount := collisionsCount + 1
            ELSE
                shipYPosition := shipYPosition + 1
                || currentPower :=  currentPower - normalPower
                || alert := Moved_Up  
                || visitedSpaceRegions := (visitedSpaceRegions <- (shipXPosition |->  shipYPosition))           
            END
        END
    ELSE
        alert := No_Power
    END;
    
    
    alert <--  moveDown =
    IF (has_power)
    THEN
        IF (strikes_boundry(shipXPosition, shipYPosition - 1))
        THEN
            alert := Exceeding_Boundry
        ELSE
            IF (hits_astroid(shipXPosition, shipYPosition - 1))
            THEN
                currentPower :=  currentPower - crashPower ||
                alert := Astroid_Strike ||
                collisionsCount := collisionsCount + 1
            ELSE
                shipYPosition := shipYPosition - 1
                || currentPower :=  currentPower - normalPower
                || alert := Moved_Down     
                || visitedSpaceRegions := (visitedSpaceRegions <- (shipXPosition |->  shipYPosition))              
            END
        END
    ELSE
        alert := No_Power
    END;
    
    alert <--  moveRight =
    IF (has_power)
    THEN
        IF (strikes_boundry(shipXPosition + 1, shipYPosition))
        THEN
            alert := Exceeding_Boundry
        ELSE
            IF ( hits_astroid(shipXPosition + 1, shipYPosition))
            THEN
                currentPower :=  currentPower - crashPower ||
                alert := Astroid_Strike ||
                collisionsCount := collisionsCount + 1
            ELSE
                shipXPosition := shipXPosition + 1
                || currentPower :=  currentPower - normalPower
                || alert := Moved_Right     
                || visitedSpaceRegions := (visitedSpaceRegions <- (shipXPosition |->  shipYPosition))              
            END
        END
    ELSE
        alert := No_Power
    END;
    
    alert <-- moveLeft =
    IF (has_power)
    THEN
        IF (strikes_boundry(shipXPosition - 1, shipYPosition))
        THEN
            alert := Exceeding_Boundry
        ELSE
            IF (hits_astroid(shipXPosition - 1, shipYPosition))
            THEN
                currentPower :=  currentPower - crashPower ||
                alert := Astroid_Strike ||
                collisionsCount := collisionsCount + 1
            ELSE
                shipXPosition := shipXPosition - 1
                || currentPower :=  currentPower - normalPower
                || alert := Moved_Left  
                || visitedSpaceRegions := (visitedSpaceRegions <- (shipXPosition |->  shipYPosition)) 
            END
        END
    ELSE
        alert := No_Power
    END;
    
    alert <-- EngageWarpDrive(xNew, yNew) =
    PRE 
        xNew :  NATURAL1 & yNew :  NATURAL1
    THEN
        IF (has_warp_power )
        THEN
            IF (strikes_boundry(xNew, yNew))
            THEN
                alert := Exceeding_Boundry
            ELSE
                IF ( hits_astroid(xNew, yNew))
                THEN
                    currentPower :=  currentPower - crashPower ||
                    alert := Astroid_Strike ||
                    collisionsCount := collisionsCount + 1
                ELSE
                    shipXPosition := xNew
                    || shipYPosition := yNew
                    || currentPower :=  currentPower - warpPower
                    || alert := Warped  
                    || visitedSpaceRegions := (visitedSpaceRegions <- (shipXPosition |->  shipYPosition)) 
                END
            END
        ELSE
            alert := No_Power
        END
    END;

location, power, collisions <-- MissionStatus = 
    BEGIN
        location := (shipXPosition |-> shipYPosition) ||
        power := currentPower ||
        collisions := collisionsCount
    END;
    
    route <-- MissionRoute = 
    BEGIN
        route := visitedSpaceRegions
    END;
    
    dockedStatus <-- DockedAtStarbase =  
    IF (is_starbase(shipXPosition, shipYPosition))
    THEN
        dockedStatus := TRUE
    ELSE
        dockedStatus := FALSE
    END;

route <-- test1 = 
    BEGIN
        route := visitedSpaceRegions
    END;

test2 = 
    BEGIN
        currentPower := 100
    END
    
END
