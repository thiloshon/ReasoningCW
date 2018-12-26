/* Game
* Author: Thiloshon
* Creation date: 24-Dec-18
*/
MACHINE
    Game
    
INCLUDES
    SpaceShip
    
SETS            
    GAME_STATUS = { READY, PLAYING, WON, LOST }
    
DEFINITIONS
    is_starbase(x, y) == ((x |-> y) = starbase) // game
    
VARIABLES
    game_status, // game
    move_status
    
INVARIANT
    game_status : GAME_STATUS &
    move_status : ALERT
    
INITIALISATION
    game_status := READY || move_status := Ready
    
OPERATIONS 
    
    
    status <-- GameStatus =  
    BEGIN
        status := game_status
    END;
    
    
    alert <-- MoveUp =  
    PRE
        game_status /= WON 
    THEN 
       move_status <-- moveUp 
         || alert :=  move_status ||
        IF (move_status = Moved_Up)
        THEN
            IF (is_starbase(shipXPosition, shipYPosition))
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
    
    alert <-- MoveDown =  
    PRE
        game_status /= WON
    THEN 
        move_status <-- moveDown || alert :=  move_status ||
        IF (move_status = Moved_Down)
        THEN
            IF (is_starbase(shipXPosition, shipYPosition))
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
    
    alert <-- MoveForward =  
    PRE
        game_status /= WON
    THEN
        move_status <-- moveRight || alert :=  move_status ||
        IF (move_status = Moved_Right)
        THEN
            IF (is_starbase(shipXPosition, shipYPosition))
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
    
    alert <-- MoveBackward =  
    PRE
        game_status /= WON
    THEN 
        move_status <-- moveLeft || alert :=  move_status ||
        IF (move_status = Moved_Left)
        THEN
            IF (is_starbase(shipXPosition, shipYPosition))
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
    
    alert <-- warpFly(xNew, yNew) = 
    PRE 
        xNew :  NATURAL1 & yNew :  NATURAL1 & game_status /= WON
    THEN        
        move_status <-- EngageWarpDrive(xNew, yNew) || alert :=  move_status ||
        IF (move_status = Warped)
        THEN
            IF (is_starbase(shipXPosition, shipYPosition))
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
