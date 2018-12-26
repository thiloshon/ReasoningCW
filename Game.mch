/* Game
* Author: Thiloshon
* Creation date: 24-Dec-18
*/
MACHINE
    Game
    
EXTENDS
    SpaceShip
    
SETS            
    GAME_STATUS = { READY, PLAYING, WON, LOST }
    
CONSTANTS
    starbase
    
PROPERTIES
    starbase = (6 |-> 4)
    
DEFINITIONS
    reached_starbase(x, y) == ((x |-> y) = starbase) // game
    
VARIABLES
    game_status, // game
    move_status
    
INVARIANT
    game_status : GAME_STATUS &
    move_status : ALERT
    
INITIALISATION
    game_status := READY || move_status := Ready
    
OPERATIONS
    
    dockedStatus <-- DockedAtStarbase =  
    IF (reached_starbase(shipXPosition, shipYPosition))
    THEN
        dockedStatus := TRUE
    ELSE
        dockedStatus := FALSE
    END;

    
    status <-- GameStatus =  
    CASE game_status OF
        EITHER
            PLAYING THEN status := Playing
        OR
            WON THEN status := Playing
            
        END
    END;
    
    //BEGIN
    //    status := game_status
    //    END;
    
    
    
    flyUp =  
    PRE
        game_status /= WON
    THEN 
        move_status <-- moveUp ||
        IF (move_status = Moved_Up)
        THEN
            IF (reached_starbase(shipXPosition, shipYPosition))
            THEN
                game_status:= WON
            ELSE
                game_status := PLAYING
            END
        ELSIF (move_status = No_Power)
        THEN
            game_status := LOST
        END
    END;
    
    flyDown =  
    PRE
        game_status /= WON
    THEN 
        move_status <-- moveDown ||
        IF (move_status = Moved_Down)
        THEN
            IF (reached_starbase(shipXPosition, shipYPosition))
            THEN
                game_status:= WON
            ELSE
                game_status := PLAYING
            END
        ELSIF (move_status = No_Power)
        THEN
            game_status := LOST
        END
    END;
    
    flyForward =  
    PRE
        game_status /= WON
    THEN
        move_status <-- moveRight ||
        IF (move_status = Moved_Right)
        THEN
            IF (reached_starbase(shipXPosition, shipYPosition))
            THEN
                game_status:= WON
            ELSE
                game_status := PLAYING
            END
        ELSIF (move_status = No_Power)
        THEN
            game_status := LOST
        END
    END;
    
    ReverseFly =  
    PRE
        game_status /= WON
    THEN 
        move_status <-- moveLeft ||
        IF (move_status = Moved_Left)
        THEN
            IF (reached_starbase(shipXPosition, shipYPosition))
            THEN
                game_status:= WON
            ELSE
                game_status := PLAYING
            END
        ELSIF (move_status = No_Power)
        THEN
            game_status := LOST
        END
    END;
    
    warpFly(xNew, yNew) = 
    PRE 
        xNew :  NATURAL1 & yNew :  NATURAL1 & game_status /= WON
    THEN        
        move_status <-- EngageWarpDrive(xNew, yNew) ||
        IF (move_status = Warped)
        THEN
            IF (reached_starbase(shipXPosition, shipYPosition))
            THEN
                game_status:= WON
            ELSE
                game_status := PLAYING
            END
        ELSIF (move_status = No_Power)
        THEN
            game_status := PLAYING // No power for warp doesn't mean the game is lost
        END
    END
END
