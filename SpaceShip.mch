/* ***********************************************
** 6SENG001W Reasoning About Programs Coursework
** Spaceship & Asteroids
**
** Component: SpaceShip
** Author:    Thiloshon
** Created:   06-Dec-18
** Modified:  26-Dec-18
*********************************************** */
MACHINE         
    SpaceShip   
    
USES
    Space, Asteroids
    
SETS            
    ALERT = { 
        Exceeding_Boundry, 
        Astroid_Strike, 
        No_Power, 
        Moved_Up, 
        Moved_Right, 
        Moved_Down, 
        Moved_Left, 
        Warped, 
        Ready } ; 
    
    GAME_STATUS = { READY, PLAYING, WON, LOST }
    
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
    totalPower : NATURAL1 & totalPower = 20 &
    homebase : (xRegion * yRegion) &  homebase = (1 |-> 1) &
    starbase : (xRegion * yRegion) &  starbase = (6 |-> 4)
    
DEFINITIONS     
    has_power == ((currentPower - normalPower) >= 0);
    has_warp_power == ((currentPower - warpPower) >= 0);
    strikes_boundry(x, y) == (x /: xRegion or y /: yRegion);
    hits_astroid(x, y) == (y : ran({x} <| asteroids));
    is_starbase(x, y) == ((x |-> y) = starbase)
    
VARIABLES       
    shipXPosition,
    shipYPosition,
    currentPower,
    collisionsCount,
    visitedSpaceRegions,
    game_status
    
INVARIANT       
    shipXPosition : xRegion & 
    shipYPosition : yRegion & 
    (shipXPosition |-> shipYPosition) /: asteroids &
    currentPower : NATURAL &
    collisionsCount : NATURAL &
    visitedSpaceRegions : seq(xRegion * yRegion) &
    game_status : GAME_STATUS
    
INITIALISATION  
    shipXPosition := prj1(xRegion, yRegion)(homebase)  || 
    shipYPosition := prj2(xRegion, yRegion)(homebase) || 
    currentPower := totalPower ||
    collisionsCount := 0 ||
    visitedSpaceRegions := [] ||
    game_status := READY
    
OPERATIONS
    
    alert <--  MoveUp =
    PRE
        game_status /= WON
    THEN
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
                    || IF (is_starbase(shipXPosition, shipYPosition))
                    THEN
                        game_status:= WON
                    ELSE
                        game_status := PLAYING
                    END           
                END
            END
        ELSE
            alert := No_Power ||
            game_status := LOST // No power for warp doesn't mean the game is lost
        END
    END;
    
    
    alert <--  MoveDown =
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
                || IF (is_starbase(shipXPosition, shipYPosition))
                THEN
                    game_status:= WON
                ELSE
                    game_status := PLAYING
                END              
            END
        END
    ELSE
        alert := No_Power ||
        game_status := LOST
    END;
    
    
    alert <--  MoveForward =
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
                ||IF (is_starbase(shipXPosition, shipYPosition))
                THEN
                    game_status:= WON
                ELSE
                    game_status := PLAYING
                END             
            END
        END
    ELSE
        alert := No_Power ||
        game_status := LOST
    END;
    
    
    alert <-- MoveBackward =
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
                || IF (is_starbase(shipXPosition, shipYPosition))
                THEN
                    game_status:= WON
                ELSE
                    game_status := PLAYING
                END
            END
        END
    ELSE
        alert := No_Power ||
        game_status := LOST
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
                    || IF (is_starbase(shipXPosition, shipYPosition))
                    THEN
                        game_status:= WON
                    ELSE
                        game_status := PLAYING
                    END
                END
            END
        ELSE
            alert := No_Power ||
            game_status := LOST
        END
    END
    
END
