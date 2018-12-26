/* ***********************************************
** 6SENG001W Reasoning About Programs Coursework
** Spaceship & Asteroids
**
** Component: Space
** Author:    Thiloshon
** Created:   24-Dec-18
** Modified:  26-Dec-18
*********************************************** */
MACHINE
    Space
    
CONSTANTS       
    xRegion,
    yRegion
    
PROPERTIES    
    xRegion = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 } & // or can use xMin, xMax
    yRegion = { 1, 2, 3, 4, 5, 6, 7 } 
    
DEFINITIONS
    strikes_boundry(x, y) == ( x /: xRegion or y /: yRegion )
    
OPERATIONS
    
    ans <-- is_a_boundry(xNew, yNew) = 
    PRE
        xNew : NATURAL1 & yNew : NATURAL1 
    THEN        
        IF (strikes_boundry(xNew, yNew))
        THEN
            ans := TRUE
        ELSE
            ans := FALSE
        END        
    END
    
END
