/* ***********************************************
** 6SENG001W Reasoning About Programs Coursework
** Spaceship & Asteroids
**
** Component: Game
** Author:    Thiloshon
** Created:   06-Dec-18
** Modified:  31-Dec-18
*********************************************** */
MACHINE
    Game

EXTENDS
    SpaceShip
    
DEFINITIONS
    is_in_starbase == ((shipXPosition |-> shipYPosition) = starbase)
    
OPERATIONS
    
    // An inquiry operation that reports: WON, LOST or PLAYING
    status <-- GameStatus =  
    BEGIN
        status := game_status
    END;
    
    
    // An inquiry operation that reports the current status of the spaceship
    location, power, collisions <-- MissionStatus = 
    BEGIN
        location := (shipXPosition |-> shipYPosition) ||
        power := currentPower ||
        collisions := collisionsCount
    END;
    
    
    // An inquiry operation that reports the route (regions of space) that the spaceship has traveled through.
    route <-- MissionRoute = 
    BEGIN
        route := visitedSpaceRegions
    END;
    
    
    // An inquiry operation that reports whether the Spaceship is “docked” at the Starbase
    dockedStatus <-- DockedAtStarbase =  
    IF (is_in_starbase)
    THEN
        dockedStatus := TRUE
    ELSE
        dockedStatus := FALSE
    END
    
END
