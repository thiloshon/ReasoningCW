/* ***********************************************
** 6SENG001W Reasoning About Programs Coursework
** Spaceship & Asteroids
**
** Component: Game
** Author:    Thiloshon
** Created:   06-Dec-18
** Modified:  24-Dec-18
*********************************************** */
MACHINE
    Game
    
EXTENDS
    SpaceShip
    
DEFINITIONS
    is_in_starbase == ((shipXPosition |-> shipYPosition) = starbase)
    
OPERATIONS
    
    status <-- GameStatus =  
    BEGIN
        status := game_status
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
    IF (is_in_starbase)
    THEN
        dockedStatus := TRUE
    ELSE
        dockedStatus := FALSE
    END
    
END
